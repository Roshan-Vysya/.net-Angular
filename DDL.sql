--1.Creating the Database--
CREATE DATABASE EventDB
  
Use EventDB

--2.Creating UserInfo Table--
CREATE TABLE UserInfo (
    EmailId VARCHAR(100) PRIMARY KEY,
    UserName VARCHAR(50) NOT NULL CHECK (LEN(UserName) BETWEEN 1 AND 50),
    Role VARCHAR(20) NOT NULL CHECK (Role IN ('Admin', 'Participant')),
    Password VARCHAR(20) NOT NULL CHECK (LEN(Password) BETWEEN 6 AND 20)
);	
--3.Event Details--
CREATE TABLE EventDetails(
    EventId INT PRIMARY KEY,
	EventName VARCHAR(100)Not Null CHECK(LEN(EventName) Between 1 and 50),
	EventCatagory VARCHAR(100)Not Null CHECK(LEN(EventCatagory) Between 1 and 50),
	EventDate DATETIME NOT NULL,
    Description VARCHAR(MAX) NULL,
    Status VARCHAR(20) CHECK (Status IN ('Active', 'In-Active'))

);

--4.Speaker Details--
CREATE TABLE SpeakersDetails(
	SpeakerId INT Primary Key,
	SpeakerName VARCHAR(100) not null CHECK(LEN(SpeakerName) Between 1 and 50),
);
-- Step 5: Create SessionInfo Table--
CREATE TABLE SessionInfo (
    SessionId INT PRIMARY KEY,
    EventId INT NOT NULL,
    SessionTitle VARCHAR(50) NOT NULL CHECK (LEN(SessionTitle) BETWEEN 1 AND 50),
    SpeakerId INT NOT NULL,
    Description VARCHAR(MAX) NULL,
    SessionStart DATETIME NOT NULL,
    SessionEnd DATETIME NOT NULL,
    SessionUrl VARCHAR(255),
    FOREIGN KEY (EventId) REFERENCES EventDetails(EventId),
    FOREIGN KEY (SpeakerId) REFERENCES SpeakersDetails(SpeakerId)
);

-- Step 6: Create ParticipantEventDetails Table--
CREATE TABLE ParticipantEventDetails (
    Id INT PRIMARY KEY,
    ParticipantEmailId VARCHAR(100) NOT NULL,
    EventId INT NOT NULL,
    SessionId INT NOT NULL,
    IsAttended BIT CHECK (IsAttended IN (0, 1)),
    FOREIGN KEY (ParticipantEmailId) REFERENCES UserInfo(EmailId),
    FOREIGN KEY (EventId) REFERENCES EventDetails(EventId),
    FOREIGN KEY (SessionId) REFERENCES SessionInfo(SessionId)
);