param([string]$ModuleName)

if(Get-Module -Name $ModuleName -List -ErrorAction SilentlyContinue) { $true } else { $false }