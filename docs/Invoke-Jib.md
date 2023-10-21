---
external help file: Jib-help.xml
Module Name: Jib
online version:
schema: 2.0.0
---

# Invoke-Jib

## SYNOPSIS
Provides a CLI with convenient methods for interacting with the Docker container running a Laravel Application.

## SYNTAX

```
Invoke-Jib -Action <String> [-d] [<CommonParameters>]
```

## DESCRIPTION
Jib is a PowerShell implementation of Laravel Sail.

Laravel Sail is a light-weight command-line interface for interacting with Laravel's default Docker development environment.

Sail provides a great starting point for building a Laravel application using PHP, MySQL, and Redis without requiring prior Docker experience.

## EXAMPLES

### Example 1: Start the application
```
PS> Invoke-Jib up
```

## PARAMETERS

### -Action
The Sail command to run

```yaml
Type: String
Parameter Sets: sail
Aliases:
Accepted values: up, stop, restart, ps

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -d
If the Sail command should be run in the background. Usefull with 'up'.

```yaml
Type: SwitchParameter
Parameter Sets: sail
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


## RELATED LINKS
