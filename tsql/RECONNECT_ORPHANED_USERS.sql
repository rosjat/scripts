/*************************************************************************************************************************
 * --- RECONNECT ORPHANED USERS WITH SERVER LOGINS ---                                                                   *
 *                                                                                                                       *
 * Copyright (c) 2010 Markus Rosjat <markus.rosjat@gmail.com>                                                            *
 * Version: 1.0                                                                                                          *
 *                                                                                                                       *
 * This small script isnt a masterpiece of TSQL but it works for me and so I provide it to others to make there work     *
 * easier. You can edit the script for your needs but be fair and leave this header as it is to give a little respect    *
 * to the guy who spend some time of his sparetime to create the script (me^^).                                          * 
 *************************************************************************************************************************/

-- select the database you want to get the user informations from
USE <DatabaseName> -- replace with your database
GO

-- declare variable to store important informations
declare @rowCount int
declare @rows int
declare @users nvarchar(128)

-- create a temporary table to store the orphaned users
DECLARE @orphaned_user TABLE(rownum int IDENTITY (1,1),
 UserName sysname NOT NULL,
 UserSID varbinary(85) NOT NULL)

-- store the orphaned user in the temporary table 
INSERT @orphaned_user (UserName, UserSID) EXEC sp_change_users_login 'Report'

-- set the counter 
SELECT @rowCount = 1

-- count the rows of our temporary table and store it into a variable
SELECT @rows = count(*) from @orphaned_user

-- renew the connection between the oprhaned database users and the server logins
while @rowCount <= @rows 
begin
-- extracte the user from the temporary table
SELECT @users = UserName FROM @orphaned_user WHERE rownum = @rowCount
-- renew the connection for the user with a system stored procedure
-- we just check if there is a login at he master database and we are
-- kind enough to tell the user if not ;)
IF(SELECT COUNT(name) FROM sys.sql_logins WHERE name= @users) = 1
exec sp_change_users_login 'Update_One', @users ,@users
ELSE
PRINT 'There isnt a login for '+@users +' at the master database!'
-- increase the counter
SELECT @rowCount = @rowCount +1
end