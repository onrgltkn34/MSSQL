use ff_veribase_com

SET NOCOUNT ON

Declare @tmp table (PlasiyerAdi varchar(250), PlasiyerKodu varchar(250), Email varchar(250), Durumu varchar(250))


insert into @tmp
select p1.title as PlasiyerAdi
		, (select p6.contentkey from iskoop_veribase_com.dbo.patient06 p6 where p6.contentid =28835 and p6.patientid = p1.id ) as PlasiyerKodu
		, Email as Email
		, 'Ýlaç Dýþý' as Durumu
	from iskoop_veribase_com.dbo.patient05 p5
inner join iskoop_veribase_com.dbo.patient01 p1 on p1.id =p5.patient and p1.recstatus='A'
where p5.project = 371
union all
select p1.title as PlasiyerAdi
		, (select p6.contentkey from iskoop_veribase_com.dbo.patient06 p6 where p6.contentid =28837 and p6.patientid = p1.id ) as PlasiyerKodu
		, (select p6.contentkey from iskoop_veribase_com.dbo.patient06 p6 where p6.contentid =70031 and p6.patientid = p1.id ) as Email
		, 'Ýlaç içi' as Durumu
	from iskoop_veribase_com.dbo.patient05 p5
inner join iskoop_veribase_com.dbo.patient01 p1 on p1.id =p5.patient and p1.recstatus='A'
where p5.project = 372


Declare @patientid int --SELECT @@IDENTITY
		,@PlasiyerAdi varchar(250)
		,@PlasiyerKodu varchar(250)
		,@Email varchar(250)
		,@Durumu varchar (250) ='Ýlaç Dýþý'

/*
132385 plasiyer kodu patient06
132386 email patient06
132389 pasiyer tipi patient07, 36752 (ilaç Ýçi) , 36753 (ilaç Dýþý)
132392 firmaId patient06, 12193952 iskoop

insert into patient06 (patientid, contentid, creuser, creunit, contentval, contentkey, credat)
select @accid, 132392, @userid, @unit, @usercompany, @usercompany, getdate()
*/



declare cursor_ad cursor for (select PlasiyerAdi, PlasiyerKodu, Email from @tmp where Durumu = @Durumu)
open cursor_ad
fetch next from cursor_ad into @PlasiyerAdi, @PlasiyerKodu, @Email
while @@FETCH_STATUS = 0
begin

	Set @patientid =(select max(p1.id)+1 from patient05 p5 inner join patient01 p1 on p1.id =p5.patient)

	--select @patientid,@PlasiyerAdi, @PlasiyerKodu, @Email

	
	insert into patient05 (patient,Unit,Project,credat)
					values (@patientid,100,2905,GETDATE())

	insert into patient01 (id, title, creuser, recstatus, credat)
					select @patientid, @PlasiyerAdi, 'iskoop.admin', 'A', getdate()
	 
	insert into patient06 (patientid, contentid, creuser, creunit, contentval, contentkey, credat)
					select @patientid, 132385, 'iskoop.admin', '100', @PlasiyerKodu , @PlasiyerKodu, getdate()

	if @Email is not null
	Begin
		insert into patient06 (patientid, contentid, creuser, creunit, contentval, contentkey, credat)
					select @patientid, 132386, 'iskoop.admin', '100', @Email , @Email, getdate()
	End
	
	insert into patient07 (patientid, contentid, creuser, creunit, contentval, contentkey, credat)
					select @patientid, 132389, 'iskoop.admin', '100', case when @Durumu='Ýlaç Dýþý' then '36753' else '36752' end , case when @Durumu='Ýlaç Dýþý' then '36753' else '36752' end, getdate()

	insert into patient06 (patientid, contentid, creuser, creunit, contentval, contentkey, credat)
					select @patientid, 132392, 'iskoop.admin', '100', '12193952', '12193952', getdate()

		

	Set @patientid = ''
fetch next from cursor_ad into @PlasiyerAdi, @PlasiyerKodu, @Email
end
close cursor_ad
deallocate cursor_ad
