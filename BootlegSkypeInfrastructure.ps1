# Using native AD module
$configurationContainer = 'CN=Configuration,'+ (((get-adforest).name.split('.') | foreach {"DC=$_"}) -join ',')

# All pools, whether Director, FrontEnd or SBA
function Get-BLSkypePools {
    get-adobject -LDAPFilter '(objectClass=msrtcsip-pool)' -SearchBase $configurationContainer -Properties 'name','dnshostname','msrtcsip-pooldata','msrtcsip-pooldisplayname','distinguishedname'
}

# An entry for each combination of pool or member server and several service types
function Get-BLSkypeTrustedServices {
    Get-ADObject -LDAPFilter '(objectclass=msrtcsip-trustedservice)' -SearchBase $configurationContainer -Properties 'msrtcsip-routingpooldn','msrtcsip-trustedServerFQDN','msrtcsip-trustedserviceport','msrtcsip-trustedservicetype'
}

# All pools and their member servers (if Enterprise)
function Get-BLSkypePoolsAndMemberServers {
    get-adobject -LDAPFilter '(objectClass=msrtcsip-trustedserver)' -SearchBase $configurationContainer -Properties 'msrtcsip-trustedserverfqdn'
}

# All Edge pools
function Get-BLSkypeEdgePools {
    Get-ADObject -LDAPFilter '(objectClass=msrtcsip-edgeproxy)' -SearchBase $configurationContainer -Properties 'msrtcsip-edgeproxyfqdn'
}

# All pools and member servers with web components (no SBAs)
function Get-BLSkypeWebComponentsServers {
    Get-ADObject -LDAPFilter '(objectClass=msrtcsip-TrustedWebComponentsServer)' -SearchBase $configurationContainer -Properties 'msrtcsip-trustedwebcomponentsserverfqdn'
}

# All Application Contacts (Reponse Groups, Dialin Access Numbers, etc.)
$appContacts = Get-ADObject -Filter * -SearchBase "cn=application contacts,cn=rtc service,cn=services,$configurationContainer" -Properties 'msrtcsip-applicationoptions','msrtcsip-line','msrtcsip-lineserver','msrtcsip-optionflags','msrtcsip-primaryhomeserver','msrtcsip-primaryuseraddress','msrtcsip-userextension','msrtcsip-userroutinggroupid','msrtcsip-applicationdestination','displayname','telephonenumber','proxyaddresses'

# Gets all Exchange servers and client access arrays
function Get-BLExchangeServersAndCAS {
    Get-ADObject -LDAPFilter '(&(objectclass=msexchexchangeserver)(!objectclass=msexchexchangetransportserver))' -SearchBase $configurationContainer -Properties networkAddress,msExchUMServerDialPlanLink,msExchServerSite,msExchVersion,msExchCurrentServerRoles,serialNumber
}        

# Gets all the objects (users, contacts, etc) homed on the pool (named by DistinguishedName) - here, 1:1, the first pool at the first site
# Pool identity: CN=Lc Services,CN=Microsoft,CN=$poolNumber,CN=Pools,CN=RTC Service,CN=Services,$configurationContainer
function Get-BLSkypeObjectsHomedOnPool {
Param([String]$PoolIdentity)
    get-adobject -LDAPFilter "(msrtcsip-primaryhomeserver=$poolIdentity)"
}
