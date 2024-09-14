<#
.SYNOPSIS
Retrieves matchups for a specific week in a league.

.DESCRIPTION
The Get-SleeperMatchups cmdlet retrieves weekly matchups for a specified week in a given league.
If no week is provided, it fetches the current week from the Sleeper NFL state API.

.PARAMETER LeagueId
Specifies the unique identifier of the Sleeper league. This can be passed directly or through the pipeline.

.PARAMETER Week
Specifies the week number to retrieve matchups for. If not provided, it defaults to the current week using the Sleeper NFL state.

.EXAMPLE
PS C:\> Get-SleeperMatchups -LeagueId "123456789" -Week 5

Retrieves matchups for week 5 in the league with ID "123456789".

.EXAMPLE
PS C:\> Get-SleeperMatchups -LeagueId "123456789"

Fetches matchups for the current week in the league with ID "123456789".

.OUTPUTS
PSCustomObject
Returns detailed matchup information for the specified week in the league.

.NOTES
Version: 1.0.0
Author: Your Name
#>
function Get-SleeperLeagueMatchups {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true)]
        [string]$LeagueId,

        [Parameter(Mandatory = $false)]
        [int]$Week
    )

    process {
        # If Week is not provided, fetch the current week from Sleeper NFL state
        if (-not $PSBoundParameters.ContainsKey('Week')) {
            Write-Host "Week not provided, fetching current week from Sleeper NFL state..."

            # Call Sleeper NFL state API to get the current week
            $nflState = Get-SleeperNFLState

            if ($nflState.week) {
                $Week = $nflState.week
                Write-Host "Current week fetched: $Week"
            } else {
                Write-Warning "Could not fetch the current week from Sleeper NFL state."
                return
            }
        }

        # Fetch matchups for the specified or default week
        $url = "https://api.sleeper.app/v1/league/$LeagueId/matchups/$Week"
        Write-Host "Fetching matchups for LeagueId: $LeagueId, Week: $Week"

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get
            return $response
        }
        catch {
            if ($_ -match '404') {
                Write-Warning "League with ID $LeagueId was not found or no matchups available for Week $Week (404)."
            } else {
                Write-Warning "An error occurred while fetching matchups for LeagueId: $LeagueId and Week: $Week. Error: $_"
            }
        }
    }
}
