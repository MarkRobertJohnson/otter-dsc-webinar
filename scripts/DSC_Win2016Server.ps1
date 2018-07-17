Configuration ServerConfig
{ 
    Import-DscResource –ModuleName PSDesiredStateConfiguration
    
    Registry RegistryExample
    {
        Ensure      = "Present"  # You can also set Ensure to "Absent"
        Key         = "HKEY_LOCAL_MACHINE\SOFTWARE\ExampleKey2"
        ValueName   = "TestValue"
        ValueData   = "TestData"
    }
    

    Environment Var1
    {
        Ensure      = "Present"
        Name        = 'Var1'
        Value       = 'Var1Value'
    }

    Environment Var2
    {
        Ensure      = "Present"
        Name        = 'Var2'
        Value       = 'Var2Value'
    }

    Environment Var3
    {
        Ensure      = "Present"
        Name        = 'Var3'
        Value       = 'Var3Value'
    }

}