function Get-SleeperWeeklyReport {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$Username,                 # Accepts a Sleeper username

        [Parameter(Mandatory = $false)]
        [string]$UserId,                   # Accepts a Sleeper user ID

        [Parameter(Mandatory = $false)]
        [string]$LeagueId,                 # Accepts a Sleeper league ID

        [Parameter(Mandatory = $false)]
        [int]$Week = (Get-SleeperNFLState).week, # Get current week by default

        [Parameter(Mandatory = $false)]
        [int]$Year = (Get-Date).Year,      # Default to current year

        [switch]$ExportToExcel,            # Export to Excel option

        [string]$ExcelFilePath,            # Excel file path (optional)

        [switch]$IncludeAllWeeks           # Switch to include every week up to $Week
    )

    # Step 1: Fetch fresh data
    Write-Verbose "Fetching fresh data for $Year, Week $Week..."

    # Step 2: Get user or league information
    if ($LeagueId) {
        Write-Verbose "Using provided league ID: $LeagueId"
        $leagues = @([PSCustomObject]@{ leagueid = $LeagueId; name = "League $LeagueId" })
    }
    else {
        if (-not $UserId -and -not $Username) {
            Write-Error "Either a username, user ID, or league ID must be provided."
            return
        }

        if ($Username) {
            Write-Verbose "Fetching Sleeper user data for $Username"
            $user = Get-SleeperUser -Username $Username
            if (-not $user) {
                Write-Error "Could not find user $Username"
                return
            }
            $UserId = $user.userid
        }

        # Step 3: Get user's leagues
        Write-Verbose "Fetching leagues for user ID $UserId"
        $leagues = Get-SleeperUserLeagues -UserId $UserId -Sport nfl -Season $Year
        if (-not $leagues) {
            Write-Error "No leagues found for user ID $UserId in year $Year"
            return
        }
    }

    # Step 4: Fetch player data
    Write-Verbose "Fetching player data from cache/API"
    $players = Get-SleeperPlayer

    # Initialize a collection for storing report data
    $rawData = @()
    $summaryStats = @()
    $allmatches = @()

    # Step 5: Loop through each league
    foreach ($league in $leagues) {
        Write-Verbose "Processing league: $($league.name)"

        # Fetch rosters for each league
        $rosters = Get-SleeperLeagueRosters -LeagueId $league.leagueid

        # Create a lookup for roster IDs to usernames
        $rosterToOwner = @{}
        foreach ($roster in $rosters) {
            try {
                $username = (Get-SleeperUser -UserId $roster.OwnerId -ErrorAction Stop ).Username
            } catch {
                $username = "Team $($roster.rosterid)"
            }
            $rosterToOwner[$roster.rosterid] = $username
        }

        # Step 6: Loop through each week if -IncludeAllWeeks is specified, else process only the specified $Week
        $weeksToProcess = if ($IncludeAllWeeks) { 1..$Week } else { @($Week) }

        foreach ($i in $weeksToProcess) {
            Write-Verbose "Processing data for Week $i in league $($league.name)"
            $weekData = @()

            # Fetch matchups for the specified week
            $matchups = Get-SleeperLeagueMatchups -LeagueId $league.leagueid -Week $i

            # Process each matchup
            foreach ($matchup in $matchups) {
                $teamOwner = $rosterToOwner[($matchup.roster_id).ToString()]
                $opponent = $matchups | Where-Object {$_.matchup_id -eq $matchup.matchup_id -and $_.roster_id -ne $matchup.roster_id}
                $opponentname = $rosterToOwner[($opponent.roster_id).ToString()]

                # For each player in the matchup, check their points and status
                foreach ($playerId in $matchup.players) {
                    $player = $players | Where-Object { $_.PlayerId -eq $playerId }

                    if ($player) {
                        # Check if the player was a starter or on the bench
                        $starter = if ($matchup.starters -contains $playerId) { "STARTER" } else { "BENCH" }
                        $points = $matchup.players_points.$playerId

                        # Create a data object for the report (include both starters and bench players)
                        $data = [PSCustomObject]@{
                            League     = $league.name
                            TeamOwner  = $teamOwner
                            RosterID   = $matchup.roster_id
                            Week       = $i
                            Opponent   = $opponentname
                            MatchupID  = $matchup.matchup_id
                            Player     = $player.FullName
                            PlayerPos  = $player.Position
                            PlayerTeam = if ($player.Position -eq "DEF") { $player.Team } else { $player.Team }
                            Starter    = $starter
                            PlayerYears = $player.YearsExp
                            PlayerAge  = $player.Age
                            PlayerDepth = $player.DepthChartOrder
                            Points     = $points
                        }

                        # Add data to the report collection
                        $rawData += $data
                        $weekData += $data
                    }
                }
            }

            # Calculate Summary Stats for this week and league (only consider starters)
            # Calculate the total points for each team by summing starter points
            $teamScores = $weekData | Where-Object { $_.Starter -eq "STARTER" } | Group-Object -Property TeamOwner | ForEach-Object {
                [PSCustomObject]@{
                    TeamOwner = $_.Name
                    TotalPoints = ($_.Group | Measure-Object -Property Points -Sum).Sum
                }
            }

            # Determine the highest scoring team
            $highestScoringTeam = $teamScores | Sort-Object -Property TotalPoints -Descending | Select-Object -First 1

            # Determine the lowest scoring team
            $lowestScoringTeam = $teamScores | Sort-Object -Property TotalPoints | Select-Object -First 1

            # Determine best bench team
            $benchScores = $weekData | Where-Object { $_.Starter -ne "STARTER" } | Group-Object -Property TeamOwner | ForEach-Object {
                [PSCustomObject]@{
                    TeamOwner = $_.Name
                    TotalPoints = ($_.Group | Measure-Object -Property Points -Sum).Sum
                }
            }

            $highestBenchTeam = $benchScores | Sort-Object -Property TotalPoints -Descending | Select-Object -First 1

            # Calulate best positions
            $bestOverall = $weekData | Where-Object { $_.Starter -eq "STARTER" } | Sort-Object Points -Descending | Select-Object -First 1
            if ($bestOverall.PlayerPos -eq "DEF"){ $bestOverallname = $bestOverall.PlayerTeam} else {$bestOverallname  = $bestOverall.Player}
            $bestQB = $weekData | Where-Object { $_.PlayerPos -eq "QB" -and $_.Starter -eq "STARTER" } | Sort-Object Points -Descending | Select-Object -First 1
            $bestRB = $weekData | Where-Object { $_.PlayerPos -eq "RB" -and $_.Starter -eq "STARTER" } | Sort-Object Points -Descending | Select-Object -First 1
            $bestWR = $weekData | Where-Object { $_.PlayerPos -eq "WR" -and $_.Starter -eq "STARTER" } | Sort-Object Points -Descending | Select-Object -First 1
            $bestTE = $weekData | Where-Object { $_.PlayerPos -eq "TE" -and $_.Starter -eq "STARTER" } | Sort-Object Points -Descending | Select-Object -First 1
            $bestK = $weekData | Where-Object { $_.PlayerPos -eq "K" -and $_.Starter -eq "STARTER" } | Sort-Object Points -Descending | Select-Object -First 1
            $bestDEF = $weekData | Where-Object { $_.PlayerPos -eq "DEF" -and $_.Starter -eq "STARTER" } | Sort-Object Points -Descending | Select-Object -First 1
            $bestBenchPlayer = $weekData | Where-Object { $_.Starter -eq "BENCH" -and $_.Points -gt 0 } | Sort-Object Points -Descending | Select-Object -First 1
            $bestBaby = $weekData | Where-Object { $_.PlayerAge -le 24 -and $_.Starter -eq "STARTER" -and $_.PlayerPos -ne "DEF" } | Sort-Object Points -Descending | Select-Object -First 1
            $bestGrandpa = $weekData | Where-Object { $_.PlayerAge -ge 30 -and $_.Starter -eq "STARTER" -and $_.PlayerPos -ne "DEF" } | Sort-Object Points -Descending | Select-Object -First 1

            # Additional matchup stats (Blowout, Narrowest, Bad Beat, Overachiever)
            $allmatches += $matchstats = $matchups | Group-Object -Property matchup_id | ForEach-Object {
                $team1 = $_.Group[0]
                $team2 = $_.Group[1]
                $team1Points = $team1.points
                $team2Points = $team2.points
            
                if ($team1Points -gt $team2Points) {
                    [PSCustomObject]@{
                        League = $league.name
                        Week = $i
                        MatchID = $_.Name
                        Winner = $rosterToOwner["$($team1.roster_id)"]
                        WinnerPoints = $team1Points
                        Loser = $rosterToOwner["$($team2.roster_id)"]
                        LoserPoints = $team2Points
                        Difference = $team1Points - $team2Points
                    }
                } else {
                    [PSCustomObject]@{
                        League = $league.name
                        Week = $i
                        MatchID = $_.Name
                        Winner = $rosterToOwner["$($team2.roster_id)"]
                        WinnerPoints = $team2Points
                        Loser = $rosterToOwner["$($team1.roster_id)"]
                        LoserPoints = $team1Points
                        Difference = $team2Points - $team1Points
                    }
                }
            } | Where-Object { $_ -ne $null }



            $biggestBlowout = $matchstats | Sort-Object -Property Difference -Descending | Select-Object -First 1

            $narrowestVictory = $matchstats | Sort-Object -Property Difference | Select-Object -First 1

            $badbeat = $matchstats | Where-Object { $_.LoserPoints -gt 0 } | Sort-Object -Property LoserPoints -Descending | Select-Object -First 1
            
            $overachiever = $matchstats | Where-Object { $_.WinnerPoints -gt 0 } | Sort-Object -Property WinnerPoints | Select-Object -First 1

            # Add Summary Stats to collection
            $summaryStats += [PSCustomObject]@{
                League               = $league.name
                Week                 = $i
                HighestScoringTeam   = "$($highestScoringTeam.TeamOwner) - $($highestScoringTeam.TotalPoints) pts"
                LowestScoringTeam    = "$($lowestScoringTeam.TeamOwner) - $($lowestScoringTeam.TotalPoints) pts"
                BestOverallPlayer = "$($bestOverall.TeamOwner) - $($bestOverallname) ($($bestOverall.Points) pts)"
                BestQB               = "$($bestQB.TeamOwner) - $($bestQB.Player) ($($bestQB.Points) pts)"
                BestRB               = "$($bestRB.TeamOwner) - $($bestRB.Player) ($($bestRB.Points) pts)"
                BestWR               = "$($bestWR.TeamOwner) - $($bestWR.Player) ($($bestWR.Points) pts)"
                BestTE               = "$($bestTE.TeamOwner) - $($bestTE.Player) ($($bestTE.Points) pts)"
                BestK                = "$($bestK.TeamOwner) - $($bestK.Player) ($($bestK.Points) pts)"
                BestDEF              = "$($bestDEF.TeamOwner) - $($bestDEF.PlayerTeam) ($($bestDEF.Points) pts)"
                "BestBaby(24-)"      = "$($bestBaby.TeamOwner) - $($bestBaby.Player) ($($bestBaby.Points) pts - $($bestBaby.PlayerAge) y.o.)"
                "BestGrandpa(30+)" = "$($bestGrandpa.TeamOwner) - $($bestGrandpa.Player) ($($bestGrandpa.Points) pts - $($bestGrandpa.PlayerAge) y.o.)"
                BestBenchPlayer     = "$($bestBenchPlayer.TeamOwner) - $($bestBenchPlayer.Player) ($($bestBenchPlayer.Points) pts)"
                BestBenchTeam       = "$($highestBenchTeam.TeamOwner) - $($highestBenchTeam.TotalPoints) pts"
                BiggestBlowout             = "$($biggestBlowout.Winner) ($($biggestBlowout.WinnerPoints) pts) vs $($biggestBlowout.Loser) ($($biggestBlowout.LoserPoints) pts) - ($($biggestBlowout.Difference)) pts)"
                "SkinOfTeeth (Narrowest W)"   = "$($narrowestVictory.Winner) ($($narrowestVictory.WinnerPoints) pts) vs $($narrowestVictory.Loser) ($($narrowestVictory.LoserPoints) pts) - ($($narrowestVictory.Difference)) pts)"
                "BadBeat (Most pts in L)"         = "$($badBeat.loser) ($($badBeat.LoserPoints) pts)"
                "Overachiever (Least pts in W)"   = "$($overachiever.Winner) ($($overachiever.WinnerPoints) pts)"

            }
        }
    }

    # Step 7: Export to Excel if requested
    if ($ExportToExcel) {
        # Ensure ImportExcel module is installed
        if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
            Write-Error "The 'ImportExcel' module is required for exporting to Excel. Install it with 'Install-Module -Name ImportExcel'."
            return
        }

        # Create a default Excel file path based on the current date, time, and seconds of script execution
        if (-not $ExcelFilePath) {
            # Ensure the .sleeper directory exists
            $sleeperDir = "$HOME/.sleeper"
            if (-not (Test-Path $sleeperDir)) {
                New-Item -ItemType Directory -Path $sleeperDir -Force | Out-Null
            }

            # Create the Excel file name based on the current timestamp (with seconds)
            $timestamp = (Get-Date).ToString("yyyyMMdd_HHmmss")
            $ExcelFilePath = Join-Path $sleeperDir "SleeperWeeklyReport_$timestamp.xlsx"

            Write-Verbose "Excel file will be saved as: $ExcelFilePath"
        }

        # Export data to Excel with pivot table
        Write-Verbose "Exporting data to Excel"

        Write-Verbose "Exporting data to specified Excel file: $ExcelFilePath"
        $rawData | Export-Excel -Path $ExcelFilePath -WorksheetName "Weekly Report" -TableStyle Medium7 -IncludePivotTable `
            -PivotRows @("League", "TeamOwner", "PlayerPos", "Player") -PivotData @{Points = "Sum"} -PivotColumns @("Week", "Starter")
        #$summaryStats | Export-Excel -Path $ExcelFilePath -WorksheetName "Summary Stats" -Append -TableStyle Medium6

        Invoke-Item $ExcelFilePath

        Write-Host "Weekly report exported."
    }
    $allmatches | Sort-Object -Property league,week,WinnerPoints -Descending | Format-Table
    return $summaryStats
}
