USE [lib03_test_veribase_com]
GO

/****** Object:  UserDefinedFunction [dbo].[KitapOnayTopluIslemler]    Script Date: 14.10.2021 17:16:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE Function [dbo].[KitapOnayTopluIslemler] (@userid varchar(100))
RETURNS varchar(MAX)
AS
BEGIN


declare @onay varchar(200)='Toplu Onay'
declare @redd varchar(200)='Toplu Ýptal'

 
 
 declare @doc varchar(max)='<p align="right"> <input type="button" class="blue_button" onclick="Javascript:var win1=window.open(''project_function.asp?sql=6196&amp;selectedgroup='' + GetCheckGroup(document.form.updatecheck)+''&amp;function=runsqlforcheckedvalue'',''win1'',''width=10, height=10, toolbar=no, scrollbars=yes'');win1.moveTo(screen.width/2,screen.height/2);document.form.submit();" name="mybutton" value="'+@onay+'">  <input type="button" class="blue_button" onclick="Javascript:var win1=window.open(''project_function.asp?sql=6197&amp;selectedgroup='' + GetCheckGroup(document.form.updatecheck)+''&amp;function=runsqlforcheckedvalue'',''win1'',''width=10, height=10, toolbar=no, scrollbars=yes'');win1.moveTo(screen.width/2,screen.height/2);document.form.submit();" name="mybutton" value="'+@redd+'"> </p>'
 
		return  @doc
END
GO


