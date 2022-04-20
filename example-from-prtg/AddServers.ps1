if(!(Get-PrtgClient))
{
    Connect-PrtgServer prtg.contoso.local
}

# Import the CSV
$csv = Import-Csv $PSScriptRoot\Servers.csv

# Group each record by its State
$states = $csv | group State

function ProcessStates($states) {

    foreach($state in $states)
    {
        Write-Host "Processing state $($state.Name)"

        # Get this state's PRTG Probe
        $probe = Get-Probe $state.Name

        if(!$probe)
        {
            throw "Could not find probe '$($state.Name)'"
        }

        # Group each record in this state by its District
        $districts = $state.Group | group District

        ProcessDistricts $probe $districts
    }
}

function ProcessDistricts($probe, $districts) {

    foreach($district in $districts)
    {
        Write-Host "   Processing district $($district.Name)"

        # Get this district's PRTG Group
        $districtGroup = $probe | Get-Group $district.Name

        if(!$districtGroup)
        {
            # If no such group exists, create one
            $districtGroup = $probe | Add-Group $district.Name
        }

        ProcessOffices $district $districtGroup
    }
}

function ProcessOffices($district, $districtGroup) {

    foreach($office in $district.Group)
    {
        # Get this office's server
        $device = $districtGroup | Get-Device $office.Name

        if(!$device)
        {
            Write-Host "      Adding device $($office.Name)"

            # Add the device using a Host of <hostname>.<domain>
            $device = $districtGroup | Add-Device $office.Name "$($office.Name).$env:userdnsdomain".ToLower()

            # Set the location
            $device | Set-ObjectProperty Location $office.Location
        }
    }
}

ProcessStates $states