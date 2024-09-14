<#
.SYNOPSIS
Retrieves a list of trending players based on recent adds or drops.

.DESCRIPTION
The Get-SleeperTrendingPlayers cmdlet retrieves a list of trending players, either based on recent adds or drops over a specified time period.

.PARAMETER Type
Specifies whether to retrieve trending players based on recent 'add' or 'drop' activity.

.PARAMETER LookbackHours
Specifies the number of hours to look back for trending player data. Defaults to 24 hours.

.PARAMETER Limit
Specifies the maximum number of trending players to retrieve. Defaults to 25.

.EXAMPLE
PS C:\> Get-SleeperTrendingPlayers -Type add -sport nfl -LookbackHours 24 -Limit 10

Retrieves the top 10 trending players in the NFL based on recent adds over the last 24 hours.

.OUTPUTS
SleeperTrendingPlayer[]

.NOTES
Version: 1.0.0
Author: Your Name
#>

function Get-SleeperTrendingPlayers {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('add', 'drop')]
        [string]$Type,
        [int]$LookbackHours = 24,
        [int]$Limit = 25
    )

    $url = "https://api.sleeper.app/v1/players/nfl/trending?type=$Type&lookback_hours=$LookbackHours&limit=$Limit"
    $response = Invoke-RestMethod -Uri $url -Method Get

    $players = foreach ($player in $response) {
        [SleeperTrendingPlayer]::new($player)
    }

    return $players
}
