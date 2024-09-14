---
external help file: Sleeper-help.xml
Module Name: Sleeper
online version:
schema: 2.0.0
---

# Get-SleeperTrendingPlayers

## SYNOPSIS
Retrieves a list of trending players based on recent adds or drops.

## SYNTAX

```
Get-SleeperTrendingPlayers [-Type] <String> [[-LookbackHours] <Int32>] [[-Limit] <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-SleeperTrendingPlayers cmdlet retrieves a list of trending players, either based on recent adds or drops over a specified time period.

## EXAMPLES

### EXAMPLE 1
```
Get-SleeperTrendingPlayers -Type add -sport nfl -LookbackHours 24 -Limit 10
```

Retrieves the top 10 trending players in the NFL based on recent adds over the last 24 hours.

## PARAMETERS

### -Type
Specifies whether to retrieve trending players based on recent 'add' or 'drop' activity.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LookbackHours
Specifies the number of hours to look back for trending player data.
Defaults to 24 hours.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 24
Accept pipeline input: False
Accept wildcard characters: False
```

### -Limit
Specifies the maximum number of trending players to retrieve.
Defaults to 25.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 25
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

### SleeperTrendingPlayer[]
## NOTES
Version: 1.0.0
Author: Your Name

## RELATED LINKS
