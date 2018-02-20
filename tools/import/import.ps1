<#
    Use this script to import already existing infrastructure to your environment state
    Sample usage 
    .\import.ps1 `
    -BackendAccessKey "xxx" `
    -ClientId "2041053b-3c33-4b18-a38f-d68cb6432b16" `
    -ClientSecretKey "xxx" `
    -SubscriptionId "2dd6c30d-7cd4-499b-a8cc-6b5b317f66b6" `
    -EnvironmentName "76Test" `
    -LocationCode "euw" `
    -TerraformResourcePath "module.blueprint_buyers_remorse_76_test_euw.module.resourceGroup_defaultServiceBus.azurerm_resource_group.resource_group" `
    -AzureResourcePath "/subscriptions/2dd6c30d-7cd4-499b-a8cc-6b5b317f66b6/resourceGroups/Default-ServiceBus-WestEurope"
#>

param (
    [Parameter(Mandatory = $true)] [String]$ClientId,
    [Parameter(Mandatory = $true)] [String]$ClientSecretKey,
    [Parameter(Mandatory = $true)] [String]$SubscriptionId,
    [Parameter(Mandatory = $true)] [String]$BackendAccessKey,
    [Parameter(Mandatory = $true)] [String]$EnvironmentName,
    [Parameter(Mandatory = $true)] [String]$LocationCode,
    [Parameter(Mandatory = $true)] [String]$TerraformResourcePath,
    [Parameter(Mandatory = $true)] [String]$TenantId,
    [Parameter(Mandatory = $true)] [String]$AzureResourcePath
)

function ReplaceKeys ([bool] $reverse = $false) {
    if ($reverse) {
        (Get-Content 'main.tf' ) | foreach {$_.replace($BackendAccessKey, '%backendAccessKey%')} | Set-Content 'main.tf' -Force
        (Get-Content 'main.tf' ) | foreach {$_.replace($ClientSecretKey, '%clientSecretKey%')} | Set-Content 'main.tf' -Force
    } else {
        (Get-Content 'main.tf' ) | foreach {$_.replace('%backendAccessKey%', $BackendAccessKey)} | Set-Content 'main.tf' -Force
        (Get-Content 'main.tf' ) | foreach {$_.replace('%clientSecretKey%', $ClientSecretKey)} | Set-Content 'main.tf' -Force  
    }   
}

function Clean () {
    Remove-Item .terraform -force -recurse -ErrorAction SilentlyContinue
    Remove-Item tfplan -ErrorAction SilentlyContinue
}

cd ../../environments/$EnvironmentName/$LocationCode

ReplaceKeys
Clean

terraform init

terraform import `
    -var "client_id=$ClientId" `
    -var "client_secret=$Secret" `
    -var "tenant_id=$TenantId" `
    -var "subscription_id=$SubscriptionId" `
    $TerraformResourcePath `
    $AzureResourcePath

ReplaceKeys $true

cd ../../../tools/import