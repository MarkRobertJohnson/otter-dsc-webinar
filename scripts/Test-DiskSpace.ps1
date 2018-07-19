param([double]$ThresholdPct)

Get-WMIobject win32_LogicalDisk -filter "DriveType=3" |
    Where-Object {($_.freespace/$_.size) -le $ThresholdPct} | Tee-Object -Variable driveinfo | write-host
 
if ($driveinfo)
{
   $driveinfo | foreach {
    write-warning "$driveinfo has less than 10% space."
   } 
   exit 1
}
exit 0