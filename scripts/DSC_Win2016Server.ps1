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
    
    foreach($var in (@{'var1'='my/path1';'var2' = 'my/path2'; 'var3' = 'my/path3'}).GetEnumerator()) {
        Environment $var.name
        {
            Ensure      = "Present"
            Name        = $var.name
            Value       = $var.value
            Path        = $true
        }
    }
}