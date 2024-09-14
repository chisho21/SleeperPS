<#
.SYNOPSIS
Retrieves detailed information for one or more Sleeper leagues by LeagueId.

.DESCRIPTION
The Get-SleeperLeague cmdlet retrieves detailed information for a specific Sleeper league or multiple leagues. 
It accepts input via the pipeline, allowing you to pass a LeagueId or an object containing a LeagueId property directly.

.PARAMETER LeagueId
Specifies the unique identifier of the Sleeper league to retrieve details for. 
This can be passed directly or through the pipeline.

.EXAMPLE
PS C:\> Get-SleeperLeague -LeagueId "123456789"

Retrieves detailed information for the league with ID "123456789".

.EXAMPLE
PS C:\> Get-SleeperUserLeagues -UserId "1065124741360615424" | Get-SleeperLeague

Fetches all leagues for the user and pipes each league's LeagueId into Get-SleeperLeague to retrieve the details for each one.

.EXAMPLE
PS C:\> $leagueIds = @("123456789", "987654321")
PS C:\> $leagueIds | Get-SleeperLeague

Fetches league details for each LeagueId in the array.

.OUTPUTS
PSCustomObject
Returns detailed information about each Sleeper league.

.NOTES
Version: 1.0.0
Author: Feros Technologies
#>
function Get-SleeperLeague {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true)]
        [string]$LeagueId
    )

    process {
        $url = "https://api.sleeper.app/v1/league/$LeagueId"

        try {
            Write-Host "Fetching details for LeagueId: $LeagueId"
            $response = Invoke-RestMethod -Uri $url -Method Get
            return $response
        }
        catch {
            if ($_ -match '404') {
                Write-Warning "League with ID $LeagueId was not found (404)."
            } else {
                Write-Warning "An error occurred while fetching LeagueId: $LeagueId. Error: $_"
            }
        }
    }
}
