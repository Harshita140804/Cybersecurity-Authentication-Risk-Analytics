CREATE DATABASE cybersecurity_risk_analytics;

USE cybersecurity_risk_analytics;
SELECT *
FROM authentication_events
LIMIT 10;

SELECT COUNT(*) AS Total_Events
FROM authentication_events;

-- Overall Authentication Summary
SELECT 
    COUNT(*) AS Total_Authentication_Events,
    SUM(Login_Status = 'Success') AS Successful_Logins,
    SUM(Login_Status = 'Failed') AS Failed_Logins,
    ROUND(
        SUM(Login_Status = 'Failed') * 100.0 / COUNT(*),
        2
    ) AS Failure_Rate_Percentage
FROM authentication_events;

-- Risk Level Distribution
SELECT 
    Risk_Level,
    COUNT(*) AS Event_Count,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM authentication_events),
        2
    ) AS Percentage
FROM authentication_events
GROUP BY Risk_Level
ORDER BY 
    CASE Risk_Level
        WHEN 'Low' THEN 1
        WHEN 'Medium' THEN 2
        WHEN 'High' THEN 3
        WHEN 'Critical' THEN 4
    END;
    
    -- Top Users with Failed Login Attempts
 SELECT 
    User_ID,
    Username,
    COUNT(*) AS Failed_Login_Count
FROM authentication_events
WHERE Login_Status = 'Failed'
GROUP BY User_ID, Username
ORDER BY Failed_Login_Count DESC
LIMIT 10;   

-- Most Suspicious IP Addresses
SELECT 
    IP_Address,
    COUNT(*) AS Failed_Login_Count,
    COUNT(DISTINCT User_ID) AS Unique_Users
FROM authentication_events
WHERE Login_Status = 'Failed'
GROUP BY IP_Address
ORDER BY Failed_Login_Count DESC
LIMIT 10;


-- High and Critical Risk Events
SELECT 
    Event_ID,
    User_ID,
    IP_Address,
    Location,
    Device_Type,
    Login_Status,
    Risk_Score,
    Risk_Level
FROM authentication_events
WHERE Risk_Level IN ('High', 'Critical')
ORDER BY Risk_Score DESC;

-- Authentication Risk by Device
SELECT 
    Device_Type,
    COUNT(*) AS Total_Events,
    SUM(Login_Status = 'Failed') AS Failed_Logins,
    ROUND(
        SUM(Login_Status = 'Failed') * 100.0 / COUNT(*),
        2
    ) AS Failure_Rate_Percentage,
    SUM(Risk_Level IN ('High', 'Critical')) AS High_Risk_Events
FROM authentication_events
GROUP BY Device_Type
ORDER BY Failure_Rate_Percentage DESC;


-- Authentication Risk by Location-- 
SELECT 
    Location,
    Country,
    COUNT(*) AS Total_Events,
    SUM(Login_Status = 'Failed') AS Failed_Logins,
    SUM(Risk_Level IN ('High', 'Critical')) AS High_Risk_Events
FROM authentication_events
GROUP BY Location, Country
ORDER BY High_Risk_Events DESC
LIMIT 15;

-- Night vs Non-Night Activity
SELECT 
    Is_Night_Login,
    COUNT(*) AS Total_Events,
    SUM(Login_Status = 'Failed') AS Failed_Logins,
    SUM(Risk_Level IN ('High', 'Critical')) AS High_Risk_Events
FROM authentication_events
GROUP BY Is_Night_Login;


-- Authentication Method Analysis
SELECT 
    Authentication_Method,
    COUNT(*) AS Total_Events,
    SUM(Login_Status = 'Failed') AS Failed_Logins,
    ROUND(
        SUM(Login_Status = 'Failed') * 100.0 / COUNT(*),
        2
    ) AS Failure_Rate_Percentage
FROM authentication_events
GROUP BY Authentication_Method
ORDER BY Failure_Rate_Percentage DESC;

-- Critical Events Investigation
SELECT 
    Event_ID,
    Timestamp,
    User_ID,
    Username,
    IP_Address,
    Location,
    Device_Type,
    Login_Status,
    User_Failed_Login_Count,
    IP_Failed_Login_Count,
    Users_Per_IP,
    Locations_Per_User,
    Account_Status,
    Risk_Score
FROM authentication_events
WHERE Risk_Level = 'Critical'
ORDER BY Risk_Score DESC;



