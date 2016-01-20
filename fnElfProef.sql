if object_id('fnElfProef') is not NULL
   DROP FUNCTION fnElfProef

GO 
CREATE FUNCTION fnElfProef (@strBsn varchar(25))
    RETURNS BIT
AS
BEGIN
    DECLARE @intBSNlengte AS int
		, @intTeller AS int
		, @intTeller2 AS int
		, @intSom AS bigint
		, @numControleSom numeric(18,6)
		, @bsnBigInt AS bigint

		IF ISNUMERIC(@strBsn) = 0 OR LEN(@strBsn) > 18 
		BEGIN
			return 0
		END

		IF (CAST(@strBsn AS bigint) = 0)
		BEGIN
			return 0
		END
						
		SET  @intBSNlengte = LEN(@strBSN)

		SET  @intTeller2 = @intBSNlengte SET  @intTeller = 1 SET  @intSom = 0

		WHILE   @intTeller <= @intBSNlengte
		BEGIN
		SET @intSom = ( CONVERT(bigint, SUBSTRING(@strBSN, @intTeller, 1))
		* CASE WHEN @intTeller2 = 1
		THEN -1
		ELSE @intTeller2
		END
		)
		+ @intSom
		SET @intTeller = @intTeller+1
		SET @intTeller2 = @intTeller2-1
		END

		SET  @numControleSom = CONVERT(numeric(18,6), @intSom)
		/CONVERT(numeric(18,6), 11)

		IF     FLOOR(@numControleSom) = CEILING(@numControleSom)
		AND @intBSNlengte IN (8,9)
		BEGIN
			return 1
		END
		return 0
END

GO

select * from aspnet_Users u
where dbo.fnElfProef(u.UserName)=1