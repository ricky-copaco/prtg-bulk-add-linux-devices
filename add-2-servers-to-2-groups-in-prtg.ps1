Get-Group -Id YourFirstGroupId | Add-Device -Name "your.firstserver.its.fqdn" -Host "your.firstserver.its.fqdn" -Verbose -AutoDiscover -Template "Your DeviceTemplate's Name"
Get-Group -Id YourSecondGroupId | Add-Device -Name "your.secondserver.its.fqdn" -Host "your.secondserver.its.fqdn" -Verbose -AutoDiscover -Template "Your DeviceTemplate's Name"
