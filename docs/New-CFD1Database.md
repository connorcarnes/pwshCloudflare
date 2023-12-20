---
external help file: pwshCloudflare-help.xml
Module Name: pwshCloudflare
online version: https://developers.cloudflare.com/api/operations/cloudflare-d1-create-database
schema: 2.0.0
---

# New-CFD1Database

## SYNOPSIS
Creates Cloudflare D1 database.

## SYNTAX

### AccountId
```
New-CFD1Database -Name <String> -AccountId <String> [<CommonParameters>]
```

### AccountName
```
New-CFD1Database -Name <String> -AccountName <String> [<CommonParameters>]
```

## DESCRIPTION
Creates Cloudflare D1 database.

## EXAMPLES

### EXAMPLE 1
```
New-CFD1Database -Name 'myDb' -AccountId '12345'
Creates database 'myDb' for account with ID 12345.
```

### EXAMPLE 2
```
New-CFD1Database -Name 'myDb' -AccountName 'My Account'
Creates database 'myDb' for account 'My Account'.
```

## PARAMETERS

### -Name
Name of database to create.

```yaml
Type: String
Parameter Sets: (All)
Aliases: DatabaseName

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccountId
ID of account to retrieve.
If not specified, all accounts will be returned.

```yaml
Type: String
Parameter Sets: AccountId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccountName
Name of account to retrieve.
If not specified, all accounts will be returned.

```yaml
Type: String
Parameter Sets: AccountName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Cloudflare.D1Database
## NOTES

## RELATED LINKS

[https://developers.cloudflare.com/api/operations/cloudflare-d1-create-database](https://developers.cloudflare.com/api/operations/cloudflare-d1-create-database)

