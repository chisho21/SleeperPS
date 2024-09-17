function Get-SleeperLeagueMatchups {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$LeagueId,   # Accepts a Sleeper league ID

        [Parameter(Mandatory = $false)]
        [int]$Week = (Get-SleeperNFLState).week,  # Get the current week by default

        [switch]$RawJSON,  # Output the raw JSON data for troubleshooting

        [switch]$PrettyOutput  # Output the summarized PrettyOutput
    )

    # Step 1: Fetch league rosters
    Write-Verbose "Fetching rosters for league $LeagueId"
    $rosters = Get-SleeperLeagueRosters -LeagueId $LeagueId

    # Fetch aliases if available
    $aliases = Get-SleeperUserAlias -LeagueID $LeagueId

    # Create a lookup for roster IDs to usernames or aliases
    $rosterToOwner = @{}
    foreach ($roster in $rosters) {
        try {
            $username = (Get-SleeperUser -UserId $roster.OwnerId -ErrorAction Stop).Username
        } catch {
            $username = "Team $($roster.rosterid)"
        }

        # Check if an alias exists for the user in this league
        $alias = $aliases | Where-Object { $_.Username -eq $username } | Select-Object -ExpandProperty Alias -ErrorAction SilentlyContinue
        if ($alias) {
            $rosterToOwner[$roster.rosterid] = $alias
        } else {
            $rosterToOwner[$roster.rosterid] = $username
        }
    }

    # Step 2: Fetch matchups for the specified week
    Write-Verbose "Fetching matchups for Week $Week in league $LeagueId"
    $matchupsEndpoint = "https://api.sleeper.app/v1/league/$LeagueId/matchups/$Week"
    $matchups = Invoke-RestMethod -Uri $matchupsEndpoint -Method Get

    # Step 3: Fetch player data
    Write-Verbose "Fetching player data from cache/API"
    $players = Get-SleeperPlayer

    # Step 4: Return raw JSON if -RawJSON switch is used
    if ($RawJSON) {
        Write-Verbose "Outputting raw JSON for troubleshooting"
        return $matchups
    }

    # Step 5: Process matchups with resolved player information
    $processedMatchups = @()

    foreach ($matchup in $matchups) {
        $teamOwner = $rosterToOwner[($matchup.roster_id).ToString()]
        $opponent = $matchups | Where-Object { $_.matchup_id -eq $matchup.matchup_id -and $_.roster_id -ne $matchup.roster_id }
        $opponentName = $rosterToOwner[($opponent.roster_id).ToString()]

        # Resolve players in the matchup
        $resolvedPlayers = @()
        foreach ($playerId in $matchup.players) {
            $player = $players | Where-Object { $_.PlayerId -eq $playerId }

            if ($player) {
                # Add extended player information
                $resolvedPlayer = [PSCustomObject]@{
                    PlayerID      = $playerId
                    FullName      = $player.FullName
                    Position      = $player.Position
                    Team          = $player.Team
                    YearsExp      = $player.YearsExp
                    Age           = $player.Age
                    DepthChartOrder = $player.DepthChartOrder
                    Points        = $matchup.players_points.$playerId
                }

                # Add to resolved players list
                $resolvedPlayers += $resolvedPlayer
            }
        }

        # Create the matchup data object with resolved players and raw fields
        $matchupData = [PSCustomObject]@{
            League          = $LeagueId
            Week            = $Week
            MatchupID       = $matchup.matchup_id
            TeamOwner       = $teamOwner
            Opponent        = $opponentName
            RosterID        = $matchup.roster_id
            Points          = $matchup.points
            Starters        = $matchup.starters
            StartersPoints  = $matchup.starters_points
            AllPlayersPoints = $resolvedPlayers
        }

        # Add the processed matchup data to the collection
        $processedMatchups += $matchupData
    }

    # Step 6: Handle PrettyOutput if the switch is used
    if ($PrettyOutput) {
        $prettyOut = @()

        # Group matchups by their unique matchup ID and process each pair only once
        $uniqueMatchups = $processedMatchups | Group-Object -Property MatchupID

        foreach ($group in $uniqueMatchups) {
            $team1 = $group.Group[0]
            $team2 = $group.Group[1]

            $winner = if ($team1.Points -gt $team2.Points) { $team1 } else { $team2 }
            $loser = if ($team1.Points -le $team2.Points) { $team1 } else { $team2 }

            # Construct the pretty output for the unique matchup
            $prettyMatchup = [PSCustomObject]@{
                League       = $team1.League
                Week         = $team1.Week
                MatchupID    = $team1.MatchupID
                Team1        = $team1.TeamOwner
                Team1Points  = $team1.Points
                Team2        = $team2.TeamOwner
                Team2Points  = $team2.Points
                Winner       = $winner.TeamOwner
                Summary      = "$($winner.TeamOwner) ($($winner.Points)) def. $($loser.TeamOwner) ($($loser.Points))"
            }

            $prettyOut += $prettyMatchup
        }

        return $prettyOut
    }

    # Step 7: Return the processed matchups
    return $processedMatchups
}
