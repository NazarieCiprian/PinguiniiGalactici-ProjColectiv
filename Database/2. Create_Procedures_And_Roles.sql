use AcademicInfo
GO

CREATE OR ALTER PROCEDURE [Create_Admin]
@Username as nvarchar(30), @Password nvarchar(30) AS
BEGIN
	EXEC sp_addlogin @Username, @Password
	EXEC sp_adduser @Username, @Username, 'Admin'
	--EXEC sp_addrole 'Admin', @Username
--	ALTER ROLE [Admin] ADD MEMBER @Username
END
GO

CREATE OR ALTER PROCEDURE [Create_Teacher]
@Username as nvarchar(30), @Password nvarchar(30) AS
BEGIN
	EXEC sp_addlogin @Username, @Password
	EXEC sp_adduser @Username, @Username, 'Teacher'
	--EXEC sp_addrole 'Teacher', @Username
--	ALTER ROLE [Teacher] ADD MEMBER @Username
END
GO

CREATE OR ALTER PROCEDURE [Create_Student]
@Username as nvarchar(30), @Password nvarchar(30) AS
BEGIN
	EXEC sp_addlogin @Username, @Password
	EXEC sp_adduser @Username, @Username, 'Student'
	--EXEC sp_addrole 'Student', @Username
--	ALTER ROLE [Student] ADD MEMBER @Username
END
GO


create or alter procedure deleteUser @username VARCHAR(50) AS
BEGIN
	IF EXISTS (SELECT name FROM master.sys.server_principals WHERE name = @username)
	BEGIN
		exec sp_dropuser @username
		exec sp_droplogin @username
	END
END
GO

--insert
create or alter procedure [Table1_Insert]
		@regNr int,
		@name  varchar(100),
		@email text,
		@groupNumber int,
		@username varchar(50),
		@password text
AS 
BEGIN
	INSERT INTO [Table1]([RegistrationNumber], [Name], [Email], [GroupNumber], [Username]) 
     VALUES (@regNr, @name, @email, @groupNumber,@username);
	 exec Create_Student @username, @password
END 
GO

--update
create or alter procedure [Table1_Update]
	@regNr int,
	@name  varchar(100),
	@email text,
	@groupNumber int,
	@username varchar(50),
	@password text
AS
BEGIN
	UPDATE [Table1]
	SET           
		[Name] = @name,
		[Email] = @email,
		[Username] = @username,
		[GroupNumber] = @groupNumber
	WHERE [RegistrationNumber] = @regNr
	--ALTER LOGIN @username WITH PASSWORD = @password;
END
GO

--delete
create or alter procedure [Table1_Delete]
       @regNr    INT        
AS 
BEGIN 
	DELETE FROM [Table1] WHERE [RegistrationNumber] = @regNr;

END
GO 

--read by id
create or alter procedure [Table1_ReadById]
	@regNr INT
AS
BEGIN
	SELECT * FROM [Table1] WHERE [RegistrationNumber] = @regNr;
END
GO

--read all
create or alter procedure [Table1_ReadAll]
AS
BEGIN
	SELECT * FROM [Table1];
END
GO

create or alter procedure [Table8_Insert]
	@FID UNIQUEIDENTIFIER,
	@Name VARCHAR(100)
AS
BEGIN
	INSERT INTO [Table8]([FacultyID], [Name]) VALUES(@FID, @Name);
END
GO

create or alter procedure [Table8_Update]
	@FacultyID UNIQUEIDENTIFIER,
	@Name VARCHAR(100)
AS
BEGIN
	UPDATE [Table8]
	SET Name = @Name
	WHERE [FacultyID] = @FacultyID;
END
GO

create or alter procedure [Table8_Delete]
	@FacultyID UNIQUEIDENTIFIER
AS
BEGIN
	DELETE FROM [Table8]
	WHERE [FacultyID] = @FacultyID;
END
GO

create or alter procedure [Table8_ReadByID]
	@FacultyID UNIQUEIDENTIFIER
AS
BEGIN
	SELECT *
	FROM [Table8]
	WHERE [FacultyID] = @FacultyID;
END
GO

create or alter procedure [Table8_ReadAll]
AS
BEGIN
	SELECT *
	FROM [Table8];
END
GO

create or alter procedure [Table7_Insert]
	@TID UNIQUEIDENTIFIER,
	@Name VARCHAR(20)
AS
BEGIN
	INSERT INTO [Table7]([TypeID], [Name]) VALUES(@TID, @Name);
END
GO

create or alter procedure [Table7_Update]
	@TypeID UNIQUEIDENTIFIER,
	@Name VARCHAR(20)
AS
BEGIN
	UPDATE [Table7]
	SET Name = @Name
	WHERE [TypeID] = @TypeID;
END
GO

create or alter procedure [Table7_Delete]
	@TypeID UNIQUEIDENTIFIER
AS
BEGIN
	DELETE FROM [Table7]
	WHERE [TypeID] = @TypeID;
END
GO

create or alter procedure [Table7_ReadByID]
	@TypeID UNIQUEIDENTIFIER
AS
BEGIN
	SELECT *
	FROM [Table7]
	WHERE [TypeID] = @TypeID;
END
GO

create or alter procedure [Table7_ReadAll]
AS
BEGIN
	SELECT *
	FROM [Table7];
END
GO

---------insert
create or alter procedure Table2_Insert
	@TID UNIQUEIDENTIFIER,
    @Name  varchar(50)  = NULL,
	@username varchar(50),
	@password text
AS 
BEGIN
	INSERT INTO Table2([TeacherID], [Name]) 
     VALUES (@TID, @Name)
	 EXEC Create_Teacher @username, @password
END 

GO

-------update
create or alter procedure Table2_Update
	@id UNIQUEIDENTIFIER,
	@Name varchar(50)
AS
BEGIN
	UPDATE Table2 
	SET                 
		[Name] = @Name
	WHERE TeacherID = @id

END
GO
----------delete
create or alter procedure Table2_Delete
       @id    UNIQUEIDENTIFIER        
AS 
BEGIN 
	DELETE FROM   Table2 WHERE TeacherID = @id

END
GO 

--------read by id
create or alter procedure Table2_ReadById
	@id UNIQUEIDENTIFIER
AS
BEGIN
SELECT * FROM Table2 WHERE TeacherID = @id;
END
GO

-----------read all
create or alter procedure Table2_ReadAll
AS
BEGIN
	SELECT * FROM Table2;
END
GO

-----------insert
--create or alter procedure Users_Insert
--	@Username VARCHAR(50), @password  text, @TeacherID UNIQUEIDENTIFIER = NULL, @StudentID INT = NULL
--AS 
--BEGIN 
--     INSERT INTO Users([Username], [Password], [TeacherID], [StudentID]) 
--     VALUES (@Username, @password, @TeacherID, @StudentID)
--END 

--GO

-----------update
--create or alter procedure Users_Update
--	@username varchar(50), @password text AS
--BEGIN
--	UPDATE Users 
--	SET                 
--		Password = @password
--	WHERE Username = @username 
--END
--GO

----------delete
--create or alter procedure Users_Delete
--       @username    varchar(50)        
--AS 
--BEGIN 
--     DELETE 
--     FROM   Users
--     WHERE  
--     Username = @username
--END
--GO

----------read by id
--create or alter procedure Users_ReadById
--	@user VARCHAR(50)
--AS
--BEGIN
--	SELECT * FROM Users WHERE Username = @user;
--END
--GO

--------read all
--create or alter procedure Users_ReadAll AS
--BEGIN
--	SELECT * FROM Users;
--END
--GO

CREATE OR ALTER PROCEDURE Table5_Insert @GroupNr INT, @DepartamentID UNIQUEIDENTIFIER AS 
BEGIN
	INSERT INTO [Table5]([GroupNumber], [DepartamentID])
	VALUES (@GroupNr, @DepartamentID)
END
GO

CREATE OR ALTER PROCEDURE Table5_Delete @GroupNr INT AS
BEGIN
	DELETE FROM [Table5] WHERE [GroupNumber] = @GroupNr
END
GO

CREATE OR ALTER PROCEDURE Table5_Update @GroupNr INT, @DepartamentID UNIQUEIDENTIFIER AS 
BEGIN
	UPDATE [Table5] set 
	[DepartamentID] = @DepartamentID
	WHERE [GroupNumber] = @GroupNr 
END
GO

CREATE OR ALTER PROCEDURE Table5_ReadAll AS
BEGIN
	SELECT * FROM [Table5]
END
GO

CREATE OR ALTER PROCEDURE Table5_ReadByID @GroupNr INT AS
BEGIN
	SELECT * FROM [Table5] WHERE [GroupNumber] = @GroupNr
END
GO

CREATE OR ALTER PROCEDURE Table3_Insert
	@CID UNIQUEIDENTIFIER, @cname nvarchar(100), @DID UNIQUEIDENTIFIER, @year INT, @labNr INT, @semNr INT AS 
BEGIN
	INSERT INTO [Table3]([CourseID], [Name], [DepartamentID], [Year], [TotalLabNr], [TotalSeminarNr])
	VALUES (@CID, @cname, @DID, @year, @labNr, @semNr)
END
GO

CREATE OR ALTER PROCEDURE Table3_Update
	@CID UNIQUEIDENTIFIER, @cname nvarchar(100), @DID UNIQUEIDENTIFIER, @year INT, @labNr INT, @semNr INT AS 
BEGIN
	UPDATE [Table3] set 
	[Name] = @cname, [DepartamentID] = @DID, [Year] = @year, [TotalLabNr] = @labNr, [TotalSeminarNr] = @semNr
	WHERE [CourseID] = @CID 
END
GO

CREATE OR ALTER PROCEDURE Table3_Delete @CID UNIQUEIDENTIFIER AS
BEGIN
	DELETE FROM [Table3] WHERE [CourseID] = @CID
END
GO

CREATE OR ALTER PROCEDURE Table3_ReadByID @CID UNIQUEIDENTIFIER AS
BEGIN
	SELECT * FROM [Table3] WHERE [CourseID] = @CID
END
GO

CREATE OR ALTER PROCEDURE Table3_ReadAll AS
BEGIN
	SELECT * FROM [Table3]
END
GO

CREATE OR ALTER PROCEDURE Table2Table3_Insert @TID UNIQUEIDENTIFIER, @CID UNIQUEIDENTIFIER AS 
BEGIN
	INSERT INTO [Table2Table3]([CourseID], [TeacherID])
	VALUES (@CID, @TID)
END
GO

CREATE OR ALTER PROCEDURE Table2Table3_ReadByID @TID UNIQUEIDENTIFIER, @CID UNIQUEIDENTIFIER AS 
BEGIN
	SELECT * FROM [Table2Table3] WHERE [CourseID] = @CID AND [TeacherID] = @TID
END
GO

CREATE OR ALTER PROCEDURE Table2Table3_ReadAll AS 
BEGIN
	SELECT * FROM [Table2Table3]
END
GO

CREATE OR ALTER PROCEDURE Table2Table3_Delete @TID UNIQUEIDENTIFIER, @CID UNIQUEIDENTIFIER AS
BEGIN
	DELETE FROM [Table2Table3] WHERE [CourseID] = @CID AND [TeacherID] = @TID
END
GO

GO
CREATE OR ALTER PROCEDURE Table1Table3_Insert
	@EID UNIQUEIDENTIFIER, @SID INT, @CID UNIQUEIDENTIFIER AS 
BEGIN
	INSERT INTO [Table1Table3]([EnrollmentID], [StudentID], [CourseID])
	VALUES (@EID, @SID, @CID)
END
GO

CREATE OR ALTER PROCEDURE Table1Table3_Update
	@EID UNIQUEIDENTIFIER, @SID INT, @CID UNIQUEIDENTIFIER AS 
BEGIN
	UPDATE [Table1Table3] set 
	[StudentID] = @SID, [CourseID]=@CID
	WHERE [EnrollmentID] = @EID 
END
GO

CREATE OR ALTER PROCEDURE Table1Table3_Delete
	@EID UNIQUEIDENTIFIER AS
BEGIN
	DELETE FROM [Table1Table3] WHERE [EnrollmentID] = @EID
END
GO

CREATE OR ALTER PROCEDURE Table1Table3_ReadByID @EID UNIQUEIDENTIFIER AS
BEGIN
	SELECT * FROM [Table1Table3] WHERE [EnrollmentID] = @EID
END
GO

CREATE OR ALTER PROCEDURE Table1Table3_ReadAll AS
BEGIN
	SELECT * FROM [Table1Table3]
END
GO

CREATE OR ALTER PROCEDURE [Table6_Insert]
	@DID UNIQUEIDENTIFIER, @name nvarchar(100), @fID UNIQUEIDENTIFIER AS 
BEGIN
	INSERT INTO [Table6]([DepartamentID], [Name], [FacultyID])
	VALUES (@DID, @name, @fID)
END
GO

CREATE OR ALTER PROCEDURE [Table6_Update]
	@ID UNIQUEIDENTIFIER, @name nvarchar(100), @fID UNIQUEIDENTIFIER AS 
BEGIN
	UPDATE [Table6] set 
	[Name] = @name, [FacultyID] = @fID
	WHERE [DepartamentID] = @ID 
END
GO

CREATE OR ALTER PROCEDURE [Table6_Delete]
	@ID UNIQUEIDENTIFIER AS
BEGIN
	DELETE FROM [Table6] WHERE [DepartamentID] = @ID
END
GO

CREATE OR ALTER PROCEDURE [Table6_ReadByID]
	@ID UNIQUEIDENTIFIER AS
BEGIN
	SELECT * FROM [Table6] WHERE [DepartamentID] = @ID
END
GO

CREATE OR ALTER PROCEDURE [Table6_ReadAll] AS
BEGIN
	SELECT * FROM [Table6]
END
GO

CREATE OR ALTER PROCEDURE [Table4_Insert]
	@AID UNIQUEIDENTIFIER, @EID UNIQUEIDENTIFIER, @weeknr int , @typeid UNIQUEIDENTIFIER, @grade INT AS 
BEGIN
	INSERT INTO [Table4]([AttendanceID], [EnrollmentID],[WeekNr],[TypeID], [Grade])
	VALUES (@AID, @EID,@weeknr, @typeid, @grade)
END
GO

CREATE OR ALTER PROCEDURE [Table4_ReadByID]
	@AID UNIQUEIDENTIFIER AS 
BEGIN
	SELECT * FROM [Table4] WHERE [AttendanceID] = @AID
END
GO

CREATE OR ALTER PROCEDURE [Table4_ReadAll] AS 
BEGIN
	SELECT * FROM [Table4]
END
GO

CREATE OR ALTER PROCEDURE [Table4_Delete]
	@AID UNIQUEIDENTIFIER AS
BEGIN
	DELETE FROM [Table4] WHERE [AttendanceID] = @AID
END
GO

CREATE OR ALTER PROCEDURE [Table4_Update]
	@AID UNIQUEIDENTIFIER, @EID UNIQUEIDENTIFIER, @weeknr INT, @typeid UNIQUEIDENTIFIER AS
BEGIN
	UPDATE [Table4] 
	SET [EnrollmentID] = @EID, [WeekNr]=@weeknr, [TypeID] = @typeid
	WHERE [AttendanceID] = @AID
END
GO



CREATE OR ALTER PROCEDURE [Table1_ReadTable4] AS
BEGIN
	SELECT * FROM Table1 s
	INNER JOIN Table1Table3 sc ON (StudentID = RegistrationNumber)
	INNER JOIN Table4 a ON (a.EnrollmentID = sc.EnrollmentID)
END
GO


CREATE OR ALTER PROCEDURE [Create_Roles] AS
BEGIN
	select 'ALTER ROLE ' +  QUOTENAME(rp.name)  + ' DROP MEMBER ' + QUOTENAME(mp.name)
from sys.database_role_members drm
  join sys.database_principals rp on (drm.role_principal_id = rp.principal_id)
  join sys.database_principals mp on (drm.member_principal_id = mp.principal_id)
WHERE rp.name = 'Admin '
order by rp.name
	DROP ROLE IF EXISTS [Admin]
	CREATE ROLE [Admin]
	GRANT EXECUTE ON [Table2_Insert] TO [Admin]
	GRANT EXECUTE ON [Table2_ReadAll] TO [Admin]
	GRANT EXECUTE ON [Table2_Update] TO [Admin]
	GRANT EXECUTE ON [Table2_Delete] TO [Admin]
	GRANT EXECUTE ON [Table3_Insert] TO [Admin]

	GRANT EXECUTE ON [Table3_ReadAll] TO [Admin]
	GRANT EXECUTE ON [Table3_Update] TO [Admin]
	GRANT EXECUTE ON [Table3_Delete] TO [Admin]
	GRANT EXECUTE ON [Table6_Insert] TO [Admin]
	GRANT EXECUTE ON [Table6_ReadAll] TO [Admin]
	GRANT EXECUTE ON [Table6_Update] TO [Admin]
	GRANT EXECUTE ON [Table6_Delete] TO [Admin]

	GRANT EXECUTE ON [Table8_Insert] TO [Admin]
	GRANT EXECUTE ON [Table8_ReadAll] TO [Admin]
	GRANT EXECUTE ON [Table8_Update] TO [Admin]
	GRANT EXECUTE ON [Table8_Delete] TO [Admin]

	GRANT EXECUTE ON [Table5_Insert] TO [Admin]
	GRANT EXECUTE ON [Table5_ReadAll] TO [Admin]
	GRANT EXECUTE ON [Table5_Update] TO [Admin]
	GRANT EXECUTE ON [Table5_Delete] TO [Admin]

	GRANT EXECUTE ON [Table1_Insert] TO [Admin]
	GRANT EXECUTE ON [Table1_ReadAll] TO [Admin]
	GRANT EXECUTE ON [Table1_Update] TO [Admin]
	GRANT EXECUTE ON [Table1_Delete] TO [Admin]

	GRANT EXECUTE ON [Table1Table3_Insert] TO [Admin]
	GRANT EXECUTE ON [Table1Table3_ReadAll] TO [Admin]
	GRANT EXECUTE ON [Table1Table3_Update] TO [Admin]
	GRANT EXECUTE ON [Table1Table3_Delete] TO [Admin]

	GRANT EXECUTE ON [Table2Table3_Insert] TO [Admin]
	GRANT EXECUTE ON [Table2Table3_ReadAll] TO [Admin]
	GRANT EXECUTE ON [Table2Table3_Delete] TO [Admin]

	GRANT EXECUTE ON [Table7_Insert] TO [Admin]
	GRANT EXECUTE ON [Table7_ReadAll] TO [Admin]
	GRANT EXECUTE ON [Table7_Update] TO [Admin]
	GRANT EXECUTE ON [Table7_Delete] TO [Admin]

	DROP ROLE IF EXISTS [Teacher]
	CREATE ROLE [Teacher]
	GRANT EXECUTE ON [Table2_ReadAll] TO [Teacher]
	GRANT EXECUTE ON [Table2_Update] TO [Teacher]
	GRANT EXECUTE ON [Table1_ReadAll] TO [Teacher]
	GRANT EXECUTE ON [Table3_ReadAll] TO [Teacher]
	GRANT EXECUTE ON [Table6_ReadAll] TO [Teacher]
	GRANT EXECUTE ON [Table5_ReadAll] TO [Teacher]
	GRANT EXECUTE ON [Table1_ReadAll] TO [Teacher]
	GRANT EXECUTE ON [Table1Table3_ReadAll] TO [Teacher]
	GRANT EXECUTE ON [Table2Table3_ReadAll] TO [Teacher]
	GRANT EXECUTE ON [Table7_ReadAll] TO [Teacher]
	GRANT EXECUTE ON [Table4_ReadAll] TO [Teacher]
	GRANT EXECUTE ON [Table4_Insert] TO [Teacher]
	GRANT EXECUTE ON [Table4_Update] TO [Teacher]
	GRANT EXECUTE ON [Table4_Delete] TO [Teacher]

	DROP ROLE IF EXISTS [Student]
	CREATE ROLE [Student]

	--GRANT EXECUTE ON [Table4_ReadAll] TO [Student]
	GRANT EXECUTE ON [Table1_ReadTable4] TO [Student]
	GRANT EXECUTE ON [Table2_ReadAll] TO [Student]
	GRANT EXECUTE ON [Table3_ReadAll] TO [Student]
	GRANT EXECUTE ON [Table5_ReadAll] TO [Student]
	GRANT EXECUTE ON [Table1_ReadAll] TO [Student]
	GRANT EXECUTE ON [Table1Table3_ReadAll] TO [Student]
	GRANT EXECUTE ON [Table2Table3_ReadAll] TO [Student]
	GRANT EXECUTE ON [Table7_ReadAll] TO [Student]
END
GO

EXEC Create_Roles
GO