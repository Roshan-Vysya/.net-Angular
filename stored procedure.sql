---Creating Stored Procedure for inserting data
-- Insert into UserInfo
CREATE PROCEDURE InsertUserInfo
    @EmailId VARCHAR(100),
    @UserName VARCHAR(50),
    @Role VARCHAR(20),
    @Password VARCHAR(20)
AS
BEGIN
    INSERT INTO UserInfo VALUES (@EmailId, @UserName, @Role, @Password);
END;

-- Insert into EventDetails
CREATE PROCEDURE InsertEventDetails
    @EventName VARCHAR(50),
    @EventCategory VARCHAR(50),
    @EventDate DATETIME,
    @Description VARCHAR(MAX),
    @Status VARCHAR(20)
AS
BEGIN
    INSERT INTO EventDetails(EventName, EventCatagory, EventDate, Description, Status)
    VALUES (@EventName, @EventCategory, @EventDate, @Description, @Status);
END;

-- Insert into SpeakersDetails
CREATE PROCEDURE InsertSpeaker
    @SpeakerName VARCHAR(50)
AS
BEGIN
    INSERT INTO SpeakersDetails(SpeakerName) VALUES (@SpeakerName);
END;

-- Insert into SessionInfo
CREATE PROCEDURE InsertSessionInfo
    @EventId INT,
    @SessionTitle VARCHAR(50),
    @SpeakerId INT,
    @Description VARCHAR(MAX),
    @SessionStart DATETIME,
    @SessionEnd DATETIME,
    @SessionUrl VARCHAR(255)
AS
BEGIN
    INSERT INTO SessionInfo(EventId, SessionTitle, SpeakerId, Description, SessionStart, SessionEnd, SessionUrl)
    VALUES (@EventId, @SessionTitle, @SpeakerId, @Description, @SessionStart, @SessionEnd, @SessionUrl);
END;

-- Insert into ParticipantEventDetails
CREATE PROCEDURE InsertParticipantEvent
    @ParticipantEmailId VARCHAR(100),
    @EventId INT,
    @SessionId INT,
    @IsAttended BIT
AS
BEGIN
    INSERT INTO ParticipantEventDetails(ParticipantEmailId, EventId, SessionId, IsAttended)
    VALUES (@ParticipantEmailId, @EventId, @SessionId, @IsAttended);
END;

--Stored procedure for deleting Data
-- Delete User
CREATE PROCEDURE DeleteUserInfo
    @EmailId VARCHAR(100)
AS
BEGIN
    DELETE FROM UserInfo WHERE EmailId = @EmailId;
END;

-- Delete Event
CREATE PROCEDURE DeleteEvent
    @EventId INT
AS
BEGIN
    DELETE FROM EventDetails WHERE EventId = @EventId;
END;

-- Delete Speaker
CREATE PROCEDURE DeleteSpeaker
    @SpeakerId INT
AS
BEGIN
    DELETE FROM SpeakersDetails WHERE SpeakerId = @SpeakerId;
END;

-- Delete Session
CREATE PROCEDURE DeleteSession
    @SessionId INT
AS
BEGIN
    DELETE FROM SessionInfo WHERE SessionId = @SessionId;
END;

-- Delete ParticipantEvent
CREATE PROCEDURE DeleteParticipantEvent
    @Id INT
AS
BEGIN
    DELETE FROM ParticipantEventDetails WHERE Id = @Id;
END;


--3.StoredProcedure to Update Data
-- Update User
CREATE PROCEDURE UpdateUserInfo
    @EmailId VARCHAR(100),
    @UserName VARCHAR(50),
    @Role VARCHAR(20),
    @Password VARCHAR(20)
AS
BEGIN
    UPDATE UserInfo
    SET UserName = @UserName, Role = @Role, Password = @Password
    WHERE EmailId = @EmailId;
END;

-- Update Event
CREATE PROCEDURE UpdateEvent
    @EventId INT,
    @EventName VARCHAR(50),
    @EventCatagory VARCHAR(50),
    @EventDate DATETIME,
    @Description VARCHAR(MAX),
    @Status VARCHAR(20)
AS
BEGIN
    UPDATE EventDetails
    SET EventName = @EventName, EventCatagory = @EventCatagory, EventDate = @EventDate,
        Description = @Description, Status = @Status
    WHERE EventId = @EventId;
END;

-- Update Speaker
CREATE PROCEDURE UpdateSpeaker
    @SpeakerId INT,
    @SpeakerName VARCHAR(50)
AS
BEGIN
    UPDATE SpeakersDetails SET SpeakerName = @SpeakerName WHERE SpeakerId = @SpeakerId;
END;

-- Update Session
CREATE PROCEDURE UpdateSession
    @SessionId INT,
    @EventId INT,
    @SessionTitle VARCHAR(50),
    @SpeakerId INT,
    @Description VARCHAR(MAX),
    @SessionStart DATETIME,
    @SessionEnd DATETIME,
    @SessionUrl VARCHAR(255)
AS
BEGIN
    UPDATE SessionInfo
    SET EventId = @EventId, SessionTitle = @SessionTitle, SpeakerId = @SpeakerId,
        Description = @Description, SessionStart = @SessionStart, SessionEnd = @SessionEnd,
        SessionUrl = @SessionUrl
    WHERE SessionId = @SessionId;
END;

-- Update Participant Event
CREATE PROCEDURE UpdateParticipantEvent
    @Id INT,
    @ParticipantEmailId VARCHAR(100),
    @EventId INT,
    @SessionId INT,
    @IsAttended BIT
AS
BEGIN
    UPDATE ParticipantEventDetails
    SET ParticipantEmailId = @ParticipantEmailId, EventId = @EventId,
        SessionId = @SessionId, IsAttended = @IsAttended
    WHERE Id = @Id;
END;

--4.Create a view to show session details of the particular event. 
CREATE VIEW View_SessionDetails_ByEvent
AS
SELECT s.SessionId, s.SessionTitle, s.SessionStart, s.SessionEnd, s.SessionUrl,
       s.Description AS SessionDescription, e.EventName, e.EventDate
FROM SessionInfo s
JOIN EventDetails e ON s.EventId = e.EventId;

CREATE OR ALTER VIEW View_SessionDetails_ByEvent
AS
SELECT 
    s.SessionId, 
    s.SessionTitle, 
    s.SessionStart, 
    s.SessionEnd, 
    s.SessionUrl,
    s.Description AS SessionDescription, 
    e.EventId,                  
    e.EventName, 
    e.EventDate
FROM SessionInfo s
JOIN EventDetails e ON s.EventId = e.EventId;

--5..Create a view to show speaker detail of particular session. 
CREATE VIEW View_SpeakerDetails_BySession
AS
SELECT s.SessionId, s.SessionTitle, sp.SpeakerId, sp.SpeakerName
FROM SessionInfo s
JOIN SpeakersDetails sp ON s.SpeakerId = sp.SpeakerId;


--6 create a view with all details in evendb
CREATE VIEW View_CompleteEventDetails
AS
SELECT 
    e.EventId, e.EventName, e.EventCatagory, e.EventDate, e.Status,
    s.SessionId, s.SessionTitle, s.SessionStart, s.SessionEnd, s.SessionUrl,
    sp.SpeakerId, sp.SpeakerName,
    p.Id AS ParticipantEventId, p.ParticipantEmailId, p.IsAttended
FROM EventDetails e
LEFT JOIN SessionInfo s ON e.EventId = s.EventId
LEFT JOIN SpeakersDetails sp ON s.SpeakerId = sp.SpeakerId
LEFT JOIN ParticipantEventDetails p ON s.SessionId = p.SessionId;


--7.Apply non-clustered indexes to tables by choosing appropriate columns.	

-- On UserInfo Role
CREATE NONCLUSTERED INDEX IX_UserInfo_Role ON UserInfo(Role);

-- On EventDetails Status
CREATE NONCLUSTERED INDEX IX_EventDetails_Status ON EventDetails(Status);

-- On SessionInfo EventId
CREATE NONCLUSTERED INDEX IX_SessionInfo_EventId ON SessionInfo(EventId);

-- On ParticipantEventDetails ParticipantEmailId
CREATE NONCLUSTERED INDEX IX_ParticipantEvent_Email ON ParticipantEventDetails(ParticipantEmailId);

-- On SpeakersDetails SpeakerName
CREATE NONCLUSTERED INDEX IX_SpeakersDetails_Name ON SpeakersDetails(SpeakerName);