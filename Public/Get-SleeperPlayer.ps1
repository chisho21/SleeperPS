<#
.SYNOPSIS
Retrieves player data from the Sleeper API or cache based on player name, ID, or position.

.DESCRIPTION
The Get-SleeperPlayer cmdlet fetches NFL player data from the Sleeper API or uses a locally cached file for faster access. 
The cmdlet supports filtering by player name (with wildcards), player ID, and position. 
Player data is cached in a global variable to avoid reloading from the JSON file unless explicitly requested using the -Force parameter.

.PARAMETER Player
Specifies the player name or ID to search for. Accepts wildcards (*) for name searches or an exact match for player ID. 
Default is "*" which returns all players.

.PARAMETER Position
Specifies the position to filter by (e.g., QB, RB, WR). Only players matching the specified position are returned.

.PARAMETER Force
Forces an update from the Sleeper API, bypassing the cache and fetching fresh data.

.PARAMETER SaveLocation
Specifies the location where the player data JSON file is saved or loaded from. 
Default is "$HOME/.sleeper/nfl_players.json".

.EXAMPLE
PS C:\> Get-SleeperPlayer -Player "*mahomes*"

Retrieves all players with "mahomes" in their name from the Sleeper API or cache.

.EXAMPLE
PS C:\> Get-SleeperPlayer -Player 4046

Retrieves the player with the exact ID of 4046.

.EXAMPLE
PS C:\> Get-SleeperPlayer -Position QB

Fetches all players with the position of Quarterback (QB) from the Sleeper API or cache.

.EXAMPLE
PS C:\> Get-SleeperPlayer -Force

Forces a fresh update from the Sleeper API, ignoring the cache and saving new data to the JSON file.

.OUTPUTS
SleeperPlayer[]
Returns a list of SleeperPlayer objects that match the search criteria.

.NOTES
Author: Your Name
Version: 1.0.0
This cmdlet caches data in a global variable to improve performance by avoiding repeated API calls.
To force a cache refresh, use the -Force parameter.
The cache is automatically updated if the data is older than 7 days.
#>

function Get-SleeperPlayer {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true)]
        [string]$Player = "*",          # Accepts player ID or name with wildcards
        [string]$Position,              # Filter by position (optional)
        [switch]$Force,                 # Force update from API (optional)
        [string]$SaveLocation = "$HOME/.sleeper/nfl_players.json"
    )

    # Global variable to cache players
    if (-not $global:SleeperPlayersCache) {
        $global:SleeperPlayersCache = @()
    }

    # Helper function to fetch and cache player data
    function Fetch-SleeperPlayers($url, $saveLocation) {
        $shouldUpdate = $true

        if (-not $Force -and $global:SleeperPlayersCache.Count -gt 0) {
            Write-Verbose "Using cached player data from global variable."
            return $global:SleeperPlayersCache
        }

        if (-not $Force) {
            if (Test-Path $saveLocation) {
                $fileAge = (Get-Item $saveLocation).LastWriteTime
                Write-Verbose "Cached player data last updated on: $fileAge"

                if ($fileAge -gt (Get-Date).AddDays(-7)) {
                    $shouldUpdate = $false
                    Write-Host "Player data is up to date (cached). Use -Force to refresh from the API."
                }
            } else {
                Write-Verbose "No cached file found. Fetching new data from the Sleeper API."
            }
        } else {
            Write-Verbose "Force option selected. Fetching fresh data from the Sleeper API."
        }

        if ($shouldUpdate) {
            Write-Host "Fetching player data from Sleeper API..."

            try {
                # Fetch all player data from the Sleeper API
                $response = Invoke-RestMethod -Uri $url -Method Get -ContentType "application/json"
                Write-Verbose "Fetched $($response.Count) players from Sleeper API."

                # Convert response into a hashtable for fast lookup
                $playersList = @()
                foreach ($player in $response.PSObject.Properties) {
                    $playerData = $player.Value
                    Write-Verbose "Processing player: $($playerData.full_name) (ID: $($playerData.player_id))"
                    $playersList += $playerData
                }

                # Save to JSON for future use
                $playersList | ConvertTo-Json -Depth 3 | Set-Content -Path $saveLocation
                Write-Host "Player data saved to $saveLocation in JSON format"

                # Cache in global variable
                $global:SleeperPlayersCache = $playersList
            }
            catch {
                Write-Warning "Failed to fetch data from Sleeper API: $_"
                return @{}
            }
        }

        # Read from the JSON if not fetching from the API
        if ($shouldUpdate -or -not $global:SleeperPlayersCache.Count) {
            Write-Verbose "Reading player data from cache at $saveLocation"

            # Load the JSON and convert back to SleeperPlayer objects
            $jsonData = Get-Content -Path $saveLocation | ConvertFrom-Json
            $global:SleeperPlayersCache = $jsonData | ForEach-Object {
                [SleeperPlayer]::new($_)
            }
        }

        return $global:SleeperPlayersCache
    }

    # NFL player API endpoint
    $urlNFL = "https://api.sleeper.app/v1/players/nfl"

    # Fetch or load cached player data
    $players = Fetch-SleeperPlayers -url $urlNFL -saveLocation $SaveLocation

    # Filter by Player ID or Name
    Write-Verbose "Filtering player data based on provided search term: $Player"
    if ($Player -match '^\d+$') {
        # Exact player ID search
        $filteredPlayers = $players | Where-Object { $_.PlayerId -eq $Player }
    }
    else {
        # Name search using wildcard (*)
        $Player = "*$Player*"
        $filteredPlayers = $players | Where-Object { $_.FullName -like $Player }
        Write-Verbose "Filtered down to $($filteredPlayers.Count) players after applying wildcard filter."
    }

    # Apply position filter if provided
    if ($Position) {
        Write-Verbose "Applying position filter: $Position"
        $filteredPlayers = $filteredPlayers | Where-Object { $_.Position -eq $Position }
        Write-Verbose "Filtered down to $($filteredPlayers.Count) players after applying position filter."
    }

    # Check if any players were found
    if (-not $filteredPlayers) {
        Write-Warning "No players found matching the criteria."
    } else {
        Write-Verbose "Returning $($filteredPlayers.Count) matching players."
    }

    # Return the filtered players
    return $filteredPlayers
}
