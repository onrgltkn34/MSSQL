
/*
sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'Ole Automation Procedures', 1;
GO
RECONFIGURE;
GO
*/
Set nocount on;

IF OBJECT_ID ('tempdb..#XMLTablosu') is not null Drop table #XMLTablosu;

create table #XMLTablosu
(
	XMLKolonu XML
)


Declare @Url varchar(max)
--Select @Url =  'https://www.w3schools.com/xml/simple.xml' --- note.xml ve simple.xml
Select @Url =  'https://www.borsaistanbul.com/datfile/kmtpkpnsxml' --- note.xml ve simple.xml

Declare @Response varchar(max)
		,@Xml Xml
		,@Obj int
		,@Result int
		,@HttpStatus int
		,@ErrorMsj varchar(max)


Exec @Result = sp_OACreate 'MSXML2.XMLHttp', @Obj Out


Exec @Result = sp_OAMethod @Obj,'open',null,'GET',@Url, false
Exec @Result = sp_OAMethod @Obj
						, 'setRequestHeader'
						, Null
						, 'Content-Type'
						, 'application/x-www-form-urlcoded'
						
Exec @Result = sp_OAMethod @Obj, send, null, ''

Exec @Result = sp_OAMethod @Obj, 'status' , @HttpStatus Out

insert #XMLTablosu (XMLKolonu)
EXEC @Result = sp_OAGetProperty @Obj, 'responseXML.xml'


declare @EmtiaTable table (Name varchar(10) , AltinDeger Money, GumusDeger money, PlatinDeger money, PladyumDeger money, Tarih datetime)



Declare @StartPoint int = 1 
		,@Endpoint int 
		, @Query varchar(max) 
		, @Root varchar(50) ='/IGE/TL' -- /note ve /breakfast_menu/food
		, @RootName varchar(50) ='<TL>' -- <note> ve <food>
		

Set @Endpoint =(select (Len(cast(XMLKolonu as varchar(max))) - LEN(REPLACE( cast (XMLKolonu as varchar(max)),@RootName, '')))/ Len(@RootName)  from #XMLTablosu)

/* XML Data test Etmek ve görmek içi kullanýlýr */
select * from #XMLTablosu


 while @StartPoint < (@Endpoint + 1)
 Begin
	
		/* note.xml */
		/*
		Set @Query ='select XMLKolonu.value(''('+@Root+'/to)['+cast (@StartPoint as varchar(2))+']'',''varchar(50)'') AS Kim,
				   XMLKolonu.value(''('+@Root+'/from)['+cast (@StartPoint as varchar(2))+']'',''varchar(50)'') AS Kimden,
				   XMLKolonu.value(''('+@Root+'/heading)['+cast (@StartPoint as varchar(2))+']'',''varchar(50)'') AS Baslik,
				   XMLKolonu.value(''('+@Root+'/body)['+cast (@StartPoint as varchar(2))+']'',''varchar(50)'') AS icerik
			from #XMLTablosu'
		*/
		
		/* Simple.xml */
		
		/*
		Set @Query ='select XMLKolonu.value(''('+@Root+'/name)['+cast (@StartPoint as varchar(2))+']'',''varchar(50)'') AS Name,
				   XMLKolonu.value(''('+@Root+'/price)['+cast (@StartPoint as varchar(2))+']'',''varchar(50)'') AS Price,
				   XMLKolonu.value(''('+@Root+'/description)['+cast (@StartPoint as varchar(2))+']'',''varchar(50)'') AS Description,
				   XMLKolonu.value(''('+@Root+'/calories)['+cast (@StartPoint as varchar(2))+']'',''varchar(50)'') AS Calories
			from #XMLTablosu'
		*/

		--Set @Query ='select ''TR'' as Name ,XMLKolonu.value(''('+@Root+'/altindeger)['+cast (@StartPoint as varchar(2))+']'',''varchar(50)'') AS altindeger,
		--		   XMLKolonu.value(''('+@Root+'/gumusdeger)['+cast (@StartPoint as varchar(2))+']'',''varchar(50)'') AS gumusdeger,
		--		   XMLKolonu.value(''('+@Root+'/platindeger)['+cast (@StartPoint as varchar(2))+']'',''varchar(50)'') AS platindeger,
		--		   XMLKolonu.value(''('+@Root+'/paladyumdeger)['+cast (@StartPoint as varchar(2))+']'',''varchar(50)'') AS paladyumdeger, Getdate()
		--	from #XMLTablosu'
		
		

		insert into @EmtiaTable (Name, AltinDeger , GumusDeger , PlatinDeger , PladyumDeger, Tarih )
		exec (@Query)

Set @StartPoint = @StartPoint +1 
End



Set @Root ='/IGE/DOLAR' -- /note ve /breakfast_menu/food
Set @RootName  ='<DOLAR>' -- <note> ve <food>
Set @StartPoint = 1

 while @StartPoint < (@Endpoint + 1)
 Begin
	
		Set @Query ='select ''DOLAR'' as Name ,XMLKolonu.value(''('+@Root+'/altindeger)['+cast (@StartPoint as varchar(2))+']'',''varchar(50)'') AS altindeger,
				   XMLKolonu.value(''('+@Root+'/gumusdeger)['+cast (@StartPoint as varchar(2))+']'',''varchar(50)'') AS gumusdeger,
				   XMLKolonu.value(''('+@Root+'/platindeger)['+cast (@StartPoint as varchar(2))+']'',''varchar(50)'') AS platindeger,
				   XMLKolonu.value(''('+@Root+'/paladyumdeger)['+cast (@StartPoint as varchar(2))+']'',''varchar(50)'') AS paladyumdeger, Getdate()
			from #XMLTablosu'
		
		insert into @EmtiaTable (Name, AltinDeger , GumusDeger , PlatinDeger , PladyumDeger, Tarih )
		exec (@Query)

Set @StartPoint = @StartPoint +1 
End

Set @Root ='/IGE/EURO' -- /note ve /breakfast_menu/food
Set @RootName  ='<Euro>' -- <note> ve <food>
Set @StartPoint = 1

 while @StartPoint < (@Endpoint + 1)
 Begin
	
	
		Set @Query ='select ''EURO'' as Name ,XMLKolonu.value(''('+@Root+'/altindeger)['+cast (@StartPoint as varchar(2))+']'',''varchar(50)'') AS altindeger,
				   XMLKolonu.value(''('+@Root+'/gumusdeger)['+cast (@StartPoint as varchar(2))+']'',''varchar(50)'') AS gumusdeger,
				   XMLKolonu.value(''('+@Root+'/platindeger)['+cast (@StartPoint as varchar(2))+']'',''varchar(50)'') AS platindeger,
				   XMLKolonu.value(''('+@Root+'/paladyumdeger)['+cast (@StartPoint as varchar(2))+']'',''varchar(50)'') AS paladyumdeger, Getdate()
			from #XMLTablosu'
		
		insert into @EmtiaTable (Name, AltinDeger , GumusDeger , PlatinDeger , PladyumDeger, Tarih )
		exec (@Query)

Set @StartPoint = @StartPoint +1 
End


select * from @EmtiaTable