CREATE DATABASE SCIMS;
USE SCIMS;

-- Citizen Registration Table
CREATE TABLE CitizenRegistration (
	Registration_ID VARCHAR(500) PRIMARY KEY,
    Full_Name VARCHAR(200) NOT NULL,
    Gender VARCHAR(10) CHECK (Gender IN ('Male', 'Female', 'Others')),
    Date_Of_Birth DATE NOT NULL,
    Address VARCHAR(300) NOT NULL,
    Contact_Number VARCHAR(15),
    Email VARCHAR(100) UNIQUE,
    National_ID VARCHAR(30) UNIQUE NOT NULL,
	Approval_Status VARCHAR(20) CHECK (Approval_Status IN ('Pending', 'Approved', 'Rejected')) DEFAULT 'Pending',
    Registration_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- SELECT * 
-- FROM CitizenRegistration;

-- Trigger
DELIMITER $$

CREATE TRIGGER After_Approval_Update
AFTER UPDATE ON CitizenRegistration
FOR EACH ROW
BEGIN
    IF NEW.Approval_Status = 'Approved' THEN
        INSERT INTO Citizen_Info (
            Citizen_ID, Name, Address, Contact_Number, Date_Of_Birth, Email, Gender, National_ID, City_Registration_Date
        )
        VALUES (
            NEW.Registration_ID, NEW.Full_Name, NEW.Address, NEW.Contact_Number, 
            NEW.Date_Of_Birth, NEW.Email, NEW.Gender, NEW.National_ID, NEW.Registration_Date
        )
        ON DUPLICATE KEY UPDATE
            Name = VALUES(Name),
            Address = VALUES(Address),
            Contact_Number = VALUES(Contact_Number),
            Email = VALUES(Email),
            Gender = VALUES(Gender),
            National_ID = VALUES(National_ID);
    END IF;
END$$

DELIMITER ;
-- Approval Querry
UPDATE CitizenRegistration
SET Approval_Status = 'Approved'
WHERE Registration_ID LIKE 'CIT%' AND National_ID LIKE '199%';
-- Rejection Querry
UPDATE CitizenRegistration
SET Approval_Status = 'Rejected'
WHERE Registration_ID LIKE 'CIT%' AND National_ID NOT LIKE '199%';
-- UnderAge Applicant Querry
UPDATE CitizenRegistration
SET Approval_Status = 'Pending'
WHERE TIMESTAMPDIFF(YEAR, Date_Of_Birth, CURDATE()) < 18;


-- Citizen Table

CREATE TABLE Citizen_Info
(
    Citizen_ID 	VARCHAR(30) PRIMARY KEY,
    Name VARCHAR(200) NOT NULL,
	Address VARCHAR(300) NOT NULL,
    Contact_Number VARCHAR(15) NOT NULL,
    Date_Of_Birth DATE NOT NULL,
    Email VARCHAR(100) UNIQUE,
	Gender VARCHAR(10) CHECK (Gender IN ('Male', 'Female', 'Others')),
    National_ID VARCHAR(30) UNIQUE NOT NULL,
    City_Registration_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);



-- City_Official Table

CREATE TABLE City_Official (
    Official_ID VARCHAR(50) PRIMARY KEY,
    Citizen_ID VARCHAR(50),
    Name VARCHAR(100) NOT NULL,
    Department_ID VARCHAR(10) NOT NULL,
    Role VARCHAR(50) NOT NULL,
    Phone_Number VARCHAR(15),
    Email VARCHAR(100),
    Years_Of_Service INT,
    Qualifications TEXT,
    Address TEXT,
    Supervisor_ID VARCHAR(50),
    FOREIGN KEY (Citizen_ID) REFERENCES Citizen_Info(Citizen_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Supervisor_ID) REFERENCES City_Official(Official_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Department table
CREATE TABLE Department (
    Department_ID VARCHAR(10) PRIMARY KEY,
    Department_Name VARCHAR(100) NOT NULL,
    Head_Official_ID VARCHAR(50),
    Department_Budget DECIMAL(15, 2),
    Number_Of_Employees INT,
    Main_Responsibilities TEXT,
    Operating_Hours VARCHAR(50),
    FOREIGN KEY (Head_Official_ID) REFERENCES City_Official(Official_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);



ALTER TABLE City_Official
ADD CONSTRAINT FK_Department_ID
FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Public Services Table

CREATE TABLE Public_Services (
    Service_ID VARCHAR(30) PRIMARY KEY, -- Unique identifier for each public service
    Department_ID VARCHAR(10), -- Links to the Department table
    Service_Type VARCHAR(100) NOT NULL, -- Type of service (e.g., Waste Management, Fire Safety)
    Service_Description TEXT, -- Detailed description of the service
    Availability_Status VARCHAR(20) CHECK (Availability_Status IN ('Available', 'Unavailable')), -- Service availability status
    Average_Response_Time DECIMAL(5, 2), -- Average time taken to respond in hours (e.g., 1.50 for 1 hour 30 minutes)
    Service_Fee DECIMAL(10, 2) DEFAULT 0.00, -- Fee for the service (if applicable)
    FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Feedback (
    Feedback_ID VARCHAR(10) PRIMARY KEY, -- Unique identifier for feedback
    Citizen_ID VARCHAR(50), -- Links to Citizen_Info table
    Service_ID VARCHAR(30), -- Links to Public_Services table
    Assigned_Official_ID VARCHAR(50), -- Links to City_Official table
    Feedback_Date DATE NOT NULL, -- Date the feedback was given
    Feedback_Type VARCHAR(50), -- Type of feedback (e.g., Complaint, Suggestion, Praise)
    Description TEXT, -- Detailed description of the feedback
    Rating DECIMAL(2, 1) CHECK (Rating BETWEEN 1 AND 5), -- Rating out of 5
    Resolved_Status BOOLEAN DEFAULT FALSE, -- Whether the issue has been resolved
    Resolution_Date DATE DEFAULT NULL, -- Date when the feedback was resolved
    FOREIGN KEY (Citizen_ID) REFERENCES Citizen_Info(Citizen_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Service_ID) REFERENCES Public_Services(Service_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Assigned_Official_ID) REFERENCES City_Official(Official_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Service_Request Table
CREATE TABLE Service_Request (
    Request_ID VARCHAR(50) PRIMARY KEY, -- Unique identifier for the request
    Citizen_ID VARCHAR(50) NOT NULL, -- Links to Citizen_Info table
    Service_ID VARCHAR(30), -- Links to Public_Services table
    Request_Date DATE NOT NULL, -- Date the request was submitted
    Request_Status VARCHAR(20) DEFAULT 'Pending' 
        CHECK (Request_Status IN ('Pending', 'In Progress', 'Completed', 'Rejected')), -- Status of the request
    Assigned_Official_ID VARCHAR(50), -- Links to City_Official table
    Request_Description TEXT, -- Description of the service request
    Completion_Date DATE, -- Date when the request was completed
    FOREIGN KEY (Citizen_ID) REFERENCES Citizen_Info(Citizen_ID) 
        ON DELETE CASCADE ON UPDATE CASCADE, -- Deletes requests if the citizen is deleted
    FOREIGN KEY (Service_ID) REFERENCES Public_Services(Service_ID) 
        ON DELETE CASCADE ON UPDATE CASCADE, -- Deletes requests if the service is deleted
    FOREIGN KEY (Assigned_Official_ID) REFERENCES City_Official(Official_ID) 
        ON DELETE SET NULL ON UPDATE CASCADE -- Sets Assigned_Official_ID to NULL if the official is deleted
);



-- Location Table
CREATE TABLE Location (
    Location_ID VARCHAR(50) PRIMARY KEY, -- Unique identifier for the location
    Location_Name VARCHAR(100) NOT NULL, -- Name of the location
    Location_Type VARCHAR(50) CHECK (Location_Type IN ('Residential', 'Commercial', 'Industrial', 'Mixed-Use','Heritage')), -- Type of area
    City VARCHAR(50) NOT NULL, -- City name
    Region VARCHAR(50) NOT NULL, -- Region or division
    Postal_Code VARCHAR(10), -- Postal or ZIP code
    Additional_Info TEXT -- Any additional details about the location  
);


-- Citizen_Location Table

CREATE TABLE Citizen_Location (
    Citizen_ID VARCHAR(30),
    Location_ID VARCHAR(50),
    PRIMARY KEY (Citizen_ID, Location_ID),
    FOREIGN KEY (Citizen_ID) REFERENCES Citizen_Info(Citizen_ID) ON DELETE CASCADE,
    FOREIGN KEY (Location_ID) REFERENCES Location(Location_ID) ON DELETE CASCADE
);

-- Weather_Condition_Data Table

CREATE TABLE Weather_Condition_Data (
    Weather_ID VARCHAR(50) PRIMARY KEY ,       -- Unique identifier for each weather record
    Location_ID VARCHAR(50) NOT NULL,                        -- Foreign key linking to the Location table
    Observation_Date DATE NOT NULL,                  -- Date of the weather observation
    Temperature DECIMAL(5, 2) NOT NULL,              -- Temperature in Celsius (or desired unit)
    Humidity INT CHECK (Humidity BETWEEN 0 AND 100), -- Humidity percentage (0-100)
    Weather_Condition VARCHAR(50) CHECK (
	Weather_Condition IN ('Sunny', 'Rainy', 'Cloudy', 'Stormy', 'Windy', 'Foggy')),      -- General weather description
    Wind_Speed DECIMAL(5, 2),                        -- Wind speed in km/h (or desired unit)
    Additional_Info TEXT,                            -- Additional details about the weather
    FOREIGN KEY (Location_ID) REFERENCES Location(Location_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


-- Infrustructure  Maintainance Table

CREATE TABLE Infrastructure_Maintenance (
    Maintenance_ID VARCHAR(50) PRIMARY KEY, -- Unique identifier for each maintenance record
    Location_ID VARCHAR(50) NOT NULL, -- Foreign key referencing the Location table
    Department_ID VARCHAR(50),
    Maintenance_Type VARCHAR(100) NOT NULL, -- Type of maintenance (e.g., Road Repair, Utility Maintenance)
    Start_Date DATE NOT NULL, -- Start date of the maintenance work
    End_Date DATE, -- End date of the maintenance work (can be NULL if ongoing)
    Status VARCHAR(50) CHECK (Status IN ('Planned', 'Ongoing', 'Completed')) DEFAULT 'Planned', 
    Cost DECIMAL(15,2), -- Cost of maintenance (optional)
    Contractor_Name VARCHAR(100), -- Name of the contractor or company handling the maintenance
    Additional_Info TEXT, -- Any additional details about the maintenance work
    FOREIGN KEY (Location_ID) REFERENCES Location(Location_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID)
    ON DELETE CASCADE 
    ON UPDATE CASCADE
);


-- Bus_Trasportation Table

CREATE TABLE Bus_Transportation  (
    Bus_ID VARCHAR(30) PRIMARY KEY ,
    Route_Name VARCHAR(50) NOT NULL, 
    Start_Location_ID VARCHAR(50),
    End_Location_ID VARCHAR(50),
    Number_Of_Stations INT NOT NULL, 
    Frequency_Per_Hour INT NOT NULL, 
	status ENUM('On Time', 'Delayed', 'Cancelled') DEFAULT 'On Time', 
    FOREIGN KEY (Start_Location_ID) REFERENCES Location(Location_ID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (End_Location_ID) REFERENCES Location(Location_ID)ON DELETE CASCADE ON UPDATE CASCADE
);



-- IoT_Devices Table    
    CREATE TABLE IoT_Devices (
    Device_ID VARCHAR(30) PRIMARY KEY ,
    Device_Type VARCHAR(100) NOT NULL,
    Department_ID VARCHAR(10) NOT NULL,
    Location_ID VARCHAR(50) NOT NULL,
    Installation_Date DATE NOT NULL,
    Device_Status VARCHAR(50) NOT NULL,
    Last_Communication_Timestamp DATETIME NOT NULL,
    Manufacturer VARCHAR(100),
    Battery_Status VARCHAR(50),
    FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID),
    FOREIGN KEY (Location_ID) REFERENCES Location(Location_ID)
);
select*
FROM IoT_Devices;

-- Traffic_Data Table
CREATE TABLE Traffic_Data (
    Traffic_ID VARCHAR(50) PRIMARY KEY,
    Location_ID VARCHAR(50) NOT NULL,
    Device_ID VARCHAR(30) NOT NULL,
    Vehicle_Count INT,
    Average_Speed DECIMAL(5, 2),
    Accident_Reports INT,
    Congestion_Level VARCHAR(50),
    Timestamp DATETIME NOT NULL,
    FOREIGN KEY (Location_ID) REFERENCES Location(Location_ID),
    FOREIGN KEY (Device_ID) REFERENCES IoT_Devices(Device_ID)
);



-- select*
-- from traffic_data;

-- Utility_Monitoring Table
CREATE TABLE Utility_Monitoring (
    Utility_ID VARCHAR(50) PRIMARY KEY,
    Location_ID VARCHAR(30) NOT NULL,
    Utility_Type VARCHAR(50) NOT NULL,
    Consumption DECIMAL(10, 2) NOT NULL,
    Provider VARCHAR(100) NOT NULL,
    Timestamp DATETIME NOT NULL,
    Cost_Per_Unit DECIMAL(10, 2) NOT NULL,
    Peak_Consumption_Period VARCHAR(50),
    Device_ID VARCHAR(30) NOT NULL,
    FOREIGN KEY (Location_ID) REFERENCES Location(Location_ID),
    FOREIGN KEY (Device_ID) REFERENCES IoT_Devices(Device_ID)
);

-- Queries

-- 1 List of all department name and department id
select d.department_name AS "Department Name", d.Department_ID AS "Department Id" 
from Department d; 

-- 2 Top performinng departments in IoT usage:
SELECT d.Department_Name, COUNT(iot.Device_ID) AS Active_Devices
FROM IoT_Devices iot
JOIN Department d ON iot.Department_ID = d.Department_ID
WHERE iot.Device_Status = 'Active'
GROUP BY d.Department_ID
ORDER BY Active_Devices DESC;

-- 3 Location with active IoT Devices
SELECT DISTINCT Location_Name AS Location_Name
FROM  IoT_Devices iot
JOIN Location l ON iot.Location_ID = l.Location_ID
WHERE iot.Device_Status = 'Active';

-- 4 Service Provided by each department
SELECT d.Department_Name AS "Department Name",ps.Service_Type AS "Service Type" 
FROM Public_Services ps
JOIN Department d ON ps.Department_ID = d.Department_ID;

-- 5Recent Traffic Data
SELECT  l.Location_name AS "Location" , l.Location_ID AS "Location Id",Traffic_ID AS "Traffic Id",  Congestion_Level AS "Congestion Level", Timestamp AS "Time"
FROM Traffic_Data, location l
ORDER BY Timestamp DESC 
LIMIT 10;

-- 6 Citizens Registered This Month
SELECT COUNT(*) AS "Monthly Registrations" 
FROM CitizenRegistration 
WHERE  MONTH(Registration_Date) = MONTH(CURDATE()) AND YEAR(Registration_Date) = YEAR(CURDATE());
 
 -- 7 Citizens name and national id who Registered This Month
SELECT  ci.Name AS "Name", ci.National_ID AS "National ID" 
FROM citizen_info ci 
WHERE  MONTH(ci.City_Registration_Date) = MONTH(CURDATE()) AND YEAR(ci.City_Registration_Date) = YEAR(CURDATE());

-- 8 Rejected Cizienshipo applicnats name and National Id and address
SELECT  cg.Full_Name AS "Name", cg.National_ID AS "National ID" , cg.address as "Address"
FROM CitizenRegistration cg
WHERE  cg.Approval_Status = "Rejected";

-- 9 Approved Cizienship applicnats details
SELECT CR.Registration_ID AS "Regrastation Id", CR.Full_Name as "Full Name", CI.Citizen_ID as "Citizen Id", CI.Name,  CI.Email as "Email" 
FROM CitizenRegistration CR 
JOIN Citizen_Info CI 
ON CR.Registration_ID = CI.Citizen_ID
WHERE CR.Approval_Status = 'Approved';


-- 10Citizenship application Approval Querry
UPDATE CitizenRegistration
SET Approval_Status = 'Approved'
WHERE Registration_ID LIKE 'CIT%' AND National_ID LIKE '199%';

-- 11Citizenship application  Rejection Querry
UPDATE CitizenRegistration
SET Approval_Status = 'Rejected'
WHERE Registration_ID LIKE 'CIT%' AND National_ID NOT LIKE '199%';
 
-- 12 Find Citizens with Pending Registrations
SELECT CR.Registration_ID, CR.Full_Name, CR.Email 
FROM CitizenRegistration CR 
LEFT JOIN Citizen_Info CI 
ON CR.Registration_ID = CI.Citizen_ID
WHERE CI.Citizen_ID IS NULL AND CR.Approval_Status = 'Pending';

-- 13List of all city officials and their departments
SELECT CO.Name AS "Official Name", CO.Official_ID AS "ID", CO.Role as "Role", D.Department_Name as "Department Name"
FROM City_Official CO 
JOIN Department D 
ON CO.Department_ID = D.Department_ID;

-- 14Find Departmental Head
SELECT D.Department_Name, CO.Name AS Head_Name 
FROM Department D 
JOIN City_Official CO 
ON D.Head_Official_ID = CO.Official_ID;

-- 15List of services with feedbacks
SELECT PS.Service_Type, F.Feedback_Type, F.Rating 
FROM Public_Services PS 
JOIN Feedback F 
ON PS.Service_ID = F.Service_ID;

-- 16Counting feedbacks by services
SELECT PS.Service_Type, COUNT(F.Feedback_ID) AS Total_Feedbacks 
FROM Public_Services PS 
JOIN Feedback F 
ON PS.Service_ID = F.Service_ID
GROUP BY PS.Service_Type;

-- 17
SELECT CL.Citizen_ID, CI.Name, CL.Location_ID, L.Location_Name, L.Location_ID
FROM Citizen_Location CL JOIN Citizen_Info CI ON CL.Citizen_ID = CI.Citizen_ID JOIN Location L 
ON CL.Location_ID = L.Location_ID;

-- 18List Traffic Data by IoT Device

SELECT TD.Traffic_ID, TD.Vehicle_Count, ID.Device_Type 
FROM Traffic_Data TD 
JOIN IoT_Devices ID 
ON TD.Device_ID = ID.Device_ID;

-- 19 location with high vehicle count
SELECT L.Location_Name, SUM(TD.Vehicle_Count) AS Total_Vehicles 
FROM Traffic_Data TD 
JOIN Location L 
ON TD.Location_ID = L.Location_ID
GROUP BY L.Location_Name 
HAVING Total_Vehicles > 100;

-- 20 Locations where no citizens live
SELECT L.Location_Name 
FROM Location L 
LEFT JOIN Citizen_Location CL 
ON L.Location_ID = CL.Location_ID
WHERE CL.Citizen_ID IS NULL;

-- 21Counting citizens in each area
SELECT L.Location_Name AS "Location Name", COUNT(CL.Citizen_ID) AS "Total Citizens" 
FROM Location L 
LEFT JOIN Citizen_Location CL 
ON L.Location_ID = CL.Location_ID
GROUP BY L.Location_Name;

-- 22 List of citizens with their location and ity
SELECT CI.Name, L.Location_Name, L.City 
FROM Citizen_Info CI 
JOIN Citizen_Location CL 
ON CI.Citizen_ID = CL.Citizen_ID 
JOIN Location L 
ON CL.Location_ID = L.Location_ID;

-- 23List Maintenance Activities by Department
SELECT IM.Maintenance_Type, IM.Status, D.Department_Name 
FROM Infrastructure_Maintenance IM 
JOIN Department D 
ON IM.Department_ID = D.Department_ID;

-- 24Counting Maintenance Activities per Department
SELECT D.Department_Name, COUNT(IM.Maintenance_ID) AS Total_Maintenance 
FROM Department D 
LEFT JOIN Infrastructure_Maintenance IM 
ON D.Department_ID = IM.Department_ID
GROUP BY D.Department_Name;

-- 25 List of Ongoing maintenance in each location 
SELECT L.Location_Name, IM.Maintenance_Type, IM.Status 
FROM Infrastructure_Maintenance IM 
JOIN Location L 
ON IM.Location_ID = L.Location_ID
WHERE IM.Status = 'Ongoing';

-- 26 location with low vehicle count
SELECT L.Location_Name, SUM(TD.Vehicle_Count) AS Total_Vehicles 
FROM Traffic_Data TD 
JOIN Location L 
ON TD.Location_ID = L.Location_ID
GROUP BY L.Location_Name 
HAVING Total_Vehicles < 100;

-- 27Finding All Requests by Citizens Along With Their Names
SELECT SR.Request_ID, CI.Name AS Citizen_Name, SR.Request_Status, SR.Request_Date 
FROM Service_Request SR
JOIN Citizen_Info CI 
ON SR.Citizen_ID = CI.Citizen_ID;

-- 28 Finding Officials with the Most Pending Requests
SELECT CO.Name AS "Official Name", COUNT(SR.Request_ID) AS "Pending Requests" 
FROM Service_Request SR
JOIN City_Official CO 
ON SR.Assigned_Official_ID = CO.Official_ID
WHERE SR.Request_Status = 'Pending'
GROUP BY CO.Name
ORDER BY Pending_Requests DESC;

-- 29 Fing locations with highest number of request
SELECT 
    L.Location_Name, 
    SR.Request_Status AS Request_Type, 
    COUNT(SR.Request_ID) AS Total_Requests, 
    GROUP_CONCAT(SR.Request_Description SEPARATOR '; ') AS Request_Details
FROM Service_Request SR
JOIN Citizen_Location CL 
    ON SR.Citizen_ID = CL.Citizen_ID
JOIN Location L 
    ON CL.Location_ID = L.Location_ID
GROUP BY L.Location_Name, SR.Request_Status
ORDER BY Total_Requests DESC;

-- 30 Retrieveing Unresolved Feedback
SELECT Feedback_ID, Description 
FROM Feedback 
WHERE Resolved_Status = FALSE;

-- 31List Available Services
SELECT Service_Type AS "Service Type", Service_Description AS "Service description" 
FROM Public_Services 
WHERE Availability_Status = 'Available';

-- 32Find Services with a Fee Above 500 taka
SELECT Service_Type, Service_Fee 
FROM Public_Services 
WHERE Service_Fee > 500.00;

-- 33Find Services with a Fee below 500 taka
SELECT Service_Type, Service_Fee 
FROM Public_Services 
WHERE Service_Fee < 500.00;

-- 34 Counting Service request by status
SELECT Request_Status As "Service Request Status", COUNT(*) AS "Total Request Count" 
FROM Service_Request 
GROUP BY Request_Status;

-- 35 Finding Locations with the Most Frequent Services Requested and Assigned Official Details
SELECT L.Location_Name AS "Location",COUNT(SR.Request_ID)  AS "Total Request Count",CO.Name AS "Assigned Official",CO.Role AS "Role",PS.Service_Type AS "Most Frequent Service"
FROM Service_Request SR
JOIN Citizen_Location CL 
    ON SR.Citizen_ID = CL.Citizen_ID
JOIN Location L 
    ON CL.Location_ID = L.Location_ID
JOIN City_Official CO 
    ON SR.Assigned_Official_ID = CO.Official_ID
JOIN Public_Services PS 
    ON SR.Service_ID = PS.Service_ID
GROUP BY L.Location_Name, CO.Name, CO.Role, PS.Service_Type
ORDER BY COUNT(SR.Request_ID) DESC;

-- 36 List of locations Experiencing Extreme Weather
SELECT L.Location_Name AS "Location", W.Weather_Condition AS "Weather Condition", W.Temperature AS "Temperature", W.Wind_Speed AS "Wind Speed", W.Humidity AS "Humidity"
FROM Weather_Condition_Data W
JOIN Location L 
ON W.Location_ID = L.Location_ID
WHERE W.Wind_Speed > 50 OR W.Weather_Condition IN ('Foggy', 'Stormy')
ORDER BY W.Wind_Speed DESC, W.Humidity DESC;

-- 37Average Temperature and Humidity by Weather Condition
SELECT Weather_Condition, AVG(Temperature) AS Avg_Temperature,AVG(Humidity) AS Avg_Humidity
FROM Weather_Condition_Data
GROUP BY Weather_Condition
ORDER BY Avg_Temperature DESC;

-- 38Monthly Average Weather Statistics
SELECT MONTH(Observation_Date) AS Month, AVG(Temperature) AS "Average Temperature", AVG(Humidity) AS "Average Humidity", AVG(Wind_Speed) AS "Average Wind Speed"
FROM Weather_Condition_Data
GROUP BY MONTH(Observation_Date)
ORDER BY Month;

-- 39
SELECT L.Location_Name AS "Location Name", AVG(TD.Vehicle_Count) AS "Average Vehicle Count",AVG(TD.Congestion_Level) AS "Average Congestion Level",MAX(TD.Accident_Reports) AS "Accidents Reported"
FROM Traffic_Data TD
JOIN Location L 
    ON TD.Location_ID = L.Location_ID
GROUP BY L.Location_Name
ORDER BY AVG(TD.Congestion_Level) DESC, AVG(TD.Vehicle_Count)  DESC;


-- 40.City Official details who don't have any supervisors
SELECT CO.Official_ID AS "Official ID", CO.Name AS "Name", CO.Role AS "Role", CO.Department_ID AS "Deparment ID", D.Department_Name AS "Department Name", CO.Phone_Number AS "Contact Number" , CO.Email, CO.Years_Of_Service AS "Service years",
    CO.Qualifications,CO.Address
FROM City_Official CO
LEFT JOIN Department D 
    ON CO.Department_ID = D.Department_ID
WHERE CO.Supervisor_ID IS NULL;

