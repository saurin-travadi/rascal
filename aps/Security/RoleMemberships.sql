EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'administrator';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'recall';


GO
EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'recall';

