<#
.SYNOPSIS
Retrieves all rosters for a specified league.

.DESCRIPTION
The Get-SleeperLeagueRosters cmdlet retrieves all rosters for a specific Sleeper league. 
It returns details such as players, starters, reserve, taxi, and metadata.

.PARAMETER LeagueId
Specifies the unique identifier of the Sleeper league. This can be passed directly or through the pipeline.

.EXAMPLE
PS C:\> Get-SleeperLeagueRosters -LeagueId "123456789"

Retrieves all rosters for the league with ID "123456789".

.OUTPUTS
SleeperRoster[]
Returns detailed information about rosters for the Sleeper league.

.NOTES
Version: 1.0.0
Author: Your Name
#>
function Get-SleeperLeagueRosters {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true)]
        [string]$LeagueId
    )

    process {
        $url = "https://api.sleeper.app/v1/league/$LeagueId/rosters"
        Write-Host "Fetching rosters for LeagueId: $LeagueId"

        try {
            $response = Invoke-RestMethod -Uri $url -Method Get
            $rosters = foreach ($roster in $response) {
                [SleeperRoster]::new($roster)
            }

            return $rosters
        }
        catch {
            if ($_ -match '404') {
                Write-Warning "League with ID $LeagueId was not found (404)."
            } else {
                Write-Warning "An error occurred while fetching rosters for LeagueId: $LeagueId. Error: $_"
            }
        }
    }
}
