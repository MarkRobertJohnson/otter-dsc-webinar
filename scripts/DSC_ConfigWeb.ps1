Configuration ConfigWeb
{ 
    Registry RegistryExample
    {
        Ensure      = "Present"  # You can also set Ensure to "Absent"
        Key         = "HKEY_LOCAL_MACHINE\SOFTWARE\ExampleKey"
        ValueName   = "TestValue"
        ValueData   = "TestData"
    }
    
    Service ServiceExample
    {
        Name        = "W3SVC"
        StartupType = "Automatic"
        State       = "Running"
        DependsOn   = @('RegistryExample')
        
    }
}