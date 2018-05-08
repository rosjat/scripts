scripts
========
a collection of some simple scripts

The content of the repository is not rocket science and I am pretty sure someone, somewhere can do it better, faster and smarter!
So don't complain about the fact that most of the suff isn't as perfect as the script from random genius number 2034. If, on the other hand, someone needs a little script without inventing the wheel then feel free to use what's on here. I don't put it under a licence because you can find x variations of it on google anyway. At least be so kind and keep a reference to me in your modified versions. 

Content
--------

 * Powershell
    * backup_and_restore_db.ps1 - script to backup or restore a MSSQL Server Database
    * check_service.ps1 - script to check if a service is running 
    * hp_cim.ps1 - script to get informations about HP CIM classes provided by HP WEBM Providers
 * T-SQL
    * RECONNECT_ORPHANED_USERS.sql - reconnect MSSQL Server logins with a given Database
 * Shell
    * OpenBSD
       * spam - script to blacklist spammer ips
       * check_spamd - a helper to get notification if spamd is running. For some reason on 6.1 
                       the process just dies randomly after a few weeks of running
       * acme_renew - script to renew let's encrypt certificates and on success restart httpd

