USE [msdb]
GO
/****** Object:  Job [CagriInsert]    Script Date: 03/12/2011 12:05:57 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 03/12/2011 12:05:57 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'CagriInsert', 
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
/****** Object:  Step [CagriInsert]    Script Date: 03/12/2011 12:05:57 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'CagriInsert', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'--dim_tarih
truncate table dbo.dim_CagriTarih
insert into dbo.dim_CagriTarih
select ''01.01.3000'' as TarihId,''3000'' as Yil,''01'' as Ay, ''01'' as Gun,
''01'' as Hafta , ''Saat Bilgisi Yok''
union all
select convert(varchar(8),cb.bm_tarih ,112) as TarihId,
year(cb.bm_tarih ) as Yil , month(cb.bm_tarih ) as Ay,day(cb.bm_tarih) as Gun,
datepart(week,cb.bm_tarih ) as Hafta ,convert(varchar(10),cb.bm_tarih ,108) as Saat
from FULLPETROL_MSCRM.dbo.bm_cagribilgileri as cb

---KULLANICI_DIM
truncate table dbo.dim_Kullanici
insert into dbo.dim_Kullanici
select ''00000000-0000-0000-0000-000000000000'' as KullaniciKodu, ''Kullanıcı Adı Yok'' as KullaniciAdi
union all 
select SystemUserId as KullaniciKodu,FullName as KullaniciAdi
from FULLPETROL_MSCRM.dbo.SystemUser



--CAGRI TIPI_DIM
truncate table dbo.dim_CagriTipi
insert into dbo.dim_CagriTipi
select 0 as CagriTipiKodu , ''Cağrı Tipi Bilgisi Yok'' as CagriTipi
union all
select AttributeValue as CagriTipiKodu, Value as CagriTipi 
from FULLPETROL_MSCRM.dbo.StringMap as sm 
where sm.AttributeName = ''bm_cagritipi'' 



--CAGRI YONU_DIM
truncate table dbo.dim_CagriYonu 
insert into dbo.dim_CagriYonu
select 0 as CagriYonuKodu , ''Cağrı Yönü Bilgisi Yok'' as CagriYonu
union all
select AttributeValue as CagriYonuKodu, Value as CagriYonu 
from FULLPETROL_MSCRM.dbo.StringMap as sm
where sm.AttributeName = ''bm_cagriyonu'' 


--CAGRI_MEASURE
truncate table dbo.fact_Cagri
insert into dbo.fact_Cagri
select convert(varchar(8),cb.bm_tarih ,112)  as Tarih , 
bm_kartturu as KartTipi,
cb.OwningUser as KullaniciKodu, 
Isnull(bm_kisiid  ,''00000000-0000-0000-0000-000000000000'') as Musteri,
Isnull(   ab.AccountID   ,''00000000-0000-0000-0000-000000000000'') as Firma,
cb.bm_cagritipi as CagriTipiKodu,cb.bm_cagriyonu as CagriYonuKodu,cb.bm_sonuc as Sonuc
from FULLPETROL_MSCRM.dbo.bm_cagribilgileri as cb left outer join
FULLPETROL_MSCRM.dbo.Contact as c on c.contactId = cb.bm_kisiid left outer join 
FULLPETROL_MSCRM.dbo.Accountbase as ab on ab.AccountId = c.accountId', 
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
