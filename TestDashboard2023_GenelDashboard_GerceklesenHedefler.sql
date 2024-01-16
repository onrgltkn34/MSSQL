USE [egeyapi_MSCRM]
GO

/****** Object:  StoredProcedure [dbo].[TestDashboard2023_GenelDashboard_GerceklesenHedefler]    Script Date: 27.02.2023 11:04:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Onur Gültekin
-- Create date: 04.01.2023
-- Description:	Gerçekleþen Hedefler
-- =============================================

-- =============================================
-- Author:		Onur Gültekin
-- Update date: 14.02.2023
-- Description:	Genel Dashboard tüm gerçekleþen hedefler.  [TestDashboard2023_GerceklesenHedefler] spsinden beslenir.
-- =============================================
CREATE PROCEDURE [dbo].[TestDashboard2023_GenelDashboard_GerceklesenHedefler] 	
	@TargetName varchar(50) = null
AS
BEGIN TRY
	SET NOCOUNT ON;

/*
361D6FC3-22A7-EB11-844C-000C292E580F	MODERNYAKA
9F2C9D29-59D6-E611-80FE-3417EBEAECF3	CER ÝSTANBUL
0C13E4A5-F358-EC11-85A7-000C292E580F	EGE YAPI KEKLÝKTEPE
B94D6764-1D20-EB11-82A7-000C292E580F	THE SUPERIOR SUITES
BE547B6F-B78F-E611-80D2-3417EBEAECF3	KORDON ÝSTANBUL
7265A677-66AA-E611-80E6-3417EBEAECF3	ÇAMLIYAKA KONAKLARI
DE4F981E-27F1-EB11-853A-000C292E580F	RADISSON BLU
6DBEF3E5-AB69-E611-80C3-44A8424333CE	ÝZPARK
180B685D-2BCC-EA11-8199-000C292E5819	ÝZTOWER
977840DF-AB69-E611-80C3-44A8424333CE	PEGA KARTAL
400FEA5E-4320-E711-8103-3417EBEAECF3	BATIÞEHÝR
*/

--Declare @ProjeId varchar(50)= '361D6FC3-22A7-EB11-844C-000C292E580F'
--		,@SubjectName varchar(50) = null
IF OBJECT_ID('tempdb..#tmp_projects') IS NOT NULL DROP TABLE #tmp_projects
IF OBJECT_ID('tempdb..#tmp_Container') IS NOT NULL DROP TABLE #tmp_Container

Declare @Target_Year int ,@x int =1 ,@Year varchar(4) ='2023'

Set @Target_Year = (select sm.AttributeValue from StringMapBase (nolock) sm where sm.AttributeName = 'new_hedefyil' and sm.Value = @Year)


Create table #tmp_projects
(
	Sira int IDENTITY(1,1)
	,ProjeName varchar(100)
	,ProjeId varchar(100)
)

insert into #tmp_projects (ProjeName, ProjeId)
select new_projeidName
		,new_projeid
from new_satishedef (nolock) 
where new_hedefyil = @Target_Year
	and new_projeidName not in ('RADISSON BLU')
group by new_projeid, new_projeidName


Create table #tmp_Container
(
    HedefTipi varchar(50)
	,OCAK float
	,SUBAT float
	,MART float
	,NISAN float
	,MAYIS float
	,HAZIRAN float
	,TEMMUZ float
	,AGUSTOS float
	,EYLUL float
	,EKIM float
	,KASIM float
	,ARALIK float
	,TOPLAMHEDEF float
	,FLAG int
)

Declare @ProjeID varchar(100)
while @x < (select COUNT(*)+1 from #tmp_projects)
BEGIN
		Set @ProjeID = (select ProjeId from #tmp_projects where Sira = @x)
		
		insert into #tmp_Container (HedefTipi, OCAK, SUBAT, MART, NISAN, MAYIS, HAZIRAN, TEMMUZ, AGUSTOS, EYLUL, EKIM, KASIM, ARALIK, TOPLAMHEDEF, FLAG)
		EXEC	[dbo].[TestDashboard2023_GerceklesenHedefler]	@ProjeID
		
		Set @x = @x + 1
END


declare @Count int
Set @Count = (select COUNT(*) from #tmp_Container t where t.HedefTipi = ISNULL(@TargetName,t.HedefTipi))


IF @Count >0
BEGIN
		select HedefTipi
				,Sum(OCAK) as OCAK
				,Sum(SUBAT) as SUBAT
				,Sum(MART) as MART
				,Sum(NISAN) as NISAN
				,Sum(MAYIS) as MAYIS
				,Sum(HAZIRAN) as HAZIRAN
				,Sum(TEMMUZ) as TEMMUZ
				,Sum(AGUSTOS) as AGUSTOS
				,Sum(EYLUL) as EYLUL
				,Sum(EKIM) as EKIM
				,Sum(KASIM) as KASIM
				,Sum(ARALIK) as ARALIK
				,Sum(TOPLAMHEDEF) as TOPLAMHEDEF
		from #tmp_Container
		where HedefTipi = ISNULL (@TargetName, HedefTipi)
		group by HedefTipi
END
ELSE
BEGIN
SELECT   ISNULL(@TargetName,'')  as HedefTipi
		, 0 as [OCAK]
		, 0 as [SUBAT] 
		, 0 as [MART]
		, 0 as [NISAN]
		, 0 as [MAYIS]
		, 0 as [HAZIRAN]
		, 0 as [TEMMUZ]
		, 0 as [AGUSTOS]
		, 0 as [EYLUL]
		, 0 as [EKIM]
		, 0 as [KASIM]
		, 0 as [ARALIK]
		, 0 as [TOPLAMHEDEF]
		, 2 as FLAG
END


END TRY
BEGIN CATCH
		DECLARE @Body VARCHAR(Max)
		SET @Body = '
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-9" />
			<meta http-equiv="content-language" content="TR" />
		</head>
		<body>
			<table cellpadding="0" cellspacing="0" bgcolor="#f3f3f3" width="1400"> 
				<tr>
					<td>TestDashboard2023_GenelDashboard_GerceklesenHedefler</td>
				</tr>
				<tr>
					<td>'
						+'ErrorNumber: ' + (SELECT CAST(ERROR_NUMBER() as varchar(50))) +'</br>'
						+'ErrorSeverity: ' + (SELECT CAST(ERROR_SEVERITY() as varchar(50))) +'</br>'
						+'ErrorState: ' + (SELECT CAST(ERROR_STATE() as varchar(50))) +'</br>'
						+'ErrorLine: ' + (SELECT CAST(ERROR_LINE() as varchar(50))) +'</br>'
						+'ErrorMessage: ' + (CAST(ERROR_MESSAGE() as varchar(500))) +'</br>
					</td>
				</tr>
			</table>
			</table>        
		  </body>
		</html>'

		--SELECT  CAST(ERROR_NUMBER() as varchar(50)) AS ErrorNumber  
		--		,CAST(ERROR_SEVERITY() as varchar(50)) AS ErrorSeverity  
		--		,CAST(ERROR_STATE() as varchar(50)) AS ErrorState  
		--		,CAST(ERROR_LINE() as varchar(50)) AS ErrorLine  
		--		,CAST(ERROR_MESSAGE() as varchar(500)) AS ErrorMessage; 

		EXEC msdb..sp_send_dbmail @profile_name = 'EgeYapi', @recipients = 'onur.gultekin@egeyapi.com', @subject = 'TestDashboard2023_GenelDashboard_GerceklesenHedefler SPsinde ERROR', @body = @Body, @body_format='HTML'
END CATCH

GO


