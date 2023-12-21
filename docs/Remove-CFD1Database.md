---
external help file: pwshCloudflare-help.xml
Module Name: pwshCloudflare
online version: https://github.com/connorcarnes/pwshCloudflare
schema: 2.0.0
---

# Remove-CFD1Database

## SYNOPSIS
Deletes a Cloudflare D1 database.

## SYNTAX

### AccountId
```
Remove-CFD1Database [-Name <String>] [-Id <String>] [-AccountId <String>]
 [<CommonParameters>]
```

### AccountName
```
Remove-CFD1Database [-Name <String>] [-Id <String>] [-AccountName <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Get Cloudflare account information.

## EXAMPLES

### EXAMPLE 1
```
Remove-CFD1Database -Name 'myDb' -AccountId '12345'
Deletes database 'myDb' for account with ID 12345.
```

### EXAMPLE 2
```
Remove-CFD1Database -Name 'myDb' -AccountName 'My Account'
Deletes database 'myDb' for account 'My Account'.
```

## PARAMETERS

### -Name
Name of database to delete.

```yaml
Type: String
Parameter Sets: (All)
Aliases: DatabaseName

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
ID of database to delete.

```yaml
Type: String
Parameter Sets: (All)
Aliases: DatabaseId

Required: False
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

Required: False
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

### Cloudflare.D1Database
## NOTES

## RELATED LINKS

[https://github.com/connorcarnes/pwshCloudflare](https://github.com/connorcarnes/pwshCloudflare)

[https://developers.cloudflare.com/api/operations/cloudflare-d1-delete-database](https://developers.cloudflare.com/api/operations/cloudflare-d1-delete-database)
