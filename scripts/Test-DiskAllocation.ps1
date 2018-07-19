param([array]$VolumesToCheck)

$Disks = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3"

foreach ($VolumeToCheck in [array]$VolumesToCheck)
{
    $DiskValue = $null
    
    $allocationIssues = @()
    
    #Needs Single Disk Seperated out
    $Driveinfo = $Disks | Where-Object -Property 'DeviceID' -match -Value $VolumeToCheck
    [int]$DiskValue = $Driveinfo.size / 1000000000
    #$JustLetter = ($Driveinfo.DeviceID).Replace(':','')
    #Finally fixed this part!!!
    $JustLetter = ($VolumeToCheck).Replace(':','')


    if ($Driveinfo.DeviceID -eq $VolumeToCheck)
        {
                #Disk Size Correctly Allocated
                $DiskValueLow = $DiskValue * '0.95'
                $DiskValueHigh = $DiskValue * '1.05'
                if ($DiskValueLow -lt $DiskValue -and $DiskValueHigh -gt $DiskValue)
                    {
                        $DiskAllocation_OK = $true
                    }
                    else
                    {
                        $DiskAllocation_OK = $false
                        Write-Warning "Bad disk allocation on ${VolumeToCheck}: $DiskValueLow -lt $DiskValue -and $DiskValueHigh -gt $DiskValue"
                    }

                #Disk Free Space Check
                $PercentFree = [Math]::round((($Driveinfo.freespace/$Driveinfo.size) * 100))
                    if ($PercentFree -gt 30)
                    {
                        $DiskFreespace_OK = $true
                    }
                    else
                    {
                        $DiskFreespace_OK = $false
                        Write-Warning "Not enough free space on ${VolumeToCheck}: ${percentFree}% free"
                    
                    }
                    }
                    #Volume Label Check
                    if ($Driveinfo.DeviceID -eq 'C:'){
                        if (($Driveinfo.VolumeName -eq 'System') -or ($Driveinfo.VolumeName -eq 'OSDisk'))
                                                {
                                                    $DiskVolumeLabel_OK = $true
                                                }
                                                else
                                                {
                                                    $DiskVolumeLabel_OK = $false
                                                    Write-Host "Expected $VolumeToCheck with volume name of $($Driveinfo.VolumeName) to be 'OSDisk or System'"
                                                }
                    }
                    if ($Driveinfo.DeviceID -eq 'D:'){
                        if (($Driveinfo.VolumeName -eq 'DataDisk1') -and ($DriveD_Request -eq $true))
                                                {
                                                    $DiskVolumeLabel_OK = $true
                                                }
                                                else
                                                {
                                                    $DiskVolumeLabel_OK = $false
                                                    Write-Host "Expected $VolumeToCheck with volume name of $($Driveinfo.VolumeName) to be 'DataDisk1'"
                                                    
                                                }
                    }
                    if ($Driveinfo.DeviceID -eq 'E:'){
                        if (($Driveinfo.VolumeName -eq 'DataDisk2') -and ($DriveE_Request -eq $true))
                                                {
                                                    $DiskVolumeLabel_OK = $true
                                                }
                                                else
                                                {
                                                    $DiskVolumeLabel_OK = $false
                                                    Write-Host "Expected $VolumeToCheck with volume name of $($Driveinfo.VolumeName) to be 'DataDisk2'"
                                                    
                                                }
                    }
                    if ($Driveinfo.DeviceID -eq 'F:'){
                        if (($Driveinfo.VolumeName -eq 'DataDisk3') -and ($DriveF_Request -eq $true))
                                                {
                                                    $DiskVolumeLabel_OK = $true
                                                }
                                                else
                                                {
                                                    $DiskVolumeLabel_OK = $false
                                                    Write-Host "Expected $VolumeToCheck with volume name of $($Driveinfo.VolumeName) to be 'DataDisk3'"
                                                    
                                                }
                    }
                    if ($Driveinfo.DeviceID -eq 'G:'){
                        if (($Driveinfo.VolumeName -eq 'DataDisk4') -and ($DriveG_Request -eq $true))
                                                {
                                                    $DiskVolumeLabel_OK = $true
                                                }
                                                else
                                                {
                                                    $DiskVolumeLabel_OK = $false
                                                    Write-Host "Expected $VolumeToCheck with volume name of $($Driveinfo.VolumeName) to be 'DataDisk4'"
                                                    
                                                }
                    }
                    if ($Driveinfo.DeviceID -eq 'H:'){
                        if (($Driveinfo.VolumeName -eq 'DataDisk5') -and ($DriveH_Request -eq $true))
                                                {
                                                    $DiskVolumeLabel_OK = $true
                                                }
                                                else
                                                {
                                                    $DiskVolumeLabel_OK = $false
                                                    Write-Host "Expected $VolumeToCheck with volume name of $($Driveinfo.VolumeName) to be 'DataDisk5'"
                                                    
                                                }
                    }
                    if ($Driveinfo.DeviceID -eq 'I:'){
                        if (($Driveinfo.VolumeName -eq 'DataDisk6') -and ($DriveI_Request -eq $true))
                                                {
                                                    $DiskVolumeLabel_OK = $true
                                                }
                                                else
                                                {
                                                    $DiskVolumeLabel_OK = $false
                                                    Write-Host "Expected $VolumeToCheck with volume name of $($Driveinfo.VolumeName) to be 'DataDisk6'"
                                                    
                                                }
                    }

                    if (($DiskAllocation_OK -ne $true) -or ($DiskFreespace_OK -ne $true) -or ($DiskVolumeLabel_OK -ne $true)) 
                    {
                        $allocationIssues += $VolumeToCheck
                    }


}


if($allocationIssues) {
 exit -1   
} else {
 exit 0   
}
