param(
    [parameter(Mandatory=$true,
        HelpMessage="The name of the module ID in the PowerShell Gallery"
    [string]$ModuleName)

Write-Host "Installing module: $ModuleName"
install-module -Name $ModuleName -Force -AllowClobber -verbose