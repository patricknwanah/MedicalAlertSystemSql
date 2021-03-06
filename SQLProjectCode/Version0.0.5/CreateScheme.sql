USE mats_user
GO
IF NOT EXISTS (SELECT name FROM sys.schemas WHERE name = N'REF') --IF SCHEME DOES NOT EXIT
BEGIN
	EXEC ('CREATE SCHEMA [REF] AUTHORIZATION [dbo]')
END
GO

IF NOT EXISTS (SELECT name FROM sys.schemas WHERE name = N'AUDIT')
BEGIN
	EXEC ('CREATE SCHEMA [AUDIT] AUTHORIZATION [dbo]')
END
GO

IF NOT EXISTS (SELECT name FROM sys.schemas WHERE name = N'DATA')
BEGIN
	EXEC ('CREATE SCHEMA [DATA] AUTHORIZATION [dbo]')
END
GO