<#
.SYNOPSIS
    This script will capture the site collection admins on personal onedrive accounts for a domain. 
    The script will temporary add the admin account being used to the site collection admin to gather the report. 
    The admin account will have to be at least a SharePoint Administrator in Entra ID.
.NOTES
    File Name      : getOneDriveSiteCollectionOwners.ps1
    Author         : Brandon Hough
    Prerequisite   : Microsoft.Online.SharePoint.PowerShell
    
.PARAMETER domainname
Only include the domain name before the TLD (i.e., instead of example.com just put example)

.PARAMETER admin_upn
The admin account performing the action

.PARAMETER export_path
The path you want the file to export to
	
.EXAMPLE
	.\getOneDriveSiteCollectionOwners.ps1 -domainname example -admin_upn admin@example.com -export_path c:\temp\report.csv
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$domainname,

    [Parameter(Mandatory=$true)]
    [string]$admin_upn, 
	
	[Parameter(Mandatory=$true)]
    [string]$export_path
)

# Connect to SPO service
$admin_url = "https://" + $domainname + "-admin.sharepoint.com"
Connect-SPOService -Url $admin_url

# Get all personal onedrive sites
$sites = Get-SPOSite -IncludePersonalSite $true -Limit all -Filter "Url -like '-my.sharepoint.com/personal/'"

foreach ($site in $sites.Url) {
	
	# try catch to find if admin_upn is alraedy site collection admin_upn
    try {
		$isadmin = Get-SPOUser -Site $site -LoginName $admin_upn_upn | Select-Object -ExpandProperty IsSiteadmin_upn
    } catch {
        $isadmin = $false
    }

	# If admin_upn is not already site collection admin_upn
    if (-not $isadmin) {
		# Set admin_upn as site collection admin_upn
        Set-SPOUser -Site $site -LoginName $admin_upn_upn -IsSiteCollectionadmin_upn $true
		
		# Get site collection admin_upns, excluding the admin_upn
		$data = Get-SPOUser -Site $site | Where-Object { $_.IsSiteadmin_upn -eq $true } | 
            Select-Object DisplayName, IsSiteadmin_upn, Title, @{Name="Site";Expression={$site}} | 
            Where-Object { $_.LoginName -ne $admin_upn }
			
		# Remove admin_upn as site collection admin_upn
		Set-SPOUser -Site $site -LoginName $admin_upn -IsSiteCollectionadmin_upn $false
		
		# Export site collection owners to CSV file
		$data | Export-CSV -Path $export_path -Append -NoTypeInformation
		Write-Host "$admin_upn is not admin on $site" -ForegroundColor Green
    }
	
	# If admin_upn is already site collection admin_upn
    if ($isadmin) {
		
		# Get site collection admin_upns
        $data = Get-SPOUser -Site $site | Where-Object { $_.IsSiteadmin_upn -eq $true } | 
            Select-Object DisplayName, IsSiteadmin_upn, Title, @{Name="Site";Expression={$site}}
			
		# Export site collection owners to CSV file
		$data | Export-CSV -Path $export_path -Append -NoTypeInformation
		Write-Host "$admin_upn is admin on $site" -ForegroundColor Red
    }
}
