---
external help file: pwshCloudflare-help.xml
Module Name: pwshCloudflare
online version: https://github.com/connorcarnes/pwshCloudflare
schema: 2.0.0
---

# Get-CFAccount

## SYNOPSIS
Get Cloudflare account information.

## SYNTAX

```
Get-CFAccount [[-Id] <String>] [[-Name] <String>] [<CommonParameters>]
```

## DESCRIPTION
Returns accounts available to the current user.
Accounts can be specified by their name or id.
All accounts are returned if name or id is not specified.

## EXAMPLES

### EXAMPLE 1
```
Get-CFAccount -AccountId '12345'
Gets account with ID 12345.
```

### EXAMPLE 2
```
Get-CFAccount
Lists accounts available to current user.
```

## PARAMETERS

### -Id
ID of account to retrieve.

```yaml
Type: String
Parameter Sets: (All)
Aliases: AccountId

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Name of account to retrieve.

```yaml
Type: String
Parameter Sets: (All)
Aliases: AccountName

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -Verbose, -WarningAction, -WarningVariable, and -ProgressAction. 
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Cloudflare.Account
## NOTES

## RELATED LINKS

[https://github.com/connorcarnes/pwshCloudflare](https://github.com/connorcarnes/pwshCloudflare)

[https://developers.cloudflare.com/api/operations/accounts-list-accounts](https://developers.cloudflare.com/api/operations/accounts-list-accounts)

[https://developers.cloudflare.com/api/operations/accounts-account-details](https://developers.cloudflare.com/api/operations/accounts-account-details)
