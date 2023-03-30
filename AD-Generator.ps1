# Set variables for user and OU creation
$ouPrefix = "TestOU"
$userPrefix = "TestUser"
$domainName = "yourdomain.com"
$numberOfOUs = 5
$numberOfUsers = 100

# Create OUs
for ($i = 1; $i -le $numberOfOUs; $i++) {
    $ouName = $ouPrefix + $i
    New-ADOrganizationalUnit -Name $ouName -Path "DC=$domainName" -ErrorAction SilentlyContinue
}

# Create random users in random OUs
for ($i = 1; $i -le $numberOfUsers; $i++) {
    $ouNumber = Get-Random -Minimum 1 -Maximum $numberOfOUs
    $ouName = $ouPrefix + $ouNumber
    $userFirstName = Get-Random -InputObject @("John", "Jane", "Michael", "Sarah", "David", "Emily")
    $userLastName = Get-Random -InputObject @("Doe", "Smith", "Johnson", "Williams", "Brown", "Jones")
    $userName = $userPrefix + $i
    $userPassword = ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force
    $userDisplayName = $userFirstName + " " + $userLastName
    $userEmail = $userName + "@" + $domainName
    $userOU = "OU=$ouName,DC=$domainName"
    
    New-ADUser -Name $userName -DisplayName $userDisplayName -SamAccountName $userName -UserPrincipalName $userEmail -Path $userOU -AccountPassword $userPassword -Enabled $true -EmailAddress $userEmail -ErrorAction SilentlyContinue
}

Write-Host "Finished creating $numberOfUsers random users in $numberOfOUs OUs." -ForegroundColor Green
