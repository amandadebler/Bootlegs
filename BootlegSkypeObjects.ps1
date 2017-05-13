function Get-BootlegAllUsers {
# This is 2.5 times faster than Get-ADUser -LDAPFilter '(&(msrtcsip-primaryuseraddress=*)(!msrtcsip-ownerurn=*))'
  Get-ADObject -LDAPFilter '(&(msrtcsip-userenabled=TRUE)(&(objectclass=User)(!msrtcsip-ownerurn=*)))' -Properties 'msrtcsip-line','msrtcsip-privateline',displayName,'msrtcsip-primaryuseraddress' | Select-Object -Property name, displayName, @{n='PhoneNumber';e={$_.'msrtcsip-line'}}, @{n='PrivateLine';e={$_.'msrtcsip-privateline'}}, @{n='SIPAddress';e={$_.'msrtcsip-primaryuseraddress'}}
}

function Get-BootlegAllCommonAreaPhones {
  Get-ADObject -LDAPFilter '(&(msrtcsip-userenabled=TRUE)(&(objectclass=Contact)(msrtcsip-ownerurn=urn:device:commonareaphone)))'
}

# Includes default RGS objects; filter for things that have a phone number if you only want "real" ones
function Get-BootlegAllResponseGroups {
  Get-ADObject -LDAPFilter '(&(msrtcsip-userenabled=TRUE)(&(objectclass=Contact)(msrtcsip-ownerurn=urn:application:RGS)))' -SearchBase 'CN=Configuration,DC=forestroot,DC=com' -Properties 'msrtcsip-line',displayName,'msrtcsip-primaryuseraddress' | Select-Object -Property displayName, @{n='PhoneNumber';e={$_.'msrtcsip-line'}}, @{n='SIPAddress';e={$_.'msrtcsip-primaryuseraddress'}}
}

function Get-BootlegAllConferenceDialins {
  Get-ADObject -LDAPFilter '(&(msrtcsip-userenabled=TRUE)(&(objectclass=Contact)(msrtcsip-ownerurn=urn:application:Caa)))' -SearchBase 'CN=Configuration,DC=forestroot,DC=com' -Properties 'msrtcsip-line',displayName,'msrtcsip-primaryuseraddress' | select -Property displayName, @{n='PhoneNumber';e={$_.'msrtcsip-line'}}, @{n='SIPAddress';e={$_.'msrtcsip-primaryuseraddress'}} 
}

function Get-BootlegAllUMAutoAttendants {
  Get-ADObject -LDAPFilter '(&(msrtcsip-userenabled=TRUE)(&(objectclass=Contact)(!msrtcsip-ownerurn=*)))' -Properties 'msrtcsip-line',displayName,'msrtcsip-primaryuseraddress' | Select-Object -Property displayName, @{n='PhoneNumber';e={$_.'msrtcsip-line'}}, @{n='SIPAddress';e={$_.'msrtcsip-primaryuseraddress'}}
}

function Get-BootlegAllRoomSystems {
  Get-ADObject -LDAPFilter '(&(msrtcsip-userenabled=TRUE)(&(objectclass=User)(msrtcsip-ownerurn=urn:device:roomsystem)))' -Properties 'msrtcsip-line','msrtcsip-privateline',displayName,'msrtcsip-primaryuseraddress' | select -Property name, displayName, @{n='PhoneNumber';e={$_.'msrtcsip-line'}}, @{n='PrivateLine';e={$_.'msrtcsip-privateline'}}, @{n='SIPAddress';e={$_.'msrtcsip-primaryuseraddress'}}
}

function Get-BootlegAllAnalogPhones {
  Get-ADObject -LDAPFilter '(msrtcsip-ownerurn=urn:device:analogphone)' -Properties 'msrtcsip-line','msrtcsip-privateline',displayName,'msrtcsip-primaryuseraddress' | select -Property name, displayName, @{n='PhoneNumber';e={$_.'msrtcsip-line'}}, @{n='PrivateLine';e={$_.'msrtcsip-privateline'}}, @{n='SIPAddress';e={$_.'msrtcsip-primaryuseraddress'}}
}

function Get-BootlegAllAnalogFaxes {
  Get-ADObject -LDAPFilter '(msrtcsip-ownerurn=urn:device:analogfax)' -Properties 'msrtcsip-line','msrtcsip-privateline',displayName,'msrtcsip-primaryuseraddress' | select -Property name, displayName, @{n='PhoneNumber';e={$_.'msrtcsip-line'}}, @{n='PrivateLine';e={$_.'msrtcsip-privateline'}}, @{n='SIPAddress';e={$_.'msrtcsip-primaryuseraddress'}}
}

function Get-BootlegAllEndpoints {
# Response groups, dial-in conferencing numbers, other application URNs
  Get-ADObject -LDAPFilter '(msrtcsip-userenabled=TRUE)' -Properties 'msrtcsip-ownerurn','msrtcsip-line','msrtcsip-primaryuseraddress', displayname -SearchBase 'CN=Configuration,DC=forestroot,DC=com' | select name, displayname,'msrtcsip-ownerurn','msrtcsip-line','msrtcsip-primaryuseraddress', objectclass}
# Users, common area phones, room systems, other devices
  Get-ADObject -LDAPFilter '(msrtcsip-userenabled=TRUE)' -Properties 'msrtcsip-ownerurn','msrtcsip-line','msrtcsip-primaryuseraddress', displayname | select name, displayname,'msrtcsip-ownerurn','msrtcsip-line','msrtcsip-primaryuseraddress', objectclass}
}

function Get-BootlegAllEndpointsWithPhoneNumbers {
  Get-ADObject -LDAPFilter '(|(msrtcsip-line=tel:*)(msrtcsip-privateline=tel:*))' -Properties 'msrtcsip-line',displayName,'msrtcsip-primaryuseraddress' | Select-Object -Property displayName, @{n='PhoneNumber';e={$_.'msrtcsip-line'}}, @{n='SIPAddress';e={$_.'msrtcsip-primaryuseraddress'}}
}

# either a whole E.164 phone number without punctuation, or a prefix
# Examples: +4991133344455 to match individual user, or +4991133344 to match all users with this prefix 
function Get-BootlegEndpointByPhoneNumber {
Param($PhoneNumber)
  # To do - Strip phone number down to digits, then slap + on it
  Get-ADObject -LDAPFilter '(|(msrtcsip-line=tel:$PhoneNumber*)(msrtcsip-privateline=tel:$PhoneNumber*))'
}

