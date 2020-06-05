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
	fk_ClientID	INTEGER NOT NULL,
	-- Specify the PRIMARY KEY constraint for table "Contact".
	CONSTRAINT	pk_Contact PRIMARY KEY (ContactID)
);

--------------------------------------------------------------
-- Alter Tables to add fk constraints --

-- Alter table to add new constraints required to implement the "Contact_Client" relationship
ALTER TABLE Contact
ADD (
	CONSTRAINT fk_Contact_to_Client FOREIGN KEY(fk_ClientID) REFERENCES Client(ClientID)
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

-- Create a Database table to represent the "Project" entity.
CREATE TABLE Project(
	ProjectID	INTEGER NOT NULL,
	AgreedBillableHours	INTEGER NOT NULL,
	CurrentBillableHours	INTEGER,
	Name	VARCHAR2(20) NOT NULL,
	StartDate	DATE NOT NULL,
	EstimatedEndDate	DATE NOT NULL,
	AgreedPrice	DECIMAL(8,2) NOT NULL,
	fk_ClientID	INTEGER NOT NULL,
	fk_ManagerID	INTEGER NOT NULL,
	-- Specify the PRIMARY KEY constraint for table "Project".
	CONSTRAINT	pk_Project PRIMARY KEY (ProjectID)
);

-- Alter table to add new constraints required to implement the "Project_Client" relationship
ALTER TABLE Project
ADD (
	CONSTRAINT fk_Proj_to_Client FOREIGN KEY(fk_ClientID) REFERENCES Client(ClientID),
	CONSTRAINT fk_Proj_to_Manager FOREIGN KEY(fk_ManagerID) REFERENCES Manager(ManagerID)
);

-- Create a Database table to represent the "EmployeeRoles" entity.
CREATE TABLE EmployeeRoles(
	StartDate	DATE NOT NULL,
	EndDate	DATE,
	fk_EmployeeID	INTEGER NOT NULL,
	fk_RoleID	INTEGER NOT NULL,
	-- Specify the PRIMARY KEY constraint for table "EmployeeRoles".
	CONSTRAINT	pk_EmployeeRoles PRIMARY KEY (fk_EmployeeID,fk_RoleID)
);

-- Alter table to add new constraints required to implement the "EmployeeRoles_Employee" relationship
ALTER TABLE EmployeeRoles
ADD (
	CONSTRAINT fk_EmpRoles_to_Emp FOREIGN KEY(fk_EmployeeID) REFERENCES Employee(EmployeeID),
	CONSTRAINT fk_EmpRoles_to_Role FOREIGN KEY(fk_RoleID) REFERENCES Role(RoleID)
);

-- Create a Database table to represent the "ProjectTeamMember" entity.
CREATE TABLE ProjectTeamMember(
	EndDate	DATE,
	StartDate	DATE NOT NULL,
	fk_ProjectID	INTEGER NOT NULL,
	fk_EmployeeID	INTEGER NOT NULL,
	fk_RoleID	INTEGER NOT NULL,
	-- Specify the PRIMARY KEY constraint for table "ProjectTeamMember".
	CONSTRAINT	pk_ProjectTeamMember PRIMARY KEY (fk_ProjectID, fk_EmployeeID, fk_RoleID)
);
-- Alter table to add new constraints required to implement the "ProjectTeamMember_Project" relationship
ALTER TABLE ProjectTeamMember
ADD (
	CONSTRAINT fk_ProjTeamMem_to_Proj FOREIGN KEY(fk_ProjectID) REFERENCES Project(ProjectID),
	CONSTRAINT fk_ProjTeamMem_to_EmpRole FOREIGN KEY(fk_EmployeeID, fk_RoleID) REFERENCES EmployeeRoles(fk_EmployeeID, fk_RoleID)
);

-- Create a Database table to represent the "SubordinateEmployee" entity.
CREATE TABLE SubordinateEmployee(
	StartDate	DATE NOT NULL,
	EndDate	DATE,
	fk_ManagerID	INTEGER NOT NULL,
	fk_EmployeeID	INTEGER NOT NULL,
	-- Specify the PRIMARY KEY constraint for table "SubordinateEmployee".
	CONSTRAINT	pk_SubordinateEmployee PRIMARY KEY (fk_ManagerID,fk_EmployeeID)
);

-- Alter table to add new constraints required to implement the "SubordinateEmployee_Manager" relationship
ALTER TABLE SubordinateEmployee
ADD (
	CONSTRAINT fk_SubEmp_to_Manager FOREIGN KEY(fk_ManagerID) REFERENCES Manager(ManagerID),
	CONSTRAINT fk_SubEmp_to_Emp FOREIGN KEY(fk_EmployeeID) REFERENCES Employee(EmployeeID)
);

-- Create a Database table to represent the "ManagerRole" entity.
CREATE TABLE ManagerRole(
	StartDate	DATE NOT NULL,
	EndDate	DATE,
	fk_RoleID	INTEGER NOT NULL,
	fk_ManagerID	INTEGER NOT NULL,
	-- Specify the PRIMARY KEY constraint for table "ManagerRole".
	CONSTRAINT	pk_ManagerRole PRIMARY KEY (fk_RoleID,fk_ManagerID)
);

-- Alter table to add new constraints required to implement the "ManagerRole_Role" relationship
ALTER TABLE ManagerRole
ADD (
	CONSTRAINT fk_ManRole_to_Role FOREIGN KEY(fk_RoleID) REFERENCES Role(RoleID),
	CONSTRAINT fk_ManRole_to_Manager FOREIGN KEY(fk_ManagerID) REFERENCES Manager(ManagerID)
);

-- Create a Database table to represent the "ProjectContact" entity.
CREATE TABLE ProjectContact(
	StartDate	DATE NOT NULL,
	EndDate	DATE,
	fk_ContactID	INTEGER NOT NULL,
	fk_ProjectID	INTEGER NOT NULL,
	-- Specify the PRIMARY KEY constraint for table "ProjectContact".
	CONSTRAINT	pk_ProjectContact PRIMARY KEY (fk_ContactID,fk_ProjectID)
);

-- Alter table to add new constraints required to implement the "ProjectContact_Contact" relationship
ALTER TABLE ProjectContact
ADD (
	CONSTRAINT fk_ProjCont_to_Cont FOREIGN KEY(fk_ContactID) REFERENCES Contact(ContactID),
	CONSTRAINT fk_ProjCont_to_Proj FOREIGN KEY(fk_ProjectID) REFERENCES Project(ProjectID)
);

-- Create a Database table to represent the "ProjectTask" entity.
CREATE TABLE ProjectTask(
	TaskID	INTEGER NOT NULL,
	Description	CLOB,
	fk_ProjectID INTEGER NOT NULL,
	-- Specify the PRIMARY KEY constraint for table "ProjectTask".
	CONSTRAINT	pk_ProjectTask PRIMARY KEY (TaskID)
);

-- Add FK to Project Task table
ALTER TABLE ProjectTask
ADD (
	CONSTRAINT fk_ProjTask_to_Proj FOREIGN KEY (fk_ProjectID) REFERENCES Project(ProjectID)
);


-- Create a Database table to represent the "ProjectHours" entity.
CREATE TABLE ProjectHours(
	StartedWorking	TIMESTAMP NOT NULL,
	FinishedWorking	TIMESTAMP NOT NULL,
	fk_TaskID	INTEGER NOT NULL,
	fk_ProjectID	INTEGER NOT NULL,
	fk_EmployeeID	INTEGER NOT NULL,
	-- Specify the PRIMARY KEY constraint for table "ProjectHours".
	CONSTRAINT	pk_ProjectHours PRIMARY KEY (fk_TaskID, fk_ProjectID, fk_EmployeeID)
);

-- Alter table to add new constraints required to implement the "ProjectHours_ProjectTask" relationship
ALTER TABLE ProjectHours
ADD (
	CONSTRAINT fk_ProjHours_to_ProjTask FOREIGN KEY(fk_TaskID) REFERENCES ProjectTask(TaskID),
	CONSTRAINT fk_ProjHours_to_ProjMemb FOREIGN KEY(fk_ProjectID,fk_EmployeeID) REFERENCES ProjectTeamMember(fk_ProjectID,fk_EmployeeID)
);



-- Create a Database table to represent the "TaskAssignedTo" entity.
CREATE TABLE TaskAssignedTo(
	AssignedOn	DATE NOT NULL,
	Deadline	DATE NOT NULL,
	fk_ProjectID	INTEGER NOT NULL,
	fk_EmployeeID	INTEGER NOT NULL,
	fk_TaskID	INTEGER NOT NULL,
	-- Specify the PRIMARY KEY constraint for table "TaskAssignedTo".
	CONSTRAINT	pk_TaskAssignedTo PRIMARY KEY (fk_ProjectID,fk_EmployeeID,fk_TaskID)
);


-- Alter table to add new constraints required to implement the "TaskAssignedTo_ProjectTeamMember" relationship
ALTER TABLE TaskAssignedTo
ADD (
	CONSTRAINT fk_TaskAssign_to_ProjMemb FOREIGN KEY(fk_ProjectID,fk_EmployeeID) REFERENCES ProjectTeamMember(fk_ProjectID,fk_EmployeeID),
	CONSTRAINT fk_TaskAssign_to_ProjTask FOREIGN KEY(fk_TaskID) REFERENCES ProjectTask(TaskID)
);
