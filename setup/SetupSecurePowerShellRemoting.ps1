param(

    $DNSName = "13.66.231.186",
    $cert64 = "MIIDJDCCAgygAwIBAgIQO4/Y7dSkiJFI0sfGyc5JnDANBgkqhkiG9w0BAQsFADAYMRYwFAYDVQQDDA0xMy42Ni4yMzEuMTg2MB4XDTE4MDcxMjE1NTMwMFoXDTE5MDcxMjE2MTMwMFowGDEWMBQGA1UEAwwNMTMuNjYuMjMxLjE4NjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAOpdLmr1+8CE8XKYtYGwpWQh7LbzZOAWtgHfYb4QGAgnHZt+TVwb0eLnA6OzreRGT0txOW9FASROnk130VYcDyj+rwVyFLoqNdZ8D/jrtoxKkk2MRAsK+RQDGqPOKH8gc5758NHBG3D9WxJFAyhaMkrNHKKI32vffo0TfzxEQtSCCRoQvrwNU7DZaqv6zA8CmV63gEsCAyW6EEXd/bhFkdQ5Ahy0XMpZ00wmVy3OmHmzU3kTqcBzBpL8pV+Rbr+VBCcSV5oBc5HzpXAQeYTBWd3YU0MB5oqX45Of/ZAm4QIaRTFpqPYOqiAHvf+o7alNUSfAew8fAvndCMESH+23Pp8CAwEAAaNqMGgwDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDATAYBgNVHREEETAPgg0xMy42Ni4yMzEuMTg2MB0GA1UdDgQWBBSc3zfxGGkneT5WlXelyfSjnq+/vzANBgkqhkiG9w0BAQsFAAOCAQEAMe5NnrdamBrXAEH6ufPhW9ge7TAXcXS/G3N6S1Tjx0sFbskdHHP68noHLyHm8H9/9C5gWamFcmGmCU0ju0DrikxOsaclr0HnlKALytnOej4UUNgtUuv0wzdcCqBWFsM53tKo/68EcwRu9P8AK9ycoKP8QLMwOA9gAbcT43O1HWWGCrELl7s6Mgtb/PmyJQemg8XzvImkEOtPIjVGJ1P8Ui/sDadhKJg1C9Q2o4ultCrOpk8WsGtS+pP1rlntw2K3EgEO9VFkPIxAiQawiHTv03FLeqwv+oab17yT+oXXpnq9G0VaMIzw7sPX6FJeKN/8cyI1/M466QEpg6KskQF1VA=="

)

$serverCode = @'
 #POWERSHELL TO EXECUTE ON REMOTE SERVER BEGINS HERE  
$DNSName = $env:COMPUTERNAME

#IP Address is better so you do not need host entries or DNS setup
$DNSName = Test-Connection -ComputerName ($env:COMPUTERNAME) -Count 1  | Select -ExpandProperty IPV4Address | select -ExpandProperty IPAddressToString

$DNSName = "13.66.231.186"
$newDnsName = Read-Host "what DNS Name for external access (Default: $DNSName)"
if($newDnsName) {
    $DNSName = $newDnsName
}
#Ensure PS remoting is enabled, although this is enabled by default for Azure VMs 
Enable-PSRemoting -Force  
 
#Create rule in Windows Firewall 
New-NetFirewallRule -Name "WinRM HTTPS" -DisplayName "WinRM HTTPS" -Enabled True -Profile "Any" -Action "Allow" -Direction "Inbound" -LocalPort 5986 -Protocol "TCP"  
  
#Create rule in Windows Firewall 
New-NetFirewallRule -Name "WinRM HTTP" -DisplayName "WinRM HTTP" -Enabled True -Profile "Any" -Action "Allow" -Direction "Inbound" -LocalPort 5985 -Protocol "TCP"  
  
#Create Self Signed certificate and store thumbprint 
$thumbprint = (New-SelfSignedCertificate -DnsName $DNSName -CertStoreLocation Cert:\LocalMachine\My).Thumbprint   

#Clear out existing listener
$cmd = "winrm delete winrm/config/Listener?Address=*+Transport=HTTPS "
cmd.exe /C $cmd

$cmd = "winrm delete winrm/config/Listener?Address=*+Transport=HTTP "
cmd.exe /C $cmd

#Run WinRM configuration on command line. DNS name set to computer hostname, you may wish to use a FQDN 
$cmd = "winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname=""$DNSName""; CertificateThumbprint=""$thumbprint""}" 
cmd.exe /C $cmd   

$cmd = "winrm create winrm/config/Listener?Address=*+Transport=HTTP @{Hostname=""$DNSName""}" 
cmd.exe /C $cmd



#Write cert to file
$cert = gi "Cert:\LocalMachine\My\$thumbPrint"
Export-Certificate -Cert $cert -FilePath "${DNSName}.cer"
$certBytes = [io.file]::ReadAllbytes("${DNSName}.cer")
[convert]::ToBase64String($certBytes)

#POWERSHELL TO EXECUTE ON REMOTE SERVER ENDS HERE
'@

Write-host -ForegroundColor Cyan $serverCode
Read-Host -Prompt "Copy this script and run on the server, hit enter to run the client configuration ..."|out-null


#CLIENT SIDE CODE

#IMPORT CERT


$newDnsName = Read-Host "Enter the IP address of the server (or DNS name) default: $DNSName"
if($newDNSName) {
    $DNSName = $newDnsName
}

$newCert64 = Read-Host -Prompt "Paste the Base64 certificate string from the terminal window of the server here (Enter for default $($cert64.Substring(0,20))...)" 
if($newCert64) {
    #Paste the Base64 cert from the terminal on the server here
    $cert64 = $newCert64
}

$certBytes = [convert]::FromBase64String($cert64)
$certPath = "c:\temp\${DNSName}.cer"
[io.file]::WriteAllBytes( $certPath, $certBytes)

Import-Certificate -FilePath $certPath -CertStoreLocation Cert:\LocalMachine\Root\ 

if(!$cred) {
    $cred = get-credential "LOCAL_VM_ADMIN_USER" -Message "Credentials for $DnsName"
}


Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value $DNSName -Concatenate -Force

# Won't need this since the cert has been added to trusted Root store
#$sessionOptions = New-PSSessionOption -SkipCACheck -SkipCNCheck 

Write-host -fore cyan "Testing HTTPS PowerShell remoting connection to $DNSName"                
Invoke-Command -ComputerName  $DNSName -Credential $cred -UseSSL  -ScriptBlock {  
    #Code to be executed in the remote session goes here 
    $hostname = hostname 
    Write-Output "Message from remote server: Hostname : $hostname" 
} 

Write-host -fore cyan "Testing HTTP PowerShell remoting connection to $DNSName"                
Invoke-Command -ComputerName  $DNSName -Credential $cred   -ScriptBlock {  
    #Code to be executed in the remote session goes here 
    $hostname = hostname 
    Write-Output "Message from remote server: Hostname : $hostname" 
} 
