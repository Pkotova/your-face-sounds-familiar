-- Scalar function for Participant - returns the name of the participant by ID
SET SCHEMA FN71866;

CREATE FUNCTION GET_PERSON_NAME(V_ID INTEGER)
RETURNS VARCHAR(64)
SPECIFIC GET_PERSON_NAME
BEGIN ATOMIC
    DECLARE V_PERSON_NAME VARCHAR(64);
    DECLARE V_ERR VARCHAR(70);
    SET V_PERSON_NAME=( SELECT NAME FROM PEOPLE WHERE PERSON_ID = V_ID);
    SET V_ERR = 'ERROR: PERSON' || V_ID || 'WAS NOT FOUND';
    IF V_PERSON_NAME IS NULL THEN SIGNAL SQLSTATE '80000' SET MESSAGE_TEXT = V_ERR;
    END IF;
RETURN V_PERSON_NAME;
END;

-- Call the function
VALUES FN71866.GET_PERSON_NAME(10);
VALUES FN71866.GET_PERSON_NAME(100);
VALUES FN71866.GET_PERSON_NAME(60);
---------------------------------------------------------------------------
-- Table function for Seasons and People - returns table (winners)
CREATE FUNCTION SEASON_INFO()
RETURNS TABLE
    (TV_CHANEL VARCHAR(30),
     FINAL_DATE DATE,
     AWARD       VARCHAR(32),
     WINNER      INTEGER,
     WINNER_NAME VARCHAR(64)
    )
SPECIFIC SEASON_INFO
RETURN
    SELECT SEASONS.TV_CHANEL, SEASONS.FINAL_DATE, SEASONS.AWARD, PEOPLE.PERSON_ID, PEOPLE.NAME
    FROM SEASONS, PEOPLE
    WHERE WINNER_ID = PERSON_ID;

-- Call the function
SELECT *
FROM TABLE(FN71866.SEASON_INFO()) T;
----------------------------------------------------------------------------
CREATE FUNCTION GET_PARTICIPANT_POINTS(V_ID INTEGER)
RETURNS VARCHAR(64)
SPECIFIC GET_PARTICIPANT_POINTS
BEGIN ATOMIC
    DECLARE V_PARTICIPANT_POINTS INTEGER;
    DECLARE V_ERR VARCHAR(70);
    SET V_PARTICIPANT_POINTS=( SELECT SUM_POINTS FROM PARTICIPANTS WHERE PARTICIPANT_ID = V_ID);
    SET V_ERR = 'ERROR: PERSON' || V_ID || 'WAS NOT FOUND';
    IF V_PARTICIPANT_POINTS IS NULL THEN SIGNAL SQLSTATE '80000' SET MESSAGE_TEXT = V_ERR;
    END IF;
RETURN V_PARTICIPANT_POINTS;
END;

VALUES FN71866.GET_PARTICIPANT_POINTS(10); -- 62
---------------------------------------------------------------------------

--  FUNCTION THAT RETURNS INTEGER
CREATE FUNCTION GET_PERSON_ID(V_NAME VARCHAR(64))
RETURNS INTEGER
RETURN
    SELECT PEOPLE.PERSON_ID
    FROM PEOPLE
    WHERE V_NAME = PEOPLE.NAME;

VALUES FN71866.GET_PERSON_ID('Luna Yordanova');
--------------------------------------------------------------------------
-- FUNCTION THAT RETURNS TABLE
CREATE FUNCTION PARTICIPANTS_INFO(V_ID INTEGER)
RETURNS TABLE
    (NAME VARCHAR(64),
    SEASON_ID INTEGER,
    AGE INTEGER)
RETURN
    SELECT PEOPLE.NAME, PARTICIPATE_IN.SEASON_ID, PEOPLE.AGE
    FROM PARTICIPATE_IN, PEOPLE, PARTICIPANTS
    WHERE PARTICIPATE_IN.PERSON_ID = V_ID AND V_ID = PARTICIPANTS.PARTICIPANT_ID AND PEOPLE.PERSON_ID = V_ID;

SELECT *
FROM TABLE(FN71866.PARTICIPANTS_INFO(15)) T;
----------------------------------------------------------------------

-- function
CREATE FUNCTION GET_PERSON_AGE(V_NAME VARCHAR(64))
RETURNS INTEGER
SPECIFIC GET_PERSON_AGE
RETURN
    SELECT PEOPLE.AGE
    FROM PEOPLE
    WHERE V_NAME = PEOPLE.NAME;

VALUES FN71866.GET_PERSON_AGE('Ivo Tanev');
-----------------------------------------------------------------------
--scalar function
CREATE FUNCTION GET_SECOND_IMPRESSION(V_ID INTEGER)
RETURNS VARCHAR(64)
SPECIFIC GET_SECOND_IMPRESSION
BEGIN ATOMIC
    DECLARE V_SINGER_NAME VARCHAR(64);
    DECLARE V_ERR VARCHAR(70);
    SET V_SINGER_NAME=( SELECT SINGER_NAME FROM GENERATED_IMPRESSION WHERE PARTICIPANT_ID = V_ID AND EPISODE_ID = 2);
    SET V_ERR = 'ERROR: PARTICIPANT ' || V_ID || ' WAS NOT FOUND';
    IF V_SINGER_NAME IS NULL THEN SIGNAL SQLSTATE '80000' SET MESSAGE_TEXT = V_ERR;
    END IF;
RETURN V_SINGER_NAME;
END;
--
VALUES FN71866.GET_SECOND_IMPRESSION(10);
VALUES FN71866.GET_SECOND_IMPRESSION(4);
----------------------------------------------------------------------
--table function
CREATE FUNCTION JUDGE_INFO(P_ID INTEGER)
RETURNS TABLE
    (
     SEASON_ID INTEGER,
     JUDGE_ID INTEGER,
	 NAME VARCHAR(64),
	 AGE INTEGER,
	 JOB VARCHAR(32)
    )
SPECIFIC JUDGE_INFO
RETURN
    SELECT PARTICIPATE_IN.SEASON_ID,JUDGES.JUDGE_ID,PEOPLE.NAME,PEOPLE.AGE,PEOPLE.JOB
    FROM JUDGES,PEOPLE,PARTICIPATE_IN
    WHERE JUDGE_ID = P_ID AND PEOPLE.PERSON_ID = JUDGE_ID AND PARTICIPATE_IN.PERSON_ID = P_ID;
--
SELECT *
FROM TABLE(FN71866.JUDGE_INFO(71)) T;
--------------------------------------------------------------
CREATE FUNCTION GET_SONG_ARTIST(S_NAME VARCHAR(64))
RETURNS VARCHAR(64)
SPECIFIC GET_SONG_ARTIST
BEGIN ATOMIC
    DECLARE V_SINGR_NAME VARCHAR(64);
    DECLARE V_ERR VARCHAR(70);
    SET V_SINGR_NAME=( SELECT GI.SINGER_NAME FROM GENERATED_IMPRESSION AS GI WHERE GI.SONS_NAME = S_NAME);
    SET V_ERR = 'ERROR: SONG ' || S_NAME || ' WAS NOT FOUND';
    IF V_SINGR_NAME IS NULL THEN SIGNAL SQLSTATE '80000' SET MESSAGE_TEXT = V_ERR;
    END IF;
RETURN V_SINGR_NAME;
END;

VALUES FN71866.GET_SONG_ARTIST('Sbogom Moya Lubov');
VALUES FN71866.GET_SONG_ARTIST('Diamonds');
--