use AcademicInfo
GO

create or alter procedure [GetAttendancesWithCourses]
as begin
	select a.AttendanceID, a.EnrollmentID, a.Grade, a.TypeID, a.WeekNr, sc.CourseID,
		c.Name as CourseName, c.TotalLabNr, c.TotalSeminarNr, c.Year, t.Name as TypeName
	from Table4 a
	inner join Table1Table3 sc on sc.EnrollmentID = a.EnrollmentID
	inner join Table3 c on c.CourseID = sc.CourseID
	inner join Table7 t on t.TypeID = a.TypeID
end
go

create or alter procedure [GetAttendancesWithCourseAndStudent]
	@RegistrationNumber int,
	@CourseID UNIQUEIDENTIFIER
as begin
	select a.AttendanceID, a.EnrollmentID, a.Grade, a.TypeID, a.WeekNr, sc.CourseID,
		c.Name as CourseName, c.TotalLabNr, c.TotalSeminarNr, c.Year, t.Name as TypeName
	from Table4 a
	inner join Table1Table3 sc on sc.EnrollmentID = a.EnrollmentID
	inner join Table3 c on c.CourseID = sc.CourseID
	inner join Table7 t on t.TypeID = a.TypeID
	inner join Table1 s on s.RegistrationNumber = sc.StudentID
	where c.CourseID = @CourseID and s.RegistrationNumber = @RegistrationNumber
end
go

create or alter procedure [GetCurrentUserRole]
as begin
	if IS_ROLEMEMBER('Admin') = 1
	begin
		select 'Admin'
		return
	end
	if IS_ROLEMEMBER('Teacher') = 1
	begin
		select 'Teacher'
		return
	end
	if IS_ROLEMEMBER('Student') = 1
	begin
		select 'Student'
		return
	end
	select 'Error'	
end
go

--CREATE OR ALTER PROCEDURE [Create_Admin]
--@Username as nvarchar(30), @Password nvarchar(30) AS
--BEGIN
--	EXEC sp_addlogin @Username, @Password
--	EXEC sp_adduser @Username, @Username, 'Admin'
--	--EXEC sp_addrole 'Admin', @Username
----	ALTER ROLE [Admin] ADD MEMBER @Username
--END
--GO

CREATE OR ALTER PROCEDURE [Create_Admin]
@Username as nvarchar(30), @Password nvarchar(30) AS
BEGIN
	declare @s varchar(100)
	set @s = 'create user [' + @Username + '] with password=''' + @Password + ''''
	exec(@s)
	set @s = 'alter role Admin add member [' + @Username + ']'
	exec(@s)
END
GO

--CREATE OR ALTER PROCEDURE [Create_Teacher]
--@Username as nvarchar(30), @Password nvarchar(30) AS
--BEGIN
--	EXEC sp_addlogin @Username, @Password
--	EXEC sp_adduser @Username, @Username, 'Teacher'
--	--EXEC sp_addrole 'Teacher', @Username
----	ALTER ROLE [Teacher] ADD MEMBER @Username
--END
--GO

CREATE OR ALTER PROCEDURE [Create_Teacher]
@Username as nvarchar(30), @Password nvarchar(30) AS
BEGIN
	declare @s varchar(100)
	set @s = 'create user [' + @Username + '] with password=''' + @Password + ''''
	exec(@s)
	set @s = 'alter role Teacher add member [' + @Username + ']'
	exec(@s)
END
GO

--CREATE OR ALTER PROCEDURE [Create_Student]
--@Username as nvarchar(30), @Password nvarchar(30) AS
--BEGIN
--	EXEC sp_addlogin @Username, @Password
--	EXEC sp_adduser @Username, @Username, 'Student'
--	--EXEC sp_addrole 'Student', @Username
----	ALTER ROLE [Student] ADD MEMBER @Username
--END
--GO

CREATE OR ALTER PROCEDURE [Create_Student]
@Username as nvarchar(30), @Password nvarchar(30) AS
BEGIN
	declare @s varchar(100)
	set @s = 'create user [' + @Username + '] with password=''' + @Password + ''''
	exec(@s)
	set @s = 'alter role Student add member [' + @Username + ']'
	exec(@s)
END
GO

--create or alter procedure deleteUser @username VARCHAR(50) AS
--BEGIN
--	IF EXISTS (SELECT name FROM master.sys.server_principals WHERE name = @username)
--	BEGIN
--		exec sp_dropuser @username
--		exec sp_droplogin @username
--	END
--END
--GO

create or alter procedure DeleteUser @Username VARCHAR(50) AS
BEGIN
	declare @s varchar(100)
	set @s = 'DROP USER IF EXISTS [' + @Username + ']'
	exec(@s)
END
GO

--insert
create or alter procedure [Table1_Insert]
		@RegistrationNumber int,
		@Name  varchar(100),
		@Email text,
		@GroupNumber int,
		@Password text='pass'
AS 
BEGIN
	INSERT INTO [Table1]([RegistrationNumber], [Name], [Email], [GroupNumber], [Password]) 
     VALUES (@RegistrationNumber, @Name, @Email, @GroupNumber, @Password);
	 exec Create_Student @Email, @Password
END 
GO

--update
create or alter procedure [Table1_Update]
	@RegistrationNumber int,
	@Name  varchar(100),
	@Email text,
	@GroupNumber int,
	@Password text
AS
BEGIN
	UPDATE [Table1]
	SET           
		[Name] = @Name,
		[GroupNumber] = @GroupNumber
	WHERE [RegistrationNumber] = @RegistrationNumber
	--ALTER LOGIN @username WITH PASSWORD = @password;
END
GO

--delete
create or alter procedure [Table1_Delete]
       @RegistrationNumber    INT        
AS 
BEGIN
	declare @username varchar(100)
	select @username=Email from Table1 where RegistrationNumber = @RegistrationNumber
	exec DeleteUser @username
	DELETE FROM [Table1] WHERE [RegistrationNumber] = @RegistrationNumber;
END
GO

--read by id
create or alter procedure [Table1_ReadById]
	@RegistrationNumber INT
AS
BEGIN
	SELECT * FROM [Table1] WHERE [RegistrationNumber] = @RegistrationNumber;
END
GO

create or alter procedure [Table1_ReadByCourseID] @CourseId UNIQUEIDENTIFIER
AS 
BEGIN 
	SELECT * FROM [Table1] s
	INNER JOIN [Table1Table3] sc on s.RegistrationNumber = sc.StudentID
	WHERE sc.CourseID = @CourseId
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
	@FacultyID UNIQUEIDENTIFIER,
	@Name VARCHAR(100)
AS
BEGIN
	INSERT INTO [Table8]([FacultyID], [Name]) VALUES(@FacultyID, @Name);
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
	@TypeID UNIQUEIDENTIFIER,
	@Name VARCHAR(20)
AS
BEGIN
	INSERT INTO [Table7]([TypeID], [Name]) VALUES(@TypeID, @Name);
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
	@TeacherID UNIQUEIDENTIFIER,
    @Name  varchar(50)  = NULL,
	@Email text,
	@Password text
AS 
BEGIN
	INSERT INTO Table2([TeacherID], [Name], [Email], [Password]) 
     VALUES (@TeacherID, @Name, @Email, @Password)
	 EXEC Create_Teacher @Email, @Password
END 

GO

-------update
create or alter procedure Table2_Update
	@TeacherID UNIQUEIDENTIFIER,
	@Name varchar(50),
	@Email text,
	@Password text
AS
BEGIN
	UPDATE Table2 
	SET                 
		[Name] = @Name
	WHERE TeacherID = @TeacherID

END
GO
----------delete
create or alter procedure Table2_Delete
       @TeacherID UNIQUEIDENTIFIER        
AS 
BEGIN 
	DELETE FROM   Table2 WHERE TeacherID = @TeacherID

END
GO 

--------read by id
create or alter procedure Table2_ReadById
	@TeacherID UNIQUEIDENTIFIER
AS
BEGIN
SELECT * FROM Table2 WHERE TeacherID = @TeacherID;
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

CREATE OR ALTER PROCEDURE Table5_Insert @GroupNumber INT, @DepartmentID UNIQUEIDENTIFIER AS 
BEGIN
	INSERT INTO [Table5]([GroupNumber], [DepartmentID])
	VALUES (@GroupNumber, @DepartmentID)
END
GO

CREATE OR ALTER PROCEDURE Table5_Delete @GroupNumber INT AS
BEGIN
	DELETE FROM [Table5] WHERE [GroupNumber] = @GroupNumber
END
GO

CREATE OR ALTER PROCEDURE Table5_Update @GroupNumber INT, @DepartmentID UNIQUEIDENTIFIER AS 
BEGIN
	UPDATE [Table5] set 
	[DepartmentID] = @DepartmentID
	WHERE [GroupNumber] = @GroupNumber 
END
GO

CREATE OR ALTER PROCEDURE Table5_ReadAll AS
BEGIN
	SELECT * FROM [Table5]
END
GO

CREATE OR ALTER PROCEDURE Table5_ReadByID @GroupNumber INT AS
BEGIN
	SELECT * FROM [Table5] WHERE [GroupNumber] = @GroupNumber
END
GO

CREATE OR ALTER PROCEDURE Table3_Insert
	@CourseID UNIQUEIDENTIFIER, @Name nvarchar(100), @DepartmentID UNIQUEIDENTIFIER, 
	@Year INT, @TotalLabNr INT, @TotalSeminarNr INT AS 
BEGIN
	INSERT INTO [Table3]([CourseID], [Name], [DepartmentID], [Year], [TotalLabNr], [TotalSeminarNr])
	VALUES (@CourseID, @Name, @DepartmentID, @Year, @TotalLabNr, @TotalSeminarNr)
END
GO

CREATE OR ALTER PROCEDURE Table3_Update
	@CourseID UNIQUEIDENTIFIER, @Name nvarchar(100), @DepartmentID UNIQUEIDENTIFIER, 
	@Year INT, @TotalLabNr INT, @TotalSeminarNr INT AS 
BEGIN
	UPDATE [Table3] set 
	[Name] = @Name, [DepartmentID] = @DepartmentID, [Year] = @Year, [TotalLabNr] = @TotalLabNr,
	 [TotalSeminarNr] = @TotalSeminarNr
	WHERE [CourseID] = @CourseID 
END
GO

CREATE OR ALTER PROCEDURE Table3_Delete @CourseID UNIQUEIDENTIFIER AS
BEGIN
	DELETE FROM [Table3] WHERE [CourseID] = @CourseID
END
GO

CREATE OR ALTER PROCEDURE Table3_ReadByID @CourseID UNIQUEIDENTIFIER AS
BEGIN
	SELECT * FROM [Table3] WHERE [CourseID] = @CourseID
END
GO

CREATE OR ALTER PROCEDURE Table3_ReadAll AS
BEGIN
	SELECT * FROM [Table3]
END
GO

CREATE OR ALTER PROCEDURE Table3_ReadAllForTeacher @TeacherID UNIQUEIDENTIFIER AS
BEGIN
	SELECT t3.CourseID, t3.DepartmentID, t3.Name, t3.TotalLabNr, t3.TotalSeminarNr, t3.Year
	FROM [Table3] t3
	INNER JOIN	[Table2Table3] t23 on t3.CourseID = t23.CourseID
	INNER JOIN [Table2] t2 on t2.TeacherID = t23.TeacherID
	WHERE t2.TeacherID = @TeacherID
END
GO

CREATE OR ALTER PROCEDURE Table2Table3_Insert @TeacherID UNIQUEIDENTIFIER, @CourseID UNIQUEIDENTIFIER AS 
BEGIN
	INSERT INTO [Table2Table3]([CourseID], [TeacherID])
	VALUES (@CourseID, @TeacherID)
END
GO

CREATE OR ALTER PROCEDURE Table2Table3_ReadByID @TeacherID UNIQUEIDENTIFIER, @CourseID UNIQUEIDENTIFIER AS 
BEGIN
	SELECT * FROM [Table2Table3] WHERE [CourseID] = @CourseID AND [TeacherID] = @TeacherID
END
GO

CREATE OR ALTER PROCEDURE Table2Table3_ReadAll AS 
BEGIN
	SELECT * FROM [Table2Table3]
END
GO

CREATE OR ALTER PROCEDURE Table2Table3_Delete @TeacherID UNIQUEIDENTIFIER, @CourseID UNIQUEIDENTIFIER AS
BEGIN
	DELETE FROM [Table2Table3] WHERE [CourseID] = @CourseID AND [TeacherID] = @TeacherID
END
GO

GO
CREATE OR ALTER PROCEDURE Table1Table3_Insert
	@EnrollmentID UNIQUEIDENTIFIER, @StudentID INT, @CourseID UNIQUEIDENTIFIER AS 
BEGIN
	INSERT INTO [Table1Table3]([EnrollmentID], [StudentID], [CourseID])
	VALUES (@EnrollmentID, @StudentID, @CourseID)
END
GO

CREATE OR ALTER PROCEDURE Table1Table3_Update
	@EnrollmentID UNIQUEIDENTIFIER, @StudentID INT, @CourseID UNIQUEIDENTIFIER AS 
BEGIN
	UPDATE [Table1Table3] set 
	[StudentID] = @StudentID, [CourseID]=@CourseID
	WHERE [EnrollmentID] = @EnrollmentID 
END
GO

CREATE OR ALTER PROCEDURE Table1Table3_Delete
	@EnrollmentID UNIQUEIDENTIFIER AS
BEGIN
	DELETE FROM [Table1Table3] WHERE [EnrollmentID] = @EnrollmentID
END
GO

CREATE OR ALTER PROCEDURE Table1Table3_ReadByID @EnrollmentID UNIQUEIDENTIFIER AS
BEGIN
	SELECT * FROM [Table1Table3] WHERE [EnrollmentID] = @EnrollmentID
END
GO

CREATE OR ALTER PROCEDURE Table1Table3_ReadAll AS
BEGIN
	SELECT * FROM [Table1Table3]
END
GO

CREATE OR ALTER PROCEDURE [Table6_Insert]
	@DepartmentID UNIQUEIDENTIFIER, @Name nvarchar(100), @FacultyID UNIQUEIDENTIFIER AS 
BEGIN
	INSERT INTO [Table6]([DepartmentID], [Name], [FacultyID])
	VALUES (@DepartmentID, @Name, @FacultyID)
END
GO

CREATE OR ALTER PROCEDURE [Table6_Update]
	@DepartmentID UNIQUEIDENTIFIER, @Name nvarchar(100), @FacultyID UNIQUEIDENTIFIER AS 
BEGIN
	UPDATE [Table6] set 
	[Name] = @Name, [FacultyID] = @FacultyID
	WHERE [DepartmentID] = @DepartmentID 
END
GO

CREATE OR ALTER PROCEDURE [Table6_Delete]
	@DepartmentID UNIQUEIDENTIFIER AS
BEGIN
	DELETE FROM [Table6] WHERE [DepartmentID] = @DepartmentID
END
GO

CREATE OR ALTER PROCEDURE [Table6_ReadByID]
	@DepartmentID UNIQUEIDENTIFIER AS
BEGIN
	SELECT * FROM [Table6] WHERE [DepartmentID] = @DepartmentID
END
GO

CREATE OR ALTER PROCEDURE [Table6_ReadAll] AS
BEGIN
	SELECT * FROM [Table6]
END
GO

CREATE OR ALTER PROCEDURE [Table4_Insert]
	@AttendanceID UNIQUEIDENTIFIER, @EnrollmentID UNIQUEIDENTIFIER, @WeekNr int,
	@TypeID UNIQUEIDENTIFIER, @Grade DECIMAL(9,2)=NULL AS 
BEGIN
	INSERT INTO [Table4]([AttendanceID], [EnrollmentID],[WeekNr],[TypeID], [Grade])
	VALUES (@AttendanceID, @EnrollmentID, @WeekNr, @TypeID, @Grade)
END
GO

CREATE OR ALTER PROCEDURE [Table4_ReadByID]
	@AttendanceID UNIQUEIDENTIFIER AS 
BEGIN
	SELECT * FROM [Table4] WHERE [AttendanceID] = @AttendanceID
END
GO

CREATE OR ALTER PROCEDURE [Table4_ReadAll] AS 
BEGIN
	SELECT * FROM [Table4]
END
GO

CREATE OR ALTER PROCEDURE [Table4_Delete]
	@AttendanceID UNIQUEIDENTIFIER AS
BEGIN
	DELETE FROM [Table4] WHERE [AttendanceID] = @AttendanceID
END
GO

CREATE OR ALTER PROCEDURE [Table4_Update]
	@AttendanceID UNIQUEIDENTIFIER, @EnrollmentID UNIQUEIDENTIFIER, @WeekNr INT,
	@TypeID UNIQUEIDENTIFIER, @Grade DECIMAL(9,2) AS
BEGIN
	UPDATE [Table4] 
	SET [EnrollmentID] = @EnrollmentID, [WeekNr]=@WeekNr, [TypeID] = @TypeID, Grade = @Grade
	WHERE [AttendanceID] = @AttendanceID
END
GO



CREATE OR ALTER PROCEDURE [Table1_ReadTable4] AS
BEGIN
	SELECT * FROM Table1 s
	INNER JOIN Table1Table3 sc ON (StudentID = RegistrationNumber)
	INNER JOIN Table4 a ON (a.EnrollmentID = sc.EnrollmentID)
END
GO

CREATE OR ALTER PROCEDURE [Table4_UpdateOrInsert]
	@StudentID INT, @CourseID UNIQUEIDENTIFIER, @WeekNr INT,
	@TypeID UNIQUEIDENTIFIER, @Grade DECIMAL(9,2) = NULL AS
BEGIN
	DECLARE @enrollmentID UNIQUEIDENTIFIER = (SELECT TOP 1 [EnrollmentID] FROM [Table1Table3] WHERE [StudentID]=@StudentID AND [CourseID] = @CourseID)
	IF @enrollmentID IS NULL
		RETURN

	DECLARE @attendanceID UNIQUEIDENTIFIER = (SELECT TOP 1 [AttendanceID] FROM [Table4] WHERE [EnrollmentID]=@enrollmentID AND [WeekNr]=@WeekNr AND [TypeID]=@TypeID)
	IF @attendanceID IS NULL
		BEGIN
			SET @attendanceID = NEWID()
			exec [Table4_Insert] @attendanceID,@enrollmentID,@WeekNr,@TypeID,@Grade
		END
	ELSE
		exec [Table4_Update] @attendanceID,@enrollmentID,@WeekNr,@TypeID,@Grade

END
GO

--------------------------- REPORTS -------------------------------

CREATE OR ALTER PROCEDURE [Get_Average_Grade_For_Course_by_Attendance_Type]
	@CourseID UNIQUEIDENTIFIER, @TypeID UNIQUEIDENTIFIER AS
BEGIN
	SELECT t1.GroupNumber, AVG(partial_res_1.Grade) AS AverageGrade 
	FROM (SELECT t1t3.StudentID, t4.Grade FROM Table1Table3 t1t3
		  INNER JOIN Table4 t4 ON t4.EnrollmentID = t1t3.EnrollmentID AND t1t3.CourseID = @CourseID AND 
		   t4.TypeID = @TypeID) partial_res_1
	INNER JOIN Table1 t1 ON t1.RegistrationNumber = partial_res_1.StudentID
	GROUP BY t1.GroupNumber
END
GO

CREATE OR ALTER PROCEDURE [Get_Passing_Grades_Number_For_Course_by_Attendance_Type]
	@CourseID UNIQUEIDENTIFIER, @TypeID UNIQUEIDENTIFIER AS
BEGIN
	SELECT t1.GroupNumber, COUNT(CASE WHEN partial_res_1.Grade >= 4.5 THEN 1 END) AS PassingGradesNumber,COUNT(partial_res_1.Grade) AS TotalGradesNumber
	FROM (SELECT t1t3.StudentID, t4.Grade FROM Table1Table3 t1t3
		  INNER JOIN Table4 t4 ON t4.EnrollmentID = t1t3.EnrollmentID AND t1t3.CourseID = @CourseID AND 
		  t4.TypeID = @TypeID) partial_res_1
	INNER JOIN Table1 t1 ON t1.RegistrationNumber = partial_res_1.StudentID
	GROUP BY t1.GroupNumber
END
GO

CREATE OR ALTER PROCEDURE [Get_Group_Attendances_for_Course_by_Attendance_Type]
	@CourseID UNIQUEIDENTIFIER, @TypeID UNIQUEIDENTIFIER, @GroupNumber int AS
BEGIN
	SELECT t4.WeekNr, COUNT(*) AS AttendancesCount
	FROM (SELECT t1t3.EnrollmentID FROM Table1Table3 t1t3
		  INNER JOIN Table1 t1 ON t1.RegistrationNumber = t1t3.StudentID
		  WHERE t1.GroupNumber = @GroupNumber AND t1t3.CourseID = @CourseID) partial_res_1
	INNER JOIN Table4 t4 on t4.EnrollmentID = partial_res_1.EnrollmentID AND t4.TypeID = @TypeID
	GROUP BY WeekNr
END
GO

CREATE OR ALTER PROCEDURE [Get_Group_Grades_for_Course_by_Attendance_Type]
	@CourseID UNIQUEIDENTIFIER, @TypeID UNIQUEIDENTIFIER, @GroupNumber int AS
BEGIN
	SELECT t4.Grade
	FROM (SELECT t1t3.EnrollmentID FROM Table1Table3 t1t3
		  INNER JOIN Table1 t1 ON t1.RegistrationNumber = t1t3.StudentID
		  WHERE t1.GroupNumber = @GroupNumber AND t1t3.CourseID = @CourseID) partial_res_1
	INNER JOIN Table4 t4 on t4.EnrollmentID = partial_res_1.EnrollmentID AND t4.TypeID = @TypeID
END
GO

--exec as login='admin1'
--revert
--exec [Get_Group_Attendances_for_Course_by_Attendance_Type] @CourseID='B0094904-B0A7-4C66-A7D3-6C313D5D193A', @TypeID='08AC7284-0228-4267-B3BD-A5FF5F5C9E5B', @GroupNumber=935
--exec [Get_Group_Grades_for_Course_by_Attendance_Type] @CourseID='B0094904-B0A7-4C66-A7D3-6C313D5D193A', @TypeID='63E3DF71-A7D4-4A30-9299-16A11E104536', @GroupNumber=935
--exec Get_Passing_Grades_Number_For_Course_by_Attendance_Type @CourseID='B0094904-B0A7-4C66-A7D3-6C313D5D193A', @TypeID='63E3DF71-A7D4-4A30-9299-16A11E104536'
--exec Get_Average_Grade_For_Course_by_Attendance_Type @CourseID='B0094904-B0A7-4C66-A7D3-6C313D5D193A', @TypeID='08AC7284-0228-4267-B3BD-A5FF5F5C9E5B'
--exec Table1_ReadAll
--SELECT * FROM Table4 SELECT * FROM Table1Table3 SELECT * FROM Table1
--drop proc Get_Group_Attendance_Percentage_for_Course_by_Attendance_Type

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
	DROP ROLE IF EXISTS [Teacher]
	CREATE ROLE [Teacher]
	DROP ROLE IF EXISTS [Student]
	CREATE ROLE [Student]
	GRANT EXECUTE ON [Table2_Insert] TO [Admin]
	GRANT EXECUTE ON [Table2_ReadByID] TO [Admin]
	GRANT EXECUTE ON [Table2_ReadAll] TO [Admin]
	GRANT EXECUTE ON [Table2_Update] TO [Admin]
	GRANT EXECUTE ON [Table2_Delete] TO [Admin]

	GRANT EXECUTE ON [Table3_Insert] TO [Admin]
	GRANT EXECUTE ON [Table3_ReadAll] TO [Admin]
	GRANT EXECUTE ON [Table3_ReadByID] TO [Admin]
	GRANT EXECUTE ON [Table3_Update] TO [Admin]
	GRANT EXECUTE ON [Table3_Delete] TO [Admin]

	GRANT EXECUTE ON [Table6_Insert] TO [Admin]
	GRANT EXECUTE ON [Table6_ReadAll] TO [Admin]
	GRANT EXECUTE ON [Table6_Update] TO [Admin]
	GRANT EXECUTE ON [Table6_Delete] TO [Admin]
	GRANT EXECUTE ON [Table6_ReadByID] TO [Admin]

	GRANT EXECUTE ON [Table8_Insert] TO [Admin]
	GRANT EXECUTE ON [Table8_ReadAll] TO [Admin]
	GRANT EXECUTE ON [Table8_ReadByID] TO [Admin]
	GRANT EXECUTE ON [Table8_Update] TO [Admin]
	GRANT EXECUTE ON [Table8_Delete] TO [Admin]

	GRANT EXECUTE ON [Table5_Insert] TO [Admin]
	GRANT EXECUTE ON [Table5_ReadAll] TO [Admin]
	GRANT EXECUTE ON [Table5_Update] TO [Admin]
	GRANT EXECUTE ON [Table5_Delete] TO [Admin]
	GRANT EXECUTE ON [Table5_ReadByID] TO [Admin]

	GRANT EXECUTE ON [Table1_Insert] TO [Admin]
	GRANT EXECUTE ON [Table1_ReadAll] TO [Admin]
	GRANT EXECUTE ON [Table1_Update] TO [Admin]
	GRANT EXECUTE ON [Table1_Delete] TO [Admin]
	GRANT EXECUTE ON [Table1_ReadByCourseID] TO [Admin]
	GRANT EXECUTE ON [Table1_ReadByID] TO [Admin]

	GRANT EXECUTE ON [Table1Table3_Insert] TO [Admin]
	GRANT EXECUTE ON [Table1Table3_ReadAll] TO [Admin]
	GRANT EXECUTE ON [Table1Table3_Update] TO [Admin]
	GRANT EXECUTE ON [Table1Table3_Delete] TO [Admin]
	GRANT EXECUTE ON [Table1Table3_ReadByID] TO [Admin]

	GRANT EXECUTE ON [Table2Table3_Insert] TO [Admin]
	GRANT EXECUTE ON [Table2Table3_ReadAll] TO [Admin]
	GRANT EXECUTE ON [Table2Table3_Delete] TO [Admin]
	GRANT EXECUTE ON [Table2Table3_ReadByID] TO [Admin]

	GRANT EXECUTE ON [Table7_Insert] TO [Admin]
	GRANT EXECUTE ON [Table7_ReadAll] TO [Admin]
	GRANT EXECUTE ON [Table7_Update] TO [Admin]
	GRANT EXECUTE ON [Table7_Delete] TO [Admin]
	GRANT EXECUTE ON [Table7_ReadByID] TO [Admin]

	GRANT EXECUTE ON [GetCurrentUserRole] to [Admin]
	GRANT EXECUTE ON [Create_Student] to [Admin]
	GRANT EXECUTE ON [Create_Teacher] to [Admin]
	GRANT EXECUTE ON [Table3_ReadAllForTeacher] to [Admin]
	GRANT EXECUTE ON [Create_Admin] to Admin
	GRANT EXECUTE ON [GetAttendancesWithCourseAndStudent] to [Admin]
	GRANT ALTER ANY USER TO Admin
	GRANT ALTER ANY ROLE TO Admin

	GRANT EXECUTE ON [Get_Average_Grade_For_Course_by_Attendance_Type] TO [Admin]
	GRANT EXECUTE ON [Get_Average_Grade_For_Course_by_Attendance_Type] TO [Teacher]
	GRANT EXECUTE ON [Get_Average_Grade_For_Course_by_Attendance_Type] TO [Student]

	GRANT EXECUTE ON [Get_Passing_Grades_Number_For_Course_by_Attendance_Type] TO [Admin]
	GRANT EXECUTE ON [Get_Passing_Grades_Number_For_Course_by_Attendance_Type] TO [Teacher]

	GRANT EXECUTE ON [Get_Group_Attendances_for_Course_by_Attendance_Type] TO [Admin]
	GRANT EXECUTE ON [Get_Group_Attendances_for_Course_by_Attendance_Type] TO [Teacher]

	GRANT EXECUTE ON [Get_Group_Grades_for_Course_by_Attendance_Type] TO [Admin]
	GRANT EXECUTE ON [Get_Group_Grades_for_Course_by_Attendance_Type] TO [Teacher]

	
	GRANT EXECUTE ON [Table2_ReadAll] TO [Teacher]
	GRANT EXECUTE ON [Table2_Update] TO [Teacher]
	GRANT EXECUTE ON [Table2_ReadByID] TO [Teacher]

	GRANT EXECUTE ON [Table1_ReadAll] TO [Teacher]
	GRANT EXECUTE ON [Table1_ReadByID] TO [Teacher]

	GRANT EXECUTE ON [Table3_ReadAll] TO [Teacher]
	GRANT EXECUTE ON [Table3_ReadByID] TO [Teacher]

	GRANT EXECUTE ON [Table6_ReadAll] TO [Teacher]
	GRANT EXECUTE ON [Table6_ReadByID] TO [Teacher]

	GRANT EXECUTE ON [Table5_ReadAll] TO [Teacher]
	GRANT EXECUTE ON [Table5_ReadByID] TO [Teacher]
	
	GRANT EXECUTE ON [Table1_ReadByCourseID] TO [Teacher]

	GRANT EXECUTE ON [Table1Table3_ReadAll] TO [Teacher]
	GRANT EXECUTE ON [Table1Table3_ReadByID] TO [Teacher]

	GRANT EXECUTE ON [Table2Table3_ReadAll] TO [Teacher]
	GRANT EXECUTE ON [Table2Table3_ReadByID] TO [Teacher]

	GRANT EXECUTE ON [Table7_ReadAll] TO [Teacher]
	GRANT EXECUTE ON [Table7_ReadByID] TO [Teacher]

	GRANT EXECUTE ON [Table4_ReadAll] TO [Teacher]
	GRANT EXECUTE ON [Table4_Insert] TO [Teacher]
	GRANT EXECUTE ON [Table4_Update] TO [Teacher]
	GRANT EXECUTE ON [Table4_Delete] TO [Teacher]
	GRANT EXECUTE ON [Table4_ReadByID] TO [Teacher]

	GRANT EXECUTE ON [GetCurrentUserRole] to [Teacher]
	GRANT EXECUTE ON [GetAttendancesWithCourses] to [Teacher]
	GRANT EXECUTE ON [GetAttendancesWithCourses] to [Student]
	GRANT EXECUTE ON [Table3_ReadAllForTeacher] to [Teacher]
	GRANT EXECUTE ON [GetAttendancesWithCourseAndStudent] to [Teacher]
	GRANT EXECUTE ON [Table4_UpdateOrInsert] to [Teacher]



	--GRANT EXECUTE ON [Table4_ReadAll] TO [Student]
	GRANT EXECUTE ON [Table1_ReadTable4] TO [Student]
	GRANT EXECUTE ON [Table1_ReadByID] TO [Student]

	GRANT EXECUTE ON [Table2_ReadAll] TO [Student]
	GRANT EXECUTE ON [Table2_ReadByID] TO [Student]

	GRANT EXECUTE ON [Table3_ReadAll] TO [Student]
	GRANT EXECUTE ON [Table3_ReadByID] TO [Student]

	GRANT EXECUTE ON [Table5_ReadAll] TO [Student]
	GRANT EXECUTE ON [Table5_ReadByID] TO [Student]

	GRANT EXECUTE ON [Table1_ReadAll] TO [Student]
	GRANT EXECUTE ON [Table1Table3_ReadAll] TO [Student]
	GRANT EXECUTE ON [Table1Table3_ReadByID] TO [Student]

	GRANT EXECUTE ON [Table2Table3_ReadAll] TO [Student]
	GRANT EXECUTE ON [Table2Table3_ReadByID] TO [Student]

	GRANT EXECUTE ON [Table7_ReadAll] TO [Student]
	GRANT EXECUTE ON [Table7_ReadByID] TO [Student]

	GRANT EXECUTE ON [GetCurrentUserRole] to [Student]
	GRANT EXECUTE ON [Table3_ReadAllForTeacher] to [Student]
	GRANT EXECUTE ON [GetAttendancesWithCourseAndStudent] to [Student]
END
GO

EXEC Create_Roles