function Register-CFArgumentCompleter {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Script block params cause this rule to fail.')]
    param()
    begin {}
    process {
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
    }
    end {}
}