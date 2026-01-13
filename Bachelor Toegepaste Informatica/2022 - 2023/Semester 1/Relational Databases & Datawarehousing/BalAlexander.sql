-- Bal Alexander - 10/01/2023 - TIATP/S1

-- 1.
SELECT p.fullName, t.primaryTitle, t.startYear FROM persons p JOIN actors a ON p.nmconst=a.nmconst
JOIN titles t ON a.tconst=t.tconst WHERE t.titleType='movie' AND t.startYear = (SELECT MIN(t2.startYear) from persons p2 JOIN actors a2 ON p2.nmconst=a2.nmconst
JOIN titles t2 ON a2.tconst=t2.tconst WHERE p.fullName=p2.fullName)

-- 2.
CREATE OR ALTER PROCEDURE UpdateDeathYear @CURRENTYEAR INT, @BIRTHYEAR INT, @DEATHYEAR INT, @FULLNAME NVARCHAR(90)
AS
BEGIN
	IF @DEATHYEAR < @BIRTHYEAR
	BEGIN
		RAISERROR('DeathYear kan niet lager zijn dan het BirthYear', 18, 1)
		END
	ELSE IF @DEATHYEAR > @CURRENTYEAR
	BEGIN
		RAISERROR('DeathYear kan niet groter zijn dan het huidige jaar', 18, 2)
		END
	ELSE 
	BEGIN
		UPDATE persons SET deathYear=@DEATHYEAR WHERE fullName=@FULLNAME
		END
END

BEGIN TRANSACTION
DECLARE @BIRTHYEAR2 INT
SET @BIRTHYEAR2 = (SELECT birthYear FROM persons WHERE fullName='George Clooney')
EXEC UpdateDeathYear 2023, @BIRTHYEAR2, 1962, 'George Clooney' 
SELECT * FROM persons WHERE fullName='George Clooney'
ROLLBACK;

-- 3.
CREATE OR ALTER PROCEDURE Top3Movies @YEAR INT
AS
BEGIN
	declare @genre NVARCHAR(60)
	DECLARE GenresCursor CURSOR FOR SELECT genre FROM genres order by genre ASC

	OPEN GenresCursor

	FETCH NEXT FROM GenresCursor INTO @genre
	WHILE @@FETCH_STATUS = 0 
	BEGIN 
		PRINT 'Genre: ' + str(@genre)

		declare @numVotes INT, @primaryTitle nvarchar(500)
		DECLARE MovieCursor CURSOR FOR 
		SELECT TOP(3) t.primaryTitle, numVotes FROM titles t JOIN genres g ON t.tconst=g.tconst JOIN ratings r ON t.tconst=r.tconst WHERE g.genre=@genre AND t.startYear=@YEAR

		OPEN MovieCursor
		FETCH NEXT FROM MovieCursor INTO @primaryTitle, @numVotes
		WHILE @@FETCH_STATUS = 0 
		BEGIN
			PRINT '- ' + str(@primaryTitle) + ' number of votes = ' + str(@numVotes)
		END

		CLOSE MovieCursor
		DEALLOCATE MovieCursor
	END

	CLOSE GenresCursor
	DEALLOCATE GenresCursor
END

BEGIN TRANSACTION
 EXEC Top3Movies 2010
ROLLBACK;

-- 4. 
SELECT startYear, DENSE_RANK() AS ranking, primaryTitle, averageRating FROM 