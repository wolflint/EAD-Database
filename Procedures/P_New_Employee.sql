CREATE OR REPLACE PROCEDURE P_NEW_EMPLOYEE
(
  EMPLOYEEID IN NOCOPY NUMBER
, FIRSTNAME IN VARCHAR2
, LASTNAME IN VARCHAR2
, PAYRATE IN VARCHAR2 DEFAULT 1
, HOMEPHONE IN VARCHAR2
, MOBILEPHONE IN VARCHAR2
, ADDRESSLINE1 IN VARCHAR2
, ADDRESSLINE2 IN VARCHAR2
, PROVINCE IN VARCHAR2
, CITY IN VARCHAR2
, POSTCODE IN VARCHAR2
, SKILLLEVEL IN NUMBER DEFAULT 0
, STARTDATE IN DATE DEFAULT TRUNC(SYSDATE)
) AS
BEGIN
    INSERT INTO "EAD-GROUP"."EMPLOYEE"(
      EMPLOYEEID,
      FIRSTNAME,
      LASTNAME,
      PAYRATE,
      HOMEPHONE,
      MOBILEPHONE,
      ADDRESSLINE1,
      ADDRESSLINE2,
      PROVINCE,
      CITY,
      POSTCODE,
      SKILLLEVEL,
      STARTDATE
    )
    VALUES (
      EMPLOYEEID,
      FIRSTNAME,
      LASTNAME,
      PAYRATE,
      HOMEPHONE,
      MOBILEPHONE,
      ADDRESSLINE1,
      ADDRESSLINE2,
      PROVINCE,
      CITY,
      POSTCODE,
      SKILLLEVEL,
      STARTDATE
      );

END P_NEW_EMPLOYEE;
