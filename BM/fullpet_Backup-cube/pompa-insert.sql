USE [msdb]
GO
/****** Object:  Job [PompaInsert]    Script Date: 03/12/2011 12:07:33 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 03/12/2011 12:07:33 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'PompaInsert', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'MESAMDEMO\Administrator', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [PompaBilgileri]    Script Date: 03/12/2011 12:07:34 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'PompaBilgileri', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--Firma
truncate table dim_firma
insert into dim_firma
select ''00000000-0000-0000-0000-000000000000'' as FirmaNo,''Firma Adı Yok'' as FirmaAdi,''Firma Türü Yok'' as FirmaTuru,
''Firma İl Yok'' as Firmail, ''Firma İlçe Yok'' as Firmaİlce
union all  
Select Isnull(ab.AccountId,''00000000-0000-0000-0000-000000000000'') as FirmaNo,ab.name as FirmaAdi,sm.Value as FirmaTuru,sm1.Value as Firmail,
sm2.Value as FirmaIlce
From FULLPETROL_MSCRM.dbo.AccountBase as ab Inner Join FULLPETROL_MSCRM.dbo.AccountExtensionBase as aeb
On ab.AccountId=aeb.AccountId left outer join
FULLPETROL_MSCRM.dbo.stringmap as sm on sm.AttributeValue = aeb.bm_iliskiTuru and AttributeName = ''bm_iliskiTuru''
left outer join FULLPETROL_MSCRM.dbo.stringmap as sm1 on sm1.AttributeValue = bm_il and sm1.AttributeName = ''bm_il''
and sm1.ObjectTypeCode = 10001
left outer join 
FULLPETROL_MSCRM.dbo.stringmap as sm2 on sm2.AttributeValue = bm_Ilce and sm2.AttributeName = ''bm_ilce''
and sm2.ObjectTypecode = 10001




--Müşteri
truncate table dim_Musteri
insert into dim_Musteri
select ''00000000-0000-0000-0000-000000000000'' as MusteriNo, ''Müşteri Türü Yok'' as MusteriTuru,
''Firma Numarası Yok'' as FirmaNo,''Cinsiyet Bilgisi Yok'' as Cinsiyet,
''01.01.3000'' as DogumTarihi,
''3000'' as Yıl,
''İl Bilgisi Yok'' as Musteriİl,
''İlçe Bilgisi Yok'' as Musteriİlce,
''Saat Bilgisi Yok'' as bm_saataraligi
union all 
Select Isnull(cb.ContactId,''00000000-0000-0000-0000-000000000000'') as MusteriNo,sm.Value as MusteriTuru,a.accountnumber as FirmaNo,
case when gendercode = 1 then ''Erkek'' else ''Kadın'' end as Cinsiyet,
convert(varchar(10),birthdate,104) as DogumTarihi,
substring((convert(varchar(10),birthdate,104)),7,4) as Yıl,
sm1.Value as Musteriİl,sm2.value as Musteriİlce,bm_saataraligi
From FULLPETROL_MSCRM.dbo.ContactBase as cb Inner Join FULLPETROL_MSCRM.dbo.ContactExtensionBase as ceb
On cb.ContactId=ceb.ContactId  left join FULLPETROL_MSCRM.dbo.Account as a on a.accountId = cb.accountId left outer join
FULLPETROL_MSCRM.dbo.stringmap as sm on sm.AttributeValue = bm_turu  and sm.AttributeName = ''bm_turu''
left outer join FULLPETROL_MSCRM.dbo.stringmap as sm1 on sm1.AttributeValue = ceb.bm_il and sm1.AttributeName = ''bm_il''
and sm1.ObjectTypeCode = 10001
left outer join 
FULLPETROL_MSCRM.dbo.stringmap as sm2 on sm2.AttributeValue = bm_ilce and sm2.AttributeName = ''bm_ilce''
and sm2.ObjectTypecode = 10001




--Araç
truncate table dbo.dim_Arac
insert into dbo.dim_Arac
select ''00000000'' as Plakano,''00000000-0000-0000-0000-000000000000'' as FirmaNo,''00000000-0000-0000-0000-000000000000'' as MusteriNo
union all
Select bm_name as PlakaNo,Isnull(a.AccountID,''00000000-0000-0000-0000-000000000000'') as FirmaNo,Isnull(cb.ContactId,''00000000-0000-0000-0000-000000000000'') as MusteriNo
From FULLPETROL_MSCRM.dbo.Bm_arac as arc left  join 
FULLPETROL_MSCRM.dbo.bm_contact_bm_aracBase as carc on carc.bm_aracid = arc.bm_aracId left outer join
FULLPETROL_MSCRM.dbo.ContactBase as cb On cb.ContactId=carc.contactid  left join 
FULLPETROL_MSCRM.dbo.Account as a on a.accountId = arc.bm_firmalarId


--Pompa Bilgileri
truncate table dbo.Fact_PompaBilgileri
insert into dbo.Fact_PompaBilgileri
Select Isnull(convert(varchar(8),pbeb.bm_tarih,112),''01.01.3000'') as Tarih,
Isnull(bm_sattipi,0) as SatısTipi,Isnull(c.bm_kartturu,0) as KartTipi,Isnull(arc.bm_name, ''00000000'' ) as PlakaNo,
Isnull(bm_musteriId,''00000000-0000-0000-0000-000000000000'') as MusteriNo,
Isnull(pbeb.bm_istasyonid,''00000000-0000-0000-0000-000000000000'') as istasyonNo, Isnull(bm_yakitturu,0) as YakıtTipi,
ISnull( bm_durum,0) as Durum, 
Isnull(bm_baglanti,0) as Baglanti , Isnull(bm_birimfiyat,0) as BirimFiyat, Isnull(bm_litre,0) as Litre, Isnull(bm_tutar,0) as Tutar,
Isnull(bm_mevcutpuan,0) as MevcutPuan, Isnull(bm_toplampuan,0) as ToplamPuan,
CASE WHEN ROW_NUMBER() OVER (Partition BY  arc.bm_name ORDER BY arc.bm_name,bm_musteriId ,pbeb.bm_istasyonid,pbeb.bm_tarih  Asc) = 1 
THEN 1 ELSE 0 END AS distinctplakano  ,
CASE WHEN ROW_NUMBER() OVER (Partition BY  bm_musteriId  ORDER BY bm_musteriId ,pbeb.bm_istasyonid,pbeb.bm_tarih,arc.bm_name Asc) = 1 
THEN 1 ELSE 0 END AS distinctmsuterino ,
CASE WHEN ROW_NUMBER() OVER (Partition BY  ab.AccountID   ORDER BY ab.AccountID  ,pbeb.bm_istasyonid,pbeb.bm_tarih,arc.bm_name Asc) = 1 
THEN 1 ELSE 0 END AS distinctfirmano ,
Isnull(ab.AccountID,''00000000-0000-0000-0000-000000000000'') as AccountID 
From FULLPETROL_MSCRM.dbo.Bm_PompaBilgileriBase as pbb Inner Join 
FULLPETROL_MSCRM.dbo.Bm_pompabilgileriExtensionBase as pbeb On pbb.Bm_pompaBilgileriId=pbeb.Bm_PompaBilgileriId Inner Join 
FULLPETROL_MSCRM.dbo.bm_arac as arc On pbeb.bm_plakanoid=arc.bm_aracId
left outer join  FULLPETROL_MSCRM.dbo.Accountbase as ab on ab.AccountId = arc.bm_firmalarId left outer join
FULLPETROL_MSCRM.dbo.Contact as c on c.contactId = bm_musteriId



--İstasyon
truncate table dbo.dim_Istasyon
insert into dbo.dim_Istasyon
select ''00000000-0000-0000-0000-000000000000'' as Bm_istasyonId,''0000'' as IstasyonNo,
''İstasyon İsmi Yok'' as IstasyonAdi,''İl Bilgisi Yok'' as Istasyonİl
union all
Select ib.Bm_istasyonId,bm_istasyonkodu as IstasyonNo,bm_name as IstasyonAdi, sm1.Value as Istasyonİl 
From FULLPETROL_MSCRM.dbo.Bm_istasyonBase as ib Inner Join FULLPETROL_MSCRM.dbo.Bm_istasyonExtensionBase as ieb
On ib.Bm_istasyonId=ieb.Bm_istasyonId left outer join 
FULLPETROL_MSCRM.dbo.stringmap as sm1 on sm1.AttributeValue = bm_il and sm1.AttributeName = ''bm_il''
and sm1.ObjectTypeCode = 10001

--Durum
truncate table dbo.dim_Durum
insert into dbo.dim_Durum
select 0 as  DurumId , ''Durum Bilgisi Yok'' as [Durum Adı] 
union all
Select AttributeValue as DurumId, Value [Durum Adı] From FULLPETROL_MSCRM.dbo.StringMap
Where AttributeName=''bm_durum'' and ObjectTypeCode=''10005''

--Bağlantı
truncate table dbo.dim_Baglanti
insert into dbo.dim_Baglanti
select 0 as  [Bağlantı Id], ''Bağlantı Bilgisi Yok'' as [Bağlantı Adı]
union all
Select AttributeValue [Bağlantı Id], Value [Bağlantı Adı] From FULLPETROL_MSCRM.dbo.StringMap
Where AttributeName=''bm_baglanti'' 

--Satış Tipi
truncate table dbo.dim_SatisTipi
insert into dbo.dim_SatisTipi
select 0 as  [Bağlantı Id], ''Satış Tipi Bilgisi Yok'' as [Bağlantı Adı]
union all
Select AttributeValue [Bağlantı Id], Value [Bağlantı Adı] From FULLPETROL_MSCRM.dbo.StringMap
Where AttributeName=''bm_sattipi'' 

--Yakıt Tipi
truncate table dbo.dim_YakitTipi
insert into dbo.dim_YakitTipi
select 0 as  [Bağlantı Id], ''Yakıt Tipi Bilgisi Yok'' as [Bağlantı Adı]
union all
Select AttributeValue [Bağlantı Id], Value [Bağlantı Adı] From FULLPETROL_MSCRM.dbo.StringMap
Where AttributeName=''bm_yakitturu'' 

--Karttipi

truncate table dbo.dim_KartTipi
insert into dbo.dim_KartTipi
select 0 as  KartTipiID, ''Kart Bilgisi Yok'' as KartAdi
union all
Select AttributeValue as KartTipiID, Value KartAdi
From FULLPETROL_MSCRM.dbo.StringMap
Where AttributeName=''bm_kartturu'' 


--dim_tarih
truncate table dbo.dim_Tarih
insert into dbo.dim_Tarih
select ''01.01.3000'' as TarihId,''3000'' as Yil,''01'' as Ay, ''01'' as Gun,
''01'' as Hafta , ''Saat Bilgisi Yok''
union all
select convert(varchar(8),pbeb.bm_tarih ,112) as TarihId,
year(pbeb.bm_tarih ) as Yil , month(pbeb.bm_tarih ) as Ay,day(pbeb.bm_tarih) as Gun,
datepart(week,pbeb.bm_tarih ) as Hafta ,convert(varchar(10),pbeb.bm_tarih ,108) as Saat
from FULLPETROL_MSCRM.dbo.Bm_pompabilgileriExtensionBase as pbeb




', 
		@database_name=N'FullPetrol', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
