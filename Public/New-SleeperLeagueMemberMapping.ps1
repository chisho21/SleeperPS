function New-SleeperLeagueMemberMapping {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$UserName,  # Accepts a Sleeper username

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$UserId,    # Accepts a Sleeper user ID

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$LeagueId,  # Accepts a Sleeper league ID

        [switch]$Force      # Force option to delete the current file if it exists
    )

    # Path to the Excel file
    $excelFilePath = "$HOME/.sleeper/leaguemembermap.xlsx"

    # Create the directory if it doesn't exist
    if (-not (Test-Path "$HOME/.sleeper")) {
        New-Item -ItemType Directory -Path "$HOME/.sleeper" -Force | Out-Null
    }

    # If -Force is used, delete the existing Excel file
    if ($Force -and (Test-Path $excelFilePath)) {
        Write-Verbose "Deleting existing mapping file at $excelFilePath due to -Force option."
        Remove-Item -Path $excelFilePath -Force
    }

    # Check if the ImportExcel module is installed
    if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
        Write-Error "The 'ImportExcel' module is required for this script. Please install it with 'Install-Module -Name ImportExcel'."
        return
    }

    # If the Excel file doesn't exist, create it with headers
    if (-not (Test-Path $excelFilePath)) {
        $headers = @("LeagueID", "SleeperUsername", "SleeperUserID", "SleeperUserAlias")
        $headers | Export-Excel -Path $excelFilePath -WorksheetName 'LeagueMemberMap' -TableName 'LeagueMembers'
    }

    # Fetching League Information
    if ($LeagueId) {
        Write-Verbose "Using provided league ID: $LeagueId"
        $leagues = @([PSCustomObject]@{ leagueid = $LeagueId; name = "League $LeagueId" })
    }
    else {
        if (-not $UserId -and -not $UserName) {
            Write-Error "Either a username, user ID, or league ID must be provided."
            return
        }

        if ($UserName) {
            Write-Verbose "Fetching Sleeper user data for $UserName"
            $user = Get-SleeperUser $UserName
            if (-not $user) {
                Write-Error "Could not find user $UserName"
                return
            }
            $UserId = $user.userid
        }

        # Fetching leagues associated with the user
        Write-Verbose "Fetching leagues for user ID $UserId"
        $leagues = Get-SleeperUserLeagues -UserId $UserId -Sport nfl
        if (-not $leagues) {
            Write-Error "No leagues found for user ID $UserId"
            return
        }
    }

    # Process each league and fetch rosters
    $entry = @()
    foreach ($league in $leagues) {
        Write-Verbose "Processing league: $($league.name)"

        # Fetch rosters for each league
        $rosters = Get-SleeperLeagueRosters -LeagueId $league.leagueid
        
        # Process each roster member and append to Excel
        foreach ($roster in $rosters) {
            
            $user = $null
            $userId = $roster.OwnerId
            try {
                $user = (Get-SleeperUser -UserId $roster.OwnerId -ErrorAction Stop).Username
            } catch {
                $user = "Team $($roster.rosterid)"
            }

            if ($user) {
                # Create the entry with SleeperUsername, SleeperUserID, and SleeperUserAlias
                $entry += [PSCustomObject]@{
                    LeagueID        = [int64]$league.leagueid
                    SleeperUsername = $user
                    SleeperUserID   = [int64]$userId
                    SleeperUserAlias = if ($user.display_name) { $user.display_name } else { "" }
                }

                # Append entry to the Excel file
                Write-Verbose "Added $user to league member map."
            }
        }
    }
    $entry | Export-Excel -Path $excelFilePath -WorksheetName 'LeagueMemberMap'
    Write-Host "League member mapping saved to $excelFilePath"
}
