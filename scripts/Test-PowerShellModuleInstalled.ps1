param([string]$ModuleName)

# Test for module
if(Get-Module -Name $ModuleName -List -ErrorAction SilentlyContinue) { $true } else { $false }