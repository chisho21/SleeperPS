---
external help file: Sleeper-help.xml
Module Name: Sleeper
online version:
schema: 2.0.0
---

# Get-SleeperLeagueMatchups

## SYNOPSIS
Retrieves matchups for a specific week in a league.

## SYNTAX

```
Get-SleeperLeagueMatchups [-LeagueId] <String> [[-Week] <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-SleeperMatchups cmdlet retrieves weekly matchups for a specified week in a given league.
If no week is provided, it fetches the current week from the Sleeper NFL state API.

## EXAMPLES

### EXAMPLE 1
```
Get-SleeperMatchups -LeagueId "123456789" -Week 5
```

Retrieves matchups for week 5 in the league with ID "123456789".

### EXAMPLE 2
```
Get-SleeperMatchups -LeagueId "123456789"
```

Fetches matchups for the current week in the league with ID "123456789".

## PARAMETERS

### -LeagueId
Specifies the unique identifier of the Sleeper league.
This can be passed directly or through the pipeline.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Week
Specifies the week number to retrieve matchups for.
If not provided, it defaults to the current week using the Sleeper NFL state.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSCustomObject
### Returns detailed matchup information for the specified week in the league.
## NOTES
Version: 1.0.0
Author: Your Name

## RELATED LINKS
