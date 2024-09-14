<#
.SYNOPSIS
Retrieves a list of leagues for the specified Sleeper user.

.DESCRIPTION
The Get-SleeperUserLeagues cmdlet retrieves all leagues that a user is a part of for the nfl and season. 
It fetches data from the Sleeper API based on the user’s ID and the specified sport and season.

.PARAMETER UserId
Specifies the unique identifier of the Sleeper user whose leagues are to be retrieved.

.PARAMETER Season
Specifies the season year for which leagues should be retrieved. Defaults to the current year.

.EXAMPLE
PS C:\> Get-SleeperUserLeagues -UserId 12345 -sport nfl -Season 2023

Retrieves all NFL leagues for the specified user in the 2023 season.

.OUTPUTS
SleeperLeague[]

.NOTES
Version: 1.0.0
Author: Your Name
#>
function Get-SleeperUserLeagues {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$UserId,
        [string]$Sport = "nfl",
        [int]$Season = (Get-Date).Year
    )

    process {
        $url = "https://api.sleeper.app/v1/user/$UserId/leagues/nfl/$Season"
        $response = Invoke-RestMethod -Uri $url -Method Get

        $leagues = foreach ($league in $response) {
            [SleeperLeague]::new($league)
        }

        return $leagues
    }
}