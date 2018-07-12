param(
    [parameter(Mandatory=$true,
        HelpMessage="The name of the module ID in the PowerShell Gallery"
    [string]$ModuleName)

# Test for module
if(Get-Module -Name $ModuleName -List -ErrorAction SilentlyContinue) { $true } else { $false }