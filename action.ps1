# HelloID-Task-SA-Target-HelloID-AccountUpdateAttributes
###########################################################
# Form mapping
$formObject = @{
    userName           = $form.userName
    firstName          = $form.firstName
    lastName           = $form.lastName
    contactEmail       = $form.contactEmail
    isEnabled          = [bool]$form.isEnabled
    password           = $form.password
    mustChangePassword = [bool]$form.mustChangePassword
    managedByUserGUID  = $form.manager.UserGUID
    userAttributes     = @{
        "employeeid"  = $form.employeeid
        "title"       = $form.title
        "department"  = $form.department
        "phonenumber" = $form.phonenumber
    }
}

try {
    Write-Information "Executing HelloID action: [UpdateAccount] for: [$($formObject.userName)]"
    Write-Verbose "Creating authorization headers"
    # Create authorization headers with HelloID API key
    $pair = "${portalApiKey}:${portalApiSecret}"
    $bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
    $base64 = [System.Convert]::ToBase64String($bytes)
    $key = "Basic $base64"
    $headers = @{"authorization" = $Key }

    Write-Verbose "Creating HelloIDAccount for: [$($formObject.userName)]"
    $splatUpdateUserParams = @{
        Uri         = "$($portalBaseUrl)/api/v1/users/$($formObject.userName)"
        Method      = "PUT"
        Body        = ([System.Text.Encoding]::UTF8.GetBytes(($formObject | ConvertTo-Json -Depth 10)))
        Verbose     = $false
        Headers     = $headers
        ContentType = "application/json"
    }
    $response = Invoke-RestMethod @splatUpdateUserParams

    $auditLog = @{
        Action            = "UpdateAccount"
        System            = "HelloID"
        TargetIdentifier  = [String]$response.userGUID
        TargetDisplayName = [String]$response.userName
        Message           = "HelloID action: [UpdateAccount] for: [$($formObject.userName)] executed successfully"
        IsError           = $false
    }
    Write-Information -Tags "Audit" -MessageData $auditLog

    Write-Information "HelloID action: [UpdateAccount] for: [$($formObject.userName)] executed successfully"
}
catch {
    $ex = $_
    $auditLog = @{
        Action            = "UpdateAccount"
        System            = "HelloID"
        TargetIdentifier  = ""
        TargetDisplayName = [String]$formObject.userName
        Message           = "Could not execute HelloID action: [UpdateAccount] for: [$($formObject.userName)], error: $($ex.Exception.Message)"
        IsError           = $true
    }
    if ($($ex.Exception.GetType().FullName -eq "Microsoft.PowerShell.Commands.HttpResponseException")) {
        $auditLog.Message = "Could not execute HelloID action: [UpdateAccount] for: [$($formObject.userName)]"
        Write-Error "Could not execute HelloID action: [UpdateAccount] for: [$($formObject.userName)], error: $($ex.ErrorDetails)"
    }
    Write-Information -Tags "Audit" -MessageData $auditLog
    Write-Error "Could not execute HelloID action: [UpdateAccount] for: [$($formObject.userName)], error: $($ex.Exception.Message)"
}
###########################################################