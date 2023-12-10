---
external help file: pwshCloudflare-help.xml
Module Name: pwshCloudflare
online version: https://developers.cloudflare.com/fundamentals/api/
schema: 2.0.0
---

# Set-CloudflareSession

## SYNOPSIS
Configures authentication for the Cloudflare API using an API token, legacy authentication (email and global API key), or both.

## SYNTAX

### SessionOnly (Default)
```
Set-CloudflareSession [-Email <String>] [-ApiKey <String>] [-ApiToken <String>] [<CommonParameters>]
```

### SaveToFile
```
Set-CloudflareSession [-Email <String>] [-ApiKey <String>] [-ApiToken <String>] [-SaveToFile]
 [-LoadOnImport <Boolean>] [-FilePath <String>] [<CommonParameters>]
```

### ImportFromFile
```
Set-CloudflareSession [-ImportFromFile] [-FilePath <String>] [<CommonParameters>]
```

## DESCRIPTION
By default configuration data is stored as a \[Microsoft.PowerShell.Commands.WebRequestSession\] object in $script:cfSession and does not persist across PowerShell sessions.
Alternatively you can save the configuration to a file to load as needed or on module import.
Export-Clixml and Import-Clixml are used to save and load the configuration.
As such, secrets are not stored securely.
See https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/import-clixml?view=powershell-7.3#example-2-import-a-secure-credential-object
The default path for the configuration file is "$(\[Environment\]::GetFolderPath(\[Environment+SpecialFolder\]::UserProfile))\.pwshCloudflare\config.xml"

## EXAMPLES

### EXAMPLE 1
```
Set-CloudflareSession -Email "user@example.com" -ApiKey "API_KEY"
Configures legacy authentication for the current session.
```

### EXAMPLE 2
```
Set-CloudflareSession -Email "user@example.com" -ApiKey "API_KEY" -ApiToken "API_TOKEN"
Configures legacy authentication and API token authentication for the current session.
```

### EXAMPLE 3
```
$Splat = @{
    Email        = "user@example.com"
    ApiKey       = "API_KEY"
    ApiToken     = "API_TOKEN"
    SaveToFile   = $true
    LoadOnImport = $true
}
Set-CloudflareSession @Splat
Configures authentication, saves the configuration to the default location and sets the module to load the configuration on import.
```

## PARAMETERS

### -Email
Specifies the email associated with the Cloudflare account.

```yaml
Type: String
Parameter Sets: SessionOnly, SaveToFile
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiKey
Specifies the API key associated with the Cloudflare account.

```yaml
Type: String
Parameter Sets: SessionOnly, SaveToFile
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiToken
Specifies the API token associated with the Cloudflare account.

```yaml
Type: String
Parameter Sets: SessionOnly, SaveToFile
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SaveToFile
Indicates whether to save the session data to a file.
If specified, the session data will be saved to the file specified by the FilePath parameter.

```yaml
Type: SwitchParameter
Parameter Sets: SaveToFile
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -LoadOnImport
Indicates whether to load the session data from the file specified by the FilePath parameter when importing session data.

```yaml
Type: Boolean
Parameter Sets: SaveToFile
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ImportFromFile
Indicates whether to import the session data from a file.
If specified, the session data will be imported from the file specified by the FilePath parameter.

```yaml
Type: SwitchParameter
Parameter Sets: ImportFromFile
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilePath
Specifies the path to the file where the session data will be saved or imported from.
If not specified, the default path will be used.

```yaml
Type: String
Parameter Sets: SaveToFile, ImportFromFile
Aliases:

Required: False
Position: Named
Default value: $Script:cfConfigPath
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://developers.cloudflare.com/fundamentals/api/](https://developers.cloudflare.com/fundamentals/api/)

