Configuration ServerConfig
{ 
    Registry RegistryExample
    {
        Ensure      = "Present"  # You can also set Ensure to "Absent"
        Key         = "HKEY_LOCAL_MACHINE\SOFTWARE\ExampleKey2"
        ValueName   = "TestValue"
        ValueData   = "TestData"
    }
    
    foreach($path in @('my/path1','my/path2','my/path3')) {
        Environment $path
        {
            Ensure      = "Present"
            Name        = "MYCUSTOMPATH"
            Value       = $path
            Path        = $true
        }
    }
}