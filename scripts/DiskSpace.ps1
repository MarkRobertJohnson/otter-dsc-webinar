
$driveinfo = Get-WMIobject win32_LogicalDisk  -filter "DriveType=3" |
    Select-Object SystemName, DeviceID, VolumeName,
    @{Name="Size(GB)"; Expression={"{0:N1}" -f($_.size/1gb)}},
    @{Name="FreeSpace(GB)"; Expression={"{0:N1}" -f($_.freespace/1gb)}},
    @{Name="% FreeSpace(GB)"; Expression={"{0:N2}%" -f(($_.freespace/$_.size)*100)}},
    @{Name="Date"; Expression={$(Get-Date -format 'g')}} 

# Can send data to multiple places
$driveinfo | Where-Object { ($_.freespace/$_.size) -le '0.1'} |foreach {
    throw $_
}
