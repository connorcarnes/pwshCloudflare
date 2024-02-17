function Get-MockApiResponse {
    param ()
    $ResultInfo = [PSCustomObject]@{
        page        = 1
        per_page    = 20
        total_pages = 1
        count       = 2
        total_count = 2
    }
    $Result = @(
        [PSCustomObject]@{id = 1; name = 'resourceOne' },
        [PSCustomObject]@{id = 2; name = 'resourceTwo' },
        [PSCustomObject]@{id = 3; name = 'resourceThree' }
    )
    $Response = [PSCustomObject]@{
        result      = $Result
        result_info = $ResultInfo
        success     = $true
        errors      = @()
        messages    = @()
    }
    $Response
}