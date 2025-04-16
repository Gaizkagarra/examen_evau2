$domainDN = "DC=midominio,DC=com"

$OUs = @("off1", "off2", "off3")
foreach ($ou in $OUs) {
    $ouPath = "OU=$ou,$domainDN"
    if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$ou'" -SearchBase $domainDN -ErrorAction SilentlyContinue)) {
        New-ADOrganizationalUnit -Name $ou -Path $domainDN -ProtectedFromAccidentalDeletion $false
    }
}

$u1 = "off1user1"
New-ADUser -Name $u1 -SamAccountName $u1 -UserPrincipalName "$u1@tu_dominio.com" -AccountPassword (ConvertTo-SecureString "P@ssw0rd123" -AsPlainText -Force) -Enabled $true
Move-ADObject -Identity "CN=$u1,CN=Users,$domainDN" -TargetPath "OU=off1,$domainDN"

For ($i = 1; $i -le 50; $i++) {
    $user = "off2user$i"
    New-ADUser -Name $user -SamAccountName $user -UserPrincipalName "$user@tu_dominio.com" -AccountPassword (ConvertTo-SecureString "P@ssw0rd123" -AsPlainText -Force) -Enabled $true
    Move-ADObject -Identity "CN=$user,CN=Users,$domainDN" -TargetPath "OU=off2,$domainDN"
    Set-ADUser $user -ProfilePath "\\servidor\perfiles\$user"
}

For ($i = 1; $i -le 30; $i++) {
    $user = "off3user$i"
    New-ADUser -Name $user -SamAccountName $user -UserPrincipalName "$user@tu_dominio.com" -AccountPassword (ConvertTo-SecureString "P@ssw0rd123" -AsPlainText -Force) -Enabled $true
    Move-ADObject -Identity "CN=$user,CN=Users,$domainDN" -TargetPath "OU=off3,$domainDN"
    Set-ADUser $user -ProfilePath "\\servidor\perfiles\$user"
}

New-ADGroup -Name "off1" -GroupScope Global -Path "OU=off1,$domainDN"
New-ADGroup -Name "off2" -GroupScope Global -Path "OU=off2,$domainDN"
New-ADGroup -Name "off3" -GroupScope Global -Path "OU=off3,$domainDN"

Add-ADGroupMember -Identity "off1" -Members "off1user1"
1..50 | ForEach-Object { Add-ADGroupMember -Identity "off2" -Members "off2user$_" }
1..30 | ForEach-Object { Add-ADGroupMember -Identity "off3" -Members "off3user$_" }
