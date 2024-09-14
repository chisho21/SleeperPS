# Sleeper.psm1
# Module to interact with Sleeper API

# Import all cmdlets from the Public directory
Get-ChildItem -Path $PSScriptRoot\Public -Filter *.ps1 | ForEach-Object {
    . $_.FullName
}

# SleeperClasses.psm1
# Contains all class definitions for Sleeper API objects

class SleeperUser {
    [string]$UserId
    [string]$Username
    [string]$DisplayName
    [string]$Avatar
    [PSCustomObject]$Metadata
    [string]$VerificationStatus

    SleeperUser([PSCustomObject]$user) {
        $this.UserId = $user.user_id
        $this.Username = $user.username
        $this.DisplayName = $user.display_name
        $this.Avatar = $user.avatar
        $this.Metadata = $user.metadata
        $this.VerificationStatus = $user.verification
    }
}

class SleeperLeague {
    [string]$LeagueId
    [string]$Name
    [string]$Sport
    [string]$Season
    [PSCustomObject]$Settings
    [bool]$DraftComplete
    [string]$Status
    [string]$RosterPositions
    [bool]$IsKeeperLeague

    SleeperLeague([PSCustomObject]$league) {
        $this.LeagueId = $league.league_id
        $this.Name = $league.name
        $this.Sport = $league.sport
        $this.Season = $league.season
        $this.Settings = $league.settings
        $this.DraftComplete = $league.draft_complete
        $this.Status = $league.status
        $this.RosterPositions = $league.roster_positions
        $this.IsKeeperLeague = $league.keeper_league
    }
}

class SleeperRoster {
    [string]$RosterId
    [string]$OwnerId
    [string]$LeagueId
    [int]$Wins
    [int]$Losses
    [int]$Ties
    [array]$Players
    [array]$Starters
    [array]$Reserve
    [array]$Taxi
    [PSCustomObject]$Metadata

    SleeperRoster([PSCustomObject]$roster) {
        $this.RosterId = $roster.roster_id
        $this.OwnerId = $roster.owner_id
        $this.LeagueId = $roster.league_id
        $this.Wins = $roster.settings.wins
        $this.Losses = $roster.settings.losses
        $this.Ties = $roster.settings.ties
        $this.Players = $roster.players
        $this.Starters = $roster.starters
        $this.Reserve = $roster.reserve
        $this.Taxi = $roster.taxi
        $this.Metadata = $roster.metadata
    }
}

class SleeperTransaction {
    [string]$TransactionId
    [string]$Type
    [string]$Status
    [array]$RosterIds
    [hashtable]$Drops
    [hashtable]$Adds
    [array]$DraftPicks
    [datetime]$CreatedAt

    # Constructor to initialize the class with the transaction data
    SleeperTransaction([PSCustomObject]$transaction) {
        $this.TransactionId = $transaction.transaction_id
        $this.Type = $transaction.type
        $this.Status = $transaction.status
        $this.RosterIds = $transaction.roster_ids
        $this.Drops = $transaction.drops
        $this.Adds = $transaction.adds
        $this.DraftPicks = $transaction.draft_picks
        $this.CreatedAt = [datetime]::ParseExact($transaction.created_at, 'yyyy-MM-ddTHH:mm:ss.fffZ', $null)
    }
}


class SleeperTradedPick {
    [string]$PickId
    [string]$OwnerId
    [string]$OwnerUserId
    [string]$DraftId
    [int]$Round
    [int]$PickNumber
    [string]$PreviousOwner
    [string]$PreviousOwnerUserId
    [string]$RosterId
    [string]$LeagueId 

    SleeperTradedPick([PSCustomObject]$pick, [string]$LeagueId) {
        $this.PickId = $pick.pick_id
        $this.OwnerId = $pick.owner_id
        $this.OwnerUserId = $pick.owner_user_id
        $this.DraftId = $pick.draft_id
        $this.Round = $pick.round
        $this.PickNumber = $pick.pick
        $this.PreviousOwner = $pick.previous_owner_id
        $this.PreviousOwnerUserId = $pick.previous_owner_user_id
        $this.RosterId = $pick.roster_id
        $this.LeagueId = $LeagueId 
    }
}


class SleeperBracket {
    [string]$BracketId
    [string]$Type
    [PSCustomObject]$Matchups

    SleeperBracket([PSCustomObject]$bracket) {
        $this.BracketId = $bracket.bracket_id
        $this.Type = $bracket.type
        $this.Matchups = $bracket.matchups
    }
}

class SleeperDraft {
    [string]$DraftId
    [string]$Type
    [int]$Rounds
    [PSCustomObject]$Settings

    SleeperDraft([PSCustomObject]$draft) {
        $this.DraftId = $draft.draft_id
        $this.Type = $draft.type
        $this.Rounds = $draft.rounds
        $this.Settings = $draft.settings
    }
}

class SleeperDraftPick {
    [string]$PickId
    [string]$DraftId
    [int]$Round
    [int]$PickNumber
    [SleeperPlayer]$Player

    SleeperDraftPick([PSCustomObject]$pick, [SleeperPlayer]$player) {
        $this.PickId = $pick.pick_id
        $this.DraftId = $pick.draft_id
        $this.Round = $pick.round
        $this.PickNumber = $pick.pick_number
        $this.Player = $player
    }
}

class SleeperTrendingPlayer {
    [string]$PlayerId
    [string]$Name
    [int]$Adds
    [int]$Drops
    [string]$Position
    [string]$Team

    SleeperTrendingPlayer([PSCustomObject]$trendingPlayer) {
        $this.PlayerId = $trendingPlayer.player_id
        $this.Name = $trendingPlayer.name
        $this.Adds = $trendingPlayer.adds
        $this.Drops = $trendingPlayer.drops
        $this.Position = $trendingPlayer.position
        $this.Team = $trendingPlayer.team
    }
}

class SleeperNFLState {
    [int]$Season
    [int]$Week
    [string]$Phase

    SleeperNFLState([PSCustomObject]$state) {
        $this.Season = $state.season
        $this.Week = $state.week
        $this.Phase = $state.phase
    }
}

class SleeperPlayer {
    [string]$PlayerId
    [string]$FirstName
    [string]$LastName
    [string]$FullName
    [string]$SearchFullName
    [string]$Position
    [string]$Team
    [string]$Status
    [string]$Sport
    [array]$FantasyPositions
    [int]$Number
    [string]$Weight
    [string]$Height
    [string]$College
    [string]$BirthCity
    [string]$BirthState
    [string]$BirthCountry
    [string]$BirthDate
    [string]$InjuryStatus
    [string]$InjuryStartDate
    [string]$InjuryNotes
    [string]$InjuryBodyPart
    [int]$Age
    [bool]$Active
    [string]$RotowireId
    [string]$SportradarId
    [string]$GsisId
    [string]$YahooId
    [string]$OptaId
    [string]$FantasyDataId
    [string]$RotoworldId
    [string]$EspnId
    [string]$TeamAbbr
    [string]$PracticeDescription
    [string]$PracticeParticipation
    [string]$HighSchool
    [string]$DepthChartPosition
    [int]$DepthChartOrder
    [hashtable]$Metadata
    [string]$Hashtag
    [string]$Competitions
    [Int64]$SearchRank
    [Int64]$NewsUpdated
    [Int64]$YearsExp
    [string]$SwishId
    [string]$StatsId
    [string]$PandascoreId
    [string]$TeamChangedAt
    [string]$OddsjamId

    # Constructor to initialize the class properties from the player data object
    SleeperPlayer([PSCustomObject]$player) {
        $this.PlayerId = $player.player_id
        $this.FirstName = $player.first_name
        $this.LastName = $player.last_name
        $this.FullName = $player.full_name
        $this.SearchFullName = $player.search_full_name
        $this.Position = $player.position
        $this.Team = $player.team
        $this.Status = $player.status
        $this.Sport = $player.sport
        $this.FantasyPositions = $player.fantasy_positions
        $this.Number = $player.number
        $this.Weight = $player.weight
        $this.Height = $player.height
        $this.College = $player.college
        $this.BirthCity = $player.birth_city
        $this.BirthState = $player.birth_state
        $this.BirthCountry = $player.birth_country
        $this.BirthDate = $player.birth_date
        $this.InjuryStatus = $player.injury_status
        $this.InjuryStartDate = $player.injury_start_date
        $this.InjuryNotes = $player.injury_notes
        $this.InjuryBodyPart = $player.injury_body_part
        $this.Age = $player.age
        $this.Active = $player.active
        $this.RotowireId = $player.rotowire_id
        $this.SportradarId = $player.sportradar_id
        $this.GsisId = $player.gsis_id
        $this.YahooId = $player.yahoo_id
        $this.OptaId = $player.opta_id
        $this.FantasyDataId = $player.fantasy_data_id
        $this.RotoworldId = $player.rotoworld_id
        $this.EspnId = $player.espnid
        $this.TeamAbbr = $player.teamabbr
        $this.PracticeDescription = $player.practice_description
        $this.PracticeParticipation = $player.practice_participation
        $this.HighSchool = $player.high_school
        $this.DepthChartPosition = $player.depth_chart_position
        $this.DepthChartOrder = $player.depth_chart_order

        # Check if Metadata is a hashtable or string and convert if necessary
        if ($player.metadata -is [hashtable]) {
            $this.Metadata = $player.metadata
        } else {
            try {
                $this.Metadata = [hashtable]::new()
                $null = $player.metadata.Split(';') | ForEach-Object {
                    $pair = $_.Split('=')
                    if ($pair.Length -eq 2) {
                        $this.Metadata[$pair[0].Trim()] = $pair[1].Trim()
                    }
                }
            } catch {
                $this.Metadata = $null
            }
        }

        $this.Hashtag = $player.hashtag
        $this.Competitions = $player.competitions
        $this.SearchRank = $player.searchrank
        $this.NewsUpdated = $player.newsupdated
        $this.YearsExp = $player.yearsexp
        $this.SwishId = $player.swishid
        $this.StatsId = $player.statsid
        $this.PandascoreId = $player.pandascoreid
        $this.TeamChangedAt = $player.teamchangedat
        $this.OddsjamId = $player.oddsjamid

    }
}
