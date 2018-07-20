# Bootstrap "cmdlet" type scripts that are not functions, this is generic code
$testScriptPath = $PSCommandPath -ireplace ".tests.ps1",'.ps1'
$functionNameToTest = [io.Path]::GetFileNameWithoutExtension($testScriptPath)
$function = Set-Item -Path function:\$functionNameToTest -Value ([scriptblock]::Create("[CmdLetBinding(SupportsShouldProcess)]" + (gc $testScriptPath -Raw))) -Force -PassThru


# Pester tests
Describe 'Install-PowerShellModule' {
  It "Given no parameters, it throws an exception" {
    { Install-PowerShellModule -WhatIf } | Should Throw
  }

  Context "Install by Name" {
    It "Given valid -ModuleName '<ModuleName>', it installs the '<ModuleName>' module" -TestCases @(
      @{ ModuleName = 'cChoco' },
      @{ ModuleName = 'Write-ObjectToSQL' }
    ) {
      param ($ModuleName)

      Install-PowerShellModule -ModuleName $ModuleName -whatif 
    }

  }
}