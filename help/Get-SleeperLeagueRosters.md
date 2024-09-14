---
external help file: Sleeper-help.xml
Module Name: Sleeper
online version:
schema: 2.0.0
---

# Get-SleeperLeagueRosters

## SYNOPSIS
Retrieves all rosters for a specified league.

## SYNTAX

```
Get-SleeperLeagueRosters [-LeagueId] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-SleeperLeagueRosters cmdlet retrieves all rosters for a specific Sleeper league. 
It returns details such as players, starters, reserve, taxi, and metadata.

## EXAMPLES

### EXAMPLE 1
```
Get-SleeperLeagueRosters -LeagueId "123456789"
```

Retrieves all rosters for the league with ID "123456789".

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

### SleeperRoster[]
### Returns detailed information about rosters for the Sleeper league.
## NOTES
Version: 1.0.0
Author: Your Name

## RELATED LINKS
