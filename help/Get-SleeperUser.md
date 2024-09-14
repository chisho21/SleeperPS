---
external help file: Sleeper-help.xml
Module Name: Sleeper
online version:
schema: 2.0.0
---

# Get-SleeperUser

## SYNOPSIS
Retrieves user information from the Sleeper API by username.

## SYNTAX

```
Get-SleeperUser [-Username] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-SleeperUser cmdlet retrieves user information from the Sleeper API based on the specified username.
It returns the user's profile information, including display name, avatar, and more.

## EXAMPLES

### EXAMPLE 1
```
Get-SleeperUser -Username "example_user"
```

Retrieves the user profile for the specified Sleeper username.

## PARAMETERS

### -Username
Specifies the username of the Sleeper user whose information will be retrieved.

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

### SleeperUser
## NOTES
Version: 1.0.0
Author: Your Name

## RELATED LINKS
