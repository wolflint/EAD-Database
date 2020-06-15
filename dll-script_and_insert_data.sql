-- Drop old tables
DROP TABLE Employee CASCADE CONSTRAINTS;
DROP TABLE Project CASCADE CONSTRAINTS;
DROP TABLE Client CASCADE CONSTRAINTS;
DROP TABLE Contact CASCADE CONSTRAINTS;
DROP TABLE Manager CASCADE CONSTRAINTS;
DROP TABLE Role CASCADE CONSTRAINTS;
DROP TABLE ProjectTeamMember CASCADE CONSTRAINTS;
DROP TABLE EmployeeRoles CASCADE CONSTRAINTS;
DROP TABLE SubordinateEmployee CASCADE CONSTRAINTS;
DROP TABLE ManagerRole CASCADE CONSTRAINTS;
DROP TABLE ProjectContact CASCADE CONSTRAINTS;
DROP TABLE ProjectHours CASCADE CONSTRAINTS;
DROP TABLE ProjectTask CASCADE CONSTRAINTS;
DROP TABLE TaskAssignedTo CASCADE CONSTRAINTS;
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
	SkillLevel	INTEGER NOT NULL, -- 0 not a dev, 1 low, 2 intermediate, 3 expert
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
	ProjectHoursID INTEGER NOT NULL,
	HoursWorked INTEGER NOT NULL,
	WorkedDate DATE NOT NULL,
	fk_TaskID	INTEGER NOT NULL,
	fk_ProjectID	INTEGER NOT NULL,
	fk_EmployeeID	INTEGER NOT NULL,
	-- Specify the PRIMARY KEY constraint for table "ProjectHours".
	CONSTRAINT	pk_ProjectHours PRIMARY KEY (ProjectHoursID)
);

-- Alter table to add new constraints required to implement the "ProjectHours_ProjectTask" relationship
ALTER TABLE ProjectHours
ADD (
	CONSTRAINT fk_ProjHours_to_ProjTask FOREIGN KEY(fk_TaskID) REFERENCES ProjectTask(TaskID),
	CONSTRAINT fk_ProjHours_to_Proj FOREIGN KEY(fk_ProjectID) REFERENCES Project(ProjectID),
	CONSTRAINT fk_ProjHours_to_Emp FOREIGN KEY(fk_EmployeeID) REFERENCES Employee(EmployeeID)
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
	CONSTRAINT fk_TaskAssign_to_Proj FOREIGN KEY(fk_ProjectID) REFERENCES Project(ProjectID),
	CONSTRAINT fk_TaskAssign_to_Emp FOREIGN KEY(fk_EmployeeID) REFERENCES Employee(EmployeeID),
	CONSTRAINT fk_TaskAssign_to_ProjTask FOREIGN KEY(fk_TaskID) REFERENCES ProjectTask(TaskID)
);
-- Insert initial data
Insert into EMPLOYEE (EMPLOYEEID,FIRSTNAME,LASTNAME,PAYRATE,HOMEPHONE,MOBILEPHONE,ADDRESSLINE1,ADDRESSLINE2,PROVINCE,CITY,POSTCODE,SKILLLEVEL,STARTDATE,ENDDATE) values (1,'Marcin','Wolf',1.2,'01827333990','079388279','123 Oracle Street',null,'Esquielle','Esquielle City','ES8H HJ8',2,to_date('06-MAY-19','DD-MON-RR'),null);
Insert into EMPLOYEE (EMPLOYEEID,FIRSTNAME,LASTNAME,PAYRATE,HOMEPHONE,MOBILEPHONE,ADDRESSLINE1,ADDRESSLINE2,PROVINCE,CITY,POSTCODE,SKILLLEVEL,STARTDATE,ENDDATE) values (2,'Ben','Bishop',1.2,'01828739478','078389278','124 Oracle Street',null,'Esquielle','Esquielle City','ES8H HJ8',2,to_date('06-MAY-19','DD-MON-RR'),null);
Insert into EMPLOYEE (EMPLOYEEID,FIRSTNAME,LASTNAME,PAYRATE,HOMEPHONE,MOBILEPHONE,ADDRESSLINE1,ADDRESSLINE2,PROVINCE,CITY,POSTCODE,SKILLLEVEL,STARTDATE,ENDDATE) values (3,'Sahmed','Guzil',1.2,'01823478923','073289478','125 Oracle Street',null,'Esquielle','Esquielle City','ES8H HJ8',2,to_date('06-MAY-19','DD-MON-RR'),null);
Insert into EMPLOYEE (EMPLOYEEID,FIRSTNAME,LASTNAME,PAYRATE,HOMEPHONE,MOBILEPHONE,ADDRESSLINE1,ADDRESSLINE2,PROVINCE,CITY,POSTCODE,SKILLLEVEL,STARTDATE,ENDDATE) values (4,'Alex','Wood',1.19,'01827389278','078234897','126 Oracle Street',null,'Esquielle','Esquielle City','ES8H HJ8',2,to_date('06-MAY-19','DD-MON-RR'),null);
Insert into EMPLOYEE (EMPLOYEEID,FIRSTNAME,LASTNAME,PAYRATE,HOMEPHONE,MOBILEPHONE,ADDRESSLINE1,ADDRESSLINE2,PROVINCE,CITY,POSTCODE,SKILLLEVEL,STARTDATE,ENDDATE) values (5,'Jim','Canfixit',1,'01823748937','023487938','12345 Fix It Road',null,'Shire','Hobbiton','SH89 HJ8',2,to_date('07-JUN-19','DD-MON-RR'),null);
Insert into EMPLOYEE (EMPLOYEEID,FIRSTNAME,LASTNAME,PAYRATE,HOMEPHONE,MOBILEPHONE,ADDRESSLINE1,ADDRESSLINE2,PROVINCE,CITY,POSTCODE,SKILLLEVEL,STARTDATE,ENDDATE) values (6,'Scott','Cantfixit',0.5,'01827389737','0187398734','1234 Button Street',null,'Mordor','Birmingham','B87 223',1,to_date('15-NOV-19','DD-MON-RR'),null);
Insert into EMPLOYEE (EMPLOYEEID,FIRSTNAME,LASTNAME,PAYRATE,HOMEPHONE,MOBILEPHONE,ADDRESSLINE1,ADDRESSLINE2,PROVINCE,CITY,POSTCODE,SKILLLEVEL,STARTDATE,ENDDATE) values (7,'Robert','Boss',2,'96788969878','8976876877','123 Paintbrush Road',null,'Acrylic','Blue','AB78 78',3,to_date('25-DEC-19','DD-MON-RR'),null);
Insert into EMPLOYEE (EMPLOYEEID,FIRSTNAME,LASTNAME,PAYRATE,HOMEPHONE,MOBILEPHONE,ADDRESSLINE1,ADDRESSLINE2,PROVINCE,CITY,POSTCODE,SKILLLEVEL,STARTDATE,ENDDATE) values (8,'Aaragorn','King',1.3,'7892347988','47839289732','123 Gondor Palace',null,'Gondor','Gondor','G78 87',2,to_date('26-DEC-19','DD-MON-RR'),null);
Insert into EMPLOYEE (EMPLOYEEID,FIRSTNAME,LASTNAME,PAYRATE,HOMEPHONE,MOBILEPHONE,ADDRESSLINE1,ADDRESSLINE2,PROVINCE,CITY,POSTCODE,SKILLLEVEL,STARTDATE,ENDDATE) values (9,'Jim','Willfixit',1,'472894732','473897243987','12 Fiix It Street',null,'Staffordshire','Lichfield','L89 8ED',1,to_date('27-DEC-19','DD-MON-RR'),null);
Insert into EMPLOYEE (EMPLOYEEID,FIRSTNAME,LASTNAME,PAYRATE,HOMEPHONE,MOBILEPHONE,ADDRESSLINE1,ADDRESSLINE2,PROVINCE,CITY,POSTCODE,SKILLLEVEL,STARTDATE,ENDDATE) values (10,'John','Snow',1.1,'9743829788','78979879838','1 Wall Street',null,'Warwickshire','Warwick','WS18 8DF',1,to_date('28-DEC-19','DD-MON-RR'),null);
INSERT INTO MANAGER VALUES ('1', 'John', 'Hocknell', 50000, '36 FrontDrive Avenue', 'Battersbury', 'Staffordshire', 'Tamworth', 'BJ343L',01234567891,02345678912, 'JohnH@Gmail.co.usa', to_date('21-MAR-06', 'DD-MON-RR'), null);
INSERT INTO MANAGER VALUES ('2', 'Robin', 'Cookie', 55000, '66 Backroad Lane', 'Tattingstone', 'Staffordshire', 'Tamworth', 'B356HZ', 01632960709, 01632960839, 'Robin.C@Gmail.co.usa', to_date('01-JUL-12', 'DD-MON-RR'), null);
INSERT INTO MANAGER VALUES ('3', 'Steven', 'Art',50000, '42  Gordon Terrace', 'Inverythan', 'Staffordshire', 'Lichfield', 'B193PD', 01632960109, 01632960737, 'Steven.A@Gmail.co.usa', to_date('12-JUN-07', 'DD-MON-RR'), null);
INSERT INTO MANAGER VALUES ('4', 'Tyler', 'Durdan', 55000, '12 Blackgate', 'Upham', 'Staffordshire', 'Tamworth', 'B139RR', 01632960378, 01632960071, 'Tyler.D@Gmail.co.usa', to_date('21-MAR-06', 'DD-MON-RR'), null);
INSERT INTO MANAGER VALUES ('5', 'Daniel', 'Johnson', 50000, '65 Whiteshine lane', 'Shreveport', 'Staffordshire', 'Birmingham', 'B775ER', 01632960767, 01214960742, 'Daniel.J@Gmail.co.usa', to_date('21-JAN-10', 'DD-MON-RR'), null);
INSERT INTO MANAGER VALUES ('6', 'Steven', 'Greggory', 50000, '6 Sidegate', 'Upham', 'Staffordshire', 'Birmingham', 'B314TB', 01214960696, 01214960252, 'Steven.G@Gmail.co.usa', to_date('28-MAR-07', 'DD-MON-RR'), null);
INSERT INTO MANAGER VALUES ('7', 'Samantha', 'Reading', 60000, '143 Cleaveland Road', 'Shreveport', 'Staffordshire', 'Cannock', 'B769BU',01214960965,01214960506, 'Samantha.R@Gmail.co.usa', to_date('22-MAR-06', 'DD-MON-RR'), null);
INSERT INTO ROLE VALUES ('1', 'CEO', 'Board Member',1,100000);
INSERT INTO ROLE VALUES ('2', 'Senior Developer', 'Expert Dev',1,60000);
INSERT INTO ROLE VALUES ('3', 'Developer', 'Passed Training',1,45000);
INSERT INTO ROLE VALUES ('4', 'Junior', 'New Developer',1,28000);
INSERT INTO ROLE VALUES ('5', 'Intern', 'New to devolopment',0,0);
INSERT INTO ROLE VALUES ('6', 'Department Manager', 'Responsible for managing departments',0,0);
INSERT INTO CLIENT VALUES (1, 'Jake', 'Cash', 01433986231, 07837520000, '27 Dovedale Road', 'Ashton In Makerfield', 'Greater Manchester', 'Manchester', 'WN40SX');
INSERT INTO CLIENT VALUES (2, 'John', 'Silver', 01432956271, 07332510000, '10 Dovedale Road', 'Ashton In Makerfield', 'Greater Manchester', 'Manchester', 'WN41SX');
INSERT INTO CLIENT VALUES (3, 'Ronnie', 'Charles', 01437786141, 07849120000, '42 Dovedale Road', 'Ashton In Makerfield', 'Greater Manchester', 'Manchester', 'WN43SX');
INSERT INTO CLIENT VALUES (4, 'Holly', 'Fairfield', 01323483131, 07247120000, '18 Dovedale Road', 'Ashton In Makerfield', 'Greater Manchester', 'Manchester', 'WN49SX');
INSERT INTO CLIENT VALUES (5, 'Andy', 'Marsh', 01422886231, 07133550000, '72 Dovedale Road', 'Ashton In Makerfield', 'Greater Manchester', 'Manchester', 'WN47SX');
INSERT INTO CONTACT VALUES (1, 'Alex', 'Wood', 01632960596, 'elucyben1873@yopmail.com', 1);
INSERT INTO CONTACT VALUES (2, 'Ben', 'Bishop', 01632960881, 'teppegemu6401@hotmail.co.uk', 2);
INSERT INTO CONTACT VALUES (3, 'Sam', 'Guzel', 01632960479, 'jullasikog1158@yopmail.com', 3);
INSERT INTO CONTACT VALUES (4, 'Marcin', 'Wolf', 01632960580, 'atujejac2990@gmail.com', 4);
INSERT INTO CONTACT VALUES (5, 'Julian', 'King', 01632763510, 'julian333@gmail.com', 5);
INSERT INTO PROJECT VALUES ('1', '30', '5', 'TesProject', to_date('21-MAR-20', 'DD-MON-RR'), to_date('11-MAY-20', 'DD-MON-RR'), 3500, '1', '2');
INSERT INTO PROJECT VALUES ('2', '15', '14', 'QuickProj', to_date('11-MAR-20', 'DD-MON-RR'), to_date('1-MAY-20', 'DD-MON-RR'), 1500, '2', '3');
INSERT INTO PROJECT VALUES ('3', '22', '18', 'MedJob', to_date('01-FEB-20', 'DD-MON-RR'), to_date('28-FEB-20', 'DD-MON-RR'), 2500, '4', '5');
INSERT INTO PROJECT VALUES ('4', '100', '33', 'GovProject',to_date('11-NOV-19', 'DD-MON-RR'),to_date('1-MAY-20', 'DD-MON-RR'),9500, '3', '1');
INSERT INTO PROJECT VALUES ('5', '10', '5', 'NewProject',to_date('11-MAY-19', 'DD-MON-RR'),to_date('21-MAY-20', 'DD-MON-RR'),9500, '3', '2');
Insert into EMPLOYEEROLES (STARTDATE,ENDDATE,FK_EMPLOYEEID,FK_ROLEID) values (to_date('02-JUN-20','DD-MON-RR'),null,1,3);
Insert into EMPLOYEEROLES (STARTDATE,ENDDATE,FK_EMPLOYEEID,FK_ROLEID) values (to_date('11-MAY-20','DD-MON-RR'),null,2,3);
Insert into MANAGERROLE (STARTDATE,ENDDATE,FK_ROLEID,FK_MANAGERID) values (to_date('13-APR-20','DD-MON-RR'),null,6,1);
Insert into MANAGERROLE (STARTDATE,ENDDATE,FK_ROLEID,FK_MANAGERID) values (to_date('20-APR-20','DD-MON-RR'),null,6,2);
Insert into PROJECTCONTACT (STARTDATE,ENDDATE,FK_CONTACTID,FK_PROJECTID) values (to_date('02-JUN-20','DD-MON-RR'),null,1,1);
Insert into PROJECTCONTACT (STARTDATE,ENDDATE,FK_CONTACTID,FK_PROJECTID) values (to_date('02-JUN-20','DD-MON-RR'),null,2,2);
Insert into PROJECTTASK (TASKID,FK_PROJECTID) values (1,1);
Insert into PROJECTTASK (TASKID,FK_PROJECTID) values (2,2);
Insert into PROJECTTASK (TASKID,FK_PROJECTID) values (3,3);
Insert into PROJECTHOURS (ProjectHoursID,HOURSWORKED,WorkedDate,FK_TASKID,FK_PROJECTID,FK_EMPLOYEEID) values (1,1, to_date('14-MAY-20','DD-MON-RR'), 1, 1, 1);
Insert into PROJECTHOURS (ProjectHoursID,HOURSWORKED,WorkedDate,FK_TASKID,FK_PROJECTID,FK_EMPLOYEEID) values (2,2, to_date('16-MAY-20','DD-MON-RR'), 2, 1, 2);
Insert into PROJECTTEAMMEMBER (ENDDATE,STARTDATE,FK_PROJECTID,FK_EMPLOYEEID,FK_ROLEID) values (to_date('31-JUL-20','DD-MON-RR'),to_date('01-MAY-20','DD-MON-RR'),1,1,3);
Insert into PROJECTTEAMMEMBER (ENDDATE,STARTDATE,FK_PROJECTID,FK_EMPLOYEEID,FK_ROLEID) values (to_date('31-JUL-20','DD-MON-RR'),to_date('01-MAY-20','DD-MON-RR'),1,2,3);
Insert into SUBORDINATEEMPLOYEE (STARTDATE,ENDDATE,FK_MANAGERID,FK_EMPLOYEEID) values (to_date('01-MAY-20','DD-MON-RR'),to_date('31-JUL-20','DD-MON-RR'),1,1);
Insert into SUBORDINATEEMPLOYEE (STARTDATE,ENDDATE,FK_MANAGERID,FK_EMPLOYEEID) values (to_date('01-MAY-20','DD-MON-RR'),to_date('31-JUL-20','DD-MON-RR'),1,2);
Insert into TASKASSIGNEDTO (ASSIGNEDON,DEADLINE,FK_PROJECTID,FK_EMPLOYEEID,FK_TASKID) values (to_date('11-MAY-20','DD-MON-RR'),to_date('31-JUL-20','DD-MON-RR'),1,1,1);
Insert into TASKASSIGNEDTO (ASSIGNEDON,DEADLINE,FK_PROJECTID,FK_EMPLOYEEID,FK_TASKID) values (to_date('11-MAY-20','DD-MON-RR'),to_date('31-JUL-20','DD-MON-RR'),1,2,2);
