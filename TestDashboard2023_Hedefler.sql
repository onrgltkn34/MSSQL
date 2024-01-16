USE [egeyapi_MSCRM]
GO

/****** Object:  StoredProcedure [dbo].[TestDashboard2023_Hedefler]    Script Date: 27.02.2023 11:03:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Onur Gültekin
-- Create date: 03.01.2023
-- Description:	Satýs Hedefleri Entitysinden bilgileri alýr. 
-- =============================================
CREATE PROCEDURE [dbo].[TestDashboard2023_Hedefler]
	@ProjeId varchar(50),
	@TargetName varchar(50) =null
	
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

Declare @Year varchar(4) = '2023'

Declare @Count int = (select count(*) 
							from new_satishedef  (nolock) sh 
							where (select top 1 sm.Value from StringMapBase (nolock) sm where sm.AttributeName = 'new_hedeftip' and sm.AttributeValue = sh.new_hedeftip) 
									= 
								  Isnull(@TargetName , (select top 1 sm.Value from StringMapBase (nolock) sm where sm.AttributeName = 'new_hedeftip' and sm.AttributeValue = sh.new_hedeftip))
								and	sh.statecode = 0
								and sh.new_projeid = @ProjeId 
								and  sh.new_HedefYil = (Case @Year 
															when '2022' then '100000000'
															when '2023' then '100000001'
															when '2024' then '100000002'
														End)
					   )

IF (@Count) > 0
BEGIN
   select 	(select top 1 sm.Value from StringMapBase (nolock) sm where sm.AttributeName = 'new_hedeftip' and sm.AttributeValue = sh.new_hedeftip) as HedefTipi 
		,cast(sh.new_ocak as float) as OCAK
		,cast(sh.new_subat as float) as SUBAT
		,cast(sh.new_mart as float) as MART
		,cast(sh.new_nisan as float) as NISAN
		,cast(sh.new_mayis as float) as MAYIS
		,cast(sh.new_haziran as float) as HAZIRAN
		,cast(sh.new_temmuz as float) as TEMMUZ
		,cast(sh.new_agustos as float) as AGUSTOS
		,cast(sh.new_eylul as float) as EYLUL
		,cast(sh.new_ekim as float) as EKIM
		,cast(sh.new_kasim as float) as KASIM
		,cast(sh.new_aralik as float) as ARALIK
		,cast(sh.new_toplamhedef as float) as TOPLAMHEDEF
		,cast(sh.new_ProjeHedefi as float) as PROJEHEDEFI
		,cast(sh.new_PesinFiyatOran as float) as PESINFIYATORAN
		, 1 as FLAG
from new_satishedef  (nolock) sh
where  sh.statecode = 0
	and sh.new_projeid = @ProjeId
	and (select top 1 sm.Value from StringMapBase (nolock) sm where sm.AttributeName = 'new_hedeftip' and sm.AttributeValue = sh.new_hedeftip) = Isnull(@TargetName, (select top 1 sm.Value from StringMapBase (nolock) sm where sm.AttributeName = 'new_hedeftip' and sm.AttributeValue = sh.new_hedeftip))
	and  sh.new_HedefYil = (Case @Year 
								when '2022' then '100000000'
								when '2023' then '100000001'
								when '2024' then '100000002'
							End)
END
ELSE 
BEGIN
	select 	'Yerli Konut KDV Hariç Hedefler' as HedefTipi 
		--,(select top 1 sm.Value from StringMapBase (nolock) sm where sm.AttributeName = 'new_HedefYil' and sm.AttributeValue = sh.new_HedefYil) as HedefYil
		,0 as OCAK
		,0 as SUBAT
		,0 as MART
		,0 as NISAN
		,0 as MAYIS
		,0 as HAZIRAN
		,0 as TEMMUZ
		,0 as AGUSTOS
		,0 as EYLUL
		,0 as EKIM
		,0 as KASIM
		,0 as ARALIK
		,0 as TOPLAMHEDEF
		,0 as PROJEHEDEFI
		,0 as PESINFIYATORAN
		, 1 as FLAG
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
					<td>TestDashboard2023_Hedefler</td>
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

		EXEC msdb..sp_send_dbmail @profile_name = 'EgeYapi', @recipients = 'onur.gultekin@egeyapi.com', @subject = 'TestDashboard2023_Hedefler SPsinde ERROR', @body = @Body, @body_format='HTML'
END CATCH
GO


