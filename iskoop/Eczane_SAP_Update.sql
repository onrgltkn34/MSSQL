use iskoop_veribase_com
/*
20108 -- üye
20109 -- Eski Üye
20110 -- Üye Değil
*/
SET NOCOUNT ON;

Declare @EczaneUyemi varchar(10)	= '20108'
		,@creuser varchar(50)		= 'iskoop.admin'
		,@creunit varchar(10)		= '12193952'
		,@insertFlag int			= 0   

/*İskop GLN numarası olan eczaneler*/
select (select p6.contentkey from patient06 p6 where p6.contentid  ='28668' and p6.patientid = p1.id) as GLN
		,(select p6.contentkey from patient06 p6 where p6.contentid  ='28679' and p6.patientid = p1.id) as SAP
		, p1.id
		into #tmp_iskoop_uye_eczaneler
from Patient05 p5
inner join patient01 p1 on p1.id = p5.patient and p1.recstatus='A'
where p5.project = 168
	and (select p7.contentkey from patient07 p7 where p7.contentid  ='22256' and p7.patientid = p1.id) = @EczaneUyemi
	and (select p6.contentkey from patient06 p6 where p6.contentid  ='28668' and p6.patientid = p1.id) is not null  /* iskopta GLN'si boş olmuyanlar */



/*FF Veribase eczaneler*/
select  (select t.id from #tmp_iskoop_uye_eczaneler t where GLN = (select p6.contentkey from ff_veribase_com.dbo.patient06 p6 where p6.contentid  ='50719' and p6.patientid = p1.id)) as iskoopID
		,p1.id
		,(select p6.contentkey from ff_veribase_com.dbo.patient06 p6 where p6.contentid  ='50719' and p6.patientid = p1.id) as GLN
		,(select t.SAP from #tmp_iskoop_uye_eczaneler t where t.GLN =(select p6.contentkey from ff_veribase_com.dbo.patient06 p6 where p6.contentid  ='50719' and p6.patientid = p1.id)) as SAP
		,@creunit as creunit 
		into #tmp_ff_kayitli_olanlar
from ff_veribase_com.dbo.patient05 p5
inner join ff_veribase_com.dbo.patient01 p1 on p1.id = p5.patient and p1.recstatus='A'
where p5.project = 168
	and (select p6.contentkey from ff_veribase_com.dbo.patient06 p6 where p6.contentid  ='50719' and p6.patientid = p1.id) 
				in (select GLN 
						from #tmp_iskoop_uye_eczaneler
						where GLN  not in 
									(
										select GLN 
										from #tmp_iskoop_uye_eczaneler
										Group by GLN
										Having count(GLN) > 1
									)
					)
	and (select p7.contentkey from ff_veribase_com.dbo.patient07 p7 where p7.contentid = 61304 and p7.patientid= p1.id) ='3090041' --- Veribilim Database
	and (select count(p7.contentkey) from ff_veribase_com.dbo.patient07 p7 where p7.contentid = 66270 and p7.patientid= p1.id) < 1 --- Eger SAP kodu yoksa
order by (select p6.contentkey from ff_veribase_com.dbo.patient06 p6 where p6.contentid  ='50719' and p6.patientid = p1.id)





/*Cursor ile tüm kayıtları, 66270 (Firma Kodu) na SAP kodu insert ediliyor, 61380 (Bayi Eczanesi mi?) Evet Ekleniyor.*/
declare @id int
		,@Sap varchar(50)

declare cursor_eczane cursor for (Select id, Sap from #tmp_ff_kayitli_olanlar)

open cursor_eczane
fetch next from cursor_eczane into @id, @sap
while @@FETCH_STATUS = 0
begin
		if @insertFlag = 1
		Begin
					insert into ff_veribase_com.dbo.patient06 (patientid,contentid, creuser, creunit,contentval, contentkey,credat)
														values (@id , 66270, @creuser, @creunit ,@Sap , @Sap , getdate())
					

					if @EczaneUyemi = '20108'
					Begin
						insert into ff_veribase_com.dbo.patient07 (patientid,contentid, creuser, creunit,contentval, contentkey,credat)
															values (@id , 61380, @creuser, @creunit ,'21397' , '21397' , getdate())  --21397 Eczane mi? (Evet)
					End
		End
		Else
		Begin
			Select @id as id
					, @sap as sap
					, @creunit as creunit
					, @creuser as creuser
		End
		
	fetch next from cursor_eczane into @id, @sap
end
close cursor_eczane
deallocate cursor_eczane




if @insertFlag = 1
Begin
			/*FF database eczanelerde olmayanlar*/
			insert into ff_veribase_com.dbo.iskoop_EczaneNotInsert (iskoopID , GLN , SAP , DURUM) 
			select id
					,GLN
					,Sap
					,case when @EczaneUyemi = '20108' Then 'Uye'
						  when @EczaneUyemi = '20109' Then 'Eski Uye'
						  when @EczaneUyemi = '20110' Then 'Uye Degil'
					 End as Durum
			from #tmp_iskoop_uye_eczaneler 
			where GLN not in (select GLN from #tmp_ff_kayitli_olanlar)  or GLN is null
			order by GLN


			/*FF database eczanelere eklenenler*/
			insert into ff_veribase_com.dbo.iskoop_EczaneInsert (iskoopID, ffID , GLN , SAP , DURUM) 
			select  iskoopID
					,id
					,GLN
					,Sap
					,case when @EczaneUyemi = '20108' Then 'Uye'
						  when @EczaneUyemi = '20109' Then 'Eski Uye'
						  when @EczaneUyemi = '20110' Then 'Uye Degil'
					 End as Durum
			from #tmp_ff_kayitli_olanlar 
			order by GLN
End
Else
Begin
			
			select id
					,GLN
					,Sap
					,case when @EczaneUyemi = '20108' Then 'Uye'
						  when @EczaneUyemi = '20109' Then 'Eski Uye'
						  when @EczaneUyemi = '20110' Then 'Uye Degil'
					 End as Durum
			from #tmp_iskoop_uye_eczaneler 
			where GLN not in (select GLN from #tmp_ff_kayitli_olanlar)  or GLN is null
			order by GLN

			
			select  iskoopID
					,id
					,GLN
					,Sap
					,case when @EczaneUyemi = '20108' Then 'Uye'
						  when @EczaneUyemi = '20109' Then 'Eski Uye'
						  when @EczaneUyemi = '20110' Then 'Uye Degil'
					 End as Durum
			from #tmp_ff_kayitli_olanlar 
			order by GLN

End


drop table #tmp_iskoop_uye_eczaneler
drop table #tmp_ff_kayitli_olanlar
			
	

/*****************************************************************
******************************************************************
******************************************************************
******************************************************************
******************************************************************
******************************************************************
declare @id int =672934 
		,@unit varchar(10) = '100'
		,@Sap varchar(50)='17399'
		,@Creuser varchar(50)='dp.admin'


--insert into ff_veribase_com.dbo.patient06 (patientid,contentid, creuser, creunit,contentval, contentkey,credat)
--						values (@id , 66270, @creuser, @unit ,@Sap , @Sap , getdate())

--insert into ff_veribase_com.dbo.patient07 (patientid,contentid, creuser, creunit,contentval, contentkey,credat)
--							values (@id , 61380, @creuser, @unit ,'3548' , '3548' , getdate())

/*
delete from ff_veribase_com.dbo.patient06 where patientid =672934 and contentid =66270 and contentkey='17399'

delete from ff_veribase_com.dbo.patient07 where patientid =672934 and contentid =61380 and contentkey='3548'

*/

select * from ff_veribase_com.dbo.patient06 where patientid=672934 and contentid =66270 

******************************************************************
******************************************************************
******************************************************************
******************************************************************
*/






 
	



