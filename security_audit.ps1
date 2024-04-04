

# Define a function to create the data object
function Add-DataToSpreadSheet {
    param(
        [int]$setting_id,
        [object]$current_value
    )
    return [PSCustomObject]@{
        "SettingID" = $setting_id
        "CurrentSetting" = $current_value
    }
}

$export_path = 'C:\path\to\export.csv'
$Report = @()

#Setting 1
Connect-MsolService
$setting_id = 1
$current_value = Get-MsolCompanyInformation | select -ExpandProperty UsersPermissionToReadOtherUsersEnabled 
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 38
Connect-ExchangeOnline
$setting_id = 38
$current_value = Get-AdminAuditLogConfig | select -ExpandProperty UnifiedAuditLogIngestionEnabled
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 53
#Connect-ExchangeOnline
$setting_id = 53
$current_value = Get-OrganizationConfig | select -ExpandProperty AutoExpandingArchiveEnabled
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 80
Connect-ExchangeOnline
$setting_id = 80
$current_value = Get-OrganizationConfig | select -ExpandProperty FocusedInboxOn
if($current_value -eq $null) {
    $current_value = "TRUE"
}
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 81
#Connect-ExchangeOnline
$setting_id = 81
$current_value = Get-OrganizationConfig | select -ExpandProperty OAuth2ClientProfileEnabled
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 90
#Connect-ExchangeOnline
$setting_id = 90
$current_value = Get-IRMConfiguration| select -ExpandProperty AzureRMSLicensingEnabled
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 91
#Connect-ExchangeOnline
$setting_id = 91
$current_value = Get-IRMConfiguration| select -ExpandProperty SimplifiedClientAccessEnabled
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 127
#Connect-ExchangeOnline
$setting_id = 127
$current_value = Get-OrganizationConfig| select -ExpandProperty ConnectorsEnabled
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 128
#Connect-ExchangeOnline
$setting_id = 128
$current_value = get-OwaMailboxPolicy | select -ExpandProperty GroupCreationEnabled
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 213
#Connect-MsolService
$setting_id = 213
$current_value = Get-MsolCompanyInformation | select -ExpandProperty AllowAdHocSubscriptions
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 214
#Connect-MsolService
$setting_id = 214
$current_value = Get-MsolCompanyInformation | select -ExpandProperty RmsViralSignUpEnabled
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 215 - Will not connect to AIP Service in Script
<#Connect-AipService
$setting_id = 215
$current_value = Get-AIPService
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data#>

#Setting 222
#Connect-ExchangeOnline
$setting_id = 222
$current_value = get-organizationconfig | select -ExpandProperty auditdisabled
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 329
#Connect-ExchangeOnline
$setting_id = 329
$current_value = get-owamailboxpolicy | select -ExpandProperty PredictedActionsEnabled
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 342
#Connect-ExchangeOnline
$setting_id = 342
$current_value = (Get-User -ResultSize Unlimited -Filter {RemotePowerShellEnabled -eq $true}).count
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

#Setting 663
Connect-MicrosoftTeams
$setting_id = 663
$current_value = Get-CsTeamsMeetingPolicy -Identity global | select -ExpandProperty recordingstoragemode
$data = Add-DataToSpreadSheet -setting_id $setting_id -current_value $current_value
$Report += $data

$Report | Export-Csv -Path $export_path -NoTypeInformation -Append -Force
