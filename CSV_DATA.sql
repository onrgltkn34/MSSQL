DECLARE @CSVDATA TABLE ( 
						MNO INT IDENTITY (1,1) 
						,NAME VARCHAR (250)
						,TARIH DATE
						)


DECLARE @DATA NVARCHAR(MAX)=
'HAYDAR;01/01/2005
ALI;11/12/2006
MEHMET;16/05/2009
SERKAN;01/04/2010
MEHMET;17/07/2011
AHMET;7/09/2008'

declare @start int = 1
declare @index int = CHARINDEX( char(13),@DATA, @start )

Declare @Data_Enter varchar(250) =substring ( @DATA,1, (CHARINDEX (char(13),@DATA) -1))
Declare @Data_NoktaVirgul varchar(250) = substring ( @DATA,1, (CHARINDEX (';',@Data_Enter)-1))
Declare @Data_Devami varchar(50) = substring ( @DATA,(CHARINDEX (';',@Data_Enter)+1), LEN (@Data_Enter) -CHARINDEX (';',@Data_Enter))



INSERT INTO @CSVDATA (NAME, TARIH)
SELECT  @Data_NoktaVirgul as NAME
		,CONVERT(date,RTRIM(@Data_Devami),103)
		


while @index > 0
begin

	SET @Data_Enter =substring (@DATA,@index, LEN (@DATA))
	SET @Data_NoktaVirgul  = substring ( @DATA,@index, (CHARINDEX (';',@Data_Enter)-1))
	SET @Data_Devami = substring ( @Data_Enter,(CHARINDEX (';',@Data_Enter)+1), 10)

	INSERT INTO @CSVDATA (NAME, TARIH)
	SELECT  REPLACE (REPLACE(@Data_NoktaVirgul,char(13),''), char(10),'') as NAME
			, CONVERT(date,RTRIM(@Data_Devami),103)
			--, substring ( @Data_Enter,7, 10)
			--,CHARINDEX (';',@Data_Enter)+1
			
				

	set @index = CHARINDEX( char(13),@DATA, @index +1)

end




SELECT *  FROM @CSVDATA










