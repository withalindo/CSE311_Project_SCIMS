
CREATE DATABASE SCIMS;
USE SCIMS;
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

INSERT INTO Citizen_Info (
    Citizen_ID, Name, Address, Contact_Number, Email, Gender, Date_of_Birth, National_ID, City_Registration_Date
) VALUES
('CIT001', 'Md. Tanvir Hossain', 'House 15, Road 10, Gulshan 1, Dhaka', '01712345678', 'tanvir.hossain@gmail.com', 'Male', '1999-10-26', '1990024530123', DEFAULT),
('CIT002', 'Nasima Akhter', 'Flat 5C, Lakeview Apartments, Banani, Dhaka', '01812345679', 'nasima.akhter@yahoo.com', 'Female', '1999-05-18', '1980054525678', DEFAULT),
('CIT003', 'Shahriar Kabir', 'House 24, Road 8, Dhanmondi, Dhaka', '01912345670', 'shahriar.kabir@gmail.com', 'Male', '1990-08-26', '1978014530987', DEFAULT),
('CIT004', 'Ayesha Rahman', 'House 32, Sector 7, Uttara, Dhaka', '01798765432', 'ayesha.rahman@gmail.com', 'Female', '1996-01-26', '1995056783456', DEFAULT),
('CIT005', 'Md. Abir Hasan', 'House 18, Road 5, Mohammadpur, Dhaka', '01876543210', 'abir.hasan@outlook.com', 'Male', '1987-10-06', '1976034526789', DEFAULT),
('CIT006', 'Taslima Begum', 'Flat 4A, Green Plaza, Mirpur 12, Dhaka', '01745678901', 'taslima.begum@gmail.com', 'Female', '1975-10-26', '1993034786541', DEFAULT),
('CIT007', 'Khaled Mahmud', 'House 22, Bashundhara R/A, Block F, Dhaka', '01899887766', 'khaled.mahmud@gmail.com', 'Male', '1985-12-16', '1988012567894', DEFAULT),
('CIT008', 'Nusrat Jahan', 'Apartment 3B, Orchid Tower, Panthapath, Dhaka', '01711223344', 'nusrat.jahan@gmail.com', 'Female', '1998-10-18', '1997054672345', DEFAULT),
('CIT009', 'Hasnat Karibul Islam Alindo', 'House 526, Road 17, Block J, Bashundhara R/A', '01316619278', 'withalindo@gmail.com', 'Male', '2001-12-28', '1998034530678', DEFAULT), 
('CIT010', 'Md. Minhaujul Islam', 'House 257, Road 5, Block C, Bashundhara R/A', '01756619289', 'minhajulislamrimon28@gmail.com', 'Male', '2001-04-16', '1990027530526', DEFAULT),
('CIT011', 'Nur Ibne Kawsar Zitu', 'House 226, Road 5, Block C, Bashundhara R/A', '01712345670', 'nur.zitu@gmail.com', 'Male', '2000-11-15', '1990045530425', DEFAULT), 
('CIT012', 'Sabbir Hossain', 'House 126, Road 15, Block A, Bashundhara R/A', '01798766832', 'sabbirsts420@gmail.com', 'Male', '2000-04-09', '1990025530223', DEFAULT),
('CIT013', 'Sayed Mahi Ashrafi', 'House 26, Road 2, Block D, Nikunja R/A', '01798765432', 'syed.mahi@gmail.com', 'Male', '2001-09-17', '1990067530124', DEFAULT), 
('CIT014', 'Ivy Khan', 'House 427, Road 8, Block D, Bashundhara R/A', '01745678901', 'ivy.khan@gmail.com', 'Female', '2001-08-06', '1990024498128', DEFAULT),
('CIT015', 'Meher Easha', 'House 126, Road 8, Block C, Bashundhara R/A', '01711223344', 'emeherun@gmail.com', 'Female', '2001-08-15', '1900024530129', DEFAULT);

-- City_Official Table

CREATE TABLE City_Official (
    Official_ID INT PRIMARY KEY, -- Unique ID for each official
    Name VARCHAR(100) NOT NULL, -- Name of the official
    Department_ID INT NOT NULL, -- Foreign Key referencing the Department table
    Role VARCHAR(50) NOT NULL, -- Role/Position of the official
    Phone_Number VARCHAR(15), -- Official's contact number
    Email VARCHAR(100), -- Official's email address
    Years_Of_Service INT, -- Duration of service in years
    Qualifications TEXT, -- Qualifications of the official
    Address TEXT, -- Address details
    Supervisor_ID INT, -- References another official (self-referencing foreign key)
--     FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID),
    FOREIGN KEY (Supervisor_ID) REFERENCES City_Official(Official_ID)
    ON DELETE CASCADE
	ON UPDATE CASCADE
);

-- Department Table

CREATE TABLE Department (
    Department_ID INT PRIMARY KEY, -- Unique identifier for each department
    Department_Name VARCHAR(100) NOT NULL, -- Name of the department
    Head_Official_ID INT, -- Foreign key referencing the head official of the department
    Department_Budget DECIMAL(15, 2), -- Budget allocated to the department
    Number_Of_Employees INT, -- Total employees in the department
    Main_Responsibilities TEXT, -- Description of the department's main tasks
    Operating_Hours VARCHAR(50), -- Department's working hours
    FOREIGN KEY (Head_Official_ID) REFERENCES City_Official(Official_ID) -- Links head official to the department
	ON DELETE CASCADE
	ON UPDATE CASCADE
);
INSERT INTO City_Official (Official_ID, Name, Department_ID, Role, Phone_Number, Email, Years_Of_Service, Qualifications, Address, Supervisor_ID)
VALUES
(1, 'Md. Tanvir Ahmed', 101, 'Department Head', '01712345678', 'tanvir.ahmed@citygov.org', 15, 'Master’s in Public Administration', 'House 15, Road 10, Gulshan 1, Dhaka', NULL),
(2, 'Nasima Akhter', 101, 'Senior Officer', '01812345679', 'nasima.akhter@citygov.org', 10, 'MBA in Management', 'Flat 5C, Lakeview Apartments, Banani, Dhaka', 1),
(3, 'Shahriar Kabir', 102, 'Department Head', '01912345670', 'shahriar.kabir@citygov.org', 20, 'PhD in Urban Planning', 'House 24, Road 8, Dhanmondi, Dhaka', NULL),
(4, 'Ayesha Rahman', 102, 'Officer', '01798765432', 'ayesha.rahman@citygov.org', 5, 'Bachelor’s in Civil Engineering', 'House 32, Sector 7, Uttara, Dhaka', 3),
(5, 'Md. Abir Hasan', 103, 'Officer', '01876543210', 'abir.hasan@citygov.org', 3, 'MBA in Public Management', 'House 18, Road 5, Mohammadpur, Dhaka', 3),
(6, 'Taslima Begum', 104, 'Department Head', '01745678901', 'taslima.begum@citygov.org', 18, 'Master’s in Environmental Science', 'Flat 4A, Green Plaza, Mirpur 12, Dhaka', NULL),
(7, 'Khaled Mahmud', 104, 'Senior Officer', '01899887766', 'khaled.mahmud@citygov.org', 12, 'Bachelor’s in Environmental Engineering', 'House 22, Bashundhara R/A, Block F, Dhaka', 6),
(8, 'Nusrat Jahan', 105, 'Department Head', '01711223344', 'nusrat.jahan@citygov.org', 25, 'Master’s in Public Policy', 'Apartment 3B, Orchid Tower, Panthapath, Dhaka', NULL),
(9, 'Hasnat Islam', 110, 'Department Head', '01316619278', 'hasnat.islam@citygov.org', 18, 'PhD in AI Modeling', 'House 526, Road 17, Block J, Bashundhara R/A', NULL),
(10, 'Md. Minhajul Islam', 106, 'Officer', '01756619289', 'minhajul.islam@citygov.org', 18, 'PhD in Infrastructure Development', 'House 257, Road 5, Block C, Bashundhara R/A',NULL),
(11, 'Sayed Mahi Ashrafi', 110, 'Department Head', '01798765432', 'syed.mahicitygov.org', 8, 'Master’s in Software Engineering', 'House 26, Road 2, Block D, Nikunja R/A',9),
(12, 'Ivy Khan', 106, 'Officer', '01745678901', 'ivy.khan@citygov.org', 9, 'Master’s in Infrastructure Development', 'House 427, Road 8, Block D, Bashundhara R/A',10);


INSERT INTO Department (Department_ID, Department_Name, Head_Official_ID, Department_Budget, Number_Of_Employees, Main_Responsibilities, Operating_Hours)
VALUES
(101, 'Public Safety', 1, 50000000, 120, 'Manage law enforcement, fire services, and public safety operations.', '24/7'),
(102, 'Infrastructure', 3, 80000000, 150, 'Oversee construction, maintenance of roads, bridges, and public buildings.', '9:00 AM - 5:00 PM'),
(103, 'Transportation', 10, 60000000, 100, 'Manage public transport systems, metro services, and traffic flow.', '6:00 AM - 11:00 PM'),
(104, 'Environment and Sanitation', 6, 30000000, 80, 'Ensure waste management, clean water supply, and environmental health.', '8:00 AM - 6:00 PM'),
(105, 'Urban Planning', 8, 45000000, 60, 'Plan and regulate land use, zoning, and urban development projects.', '9:00 AM - 5:00 PM'),
(106, 'Emergency Services', 10, 70000000, 90, 'Respond to emergencies, manage disaster recovery, and medical aid.', '24/7'),
(107, 'Health and Welfare', NULL, 55000000, 110, 'Provide health services, welfare programs, and public healthcare.', '9:00 AM - 5:00 PM'),
(108, 'Education and Community Services', NULL, 40000000, 75, 'Oversee public schools, libraries, and community programs.', '8:00 AM - 6:00 PM'),
(109, 'Finance and Budget', NULL, 20000000, 50, 'Manage city finances, budgets, and tax collection.', '9:00 AM - 5:00 PM'),
(110, 'Technology and Innovation', 9, 65000000, 40, 'Develop and manage city tech infrastructure and smart city initiatives.', '9:00 AM - 6:00 PM');

ALTER TABLE City_Official
ADD CONSTRAINT FK_Department_ID
FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID)
ON DELETE CASCADE
ON UPDATE CASCADE;
USE SCIMS;

-- Public Services Table

CREATE TABLE Public_Services (
    Service_ID INT PRIMARY KEY AUTO_INCREMENT, -- Unique identifier for each public service
    Department_ID INT, -- Links to the Department table
    Service_Type VARCHAR(100) NOT NULL, -- Type of service (e.g., Waste Management, Fire Safety)
    Service_Description TEXT, -- Detailed description of the service
    Availability_Status VARCHAR(20) CHECK (Availability_Status IN ('Available', 'Unavailable')), -- Service availability status
    Average_Response_Time TIME, -- Average time taken to respond
    Service_Fee DECIMAL(10, 2), -- Fee for the service (if applicable)
    FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID)
    ON DELETE CASCADE
	ON UPDATE CASCADE
);
CREATE TABLE Feedback (
    Feedback_ID INT PRIMARY KEY AUTO_INCREMENT, -- Unique identifier for feedback
    Citizen_ID VARCHAR(10), -- Links to Citizen_Info table
    Service_ID INT, -- Links to Public_Services table
    Assigned_Official_ID INT, -- Links to City_Official table
    Feedback_Date DATE NOT NULL, -- Date the feedback was given
    Feedback_Type VARCHAR(50), -- Type of feedback (e.g., Complaint, Suggestion, Praise)
    Description TEXT, -- Detailed description of the feedback
    Rating INT CHECK (Rating BETWEEN 1 AND 5), -- Rating out of 5
    Resolved_Status BOOLEAN DEFAULT FALSE, -- Whether the issue has been resolved
    Resolution_Date DATE, -- Date when the feedback was resolved
    FOREIGN KEY (Citizen_ID) REFERENCES Citizen_Info(Citizen_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Service_ID) REFERENCES Public_Services(Service_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Assigned_Official_ID) REFERENCES City_Official(Official_ID)
    ON DELETE CASCADE 
    ON UPDATE CASCADE
);
INSERT INTO Public_Services (Department_ID, Service_Type, Service_Description, Availability_Status, Average_Response_Time, Service_Fee)
VALUES
(101, 'Emergency Rescue', 'Provide immediate rescue operations during natural disasters and accidents.', 'Available', '00:20:00', 0.00),
(102, 'Bridge Inspection', 'Conduct routine inspections and maintenance of city bridges.', 'Available', '72:00:00', 0.00),
(103, 'Traffic Management', 'Monitor and regulate traffic flow across the city.', 'Available', '00:15:00', 0.00),
(104, 'Water Quality Monitoring', 'Test and ensure safe drinking water supply to households.', 'Unavailable', NULL, 200.00),
(105, 'Urban Redevelopment', 'Plan and execute redevelopment projects in underutilized areas.', 'Available', '96:00:00', 10000.00),
(106, 'Disaster Recovery', 'Coordinate recovery efforts after major disasters.', 'Available', '02:00:00', 0.00),
(107, 'Vaccination Programs', 'Administer free vaccines for common diseases.', 'Available', '00:30:00', 0.00),
(108, 'Library Membership', 'Provide access to public libraries and online resources.', 'Available', '00:05:00', 500.00),
(109, 'Tax Consultation', 'Assist citizens in calculating and paying city taxes.', 'Unavailable', NULL, 0.00),
(110, 'Wi-Fi Services', 'Offer free public Wi-Fi in selected urban zones.', 'Available', '00:10:00', 0.00);

INSERT INTO Feedback (Citizen_ID, Service_ID, Assigned_Official_ID, Feedback_Date, Feedback_Type, Description, Rating, Resolved_Status, Resolution_Date)
VALUES
('CIT001', 1, 3, '2024-11-29', 'Complaint', 'The service was delayed.', 2, FALSE, NULL),
('CIT002', 2, 4, '2024-11-28', 'Praise', 'The officer was very helpful and efficient.', 5, TRUE, '2024-11-28'),
('CIT003', 3, 5, '2024-11-27', 'Suggestion', 'Consider extending service hours to weekends.', 4, FALSE, NULL),
('CIT004', 4, 6, '2024-11-26', 'Complaint', 'Difficulties in reaching support during emergencies.', 3, FALSE, NULL),
('CIT005', 5, 7, '2024-11-25', 'Praise', 'Prompt response and excellent resolution.', 5, TRUE, '2024-11-25');

-- Service_Request Table
CREATE TABLE Service_Request (
    Request_ID INT PRIMARY KEY AUTO_INCREMENT, -- Unique identifier for the request
    Citizen_ID VARCHAR(10) NOT NULL, -- Links to Citizen_Info table
    Service_ID INT NOT NULL, -- Links to Public_Services table
    Request_Date DATE NOT NULL, -- Date the request was submitted
    Request_Status VARCHAR(20) DEFAULT 'Pending' 
        CHECK (Request_Status IN ('Pending', 'In Progress', 'Completed', 'Rejected')), -- Status of the request
    Assigned_Official_ID INT, -- Links to City_Official table
    Request_Description TEXT, -- Description of the service request
    Completion_Date DATE, -- Date when the request was completed
    FOREIGN KEY (Citizen_ID) REFERENCES Citizen_Info(Citizen_ID) 
        ON DELETE CASCADE ON UPDATE CASCADE, -- Deletes requests if the citizen is deleted
    FOREIGN KEY (Service_ID) REFERENCES Public_Services(Service_ID) 
        ON DELETE CASCADE ON UPDATE CASCADE, -- Deletes requests if the service is deleted
    FOREIGN KEY (Assigned_Official_ID) REFERENCES City_Official(Official_ID) 
        ON DELETE SET NULL ON UPDATE CASCADE -- Sets Assigned_Official_ID to NULL if the official is deleted
);

INSERT INTO Service_Request (Citizen_ID, Service_ID, Request_Date, Request_Status, Assigned_Official_ID, Request_Description, Completion_Date)
VALUES
('CIT001', 1, '2024-11-20', 'Completed', 3, 'Requested fire safety inspection for a school building.', '2024-11-21'),
('CIT002', 3, '2024-11-21', 'In Progress', 5, 'Complaint about inconsistent bus schedules in the area.', NULL),
('CIT003', 4, '2024-11-22', 'Rejected', 6, 'Requested water quality testing for a residential complex.', NULL),
('CIT004', 6, '2024-11-23', 'Completed', 7, 'Assistance required for disaster recovery after recent heavy rainfall.', '2024-11-23'),
('CIT005', 2, '2024-11-24', 'Pending', 4, 'Requested routine road maintenance for a damaged street.', NULL),
('CIT006', 8, '2024-11-25', 'Completed', 9, 'Applied for library membership for access to online resources.', '2024-11-25'),
('CIT007', 5, '2024-11-26', 'In Progress', 8, 'Zoning approval request for construction of a commercial plaza.', NULL),
('CIT008', 10, '2024-11-27', 'Pending', NULL, 'Inquiry about the availability of free Wi-Fi in public parks.', NULL),
('CIT009', 7, '2024-11-28', 'Completed', 2, 'Requested vaccination for a family of four during the health drive.', '2024-11-28'),
('CIT010', 9, '2024-11-29', 'Rejected', 1, 'Consultation request for tax calculation and payment issues.', NULL);

-- Location Table
CREATE TABLE Location (
    Location_ID INT PRIMARY KEY AUTO_INCREMENT, -- Unique identifier for the location
    Location_Name VARCHAR(100) NOT NULL, -- Name of the location
    Location_Type VARCHAR(50) CHECK (Location_Type IN ('Residential', 'Commercial', 'Industrial', 'Mixed-Use','Heritage')), -- Type of area
    City VARCHAR(50) NOT NULL, -- City name
    Region VARCHAR(50) NOT NULL, -- Region or division
    Postal_Code VARCHAR(10), -- Postal or ZIP code
    Additional_Info TEXT -- Any additional details about the location  
); 
-- drop table Location;
-- Inserting 10 Sample Data Rows for Locations in Dhaka
INSERT INTO Location (Location_Name, Location_Type, City, Region, Postal_Code, Additional_Info) 
VALUES 
('Gulshan 1', 'Commercial', 'Dhaka', 'Dhaka Division', '1212', 'Busy commercial area with diplomatic zones and shopping centers.'),
('Gulshan 2', 'Residential', 'Dhaka', 'Dhaka Division', '1213', 'Upscale residential area with high-end facilities and security.'),
('Banani', 'Residential', 'Dhaka', 'Dhaka Division', '1214', 'Popular upscale area with restaurants, boutiques, and offices.'),
('Dhanmondi 27', 'Mixed-Use', 'Dhaka', 'Dhaka Division', '1209', 'Hub for educational institutions, hospitals, and commercial spaces.'),
('Mirpur 10', 'Residential', 'Dhaka', 'Dhaka Division', '1216', 'Densely populated area known for its cricket stadium.'),
('Bashundhara Residential Area', 'Mixed-Use', 'Dhaka', 'Dhaka Division', '1229', 'Modern gated community with high-rise buildings and shopping malls.'),
('Uttara Sector 4', 'Mixed-Use', 'Dhaka', 'Dhaka Division', '1230', 'Organized residential sector with green spaces and markets.'),
('Farmgate', 'Commercial', 'Dhaka', 'Dhaka Division', '1215', 'Busy commercial area known for markets and transport connectivity.'),
('Shyamoli', 'Residential', 'Dhaka', 'Dhaka Division', '1207', 'Affordable housing area with access to major roads.'),
('Old Dhaka', 'Heritage', 'Dhaka', 'Dhaka Division', '1100', 'Historic area with traditional markets and architectural landmarks.'),
('Tejgaon Industrial Area', 'Industrial', 'Dhaka', 'Dhaka Division', '1218', 'Central industrial zone with factories and corporate offices.');
drop table location;
CREATE TABLE Citizen_Location (
    Citizen_ID VARCHAR(30),
    Location_ID INT,
    PRIMARY KEY (Citizen_ID, Location_ID),
    FOREIGN KEY (Citizen_ID) REFERENCES Citizen_Info(Citizen_ID) ON DELETE CASCADE,
    FOREIGN KEY (Location_ID) REFERENCES Location(Location_ID) ON DELETE CASCADE
);

INSERT INTO Citizen_Location (Citizen_ID, Location_ID)
VALUES
    ('CIT001', 1), 
    ('CIT002', 3), 
    ('CIT003', 4), 
    ('CIT004', 7),
    ('CIT005', 9), 
    ('CIT006', 5), 
    ('CIT007', 6), 
    ('CIT008', 8), 
    ('CIT009', 6), 
    ('CIT010', 6), 
	('CIT011', 6),
    ('CIT012', 6), 
    ('CIT013', 6), 
    ('CIT014', 6),
    ('CIT015', 6); 
-- Testing and debugging Purpose
SELECT CL.Citizen_ID, CI.Name, CL.Location_ID, L.Location_Name, L.Location_ID
FROM Citizen_Location CL JOIN Citizen_Info CI ON CL.Citizen_ID = CI.Citizen_ID JOIN Location L 
ON CL.Location_ID = L.Location_ID;

CREATE TABLE Weather_Condition_Data (
    Weather_ID INT PRIMARY KEY AUTO_INCREMENT,       -- Unique identifier for each weather record
    Location_ID INT NOT NULL,                        -- Foreign key linking to the Location table
    Observation_Date DATE NOT NULL,                  -- Date of the weather observation
    Temperature DECIMAL(5, 2) NOT NULL,              -- Temperature in Celsius (or desired unit)
    Humidity INT CHECK (Humidity BETWEEN 0 AND 100), -- Humidity percentage (0-100)
    Weather_Condition VARCHAR(50) CHECK (
	Weather_Condition IN ('Sunny', 'Rainy', 'Cloudy', 'Stormy', 'Snowy', 'Windy', 'Foggy')),      -- General weather description
    Wind_Speed DECIMAL(5, 2),                        -- Wind speed in km/h (or desired unit)
    Additional_Info TEXT,                            -- Additional details about the weather
    FOREIGN KEY (Location_ID) REFERENCES Location(Location_ID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
INSERT INTO Weather_Condition_Data (Location_ID, Observation_Date, Temperature, Humidity, Weather_Condition, Wind_Speed, Additional_Info)
VALUES
(1, '2024-11-29', 30.0, 75, 'Sunny', 10.0, 'Clear skies with light breeze'), -- Gulshan 1
(2, '2024-11-29', 29.5, 70, 'Cloudy', 12.5, 'Partly cloudy with comfortable weather'), -- Gulshan 2
(3, '2024-11-29', 31.2, 65, 'Sunny', 8.0, 'Warm day with no rain'), -- Banani
(4, '2024-11-29', 27.8, 80, 'Rainy', 15.0, 'Intermittent showers with high humidity'), -- Dhanmondi 27
(5, '2024-11-29', 28.0, 85, 'Rainy', 18.0, 'Heavy rains expected later in the evening'), -- Mirpur 10
(6, '2024-11-29', 26.5, 60, 'Cloudy', 10.0, 'Cool weather with overcast skies'), -- Bashundhara Residential Area
(7, '2024-11-29', 29.0, 72, 'Sunny', 14.0, 'Sunny and mild winds during the day'), -- Uttara Sector 4
(8, '2024-11-29', 32.0, 50, 'Windy', 20.0, 'Hot day with strong winds'), -- Farmgate
(9, '2024-11-29', 28.5, 78, 'Rainy', 16.5, 'Occasional rain showers with moderate winds'), -- Shyamoli
(10, '2024-11-29', 25.0, 90, 'Foggy', 5.0, 'Low visibility due to morning fog'), -- Old Dhaka
(11, '2024-11-29', 30.5, 55, 'Sunny', 12.0, 'Bright and sunny with mild humidity'); -- Tejgaon Industrial Area

CREATE TABLE Infrastructure_Maintenance (
    Maintenance_ID INT PRIMARY KEY AUTO_INCREMENT, -- Unique identifier for each maintenance record
    Location_ID INT NOT NULL, -- Foreign key referencing the Location table
    Department_ID INT,
    Maintenance_Type VARCHAR(100) NOT NULL, -- Type of maintenance (e.g., Road Repair, Utility Maintenance)
    Start_Date DATE NOT NULL, -- Start date of the maintenance work
    End_Date DATE, -- End date of the maintenance work (can be NULL if ongoing)
    Status VARCHAR(50) CHECK (Status IN ('Planned', 'Ongoing', 'Completed')) DEFAULT 'Planned', -- Status of maintenance
    Cost DECIMAL(15,2), -- Cost of maintenance (optional)
    Contractor_Name VARCHAR(100), -- Name of the contractor or company handling the maintenance
    Additional_Info TEXT, -- Any additional details about the maintenance work
    FOREIGN KEY (Location_ID) REFERENCES Location(Location_ID) ON DELETE CASCADE ON UPDATE CASCADE,
       FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID)ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Infrastructure_Maintenance (Location_ID, Maintenance_Type,Department_ID, Start_Date, End_Date, Status, Cost, Contractor_Name, Additional_Info)
VALUES
    (1, 'Road Repair', 102 , '2024-01-10', '2024-01-20', 'Completed', 500000.00, 'ABC Construction Ltd.', 'Repaved damaged road sections.'),
    (2, 'Utility Maintenance', 102 , '2024-02-01', NULL, 'Ongoing', 200000.00, 'Dhaka Power Grid Co.', 'Upgrading electrical grid systems.'),
    (3, 'Bridge Inspection',102, '2024-03-15', '2024-03-17', 'Completed', 150000.00, 'BridgeTech Engineers', 'Routine inspection of structural integrity.'),
    (4, 'Drainage System Cleanup',102, '2024-04-05', '2024-04-15', 'Completed', 100000.00, 'CityWorks Inc.', 'Cleared blockages in the drainage system.'),
    (5, 'Park Renovation', 105 , '2024-05-01', '2024-06-01', 'Planned', 300000.00, 'GreenScape Services', 'Renovating public parks and adding new amenities.'),
    (6, 'Building Demolition', 102,  '2024-06-10', NULL, 'Ongoing', 250000.00, 'SafeWreckers Co.', 'Demolishing old unsafe structures.'),
    (7, 'Roadside Tree Planting', 104 , '2024-07-15', '2024-08-15', 'Planned', 50000.00, 'EcoTree Initiative', 'Planting trees along major roads.'),
    (8, 'Sewer Line Repair', 104, '2024-08-20', '2024-09-10', 'Completed', 80000.00, 'PipeFix Ltd.', 'Fixed damaged sewer lines causing overflow.'),
    (9, 'Streetlight Installation', 105 , '2024-09-25', NULL, 'Ongoing', 120000.00, 'LightCo Electricals', 'Installing new streetlights for improved visibility.'),
    (10, 'Traffic Signal Upgrade', 110 , '2024-10-01', '2024-10-05', 'Completed', 60000.00, 'SignalTech Solutions', 'Upgraded outdated traffic lights.');

CREATE TABLE Metro_Transportation  (
    Metro_ID INT PRIMARY KEY AUTO_INCREMENT, -- Unique identifier for each maintenance record
    Route_Name VARCHAR(50) NOT NULL, 
    Start_Location_ID INT,
    End_Location_ID INT,
    Number_Of_Stations INT NOT NULL, -- Type of maintenance (e.g., Road Repair, Utility Maintenance)
    Frequency_Per_Hour INT NOT NULL, -- Start date of the maintenance work
	status ENUM('On Time', 'Delayed', 'Cancelled') DEFAULT 'On Time', 
    FOREIGN KEY (Start_Location_ID) REFERENCES Location(Location_ID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (End_Location_ID) REFERENCES Location(Location_ID)ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO Metro_Transportation(Metro_ID, Route_Name,Start_Location_ID, End_Location_ID, Frequency_Per_Hour, Number_Of_Stations,Status)
VALUES
    (1, 'Mirpur to Uttara', 5 , 7 , 1000 , 3 ,'On Time'),
	(3, 'Mirpur to Farmgate', 5 , 8 , 800 ,3,'On Time'),
    (2, 'Uttara to Old Dhaka', 7 , 10 , 1200 ,5 ,'Cancelled'),
    (4, 'Farmgate to Old Dhaka', 8 , 10 , 1300 , 2 ,'On Time'),
    (5, 'Mirpur to Shyamoli', 5 , 7 , 1000 , 1 ,'Delayed');
    
    CREATE TABLE IoT_Devices (
    Device_ID INT PRIMARY KEY AUTO_INCREMENT,
    Device_Type VARCHAR(100) NOT NULL,
    Department_ID INT NOT NULL,
    Location_ID INT NOT NULL,
    Installation_Date DATE NOT NULL,
    Device_Status VARCHAR(50) NOT NULL,
    Last_Communication_Timestamp DATETIME NOT NULL,
    Manufacturer VARCHAR(100),
    Battery_Status VARCHAR(50),
    FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID),
    FOREIGN KEY (Location_ID) REFERENCES Location(Location_ID)
);

INSERT INTO IoT_Devices (Device_Type, Department_ID, Location_ID, Installation_Date, Device_Status, Last_Communication_Timestamp, Manufacturer, Battery_Status)
VALUES
('Air Quality Sensor', 104, 11, '2023-01-15', 'Active', '2024-11-29 12:00:00', 'EnviroTech', 'Good'),
('Traffic Camera', 110, 1, '2022-10-10', 'Active', '2024-11-29 10:30:00', 'CamCorp', 'Low'),
('Smart Meter', 110, 2, '2023-03-20', 'Inactive', '2024-11-25 09:00:00', 'SmartPower', 'N/A'),
('Weather Station', 104, 4, '2022-08-05', 'Active', '2024-11-28 15:00:00', 'WeatherWorks', 'Excellent'),
('Parking Sensor', 110, 2, '2023-05-30', 'Active', '2024-11-30 08:45:00', 'ParkSense', 'Moderate'),
('Smart Light', 110, 1, '2023-06-15', 'Inactive', '2024-11-15 20:00:00', 'LumaTech', 'Dead'),
('Noise Monitor', 110, 6, '2022-11-25', 'Active', '2024-11-29 14:10:00', 'SoundTrack', 'Good'),
('Energy Monitor', 106, 8, '2023-07-10', 'Active', '2024-11-30 09:30:00', 'EcoEnergy', 'Good'),
('Flood Sensor', 104, 10, '2023-02-01', 'Inactive', '2024-11-01 07:00:00', 'FloodGuard', 'Low'),
('Surveillance Drone', 110, 11, '2023-09-25', 'Active', '2024-11-30 11:00:00', 'DroneTech', 'Full');

select*
FROM IoT_Devices;
CREATE TABLE Traffic_Data (
    Traffic_ID INT PRIMARY KEY AUTO_INCREMENT,
    Location_ID INT NOT NULL,
    Device_ID INT NOT NULL,
    Vehicle_Count INT,
    Average_Speed DECIMAL(5, 2),
    Accident_Reports INT,
    Congestion_Level VARCHAR(50),
    Timestamp DATETIME NOT NULL,
    FOREIGN KEY (Location_ID) REFERENCES Location(Location_ID),
    FOREIGN KEY (Device_ID) REFERENCES IoT_Devices(Device_ID)
);

INSERT INTO IoT_Devices (Device_Type, Department_ID, Location_ID, Installation_Date, Device_Status, Last_Communication_Timestamp, Manufacturer, Battery_Status)
VALUES
('Traffic Sensor', 103, 1, '2023-01-15', 'Active', '2024-11-01 08:00:00', 'SensorTech', 'Good'),
('Traffic Sensor', 103, 2, '2023-02-10', 'Active', '2024-11-01 09:00:00', 'SensorTech', 'Good'),
('Traffic Sensor', 103, 3, '2023-03-05', 'Active', '2024-11-01 07:45:00', 'SensorTech', 'Good'),
('Traffic Sensor', 103, 9, '2023-04-20', 'Active', '2024-11-01 10:15:00', 'SensorTech', 'Good'),
('Traffic Sensor', 103, 4, '2023-05-10', 'Active', '2024-11-01 11:00:00', 'SensorTech', 'Good'),
('Traffic Sensor', 103, 5, '2023-06-15', 'Active', '2024-11-01 06:30:00', 'SensorTech', 'Good'),
('Traffic Sensor', 103, 11, '2023-07-25', 'Active', '2024-11-01 17:00:00', 'SensorTech', 'Good'),
('Traffic Sensor', 103, 6, '2023-08-30', 'Active', '2024-11-01 12:30:00', 'SensorTech', 'Good'),
('Traffic Sensor', 103, 2, '2023-09-15', 'Active', '2024-11-01 18:45:00', 'SensorTech', 'Good'),
('Traffic Sensor', 103, 10, '2023-10-10', 'Active', '2024-11-01 05:30:00', 'SensorTech', 'Good');


INSERT INTO Traffic_Data (Location_ID, Device_ID, Vehicle_Count, Average_Speed, Accident_Reports, Congestion_Level, Timestamp)
VALUES 
(1, 20, 120, 45.5, 0, 'Low', '2024-11-01 08:30:00'),
(2, 16, 200, 30.2, 2, 'High', '2024-11-01 09:00:00'),
(3, 15, 50, 60.8, 0, 'Low', '2024-11-01 07:45:00'),
(1, 14, 180, 25.4, 3, 'High', '2024-11-01 10:15:00'),
(4, 13, 90, 40.7, 1, 'Moderate', '2024-11-01 11:00:00'),
(5, 12, 70, 55.3, 0, 'Low', '2024-11-01 06:30:00'),
(6, 11, 250, 20.0, 5, 'Severe', '2024-11-01 17:00:00'),
(3, 18, 140, 35.6, 1, 'Moderate', '2024-11-01 12:30:00'),
(2, 19, 300, 15.8, 8, 'Severe', '2024-11-01 18:45:00'),
(1, 17, 60, 50.0, 0, 'Low', '2024-11-01 05:30:00');

-- select*
-- from traffic_data;

CREATE TABLE Utility_Monitoring (
    Utility_ID INT AUTO_INCREMENT PRIMARY KEY,
    Location_ID INT NOT NULL,
    Utility_Type VARCHAR(50) NOT NULL,
    Consumption DECIMAL(10, 2) NOT NULL,
    Provider VARCHAR(100) NOT NULL,
    Timestamp DATETIME NOT NULL,
    Cost_Per_Unit DECIMAL(10, 2) NOT NULL,
    Peak_Consumption_Period VARCHAR(50),
    Device_ID INT NOT NULL,
    FOREIGN KEY (Location_ID) REFERENCES Location(Location_ID),
    FOREIGN KEY (Device_ID) REFERENCES IoT_Devices(Device_ID)
);

INSERT INTO IoT_Devices (Device_Type, Department_ID, Location_ID, Installation_Date, Device_Status, Last_Communication_Timestamp, Manufacturer, Battery_Status)
VALUES
('Sensor', 110, 1, '2023-01-01', 'Active', '2024-11-01 08:00:00', 'DeviceCorp', 'Good'),
('Meter', 110, 2, '2023-02-15', 'Active', '2024-11-01 08:15:00', 'EnergyCo', 'Good'),
('Sensor', 110, 3, '2023-03-10', 'Active', '2024-11-01 08:30:00', 'GasTech', 'Good'),
('Meter', 110, 4, '2023-04-20', 'Active', '2024-11-01 08:45:00', 'CityPower', 'Good'),
('Sensor', 110, 5, '2023-05-25', 'Active', '2024-11-01 09:00:00', 'WaterCorp', 'Good'),
('Meter', 110, 6, '2023-06-10', 'Active', '2024-11-01 09:15:00', 'GasTech', 'Good'),
('Sensor', 110, 7, '2023-07-18', 'Active', '2024-11-01 09:30:00', 'DeviceCorp', 'Good'),
('Meter', 110, 8, '2023-08-12', 'Active', '2024-11-01 09:45:00', 'EnergyCo', 'Good'),
('Sensor', 110, 9, '2023-09-05', 'Active', '2024-11-01 10:00:00', 'GasTech', 'Good'),
('Meter', 110, 1, '2023-10-01', 'Active', '2024-11-01 10:15:00', 'CityPower', 'Good');

INSERT INTO Utility_Monitoring (Location_ID, Utility_Type, Consumption, Provider, Timestamp, Cost_Per_Unit, Peak_Consumption_Period, Device_ID)
VALUES
(1, 'Electricity', 350.75, 'City Power Co.', '2024-11-01 08:30:00', 0.12, '18:00-22:00', 1),
(2, 'Water', 120.50, 'Urban Water Supply', '2024-11-01 09:00:00', 0.05, '06:00-08:00', 2),
(3, 'Gas', 220.00, 'Natural Gas Ltd.', '2024-11-01 07:45:00', 0.08, '17:00-20:00', 3),
(4, 'Electricity', 500.25, 'City Power Co.', '2024-11-01 10:15:00', 0.12, '18:00-22:00', 4),
(5, 'Water', 85.00, 'Urban Water Supply', '2024-11-01 11:00:00', 0.05, '06:00-08:00', 5),
(6, 'Gas', 300.00, 'Natural Gas Ltd.', '2024-11-01 06:30:00', 0.08, '17:00-20:00', 6),
(7, 'Electricity', 400.80, 'City Power Co.', '2024-11-01 17:00:00', 0.12, '18:00-22:00', 7),
(8, 'Water', 95.60, 'Urban Water Supply', '2024-11-01 12:30:00', 0.05, '06:00-08:00', 8),
(9, 'Gas', 310.40, 'Natural Gas Ltd.', '2024-11-01 18:45:00', 0.08, '17:00-20:00', 9),
(1, 'Electricity', 280.90, 'City Power Co.', '2024-11-01 05:30:00', 0.12, '18:00-22:00', 10);

select * 
from utility_monitoring;

