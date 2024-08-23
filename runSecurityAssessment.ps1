<#
.SYNOPSIS
    Welcome to the Azure Security Settings Audit tool! This project is currently in its alpha stage, aimed at providing a foundational solution for auditing security 
    settings within Microsoft Azure environments. As we continue development, we aim to expand features, enhance reliability, and ensure compatibility with various Azure configuration.
.NOTES
    File Name      : runSecurityAssessment.ps1
    Author         : Brandon Hough
    Prerequisite   : MSOnline, ExchangeOnlineManagement, MicrosoftTeams, AIPService, and ORCA

.PARAMETER export_path
The path you want the file to export to
	
.EXAMPLE
	.\runSecurityAssessment.ps1 -export_path c:\temp\report.csv
#>﻿

# Define a function to create the data object
function Add-DataToSpreadSheet {
    param(
        [int]$setting_id,
        [object]$current_value,
        
        [Parameter(Mandatory=$true)]
        [string]$domainname,
    )
    return [PSCustomObject]@{
        "SettingID" = $setting_id
        "CurrentSetting" = $current_value
    }
}

$Report = @()

### Microsoft Online Services - Start ###
Write-Host "Processing settings for Microsoft Online Services.." -ForegroundColor Green
Connect-MsolService

#Setting 1
$setting_id = 1
$current_value = Get-MsolCompanyInformation | select -ExpandProperty UsersPermissionToReadOtherUsersEnabled 
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 213
$setting_id = 213
$current_value = Get-MsolCompanyInformation | select -ExpandProperty AllowAdHocSubscriptions
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 214
$setting_id = 214
$current_value = Get-MsolCompanyInformation | select -ExpandProperty RmsViralSignUpEnabled
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

Write-Host "Done processing settings for Microsoft Online Services.." -ForegroundColor Green
### Microsoft Online Services - End ###


### Microsoft SharePoint - Start ###
Write-Host "Processing settings for Microsoft Azure Inforamtion Protection.." -ForegroundColor Green
$base_domain = Read-Host "Enter base domain with out top level domain (TLD)"
Connect-SPOService -Url https://$base_domain-admin.sharepoint.com

#Setting 189
$setting_id = 189
$ShowEveryoneClaim_value = get-SPOTenant | select -ExpandProperty ShowEveryoneClaim
$ShowEveryoneExceptExternalUsersClaim_value = get-SPOTenant | select -ExpandProperty ShowEveryoneExceptExternalUsersClaim
$ShowAllUsersClaim_value = get-SPOTenant | select -ExpandProperty ShowAllUsersClaim
if($ShowEveryoneClaim_value -eq $True -or $ShowEveryoneExceptExternalUsersClaim_value -eq $True -or $ShowAllUsersClaim_value -eq $True) {
    $current_value = "TRUE"
}
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 763
$setting_id = 199
$current_value = Get-SPOTenant | select -ExpandProperty NotifyOwnersWhenItemsReshared
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 199
$setting_id = 763
$current_value = Get-SPOTenant | select -ExpandProperty EnableAzureADB2BIntegration
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 201
$setting_id = 201
$current_value = Get-SPOTenant | select -ExpandProperty OwnerAnonymousNotification
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 390
$setting_id = 390
$current_value = Get-SPOTenant | select -ExpandProperty DisallowInfectedFileDownload
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 526
$setting_id = 526
$current_value = Get-SPOTenant | select -ExpandProperty EnableAIPIntegration
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 602
$setting_id = 602
$current_value = Get-SPOTenant | select -ExpandProperty MarkNewFilesSensitiveByDefault
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 640
$setting_id = 640
$current_value = Get-SPOTenant | select -ExpandProperty enableAutoNewsDigest
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

Write-Host "Done processing settings for Microsoft Azure Inforamtion Protection.." -ForegroundColor Green
### Microsoft SharePoint - End ###


### Microsoft Azure Inforamtion Protection - Start ###
Write-Host "Processing settings for Microsoft Azure Inforamtion Protection.." -ForegroundColor Green
#Connect-AipService

#Setting 215 - Will not connect to AIP Service in Script
<#Connect-AipService
$setting_id = 215
$current_value = Get-AIPService
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data#>

Write-Host "Done processing settings for Microsoft Azure Inforamtion Protection.." -ForegroundColor Green
### Microsoft Online Services - End ###

### Microsoft Exchange Online - Start ###
Write-Host "Processing settings for Microsoft Exchange Online.." -ForegroundColor Green
Connect-ExchangeOnline

#Setting 38
$setting_id = 38
$current_value = Get-AdminAuditLogConfig | select -ExpandProperty UnifiedAuditLogIngestionEnabled
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 53
$setting_id = 53
$current_value = Get-OrganizationConfig | select -ExpandProperty AutoExpandingArchiveEnabled
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 80
$setting_id = 80
$current_value = Get-OrganizationConfig | select -ExpandProperty FocusedInboxOn
if($current_value -eq $null) {
    $current_value = "TRUE"
}
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 81
$setting_id = 81
$current_value = Get-OrganizationConfig | select -ExpandProperty OAuth2ClientProfileEnabled
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 90
$setting_id = 90
$current_value = Get-IRMConfiguration| select -ExpandProperty AzureRMSLicensingEnabled
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 91
$setting_id = 91
$current_value = Get-IRMConfiguration| select -ExpandProperty SimplifiedClientAccessEnabled
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 127
$setting_id = 127
$current_value = Get-OrganizationConfig| select -ExpandProperty ConnectorsEnabled
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 128
$setting_id = 128
$current_value = get-OwaMailboxPolicy | select -ExpandProperty GroupCreationEnabled
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 222
$setting_id = 222
$current_value = get-organizationconfig | select -ExpandProperty auditdisabled
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 329
$setting_id = 329
$current_value = get-owamailboxpolicy | select -ExpandProperty PredictedActionsEnabled
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 342
$setting_id = 342
$current_value = (Get-User -ResultSize Unlimited -Filter {RemotePowerShellEnabled -eq $true}).count
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 376
$setting_id = 376
$current_value = Get-TransportConfig | select -ExpandProperty SmtpClientAuthenticationDisabled
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 404
$setting_id = 404
$current_value = Get-OWAMailboxPolicy | select -ExpandProperty ThirdPartyFileProvidersEnabled
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 451
$setting_id = 451
$current_value = Get-IRMConfiguration | select -ExpandProperty SimplifiedClientAccessEncryptOnlyDisabled
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 452
$setting_id = 452
$current_value = Get-IRMConfiguration | select -ExpandProperty SimplifiedClientAccessDoNotForwardDisabled
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 529 - Not Working
<#$setting_id = 529
$current_value = Get-HostedContentFilterPolicy | select -ExpandProperty PhishZapEnabled
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 530 - Not Working
$setting_id = 530
$current_value = Get-HostedContentFilterPolicy | select -ExpandProperty SpamZapEnabled
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data#>

#Setting 595
$setting_id = 595
$current_value = Get-OrganizationConfig | select -ExpandProperty MailTipsExternalRecipientsTipsEnabled
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 628 - Not Working
<#$setting_id = 628
$current_value = Get-HostedOutboundSpamFilterPolicy | select -ExpandProperty auto*
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data#>

#Setting 674
$setting_id = 674
$current_value = Get-TransportRule | Where-Object { $_.State -eq 'Enabled' -and $_.Mode -eq 'Enforce' -and $_.MessageTypeMatches -eq 'AutoForward' } | Select-Object -ExpandProperty Name
if($current_value -ne $null) {
    $current_value = 'True'
}
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 859
$setting_id = 859
$current_value = Get-IRMConfiguration| select -ExpandProperty EnablePortalTrackingLogs
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

### Microsoft Exchange Online - End ###
Write-Host "Done processing settings for Microsoft Exchange Online.." -ForegroundColor Green

### Microsoft Teams - Start ###
Write-Host "Processing settings for Microsoft Teams.." -ForegroundColor Green
Connect-MicrosoftTeams

#Setting 663
$setting_id = 663
$current_value = Get-CsTeamsMeetingPolicy -Identity global | select -ExpandProperty recordingstoragemode
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

Write-Host "Done processing settings for Microsoft Teams.." -ForegroundColor Green
### Microsoft Exchange Online - End ###

#Export all results to CSV
$Report | Export-Csv -Path $export_path -NoTypeInformation -Append -Force
