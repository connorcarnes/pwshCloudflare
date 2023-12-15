<#
.SYNOPSIS
    Registers argument completers for pwshCloudflare functions
.DESCRIPTION
    This function registers argument completers for pwshCloudflare functions with data from the Cloudflare API.
    It creates a lookup table of Cloudflare zone names and their corresponding IDs.
    This function is called by Set-CloudflareSession so that the argument completers are updated when a session is created or updated.
.EXAMPLE
    Register-CFArgumentCompleter
    Registers argument completers for the Cloudflare cmdlets.
#>
function Register-CFArgumentCompleter {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Script block params cause this rule to fail.')]
    param()
    begin {}
    process {
        # Zone Lookup Table
        $Functions = ($MyInvocation.MyCommand.Module.ExportedFunctions.GetEnumerator() |
                Where-Object { $_.Value.Parameters.Keys -Contains 'ZoneName' }).Key
        $Script:cfZoneLookupTable = @{}
        Get-CFZone | ForEach-Object {
            $Script:cfZoneLookupTable.Add($_.name, $_.id)
        }
        $Splat = @{
            CommandName   = 'Get-CFZone', 'Get-CFZoneRecord', 'New-CFZoneRecord'
            ParameterName = 'ZoneName'
            ScriptBlock   = {
                param(
                    $commandName,
                    $parameterName,
                    $wordToComplete,
                    $commandAst,
                    $fakeBoundParameters
                )
                $Script:cfZoneLookupTable.Keys | Where-Object { $_ -like "$WordToComplete*" }
            }
        }
        Register-ArgumentCompleter @Splat

        # Account Lookup Table
        $Functions = ($MyInvocation.MyCommand.Module.ExportedFunctions.GetEnumerator() |
                Where-Object { $_.Value.Parameters.Keys -Contains 'AccountName' }).Key
        $Script:cfAccountLookupTable = @{}
        Get-CFAccount | ForEach-Object {
            $Script:cfAccountLookupTable.Add($_.name, $_.id)
        }
        $Splat = @{
            CommandName   = $Functions
            ParameterName = 'AccountName'
            ScriptBlock   = {
                param(
                    $commandName,
                    $parameterName,
                    $wordToComplete,
                    $commandAst,
                    $fakeBoundParameters
                )
                $Script:cfAccountLookupTable.Keys | Where-Object { $_ -like "$WordToComplete*" }
            }
        }
        Register-ArgumentCompleter @Splat
    }
    end {}
}