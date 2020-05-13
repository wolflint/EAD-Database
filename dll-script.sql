-- Table Creation --

-- Create a Database table to represent the "Employee" entity.
CREATE TABLE Employee(
	EmployeeID	INTEGER NOT NULL,
	FirstName	VARCHAR2(20) NOT NULL,
	LastName	VARCHAR2(40) NOT NULL,
	PayRate	DECIMAL(8,2) NOT NULL,
	HomePhone	VARCHAR2(12) NOT NULL,
	MobilePhone	VARCHAR2(12) NOT NULL,
	AddressLine1	VARCHAR2(30) NOT NULL,
	AddressLine2	VARCHAR2(20),
	Province	VARCHAR2(20) NOT NULL,
	City	VARCHAR2(20) NOT NULL,
	PostCode	VARCHAR2(8) NOT NULL,
	SkillLevel	INTEGER NOT NULL,
	StartDate	DATE NOT NULL,
	EndDate	DATE,
	-- Specify the PRIMARY KEY constraint for table "Employee".
	CONSTRAINT	pk_Employee PRIMARY KEY (EmployeeID)
);

-- Create a Database table to represent the "Project" entity.
CREATE TABLE Project(
	ProjectID	INTEGER NOT NULL,
	AgreedBillableHours	INTEGER NOT NULL,
	CurrentBillableHours	INTEGER,
	Name	VARCHAR2(20) NOT NULL,
	StartDate	DATE NOT NULL,
	EstimatedEndDate	DATE NOT NULL,
	AgreedPrice	DECIMAL(8,2) NOT NULL,
	fk1_ClientID	INTEGER NOT NULL,
	fk2_ManagerID	INTEGER NOT NULL,
	-- Specify the PRIMARY KEY constraint for table "Project".
	CONSTRAINT	pk_Project PRIMARY KEY (ProjectID,fk1_ClientID)
);

-- Create a Database table to represent the "Client" entity.
CREATE TABLE Client(
	ClientID	INTEGER NOT NULL,
	FirstName	VARCHAR2(15) NOT NULL,
	LastName	VARCHAR2(30) NOT NULL,
	WorkPhone	VARCHAR2(12) NOT NULL,
	MobilePhone	VARCHAR2(12) NOT NULL,
	AddressLine1	VARCHAR2(30) NOT NULL,
	AddressLine2	VARCHAR2(30),
	Province	VARCHAR2(20) NOT NULL,
	City	VARCHAR2(20) NOT NULL,
	PostCode	VARCHAR2(8) NOT NULL,
	-- Specify the PRIMARY KEY constraint for table "Client".
	CONSTRAINT	pk_Client PRIMARY KEY (ClientID)
);

-- Create a Database table to represent the "Contact" entity.
CREATE TABLE Contact(
	ContactID	INTEGER NOT NULL,
	FirstName	VARCHAR2(20) NOT NULL,
	LastName	VARCHAR2(30) NOT NULL,
	Phone	VARCHAR2(12),
	Email	VARCHAR2(40),
	fk1_ClientID	INTEGER NOT NULL,
	-- Specify the PRIMARY KEY constraint for table "Contact".
	CONSTRAINT	pk_Contact PRIMARY KEY (ContactID,fk1_ClientID)
);

-- Create a Database table to represent the "Manager" entity.
CREATE TABLE Manager(
	ManagerID	INTEGER NOT NULL,
	FirstName	VARCHAR2(20) NOT NULL,
	LastName	VARCHAR2(40) NOT NULL,
	Salary	DECIMAL(8,2) NOT NULL,
	AddressLine1	VARCHAR2(20) NOT NULL,
	AddressLine2	VARCHAR2(20),
	Province	VARCHAR2(20),
	City	VARCHAR2(20) NOT NULL,
	PostCode	VARCHAR2(8) NOT NULL,
	HomePhone	VARCHAR2(12),
	MobilePhone	VARCHAR2(12),
	Email	VARCHAR2(40),
	StartDate	DATE NOT NULL,
	EndDate	DATE,
	-- Specify the PRIMARY KEY constraint for table "Manager".
	-- This indicates which attribute(s) uniquely identify each row of data.
	CONSTRAINT	pk_Manager PRIMARY KEY (ManagerID)
);

-- Create a Database table to represent the "Role" entity.
CREATE TABLE Role(
	RoleID	INTEGER NOT NULL,
	Title	VARCHAR2(20) NOT NULL UNIQUE,
	Description	CLOB,
	IsBillable	SMALLINT NOT NULL,
	BaseSalary	INTEGER,
	-- Specify the PRIMARY KEY constraint for table "Role".
	CONSTRAINT	pk_Role PRIMARY KEY (RoleID)
);

-- Create a Database table to represent the "ProjectTeamMember" entity.
CREATE TABLE ProjectTeamMember(
	EndDate	DATE,
	StartDate	DATE NOT NULL,
	fk1_ProjectID	INTEGER NOT NULL,
	fk1_fk1_ClientID	INTEGER NOT NULL,
	fk2_fk1_EmployeeID	INTEGER NOT NULL,
	fk2_fk2_RoleID	INTEGER NOT NULL,
	-- Specify the PRIMARY KEY constraint for table "ProjectTeamMember".
	CONSTRAINT	pk_ProjectTeamMember PRIMARY KEY (fk1_ProjectID,fk1_fk1_ClientID,fk2_fk1_EmployeeID,fk2_fk2_RoleID)
);

-- Create a Database table to represent the "EmployeeRoles" entity.
CREATE TABLE EmployeeRoles(
	StartDate	DATE NOT NULL,
	EndDate	DATE,
	fk1_EmployeeID	INTEGER NOT NULL,
	fk2_RoleID	INTEGER NOT NULL,
	-- Specify the PRIMARY KEY constraint for table "EmployeeRoles".
	CONSTRAINT	pk_EmployeeRoles PRIMARY KEY (fk1_EmployeeID,fk2_RoleID)
);

-- Create a Database table to represent the "SubordinateEmployee" entity.
CREATE TABLE SubordinateEmployee(
	StartDate	DATE NOT NULL,
	EndDate	DATE,
	fk1_ManagerID	INTEGER NOT NULL,
	fk2_EmployeeID	INTEGER NOT NULL,
	-- Specify the PRIMARY KEY constraint for table "SubordinateEmployee".
	CONSTRAINT	pk_SubordinateEmployee PRIMARY KEY (fk1_ManagerID,fk2_EmployeeID)
);

-- Create a Database table to represent the "ManagerRole" entity.
CREATE TABLE ManagerRole(
	StartDate	DATE NOT NULL,
	EndDate	DATE,
	fk1_RoleID	INTEGER NOT NULL,
	fk2_ManagerID	INTEGER NOT NULL,
	-- Specify the PRIMARY KEY constraint for table "ManagerRole".
	CONSTRAINT	pk_ManagerRole PRIMARY KEY (fk1_RoleID,fk2_ManagerID)
);

-- Create a Database table to represent the "ProjectContact" entity.
CREATE TABLE ProjectContact(
	StartDate	DATE NOT NULL,
	EndDate	DATE,
	fk1_ContactID	INTEGER NOT NULL,
	fk1_fk1_ClientID	INTEGER NOT NULL,
	fk2_ProjectID	INTEGER NOT NULL,
	fk2_fk1_ClientID	INTEGER NOT NULL,
	-- Specify the PRIMARY KEY constraint for table "ProjectContact".
	CONSTRAINT	pk_ProjectContact PRIMARY KEY (fk1_ContactID,fk1_fk1_ClientID,fk2_ProjectID,fk2_fk1_ClientID)
);

-- Create a Database table to represent the "ProjectHours" entity.
CREATE TABLE ProjectHours(
	StartedWorking	TIMESTAMP NOT NULL,
	FinishedWorking	TIMESTAMP NOT NULL,
	fk1_TaskID	INTEGER NOT NULL,
	fk2_fk1_ProjectID	INTEGER NOT NULL,
	fk2_fk1_fk1_ClientID	INTEGER NOT NULL,
	fk2_fk2_fk1_EmployeeID	INTEGER NOT NULL,
	fk2_fk2_fk2_RoleID	INTEGER NOT NULL,
	-- Specify the PRIMARY KEY constraint for table "ProjectHours".
	CONSTRAINT	pk_ProjectHours PRIMARY KEY (fk1_TaskID,fk2_fk1_ProjectID,fk2_fk1_fk1_ClientID,fk2_fk2_fk1_EmployeeID,fk2_fk2_fk2_RoleID)
);

-- Create a Database table to represent the "ProjectTask" entity.
CREATE TABLE ProjectTask(
	TaskID	INTEGER NOT NULL,
	Description	CLOB,
	-- Specify the PRIMARY KEY constraint for table "ProjectTask".
	CONSTRAINT	pk_ProjectTask PRIMARY KEY (TaskID)
);

-- Create a Database table to represent the "TaskAssignedTo" entity.
CREATE TABLE TaskAssignedTo(
	AssignedOn	DATE NOT NULL,
	Deadline	DATE NOT NULL,
	fk1_fk1_ProjectID	INTEGER NOT NULL,
	fk1_fk1_fk1_ClientID	INTEGER NOT NULL,
	fk1_fk2_fk1_EmployeeID	INTEGER NOT NULL,
	fk1_fk2_fk2_RoleID	INTEGER NOT NULL,
	fk2_TaskID	INTEGER NOT NULL,
	-- Specify the PRIMARY KEY constraint for table "TaskAssignedTo".
	CONSTRAINT	pk_TaskAssignedTo PRIMARY KEY (fk1_fk1_ProjectID,fk1_fk1_fk1_ClientID,fk1_fk2_fk1_EmployeeID,fk1_fk2_fk2_RoleID,fk2_TaskID)
);


--------------------------------------------------------------
-- Alter Tables to add fk constraints --

-- Alter table to add new constraints required to implement the "Contact_Client" relationship
ALTER TABLE Contact
ADD (
	CONSTRAINT fk1_Contact_to_Client FOREIGN KEY(fk1_ClientID) REFERENCES Client(ClientID)
);

-- Alter table to add new constraints required to implement the "Project_Client" relationship
ALTER TABLE Project
ADD (
	CONSTRAINT fk1_Project_to_Client FOREIGN KEY(fk1_ClientID) REFERENCES Client(ClientID)
);

-- Alter table to add new constraints required to implement the "ProjectTeamMember_Project" relationship
ALTER TABLE ProjectTeamMember
ADD (
	CONSTRAINT fk1_ProjectTeamMember_to_Pr1 FOREIGN KEY(fk1_ProjectID,fk1_fk1_ClientID) REFERENCES Project(ProjectID,fk1_ClientID)
);

-- Alter table to add new constraints required to implement the "EmployeeRoles_Employee" relationship
ALTER TABLE EmployeeRoles
ADD (
	CONSTRAINT fk1_EmployeeRoles_to_Employ2 FOREIGN KEY(fk1_EmployeeID) REFERENCES Employee(EmployeeID)
);

-- Alter table to add new constraints required to implement the "EmployeeRoles_Role" relationship
ALTER TABLE EmployeeRoles
ADD (
	CONSTRAINT fk2_EmployeeRoles_to_Role FOREIGN KEY(fk2_RoleID) REFERENCES Role(RoleID)
);

-- Alter table to add new constraints required to implement the "SubordinateEmployee_Manager" relationship
ALTER TABLE SubordinateEmployee
ADD (
	CONSTRAINT fk1_SubordinateEmployee_to_3 FOREIGN KEY(fk1_ManagerID) REFERENCES Manager(ManagerID)
);

-- Alter table to add new constraints required to implement the "SubordinateEmployee_Employee" relationship
ALTER TABLE SubordinateEmployee
ADD (
	CONSTRAINT fk2_SubordinateEmployee_to_4 FOREIGN KEY(fk2_EmployeeID) REFERENCES Employee(EmployeeID)
);

-- Alter table to add new constraints required to implement the "ManagerRole_Role" relationship
ALTER TABLE ManagerRole
ADD (
	CONSTRAINT fk1_ManagerRole_to_Role FOREIGN KEY(fk1_RoleID) REFERENCES Role(RoleID)
);

-- Alter table to add new constraints required to implement the "ManagerRole_Manager" relationship
ALTER TABLE ManagerRole
ADD (
	CONSTRAINT fk2_ManagerRole_to_Manager FOREIGN KEY(fk2_ManagerID) REFERENCES Manager(ManagerID)
);

-- Alter table to add new constraints required to implement the "ProjectContact_Contact" relationship
ALTER TABLE ProjectContact
ADD (
	CONSTRAINT fk1_ProjectContact_to_Conta5 FOREIGN KEY(fk1_ContactID,fk1_fk1_ClientID) REFERENCES Contact(ContactID,fk1_ClientID)
);

-- Alter table to add new constraints required to implement the "ProjectContact_Project" relationship
ALTER TABLE ProjectContact
ADD (
	CONSTRAINT fk2_ProjectContact_to_Proje6 FOREIGN KEY(fk2_ProjectID,fk2_fk1_ClientID) REFERENCES Project(ProjectID,fk1_ClientID)
);

-- Alter table to add new constraints required to implement the "ProjectTeamMember_EmployeeRoles" relationship
ALTER TABLE ProjectTeamMember
ADD (
	CONSTRAINT fk2_ProjectTeamMember_to_Em7 FOREIGN KEY(fk2_fk1_EmployeeID,fk2_fk2_RoleID) REFERENCES EmployeeRoles(fk1_EmployeeID,fk2_RoleID)
);

-- Alter table to add new constraints required to implement the "Project_Manager" relationship
ALTER TABLE Project
ADD (
	CONSTRAINT fk2_Project_to_Manager FOREIGN KEY(fk2_ManagerID) REFERENCES Manager(ManagerID)
);

-- Alter table to add new constraints required to implement the "ProjectHours_ProjectTask" relationship
ALTER TABLE ProjectHours
ADD (
	CONSTRAINT fk1_ProjectHours_to_Project8 FOREIGN KEY(fk1_TaskID) REFERENCES ProjectTask(TaskID)
);

-- Alter table to add new constraints required to implement the "TaskAssignedTo_ProjectTeamMember" relationship
ALTER TABLE TaskAssignedTo
ADD (
	CONSTRAINT fk1_TaskAssignedTo_to_Proje9 FOREIGN KEY(fk1_fk1_ProjectID,fk1_fk1_fk1_ClientID,fk1_fk2_fk1_EmployeeID,fk1_fk2_fk2_RoleID) REFERENCES ProjectTeamMember(fk1_ProjectID,fk1_fk1_ClientID,fk2_fk1_EmployeeID,fk2_fk2_RoleID)
);

-- Alter table to add new constraints required to implement the "TaskAssignedTo_ProjectTask" relationship
ALTER TABLE TaskAssignedTo
ADD (
	CONSTRAINT fk2_TaskAssignedTo_to_Proje10 FOREIGN KEY(fk2_TaskID) REFERENCES ProjectTask(TaskID)
);

-- Alter table to add new constraints required to implement the "ProjectHours_ProjectTeamMember" relationship
ALTER TABLE ProjectHours
ADD (
	CONSTRAINT fk2_ProjectHours_to_Project11 FOREIGN KEY(fk2_fk1_ProjectID,fk2_fk1_fk1_ClientID,fk2_fk2_fk1_EmployeeID,fk2_fk2_fk2_RoleID) REFERENCES ProjectTeamMember(fk1_ProjectID,fk1_fk1_ClientID,fk2_fk1_EmployeeID,fk2_fk2_RoleID)
);
