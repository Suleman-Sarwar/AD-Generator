 # Load ActiveDirectory module
Import-Module ActiveDirectory

# Set variables for user creation
$ouPath = "OU=Test,DC=domain,DC=local"
$firstNameList = "John","Jane","David","Michael","Sarah","Emily","Jessica","Amanda","Jacob","William","Olivia","Noah","Sophia","Liam","Mia","Ava","Ethan","Isabella","Jackson","Charlotte"
$lastNameList = "Smith","Johnson","Brown","Taylor","Davis","Wilson","Anderson","Thomas","Jackson","Lee","Garcia","Martinez","Davis","Parker","Hill","Cooper","Reed","Cox","Ward","Foster"

# Set variables for OU group creation
$ouGroupPrefix = "Test"
$ouGroupCount = 5
$usercount = 50
$password = "Pa$$w0rd00@!"

# Generate random users
for ($i = 1; $i -le $usercount; $i++) {
    # Set variables for user properties
    $firstName = Get-Random -InputObject $firstNameList
    $lastName = Get-Random -InputObject $lastNameList
    $displayName = "$firstName $lastName"
    $samAccountName = "$firstName.$lastName"
    $password = ConvertTo-SecureString -String $password -AsPlainText -Force
    $userPrincipalName = "$samAccountName@example.com"
    
    # Create user
    New-ADUser -Name $displayName `
        -SamAccountName $samAccountName `
        -UserPrincipalName $userPrincipalName `
        -GivenName $firstName `
        -Surname $lastName `
        -DisplayName $displayName `
        -AccountPassword $password `
        -Path $ouPath `
        -Enabled $true
}

# Verify users were created
Get-ADUser -Filter * -SearchBase $ouPath

# Generate random OU groups
for ($j = 1; $j -le $ouGroupCount; $j++) {
    $groupName = "$ouGroupPrefix$j"
    $groupPath = "OU=$groupName,$ouPath"
    New-ADOrganizationalUnit -Name $groupName `
        -Path $ouPath
}

# Verify OU groups were created
Get-ADOrganizationalUnit -Filter "Name -like '$ouGroupPrefix*'" -SearchBase $ouPath
 
