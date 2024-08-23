<#
.SYNOPSIS
    This script will export group expiration date for cloud groups
.NOTES
    File Name      : getCloudGroupExpirations.ps1
    Author         : Brandon Hough
    Prerequisite   : Microsoft.Graph
	
.PARAMETERS

	export_path; the path you want the file to export to
	
.EXAMPLE
	.\getCloudGroupExpirations.ps1 -export_path c:\temp\report.csv

#>

param(
	
	[Parameter(Mandatory=$true)]
    [string]$export_path
)

$group_ids = Get-MgBetaGroup -All | Where-Object { $_.ExpirationDateTime -ne $null } | select-object -ExpandProperty Id

foreach ($id in $group_ids) {
	$data = Get-MgBetaGroup -GroupId $id | select DisplayName, ExpirationDateTime
	
	if ($data) {
       $data | Export-Csv -Path $export_path -Append -NoTypeInformation
    } 
	else {
        Write-Host "No data found for GroupId: $id"
     }
 }
