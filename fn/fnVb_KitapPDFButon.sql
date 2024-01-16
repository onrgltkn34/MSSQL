USE [lib03_test_veribase_com]
GO

/****** Object:  UserDefinedFunction [dbo].[fnVb_KitapPDFButon]    Script Date: 14.10.2021 17:16:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[fnVb_KitapPDFButon] (@userid varchar(100))
returns varchar(8000) 
AS
BEGIN
Declare @return varchar(8000)


Set @return = '<a onclick="Javascript:var win1=window.open(''htmltopdf.asp?Orientation=L&amp;scale=0.80&amp;link=@url/showcontent.asp?contentid=1319&amp;userid=@userid'',''win1'',''width=1, height=1, toolbar=no, scrollbars=yes'');win1.moveTo(screen.width/2-275,screen.height/2-187);" class="k-button  k-primary" href="#"> PDF </a>'


return @return
END

GO


