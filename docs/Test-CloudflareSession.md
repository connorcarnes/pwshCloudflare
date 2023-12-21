---
external help file: pwshCloudflare-help.xml
Module Name: pwshCloudflare
online version: https://github.com/connorcarnes/pwshCloudflare
schema: 2.0.0
---

# Test-CloudflareSession

## SYNOPSIS
Tests the Cloudflare session by verifying the authentication credentials.

## SYNTAX

### ImportedSession
```
Test-CloudflareSession [-Session <WebRequestSession>] [<CommonParameters>]
```

### NewSession
```
Test-CloudflareSession [-Email <String>] [-ApiKey <String>] [-ApiToken <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Tests the Cloudflare session by verifying the authentication credentials.
Token auth is tested using the https://api.cloudflare.com/client/v4/user/tokens/verify endpoint.
Legacy auth is tested using the https://api.cloudflare.com/client/v4/user endpoint.

## EXAMPLES

### EXAMPLE 1
```
$Splat = @{
    Email        = "user@example.com"
    ApiKey       = "API_KEY"
    ApiToken     = "API_TOKEN"
}
Test-CloudflareSession @Splat
Configures a new [Microsoft.PowerShell.Commands.WebRequestSession] and tests authentication.
```

## PARAMETERS

### -Session
Specifies the WebRequestSession object to be used for the Cloudflare session.
This parameter is only required when using the 'ImportedSession' parameter set.

```yaml
Type: WebRequestSession
Parameter Sets: ImportedSession
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Email
Specifies the email associated with the Cloudflare account.
This parameter is only required when using the 'NewSession' parameter set.

```yaml
Type: String
Parameter Sets: NewSession
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiKey
Specifies the API key associated with the Cloudflare account.
This parameter is only required when using the 'NewSession' parameter set.

```yaml
Type: String
Parameter Sets: NewSession
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiToken
Specifies the API token associated with the Cloudflare account.
This parameter is only required when using the 'NewSession' parameter set.

```yaml
Type: String
Parameter Sets: NewSession
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -Verbose, -WarningAction, -WarningVariable, and -ProgressAction.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/connorcarnes/pwshCloudflare](https://github.com/connorcarnes/pwshCloudflare)

[https://developers.cloudflare.com/fundamentals/api/](https://developers.cloudflare.com/fundamentals/api/)
