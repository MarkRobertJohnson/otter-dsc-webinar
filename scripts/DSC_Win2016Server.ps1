Configuration ServerConfig
{ 
    Import-DscResource –ModuleName PSDscResources
    
    Registry RegistryExample
    {
        Ensure      = "Present"  # You can also set Ensure to "Absent"
        Key         = "HKEY_LOCAL_MACHINE\SOFTWARE\ExampleKey3"
        ValueName   = "TestValue"
        ValueData   = "TestData"
    }
    
    foreach($var in (@{'var1'='my/path7';'var2' = 'my/path8'; 'var3' = 'my/path9'}).GetEnumerator()) {
        Environment $var.name
        {
            Ensure      = "Present"
            Name        = $var.name
            Value       = $var.value
            Target      = 'Machine'
        }
    }
}