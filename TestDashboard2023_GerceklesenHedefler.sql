USE [egeyapi_MSCRM]
GO

/****** Object:  StoredProcedure [dbo].[TestDashboard2023_GerceklesenHedefler]    Script Date: 27.02.2023 11:03:45 ******/
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
-- Update date: 31.01.2023
-- Description:	Cer için new_uygulamatip ve new_uygulamabrutm2 alanlarý uzerinden hesaplama yapýldý. 
-- =============================================
CREATE PROCEDURE [dbo].[TestDashboard2023_GerceklesenHedefler] 	
	@ProjeId varchar(50),
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
Declare @Year varchar(4) ='2023'


IF OBJECT_ID('tempdb..#tmp_pivot') IS NOT NULL DROP TABLE #tmp_pivot


Create table #tmp_pivot
(
	SubjectName varchar(50),
	Yil int, 
	Ay int,
	Toplam float  
)


IF @ProjeId = '9F2C9D29-59D6-E611-80FE-3417EBEAECF3'  /*new_uygulamatip ve new_uygulamabrutm2 den gidiliyor.Cer Ýstanbul*/
BEGIN
			/*************************************************************************************************************************/
			/*************************************************************************************************************************/
			/********************************** YERLÝ KONUTLARLAR (YERLÝ/YABANCI) ****************************************************/
			/*************************************************************************************************************************/
			/*************************************************************************************************************************/


			/*
				**************************
				**************************
				**************************
				 YERLÝ KONUT SATIÞLARI
				**************************
				**************************
				**************************
			*/
			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select 'Yerli Konut KDV Hariç Hedefler' as [Yerli Konut KDV Hariç Satýþlar]
					,YEAR(ns.CreatedOn) as Yil
					,MONTH (ns.CreatedOn) as Ay
					,case ns.new_satisdoviz
						when 1 then Isnull(sum(ns.new_kdvharic),0) 
						when 2 then Isnull(sum(ns.new_ssftlkdvharic),0)
						End Toplam
			from new_satis ns (nolock) 
			inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
			inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and (nd.new_konuttipi not in('100000000') and nd.new_UygulamaTip is not null) /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
			where ns.new_projeid = @ProjeId
				and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
				and YEAR(ns.CreatedOn) = @Year
				and ns.statecode = 0 
				--and new_satisdoviz = 1 /* satýþ kartýnda yabancý olup, müþteri kartýnda türk olanlar geldiðinden yok sayýyoruz*/
			Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn), ns.new_satisdoviz

	
			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select	'Yerli Konut KDV Dahil Tahsilat' as [Yerli KonutKDV Dahil Nakit Satýþý]
					,YEAR(o.new_odemezamani) as Yil
					,MONTH(o.new_odemezamani) as Ay
					,sum(ISNULL(o.new_miktar,0)) as Toplam
			from new_senet se
					inner join new_Satis s on s.new_satisId = se.new_satisid
					inner join Contact c on c.contactId = s.new_contactid --and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
					inner join new_odeme o on se.new_senetId = o.new_senetid
					inner join new_daire nd (nolock) on nd.new_daireId = s.new_daireid and (nd.new_konuttipi not in('100000000') and nd.new_UygulamaTip is not null) /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
					left join stringmap sm on sm.ObjectTypeCode = 10030 and sm.AttributeName = 'new_senettipi'	and sm.AttributeValue = se.new_SenetTipi
			where s.statecode = 0 and se.statecode = 0 
					and se.new_senettipi not in ('100000001','8','10','11','12','13','24','14','15','16','17','20','21','23','22','26','27','28','29') 
					and o.statecode=0 
					and new_satisdoviz = 1  
					and YEAR(o.new_odemezamani) = @Year
					and s.new_projeid in (@ProjeId)
					and o.new_odemezamani < = (GETDATE () +1) ---##Bunu cerde 2023 yýlýnda TOPLAMHEDEF ayý içindeyken, aralýk ayý tahsilatý göründüðünden koydum.
			group by MONTH(o.new_odemezamani),YEAR(o.new_odemezamani) 


	
			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select 'Yerli Konut Brüt M2 Hedefleri' as [Yerli Konut Brüt M2 Hedefleri Satýþ]
					,YEAR(ns.CreatedOn) as Yil
					,MONTH (ns.CreatedOn) as Ay
					,Isnull(sum(nd.new_UygulamaBrutM2),0) Toplam
			from new_satis ns (nolock) 
			inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
			inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and (nd.new_konuttipi not in('100000000') and nd.new_UygulamaTip is not null) /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
			where ns.new_projeid = @ProjeId
				and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
				and YEAR(ns.CreatedOn) = @Year
				and ns.statecode = 0 
				and new_satisdoviz = 1
			Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn)



			/*
				**************************
				**************************
				**************************
				 YABANCI KONUT SATIÞLARI
				**************************
				**************************
				**************************
			*/
			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select 'Yabancý Konut KDV Hariç Hedefler' as [Yabancý Konut KDV Hariç Satýþlar]
					,YEAR(ns.CreatedOn) as Yil
					,MONTH (ns.CreatedOn) as Ay
					,case ns.new_satisdoviz
						when 1 then Isnull(sum(ns.new_kdvharic),0) 
						when 2 then Isnull(sum(ns.new_ssftlkdvharic),dbo.GetUSDPrice(ns.new_kdvharic,ns.CreatedOn))
						End Toplam
			from new_satis ns (nolock) 
			inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
			inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and (nd.new_konuttipi not in('100000000') and nd.new_UygulamaTip is not null) /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
			where ns.new_projeid = @ProjeId
				and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
				and YEAR(ns.CreatedOn) = @Year
				and ns.statecode = 0 
				--and new_satisdoviz = 2 /* satýþ kartýnda yabancý olup, müþteri kartýnda türk olanlar geldiðinden yok sayýyoruz*/
			Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn), ns.new_satisdoviz,ns.new_kdvharic,ns.CreatedOn


			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select	'Yabancý Konut KDV Dahil Tahsilat' as [Yabancý KonutKDV Dahil Nakit Satýþý]
					,YEAR(o.new_odemezamani) as Yil
					,MONTH(o.new_odemezamani) as Ay
					,case when o.new_TLTutar is not null then o.new_TLTutar else o.new_miktar end as Toplam
			from new_senet se
					inner join new_Satis s on s.new_satisId = se.new_satisid
					inner join Contact c on c.contactId = s.new_contactid --and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
					inner join new_daire nd (nolock) on nd.new_daireId = s.new_daireid and (nd.new_konuttipi not in('100000000') and nd.new_UygulamaTip is not null) /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
					inner join new_odeme o on se.new_senetId = o.new_senetid
					left join stringmap sm on sm.ObjectTypeCode = 10030 and sm.AttributeName = 'new_senettipi' and sm.AttributeValue = se.new_SenetTipi
			where s.statecode = 0 and se.statecode = 0 
					and se.new_senettipi not in ('100000001','8','10','11','12','13','24','14','15','16','17','20','21','23','22','26','27','28','29') 
					and o.statecode=0 and new_satisdoviz=2 
					and Year(o.new_odemezamani) = @Year
					and s.new_projeid in (@ProjeId)
					and o.new_odemezamani < = (GETDATE () +1)
			group by MONTH(o.new_odemezamani),YEAR(o.new_odemezamani), o.new_TLTutar, O.new_miktar 


			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select 'Yabancý Konut Brüt M2 Hedefleri' as [Yabancý Konut Brüt M2 Hedefleri Satýþ]
					,YEAR(ns.CreatedOn) as Yil
					,MONTH (ns.CreatedOn) as Ay
					,Isnull(sum(nd.new_UygulamaBrutM2),0) Toplam
			from new_satis ns (nolock) 
			inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
			inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and (nd.new_konuttipi not in('100000000') and nd.new_UygulamaTip is not null) /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
			where ns.new_projeid = @ProjeId
				and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
				and YEAR(ns.CreatedOn) = @Year
				and ns.statecode = 0 
				and new_satisdoviz = 2
			Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn)

			/*************************************************************************************************************************/
			/*************************************************************************************************************************/
			/********************************** TÝCARÝ KONUTLARLAR (YERLÝ/YABANCI) ***************************************************/
			/*************************************************************************************************************************/
			/*************************************************************************************************************************/

			/*
				**************************
				**************************
				**************************
				 YERLÝ TÝCARÝ SATIÞLARI
				**************************
				**************************
				**************************
			*/
				insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
				select 'Yerli Ticari KDV Hariç Hedefler' as [Yerli Ticari KDV Hariç Satýþlar]
						,YEAR(ns.CreatedOn) as Yil
						,MONTH (ns.CreatedOn) as Ay
						,case ns.new_satisdoviz
							when 1 then Isnull(sum(ns.new_kdvharic),0) 
							when 2 then Isnull(sum(ns.new_ssftlkdvharic),0)
							End Toplam 
				from new_satis ns (nolock) 
				inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
				inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi  in('100000000') and nd.new_UygulamaTip in ('Ticari','Sosyal Tesis') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
				where ns.new_projeid = @ProjeId
					and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
					and YEAR(ns.CreatedOn) = @Year
					and ns.statecode = 0 --and new_satisdoviz = 1
				Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn), ns.new_satisdoviz

	
				insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
				select		'Yerli Ticari KDV Dahil Tahsilat' as [Yerli Ticari Dahil Nakit Satýþý]
							,YEAR(o.new_odemezamani) as Yil
							,MONTH(o.new_odemezamani) as Ay
							,sum(ISNULL(o.new_miktar,0)) as Toplam
				from new_senet se
						inner join new_Satis s on s.new_satisId = se.new_satisid
						inner join Contact c on c.contactId = s.new_contactid --and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
						inner join new_odeme o on se.new_senetId = o.new_senetid
						inner join new_daire nd (nolock) on nd.new_daireId = s.new_daireid and nd.new_konuttipi  in('100000000') and nd.new_UygulamaTip in ('Ticari','Sosyal Tesis') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
						left join stringmap sm on sm.ObjectTypeCode = 10030 and sm.AttributeName = 'new_senettipi'	and sm.AttributeValue = se.new_SenetTipi
				where s.statecode = 0 and se.statecode = 0 
						and se.new_senettipi not in ('100000001','8','10','11','12','13','24','14','15','16','17','20','21','23','22','26','27','28','29') 
						and o.statecode=0 and new_satisdoviz = 1  
						and YEAR(o.new_odemezamani) = @Year
						and s.new_projeid in (@ProjeId)
						and o.new_odemezamani < = (GETDATE () +1)
				group by MONTH(o.new_odemezamani),YEAR(o.new_odemezamani) 

	
				insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
				select 'Yerli Ticari Brüt M2 Hedefleri' as [Yerli Ticari Brüt M2 Hedefleri Satýþ]
						,YEAR(ns.CreatedOn) as Yil
						,MONTH (ns.CreatedOn) as Ay
						,Isnull(sum(nd.new_brtm2),0) Toplam
				from new_satis ns (nolock) 
				inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
				inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi  in('100000000') and nd.new_UygulamaTip in ('Ticari','Sosyal Tesis')/*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
				where ns.new_projeid = @ProjeId
					and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
					and YEAR(ns.CreatedOn) = @Year
					and ns.statecode = 0 and new_satisdoviz = 1
				Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn)

			/*
				**************************
				**************************
				**************************
				 YABANCI TÝCARÝ SATIÞLARI
				**************************
				**************************
				**************************
			*/
			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select 'Yabancý Ticari KDV Hariç Hedefler' as [Yabancý Ticari KDV Hariç Satýþlar]
					,YEAR(ns.CreatedOn) as Yil
					,MONTH (ns.CreatedOn) as Ay
					,case ns.new_satisdoviz
						when 1 then Isnull(sum(ns.new_kdvharic),0) 
						when 2 then Isnull(sum(ns.new_ssftlkdvharic),0)
						End Toplam
			from new_satis ns (nolock) 
			inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
			inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi  in('100000000') and nd.new_UygulamaTip in ('Ticari','Sosyal Tesis')/*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
			where ns.new_projeid = @ProjeId
				and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
				and YEAR(ns.CreatedOn) = @Year
				and ns.statecode = 0 
				--and new_satisdoviz = 2
			Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn) ,ns.new_satisdoviz


			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select	'Yabancý Ticari KDV Dahil Tahsilat' as [Yabancý Ticari Dahil Nakit Satýþý]
					,YEAR(o.new_odemezamani) as Yil
					,MONTH(o.new_odemezamani) as Ay
					,case when o.new_TLTutar is not null then o.new_TLTutar else o.new_miktar end as Toplam
			from new_senet se
					inner join new_Satis s on s.new_satisId = se.new_satisid
					inner join Contact c on c.contactId = s.new_contactid --and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
					inner join new_daire nd (nolock) on nd.new_daireId = s.new_daireid and nd.new_konuttipi  in('100000000') and nd.new_UygulamaTip in ('Ticari','Sosyal Tesis')/*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
					inner join new_odeme o on se.new_senetId = o.new_senetid
					left join stringmap sm on sm.ObjectTypeCode = 10030 and sm.AttributeName = 'new_senettipi' and sm.AttributeValue = se.new_SenetTipi
			where s.statecode = 0 and se.statecode = 0 
					and se.new_senettipi not in ('100000001','8','10','11','12','13','24','14','15','16','17','20','21','23','22','26','27','28','29') 
					and o.statecode=0 and new_satisdoviz=2 
					and Year(o.new_odemezamani) = @Year
					and s.new_projeid in (@ProjeId) 
					and o.new_odemezamani < = (GETDATE () +1)
			group by MONTH(o.new_odemezamani),YEAR(o.new_odemezamani), o.new_TLTutar, O.new_miktar 


			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select 'Yabancý Ticari Brüt M2 Hedefleri' as [Yabancý Ticari Brüt M2 Hedefleri Satýþ]
					,YEAR(ns.CreatedOn) as Yil
					,MONTH (ns.CreatedOn) as Ay
					,Isnull(sum(nd.new_brtm2),0) Toplam
			from new_satis ns (nolock) 
			inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
			inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi in('100000000') and nd.new_UygulamaTip in ('Ticari','Sosyal Tesis')/*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
			where ns.new_projeid = @ProjeId
				and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
				and YEAR(ns.CreatedOn) = @Year
				and ns.statecode = 0 
				and new_satisdoviz = 2
			Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn)



			/*************************************************************************************************************************/
			/*************************************************************************************************************************/
			/********************************** LOFT KONUTLARLAR (YERLÝ/YABANCI) ***************************************************/
			/*************************************************************************************************************************/
			/*************************************************************************************************************************/

			/*
				**************************
				**************************
				**************************
				 YERLÝ LOFT SATIÞLARI
				**************************
				**************************
				**************************
			*/
				insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
				select 'Yerli Loft KDV Hariç Hedefler' as [Yerli Ticari KDV Hariç Satýþlar]
						,YEAR(ns.CreatedOn) as Yil
						,MONTH (ns.CreatedOn) as Ay
						,case ns.new_satisdoviz
							when 1 then Isnull(sum(ns.new_kdvharic),0) 
							when 2 then Isnull(sum(ns.new_ssftlkdvharic),0)
							End Toplam 
				from new_satis ns (nolock) 
				inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
				inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi  in('100000000') and nd.new_UygulamaTip ='Loft' /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
				where ns.new_projeid = @ProjeId
					and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
					and YEAR(ns.CreatedOn) = @Year
					and ns.statecode = 0 --and new_satisdoviz = 1
				Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn), ns.new_satisdoviz

	
				insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
				select		'Yerli Loft KDV Dahil Tahsilat' as [Yerli Ticari Dahil Nakit Satýþý]
							,YEAR(o.new_odemezamani) as Yil
							,MONTH(o.new_odemezamani) as Ay
							,sum(ISNULL(o.new_miktar,0)) as Toplam
				from new_senet se
						inner join new_Satis s on s.new_satisId = se.new_satisid
						inner join Contact c on c.contactId = s.new_contactid --and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
						inner join new_odeme o on se.new_senetId = o.new_senetid
						inner join new_daire nd (nolock) on nd.new_daireId = s.new_daireid and nd.new_konuttipi  in('100000000') and nd.new_UygulamaTip ='Loft' /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
						left join stringmap sm on sm.ObjectTypeCode = 10030 and sm.AttributeName = 'new_senettipi'	and sm.AttributeValue = se.new_SenetTipi
				where s.statecode = 0 and se.statecode = 0 
						and se.new_senettipi not in ('100000001','8','10','11','12','13','24','14','15','16','17','20','21','23','22','26','27','28','29') 
						and o.statecode=0 and new_satisdoviz = 1  
						and YEAR(o.new_odemezamani) = @Year
						and s.new_projeid in (@ProjeId)
						and o.new_odemezamani < = (GETDATE () +1)
				group by MONTH(o.new_odemezamani),YEAR(o.new_odemezamani) 

	
				insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
				select 'Yerli Loft Brüt M2 Hedefleri' as [Yerli Ticari Brüt M2 Hedefleri Satýþ]
						,YEAR(ns.CreatedOn) as Yil
						,MONTH (ns.CreatedOn) as Ay
						,Isnull(sum(nd.new_UygulamaBrutM2),0) Toplam
				from new_satis ns (nolock) 
				inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
				inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi  in('100000000') and nd.new_UygulamaTip='Loft' /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
				where ns.new_projeid = @ProjeId
					and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
					and YEAR(ns.CreatedOn) = @Year
					and ns.statecode = 0 and new_satisdoviz = 1
				Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn)

			/*
				**************************
				**************************
				**************************
				 YABANCI LOFT SATIÞLARI
				**************************
				**************************
				**************************
			*/
			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select 'Yabancý Loft KDV Hariç Hedefler' as [Yabancý Ticari KDV Hariç Satýþlar]
					,YEAR(ns.CreatedOn) as Yil
					,MONTH (ns.CreatedOn) as Ay
					,case ns.new_satisdoviz
						when 1 then Isnull(sum(ns.new_kdvharic),0) 
						when 2 then Isnull(sum(ns.new_ssftlkdvharic),0)
						End Toplam
			from new_satis ns (nolock) 
			inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
			inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi  in('100000000') and nd.new_UygulamaTip='Loft'/*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
			where ns.new_projeid = @ProjeId
				and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
				and YEAR(ns.CreatedOn) = @Year
				and ns.statecode = 0 
				--and new_satisdoviz = 2
			Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn) ,ns.new_satisdoviz


			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select	'Yabancý Loft KDV Dahil Tahsilat' as [Yabancý Ticari Dahil Nakit Satýþý]
					,YEAR(o.new_odemezamani) as Yil
					,MONTH(o.new_odemezamani) as Ay
					,case when o.new_TLTutar is not null then o.new_TLTutar else o.new_miktar end as Toplam
			from new_senet se
					inner join new_Satis s on s.new_satisId = se.new_satisid
					inner join Contact c on c.contactId = s.new_contactid --and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
					inner join new_daire nd (nolock) on nd.new_daireId = s.new_daireid and nd.new_konuttipi  in('100000000') and nd.new_UygulamaTip='Loft'/*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
					inner join new_odeme o on se.new_senetId = o.new_senetid
					left join stringmap sm on sm.ObjectTypeCode = 10030 and sm.AttributeName = 'new_senettipi' and sm.AttributeValue = se.new_SenetTipi
			where s.statecode = 0 and se.statecode = 0 
					and se.new_senettipi not in ('100000001','8','10','11','12','13','24','14','15','16','17','20','21','23','22','26','27','28','29') 
					and o.statecode=0 and new_satisdoviz=2 
					and Year(o.new_odemezamani) = @Year
					and s.new_projeid in (@ProjeId) 
					and o.new_odemezamani < = (GETDATE () +1)
			group by MONTH(o.new_odemezamani),YEAR(o.new_odemezamani), o.new_TLTutar, O.new_miktar 


			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select 'Yabancý Loft Brüt M2 Hedefleri' as [Yabancý Ticari Brüt M2 Hedefleri Satýþ]
					,YEAR(ns.CreatedOn) as Yil
					,MONTH (ns.CreatedOn) as Ay
					,Isnull(sum(nd.new_UygulamaBrutM2),0) Toplam
			from new_satis ns (nolock) 
			inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
			inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi in('100000000') and nd.new_UygulamaTip='Loft'/*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
			where ns.new_projeid = @ProjeId
				and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
				and YEAR(ns.CreatedOn) = @Year
				and ns.statecode = 0 
				and new_satisdoviz = 2
			Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn)





END
ELSE IF @ProjeId in ( 'B94D6764-1D20-EB11-82A7-000C292E580F' , '0C13E4A5-F358-EC11-85A7-000C292E580F' ,'7265A677-66AA-E611-80E6-3417EBEAECF3')
BEGIN 
			/*************************************************************************************************************************/
			/*************************************************************************************************************************/
			/********************************** YERLÝ KONUTLARLAR (YERLÝ/YABANCI) ****************************************************/
			/*************************************************************************************************************************/
			/*************************************************************************************************************************/


			/*
				**************************
				**************************
				**************************
				 YERLÝ KONUT SATIÞLARI
				**************************
				**************************
				**************************
			*/
			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select 'Yerli Konut KDV Hariç Hedefler' as [Yerli Konut KDV Hariç Satýþlar]
					,YEAR(ns.CreatedOn) as Yil
					,MONTH (ns.CreatedOn) as Ay
					,case ns.new_satisdoviz
						when 1 then Isnull(sum(ns.new_kdvharic),0) 
						when 2 then Isnull(sum(ns.new_ssftlkdvharic),0)
						End Toplam
			from new_satis ns (nolock) 
			inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
			inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and (nd.new_konuttipi not in('100000000') or nd.new_konuttipi is null) /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
			where ns.new_projeid = @ProjeId
				and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
				and YEAR(ns.CreatedOn) = @Year
				and ns.statecode = 0 
				--and new_satisdoviz = 1 /* satýþ kartýnda yabancý olup, müþteri kartýnda türk olanlar geldiðinden yok sayýyoruz*/
			Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn), ns.new_satisdoviz

	
			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select	'Yerli Konut KDV Dahil Tahsilat' as [Yerli KonutKDV Dahil Nakit Satýþý]
					,YEAR(o.new_odemezamani) as Yil
					,MONTH(o.new_odemezamani) as Ay
					,sum(ISNULL(o.new_miktar,0)) as Toplam
			from new_senet se
					inner join new_Satis s on s.new_satisId = se.new_satisid
					inner join Contact c on c.contactId = s.new_contactid --and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
					inner join new_odeme o on se.new_senetId = o.new_senetid
					inner join new_daire nd (nolock) on nd.new_daireId = s.new_daireid and (nd.new_konuttipi not in('100000000') or nd.new_konuttipi is null) /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
					left join stringmap sm on sm.ObjectTypeCode = 10030 and sm.AttributeName = 'new_senettipi'	and sm.AttributeValue = se.new_SenetTipi
			where s.statecode = 0 and se.statecode = 0 
					and se.new_senettipi not in ('100000001','8','10','11','12','13','24','14','15','16','17','20','21','23','22','26','27','28','29') 
					and o.statecode=0 
					and new_satisdoviz = 1  
					and YEAR(o.new_odemezamani) = @Year
					and s.new_projeid in (@ProjeId)
					and o.new_odemezamani < = (GETDATE () +1) ---##Bunu cerde 2023 yýlýnda TOPLAMHEDEF ayý içindeyken, aralýk ayý tahsilatý göründüðünden koydum.
			group by MONTH(o.new_odemezamani),YEAR(o.new_odemezamani) 


	
			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select 'Yerli Konut Brüt M2 Hedefleri' as [Yerli Konut Brüt M2 Hedefleri Satýþ]
					,YEAR(ns.CreatedOn) as Yil
					,MONTH (ns.CreatedOn) as Ay
					,Isnull(sum(nd.new_UygulamaSatM2),0) Toplam
			from new_satis ns (nolock) 
			inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
			inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and (nd.new_konuttipi not in('100000000') or nd.new_konuttipi is null) /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
			where ns.new_projeid = @ProjeId
				and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
				and YEAR(ns.CreatedOn) = @Year
				and ns.statecode = 0 
				and new_satisdoviz = 1
			Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn)



			/*
				**************************
				**************************
				**************************
				 YABANCI KONUT SATIÞLARI
				**************************
				**************************
				**************************
			*/
			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select 'Yabancý Konut KDV Hariç Hedefler' as [Yabancý Konut KDV Hariç Satýþlar]
					,YEAR(ns.CreatedOn) as Yil
					,MONTH (ns.CreatedOn) as Ay
					,case ns.new_satisdoviz
						when 1 then Isnull(sum(ns.new_kdvharic),0) 
						when 2 then Isnull(sum(ns.new_ssftlkdvharic),dbo.GetUSDPrice(ns.new_kdvharic,ns.CreatedOn))
						End Toplam
			from new_satis ns (nolock) 
			inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
			inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and (nd.new_konuttipi not in('100000000') or nd.new_konuttipi is null) /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
			where ns.new_projeid = @ProjeId
				and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
				and YEAR(ns.CreatedOn) = @Year
				and ns.statecode = 0 
				--and new_satisdoviz = 2 /* satýþ kartýnda yabancý olup, müþteri kartýnda türk olanlar geldiðinden yok sayýyoruz*/
			Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn), ns.new_satisdoviz,ns.new_kdvharic,ns.CreatedOn


			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select	'Yabancý Konut KDV Dahil Tahsilat' as [Yabancý KonutKDV Dahil Nakit Satýþý]
					,YEAR(o.new_odemezamani) as Yil
					,MONTH(o.new_odemezamani) as Ay
					,case when o.new_TLTutar is not null then o.new_TLTutar else o.new_miktar end as Toplam
			from new_senet se
					inner join new_Satis s on s.new_satisId = se.new_satisid
					inner join Contact c on c.contactId = s.new_contactid --and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
					inner join new_daire nd (nolock) on nd.new_daireId = s.new_daireid and (nd.new_konuttipi not in('100000000') or nd.new_konuttipi is null) /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
					inner join new_odeme o on se.new_senetId = o.new_senetid
					left join stringmap sm on sm.ObjectTypeCode = 10030 and sm.AttributeName = 'new_senettipi' and sm.AttributeValue = se.new_SenetTipi
			where s.statecode = 0 and se.statecode = 0 
					and se.new_senettipi not in ('100000001','8','10','11','12','13','24','14','15','16','17','20','21','23','22','26','27','28','29') 
					and o.statecode=0 and new_satisdoviz=2 
					and Year(o.new_odemezamani) = @Year
					and s.new_projeid in (@ProjeId)
					and o.new_odemezamani < = (GETDATE () +1)
			group by MONTH(o.new_odemezamani),YEAR(o.new_odemezamani), o.new_TLTutar, O.new_miktar 


			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select 'Yabancý Konut Brüt M2 Hedefleri' as [Yabancý Konut Brüt M2 Hedefleri Satýþ]
					,YEAR(ns.CreatedOn) as Yil
					,MONTH (ns.CreatedOn) as Ay
					,Isnull(sum(nd.new_UygulamaSatM2),0) Toplam
			from new_satis ns (nolock) 
			inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
			inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and (nd.new_konuttipi not in('100000000') or nd.new_konuttipi is null) /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
			where ns.new_projeid = @ProjeId
				and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
				and YEAR(ns.CreatedOn) = @Year
				and ns.statecode = 0 
				and new_satisdoviz = 2
			Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn)


			/*************************************************************************************************************************/
			/*************************************************************************************************************************/
			/********************************** TÝCARÝ KONUTLARLAR (YERLÝ/YABANCI) ***************************************************/
			/*************************************************************************************************************************/
			/*************************************************************************************************************************/

			/*
				**************************
				**************************
				**************************
				 YERLÝ TÝCARÝ SATIÞLARI
				**************************
				**************************
				**************************
			*/
				insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
				select 'Yerli Ticari KDV Hariç Hedefler' as [Yerli Ticari KDV Hariç Satýþlar]
						,YEAR(ns.CreatedOn) as Yil
						,MONTH (ns.CreatedOn) as Ay
						,case ns.new_satisdoviz
							when 1 then Isnull(sum(ns.new_kdvharic),0) 
							when 2 then Isnull(sum(ns.new_ssftlkdvharic),0)
							End Toplam 
				from new_satis ns (nolock) 
				inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
				inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi  in('100000000') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
				where ns.new_projeid = @ProjeId
					and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
					and YEAR(ns.CreatedOn) = @Year
					and ns.statecode = 0 --and new_satisdoviz = 1
				Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn), ns.new_satisdoviz

	
				insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
				select		'Yerli Ticari KDV Dahil Tahsilat' as [Yerli Ticari Dahil Nakit Satýþý]
							,YEAR(o.new_odemezamani) as Yil
							,MONTH(o.new_odemezamani) as Ay
							,sum(ISNULL(o.new_miktar,0)) as Toplam
				from new_senet se
						inner join new_Satis s on s.new_satisId = se.new_satisid
						inner join Contact c on c.contactId = s.new_contactid --and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
						inner join new_odeme o on se.new_senetId = o.new_senetid
						inner join new_daire nd (nolock) on nd.new_daireId = s.new_daireid and nd.new_konuttipi  in('100000000') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
						left join stringmap sm on sm.ObjectTypeCode = 10030 and sm.AttributeName = 'new_senettipi'	and sm.AttributeValue = se.new_SenetTipi
				where s.statecode = 0 and se.statecode = 0 
						and se.new_senettipi not in ('100000001','8','10','11','12','13','24','14','15','16','17','20','21','23','22','26','27','28','29') 
						and o.statecode=0 and new_satisdoviz = 1  
						and YEAR(o.new_odemezamani) = @Year
						and s.new_projeid in (@ProjeId)
						and o.new_odemezamani < = (GETDATE () +1)
				group by MONTH(o.new_odemezamani),YEAR(o.new_odemezamani) 

	
				insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
				select 'Yerli Ticari Brüt M2 Hedefleri' as [Yerli Ticari Brüt M2 Hedefleri Satýþ]
						,YEAR(ns.CreatedOn) as Yil
						,MONTH (ns.CreatedOn) as Ay
						,Isnull(sum(nd.new_UygulamaSatM2),0) Toplam
				from new_satis ns (nolock) 
				inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
				inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi  in('100000000') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
				where ns.new_projeid = @ProjeId
					and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
					and YEAR(ns.CreatedOn) = @Year
					and ns.statecode = 0 and new_satisdoviz = 1
				Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn)

			/*
				**************************
				**************************
				**************************
				 YABANCI TÝCARÝ SATIÞLARI
				**************************
				**************************
				**************************
			*/
			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select 'Yabancý Ticari KDV Hariç Hedefler' as [Yabancý Ticari KDV Hariç Satýþlar]
					,YEAR(ns.CreatedOn) as Yil
					,MONTH (ns.CreatedOn) as Ay
					,case ns.new_satisdoviz
						when 1 then Isnull(sum(ns.new_kdvharic),0) 
						when 2 then Isnull(sum(ns.new_ssftlkdvharic),0)
						End Toplam
			from new_satis ns (nolock) 
			inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
			inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi  in('100000000') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
			where ns.new_projeid = @ProjeId
				and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
				and YEAR(ns.CreatedOn) = @Year
				and ns.statecode = 0 
				--and new_satisdoviz = 2
			Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn) ,ns.new_satisdoviz


			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select	'Yabancý Ticari KDV Dahil Tahsilat' as [Yabancý Ticari Dahil Nakit Satýþý]
					,YEAR(o.new_odemezamani) as Yil
					,MONTH(o.new_odemezamani) as Ay
					,case when o.new_TLTutar is not null then o.new_TLTutar else o.new_miktar end as Toplam
			from new_senet se
					inner join new_Satis s on s.new_satisId = se.new_satisid
					inner join Contact c on c.contactId = s.new_contactid --and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
					inner join new_daire nd (nolock) on nd.new_daireId = s.new_daireid and nd.new_konuttipi  in('100000000') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
					inner join new_odeme o on se.new_senetId = o.new_senetid
					left join stringmap sm on sm.ObjectTypeCode = 10030 and sm.AttributeName = 'new_senettipi' and sm.AttributeValue = se.new_SenetTipi
			where s.statecode = 0 and se.statecode = 0 
					and se.new_senettipi not in ('100000001','8','10','11','12','13','24','14','15','16','17','20','21','23','22','26','27','28','29') 
					and o.statecode=0 and new_satisdoviz=2 
					and Year(o.new_odemezamani) = @Year
					and s.new_projeid in (@ProjeId) 
					and o.new_odemezamani < = (GETDATE () +1)
			group by MONTH(o.new_odemezamani),YEAR(o.new_odemezamani), o.new_TLTutar, O.new_miktar 


			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select 'Yabancý Ticari Brüt M2 Hedefleri' as [Yabancý Ticari Brüt M2 Hedefleri Satýþ]
					,YEAR(ns.CreatedOn) as Yil
					,MONTH (ns.CreatedOn) as Ay
					,Isnull(sum(nd.new_UygulamaSatM2),0) Toplam
			from new_satis ns (nolock) 
			inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
			inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi in('100000000') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
			where ns.new_projeid = @ProjeId
				and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
				and YEAR(ns.CreatedOn) = @Year
				and ns.statecode = 0 
				and new_satisdoviz = 2
			Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn)
END
ELSE IF @ProjeId  = 'DE4F981E-27F1-EB11-853A-000C292E580F'
BEGIN
	/*************************************************************************************************************************/
			/*************************************************************************************************************************/
			/********************************** YERLÝ KONUTLARLAR (YERLÝ/YABANCI) ****************************************************/
			/*************************************************************************************************************************/
			/*************************************************************************************************************************/


			/*
				**************************
				**************************
				**************************
				 YERLÝ KONUT SATIÞLARI
				**************************
				**************************
				**************************
			*/
			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select 'Yerli Konut KDV Hariç Hedefler' as [Yerli Konut KDV Hariç Satýþlar]
					,YEAR(ns.CreatedOn) as Yil
					,MONTH (ns.CreatedOn) as Ay
					,case ns.new_satisdoviz
						when 1 then Isnull(sum(ns.new_kdvharic),0) 
						when 2 then Isnull(sum(ns.new_ssftlkdvharic),0)
						End Toplam
			from new_satis ns (nolock) 
			inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
			inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid  /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
			where ns.new_projeid = @ProjeId
				and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
				and YEAR(ns.CreatedOn) = @Year
				and ns.statecode = 0 
				--and new_satisdoviz = 1 /* satýþ kartýnda yabancý olup, müþteri kartýnda türk olanlar geldiðinden yok sayýyoruz*/
			Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn), ns.new_satisdoviz

	
			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select	'Yerli Konut KDV Dahil Tahsilat' as [Yerli KonutKDV Dahil Nakit Satýþý]
					,YEAR(o.new_odemezamani) as Yil
					,MONTH(o.new_odemezamani) as Ay
					,sum(ISNULL(o.new_miktar,0)) as Toplam
			from new_senet se
					inner join new_Satis s on s.new_satisId = se.new_satisid
					inner join Contact c on c.contactId = s.new_contactid --and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
					inner join new_odeme o on se.new_senetId = o.new_senetid
					inner join new_daire nd (nolock) on nd.new_daireId = s.new_daireid  /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
					left join stringmap sm on sm.ObjectTypeCode = 10030 and sm.AttributeName = 'new_senettipi'	and sm.AttributeValue = se.new_SenetTipi
			where s.statecode = 0 and se.statecode = 0 
					and se.new_senettipi not in ('100000001','8','10','11','12','13','24','14','15','16','17','20','21','23','22','26','27','28','29') 
					and o.statecode=0 
					and new_satisdoviz = 1  
					and YEAR(o.new_odemezamani) = @Year
					and s.new_projeid in (@ProjeId)
					and o.new_odemezamani < = (GETDATE () +1) ---##Bunu cerde 2023 yýlýnda TOPLAMHEDEF ayý içindeyken, aralýk ayý tahsilatý göründüðünden koydum.
			group by MONTH(o.new_odemezamani),YEAR(o.new_odemezamani) 


	
			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select 'Yerli Konut Brüt M2 Hedefleri' as [Yerli Konut Brüt M2 Hedefleri Satýþ]
					,YEAR(ns.CreatedOn) as Yil
					,MONTH (ns.CreatedOn) as Ay
					,Isnull(sum(nd.new_brtm2),0) Toplam
			from new_satis ns (nolock) 
			inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
			inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid  /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
			where ns.new_projeid = @ProjeId
				and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
				and YEAR(ns.CreatedOn) = @Year
				and ns.statecode = 0 
				and new_satisdoviz = 1
			Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn)



			/*
				**************************
				**************************
				**************************
				 YABANCI KONUT SATIÞLARI
				**************************
				**************************
				**************************
			*/
			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select 'Yabancý Konut KDV Hariç Hedefler' as [Yabancý Konut KDV Hariç Satýþlar]
					,YEAR(ns.CreatedOn) as Yil
					,MONTH (ns.CreatedOn) as Ay
					,case ns.new_satisdoviz
						when 1 then Isnull(sum(ns.new_kdvharic),0) 
						when 2 then Isnull(sum(ns.new_ssftlkdvharic),dbo.GetUSDPrice(ns.new_kdvharic,ns.CreatedOn))
						End Toplam
			from new_satis ns (nolock) 
			inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
			inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid  /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
			where ns.new_projeid = @ProjeId
				and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
				and YEAR(ns.CreatedOn) = @Year
				and ns.statecode = 0 
				--and new_satisdoviz = 2 /* satýþ kartýnda yabancý olup, müþteri kartýnda türk olanlar geldiðinden yok sayýyoruz*/
			Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn), ns.new_satisdoviz,ns.new_kdvharic,ns.CreatedOn


			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select	'Yabancý Konut KDV Dahil Tahsilat' as [Yabancý KonutKDV Dahil Nakit Satýþý]
					,YEAR(o.new_odemezamani) as Yil
					,MONTH(o.new_odemezamani) as Ay
					,case when o.new_TLTutar is not null then o.new_TLTutar else o.new_miktar end as Toplam
			from new_senet se
					inner join new_Satis s on s.new_satisId = se.new_satisid
					inner join Contact c on c.contactId = s.new_contactid --and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
					inner join new_daire nd (nolock) on nd.new_daireId = s.new_daireid  /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
					inner join new_odeme o on se.new_senetId = o.new_senetid
					left join stringmap sm on sm.ObjectTypeCode = 10030 and sm.AttributeName = 'new_senettipi' and sm.AttributeValue = se.new_SenetTipi
			where s.statecode = 0 and se.statecode = 0 
					and se.new_senettipi not in ('100000001','8','10','11','12','13','24','14','15','16','17','20','21','23','22','26','27','28','29') 
					and o.statecode=0 and new_satisdoviz=2 
					and Year(o.new_odemezamani) = @Year
					and s.new_projeid in (@ProjeId)
					and o.new_odemezamani < = (GETDATE () +1)
			group by MONTH(o.new_odemezamani),YEAR(o.new_odemezamani), o.new_TLTutar, O.new_miktar 


			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select 'Yabancý Konut Brüt M2 Hedefleri' as [Yabancý Konut Brüt M2 Hedefleri Satýþ]
					,YEAR(ns.CreatedOn) as Yil
					,MONTH (ns.CreatedOn) as Ay
					,Isnull(sum(nd.new_brtm2),0) Toplam
			from new_satis ns (nolock) 
			inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
			inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid  /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
			where ns.new_projeid = @ProjeId
				and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
				and YEAR(ns.CreatedOn) = @Year
				and ns.statecode = 0 
				and new_satisdoviz = 2
			Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn)


			/*************************************************************************************************************************/
			/*************************************************************************************************************************/
			/********************************** TÝCARÝ KONUTLARLAR (YERLÝ/YABANCI) ***************************************************/
			/*************************************************************************************************************************/
			/*************************************************************************************************************************/

			/*
				**************************
				**************************
				**************************
				 YERLÝ TÝCARÝ SATIÞLARI
				**************************
				**************************
				**************************
			*/
				insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
				select 'Yerli Ticari KDV Hariç Hedefler' as [Yerli Ticari KDV Hariç Satýþlar]
						,YEAR(ns.CreatedOn) as Yil
						,MONTH (ns.CreatedOn) as Ay
						,case ns.new_satisdoviz
							when 1 then Isnull(sum(ns.new_kdvharic),0) 
							when 2 then Isnull(sum(ns.new_ssftlkdvharic),0)
							End Toplam 
				from new_satis ns (nolock) 
				inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
				inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi  in('100000000') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
				where ns.new_projeid = @ProjeId
					and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
					and YEAR(ns.CreatedOn) = @Year
					and ns.statecode = 0 --and new_satisdoviz = 1
				Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn), ns.new_satisdoviz

	
				insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
				select		'Yerli Ticari KDV Dahil Tahsilat' as [Yerli Ticari Dahil Nakit Satýþý]
							,YEAR(o.new_odemezamani) as Yil
							,MONTH(o.new_odemezamani) as Ay
							,sum(ISNULL(o.new_miktar,0)) as Toplam
				from new_senet se
						inner join new_Satis s on s.new_satisId = se.new_satisid
						inner join Contact c on c.contactId = s.new_contactid --and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
						inner join new_odeme o on se.new_senetId = o.new_senetid
						inner join new_daire nd (nolock) on nd.new_daireId = s.new_daireid and nd.new_konuttipi  in('100000000') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
						left join stringmap sm on sm.ObjectTypeCode = 10030 and sm.AttributeName = 'new_senettipi'	and sm.AttributeValue = se.new_SenetTipi
				where s.statecode = 0 and se.statecode = 0 
						and se.new_senettipi not in ('100000001','8','10','11','12','13','24','14','15','16','17','20','21','23','22','26','27','28','29') 
						and o.statecode=0 and new_satisdoviz = 1  
						and YEAR(o.new_odemezamani) = @Year
						and s.new_projeid in (@ProjeId)
						and o.new_odemezamani < = (GETDATE () +1)
				group by MONTH(o.new_odemezamani),YEAR(o.new_odemezamani) 

	
				insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
				select 'Yerli Ticari Brüt M2 Hedefleri' as [Yerli Ticari Brüt M2 Hedefleri Satýþ]
						,YEAR(ns.CreatedOn) as Yil
						,MONTH (ns.CreatedOn) as Ay
						,Isnull(sum(nd.new_brtm2),0) Toplam
				from new_satis ns (nolock) 
				inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
				inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi  in('100000000') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
				where ns.new_projeid = @ProjeId
					and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
					and YEAR(ns.CreatedOn) = @Year
					and ns.statecode = 0 and new_satisdoviz = 1
				Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn)

			/*
				**************************
				**************************
				**************************
				 YABANCI TÝCARÝ SATIÞLARI
				**************************
				**************************
				**************************
			*/
			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select 'Yabancý Ticari KDV Hariç Hedefler' as [Yabancý Ticari KDV Hariç Satýþlar]
					,YEAR(ns.CreatedOn) as Yil
					,MONTH (ns.CreatedOn) as Ay
					,case ns.new_satisdoviz
						when 1 then Isnull(sum(ns.new_kdvharic),0) 
						when 2 then Isnull(sum(ns.new_ssftlkdvharic),0)
						End Toplam
			from new_satis ns (nolock) 
			inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
			inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi  in('100000000') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
			where ns.new_projeid = @ProjeId
				and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
				and YEAR(ns.CreatedOn) = @Year
				and ns.statecode = 0 
				--and new_satisdoviz = 2
			Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn) ,ns.new_satisdoviz


			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select	'Yabancý Ticari KDV Dahil Tahsilat' as [Yabancý Ticari Dahil Nakit Satýþý]
					,YEAR(o.new_odemezamani) as Yil
					,MONTH(o.new_odemezamani) as Ay
					,case when o.new_TLTutar is not null then o.new_TLTutar else o.new_miktar end as Toplam
			from new_senet se
					inner join new_Satis s on s.new_satisId = se.new_satisid
					inner join Contact c on c.contactId = s.new_contactid --and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
					inner join new_daire nd (nolock) on nd.new_daireId = s.new_daireid and nd.new_konuttipi  in('100000000') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
					inner join new_odeme o on se.new_senetId = o.new_senetid
					left join stringmap sm on sm.ObjectTypeCode = 10030 and sm.AttributeName = 'new_senettipi' and sm.AttributeValue = se.new_SenetTipi
			where s.statecode = 0 and se.statecode = 0 
					and se.new_senettipi not in ('100000001','8','10','11','12','13','24','14','15','16','17','20','21','23','22','26','27','28','29') 
					and o.statecode=0 and new_satisdoviz=2 
					and Year(o.new_odemezamani) = @Year
					and s.new_projeid in (@ProjeId) 
					and o.new_odemezamani < = (GETDATE () +1)
			group by MONTH(o.new_odemezamani),YEAR(o.new_odemezamani), o.new_TLTutar, O.new_miktar 


			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select 'Yabancý Ticari Brüt M2 Hedefleri' as [Yabancý Ticari Brüt M2 Hedefleri Satýþ]
					,YEAR(ns.CreatedOn) as Yil
					,MONTH (ns.CreatedOn) as Ay
					,Isnull(sum(nd.new_brtm2),0) Toplam
			from new_satis ns (nolock) 
			inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
			inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi in('100000000') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
			where ns.new_projeid = @ProjeId
				and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
				and YEAR(ns.CreatedOn) = @Year
				and ns.statecode = 0 
				and new_satisdoviz = 2
			Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn)
END
ELSE
BEGIN	
			/*************************************************************************************************************************/
			/*************************************************************************************************************************/
			/********************************** YERLÝ KONUTLARLAR (YERLÝ/YABANCI) ****************************************************/
			/*************************************************************************************************************************/
			/*************************************************************************************************************************/


			/*
				**************************
				**************************
				**************************
				 YERLÝ KONUT SATIÞLARI
				**************************
				**************************
				**************************
			*/
			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select 'Yerli Konut KDV Hariç Hedefler' as [Yerli Konut KDV Hariç Satýþlar]
					,YEAR(ns.CreatedOn) as Yil
					,MONTH (ns.CreatedOn) as Ay
					,case ns.new_satisdoviz
						when 1 then Isnull(sum(ns.new_kdvharic),0) 
						when 2 then Isnull(sum(ns.new_ssftlkdvharic),0)
						End Toplam
			from new_satis ns (nolock) 
			inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
			inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi not in('100000000') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
			where ns.new_projeid = @ProjeId
				and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
				and YEAR(ns.CreatedOn) = @Year
				and ns.statecode = 0 
				--and new_satisdoviz = 1 /* satýþ kartýnda yabancý olup, müþteri kartýnda türk olanlar geldiðinden yok sayýyoruz*/
			Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn), ns.new_satisdoviz

	
			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select	'Yerli Konut KDV Dahil Tahsilat' as [Yerli KonutKDV Dahil Nakit Satýþý]
					,YEAR(o.new_odemezamani) as Yil
					,MONTH(o.new_odemezamani) as Ay
					,sum(ISNULL(o.new_miktar,0)) as Toplam
			from new_senet se
					inner join new_Satis s on s.new_satisId = se.new_satisid
					inner join Contact c on c.contactId = s.new_contactid --and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
					inner join new_odeme o on se.new_senetId = o.new_senetid
					inner join new_daire nd (nolock) on nd.new_daireId = s.new_daireid and nd.new_konuttipi not in('100000000') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
					left join stringmap sm on sm.ObjectTypeCode = 10030 and sm.AttributeName = 'new_senettipi'	and sm.AttributeValue = se.new_SenetTipi
			where s.statecode = 0 and se.statecode = 0 
					and se.new_senettipi not in ('100000001','8','10','11','12','13','24','14','15','16','17','20','21','23','22','26','27','28','29') 
					and o.statecode=0 
					and new_satisdoviz = 1  
					and YEAR(o.new_odemezamani) = @Year
					and s.new_projeid in (@ProjeId)
					and o.new_odemezamani < = (GETDATE () +1) ---##Bunu cerde 2023 yýlýnda TOPLAMHEDEF ayý içindeyken, aralýk ayý tahsilatý göründüðünden koydum.
			group by MONTH(o.new_odemezamani),YEAR(o.new_odemezamani) 


	
			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select 'Yerli Konut Brüt M2 Hedefleri' as [Yerli Konut Brüt M2 Hedefleri Satýþ]
					,YEAR(ns.CreatedOn) as Yil
					,MONTH (ns.CreatedOn) as Ay
					,Isnull(sum(nd.new_brtm2),0) Toplam
			from new_satis ns (nolock) 
			inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
			inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi not in('100000000') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
			where ns.new_projeid = @ProjeId
				and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
				and YEAR(ns.CreatedOn) = @Year
				and ns.statecode = 0 
				and new_satisdoviz = 1
			Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn)



			/*
				**************************
				**************************
				**************************
				 YABANCI KONUT SATIÞLARI
				**************************
				**************************
				**************************
			*/
			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select 'Yabancý Konut KDV Hariç Hedefler' as [Yabancý Konut KDV Hariç Satýþlar]
					,YEAR(ns.CreatedOn) as Yil
					,MONTH (ns.CreatedOn) as Ay
					,case ns.new_satisdoviz
						when 1 then Isnull(sum(ns.new_kdvharic),0) 
						when 2 then Isnull(sum(ns.new_ssftlkdvharic),dbo.GetUSDPrice(ns.new_kdvharic,ns.CreatedOn))
						End Toplam
			from new_satis ns (nolock) 
			inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
			inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi not in('100000000') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
			where ns.new_projeid = @ProjeId
				and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
				and YEAR(ns.CreatedOn) = @Year
				and ns.statecode = 0 
				--and new_satisdoviz = 2 /* satýþ kartýnda yabancý olup, müþteri kartýnda türk olanlar geldiðinden yok sayýyoruz*/
			Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn), ns.new_satisdoviz,ns.new_kdvharic,ns.CreatedOn


			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select	'Yabancý Konut KDV Dahil Tahsilat' as [Yabancý KonutKDV Dahil Nakit Satýþý]
					,YEAR(o.new_odemezamani) as Yil
					,MONTH(o.new_odemezamani) as Ay
					,case when o.new_TLTutar is not null then o.new_TLTutar else o.new_miktar end as Toplam
			from new_senet se
					inner join new_Satis s on s.new_satisId = se.new_satisid
					inner join Contact c on c.contactId = s.new_contactid --and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
					inner join new_daire nd (nolock) on nd.new_daireId = s.new_daireid and nd.new_konuttipi not in('100000000') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
					inner join new_odeme o on se.new_senetId = o.new_senetid
					left join stringmap sm on sm.ObjectTypeCode = 10030 and sm.AttributeName = 'new_senettipi' and sm.AttributeValue = se.new_SenetTipi
			where s.statecode = 0 and se.statecode = 0 
					and se.new_senettipi not in ('100000001','8','10','11','12','13','24','14','15','16','17','20','21','23','22','26','27','28','29') 
					and o.statecode=0 and new_satisdoviz=2 
					and Year(o.new_odemezamani) = @Year
					and s.new_projeid in (@ProjeId)
					and o.new_odemezamani < = (GETDATE () +1)
			group by MONTH(o.new_odemezamani),YEAR(o.new_odemezamani), o.new_TLTutar, O.new_miktar 


			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select 'Yabancý Konut Brüt M2 Hedefleri' as [Yabancý Konut Brüt M2 Hedefleri Satýþ]
					,YEAR(ns.CreatedOn) as Yil
					,MONTH (ns.CreatedOn) as Ay
					,Isnull(sum(nd.new_brtm2),0) Toplam
			from new_satis ns (nolock) 
			inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
			inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi not in('100000000') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
			where ns.new_projeid = @ProjeId
				and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
				and YEAR(ns.CreatedOn) = @Year
				and ns.statecode = 0 
				and new_satisdoviz = 2
			Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn)


			/*************************************************************************************************************************/
			/*************************************************************************************************************************/
			/********************************** TÝCARÝ KONUTLARLAR (YERLÝ/YABANCI) ***************************************************/
			/*************************************************************************************************************************/
			/*************************************************************************************************************************/

			/*
				**************************
				**************************
				**************************
				 YERLÝ TÝCARÝ SATIÞLARI
				**************************
				**************************
				**************************
			*/
				insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
				select 'Yerli Ticari KDV Hariç Hedefler' as [Yerli Ticari KDV Hariç Satýþlar]
						,YEAR(ns.CreatedOn) as Yil
						,MONTH (ns.CreatedOn) as Ay
						,case ns.new_satisdoviz
							when 1 then Isnull(sum(ns.new_kdvharic),0) 
							when 2 then Isnull(sum(ns.new_ssftlkdvharic),0)
							End Toplam 
				from new_satis ns (nolock) 
				inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
				inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi  in('100000000') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
				where ns.new_projeid = @ProjeId
					and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
					and YEAR(ns.CreatedOn) = @Year
					and ns.statecode = 0 --and new_satisdoviz = 1
				Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn), ns.new_satisdoviz

	
				insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
				select		'Yerli Ticari KDV Dahil Tahsilat' as [Yerli Ticari Dahil Nakit Satýþý]
							,YEAR(o.new_odemezamani) as Yil
							,MONTH(o.new_odemezamani) as Ay
							,sum(ISNULL(o.new_miktar,0)) as Toplam
				from new_senet se
						inner join new_Satis s on s.new_satisId = se.new_satisid
						inner join Contact c on c.contactId = s.new_contactid --and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
						inner join new_odeme o on se.new_senetId = o.new_senetid
						inner join new_daire nd (nolock) on nd.new_daireId = s.new_daireid and nd.new_konuttipi  in('100000000') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
						left join stringmap sm on sm.ObjectTypeCode = 10030 and sm.AttributeName = 'new_senettipi'	and sm.AttributeValue = se.new_SenetTipi
				where s.statecode = 0 and se.statecode = 0 
						and se.new_senettipi not in ('100000001','8','10','11','12','13','24','14','15','16','17','20','21','23','22','26','27','28','29') 
						and o.statecode=0 and new_satisdoviz = 1  
						and YEAR(o.new_odemezamani) = @Year
						and s.new_projeid in (@ProjeId)
						and o.new_odemezamani < = (GETDATE () +1)
				group by MONTH(o.new_odemezamani),YEAR(o.new_odemezamani) 

	
				insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
				select 'Yerli Ticari Brüt M2 Hedefleri' as [Yerli Ticari Brüt M2 Hedefleri Satýþ]
						,YEAR(ns.CreatedOn) as Yil
						,MONTH (ns.CreatedOn) as Ay
						,Isnull(sum(nd.new_brtm2),0) Toplam
				from new_satis ns (nolock) 
				inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
				inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi  in('100000000') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
				where ns.new_projeid = @ProjeId
					and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
					and YEAR(ns.CreatedOn) = @Year
					and ns.statecode = 0 and new_satisdoviz = 1
				Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn)

			/*
				**************************
				**************************
				**************************
				 YABANCI TÝCARÝ SATIÞLARI
				**************************
				**************************
				**************************
			*/
			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select 'Yabancý Ticari KDV Hariç Hedefler' as [Yabancý Ticari KDV Hariç Satýþlar]
					,YEAR(ns.CreatedOn) as Yil
					,MONTH (ns.CreatedOn) as Ay
					,case ns.new_satisdoviz
						when 1 then Isnull(sum(ns.new_kdvharic),0) 
						when 2 then Isnull(sum(ns.new_ssftlkdvharic),0)
						End Toplam
			from new_satis ns (nolock) 
			inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
			inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi  in('100000000') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
			where ns.new_projeid = @ProjeId
				and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
				and YEAR(ns.CreatedOn) = @Year
				and ns.statecode = 0 
				--and new_satisdoviz = 2
			Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn) ,ns.new_satisdoviz


			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select	'Yabancý Ticari KDV Dahil Tahsilat' as [Yabancý Ticari Dahil Nakit Satýþý]
					,YEAR(o.new_odemezamani) as Yil
					,MONTH(o.new_odemezamani) as Ay
					,case when o.new_TLTutar is not null then o.new_TLTutar else o.new_miktar end as Toplam
			from new_senet se
					inner join new_Satis s on s.new_satisId = se.new_satisid
					inner join Contact c on c.contactId = s.new_contactid --and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
					inner join new_daire nd (nolock) on nd.new_daireId = s.new_daireid and nd.new_konuttipi  in('100000000') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
					inner join new_odeme o on se.new_senetId = o.new_senetid
					left join stringmap sm on sm.ObjectTypeCode = 10030 and sm.AttributeName = 'new_senettipi' and sm.AttributeValue = se.new_SenetTipi
			where s.statecode = 0 and se.statecode = 0 
					and se.new_senettipi not in ('100000001','8','10','11','12','13','24','14','15','16','17','20','21','23','22','26','27','28','29') 
					and o.statecode=0 and new_satisdoviz=2 
					and Year(o.new_odemezamani) = @Year
					and s.new_projeid in (@ProjeId) 
					and o.new_odemezamani < = (GETDATE () +1)
			group by MONTH(o.new_odemezamani),YEAR(o.new_odemezamani), o.new_TLTutar, O.new_miktar 


			insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
			select 'Yabancý Ticari Brüt M2 Hedefleri' as [Yabancý Ticari Brüt M2 Hedefleri Satýþ]
					,YEAR(ns.CreatedOn) as Yil
					,MONTH (ns.CreatedOn) as Ay
					,Isnull(sum(nd.new_brtm2),0) Toplam
			from new_satis ns (nolock) 
			inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
			inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi in('100000000') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
			where ns.new_projeid = @ProjeId
				and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
				and YEAR(ns.CreatedOn) = @Year
				and ns.statecode = 0 
				and new_satisdoviz = 2
			Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn)

END



/*YERLÝ ZÝYARETÇÝ HEDEF*/
insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
select 'Yerli Ziyaretçi Hedefi' as [Yerli Ziyaretçi Hedefi]
		,YEAR(sf.CreatedOn) as Yil
		,MONTH (sf.CreatedOn) as Ay
		,isnull(sum(sf.tpl),0) Toplam
 from 
 (select new_projeId, statecode from new_proje where new_projeId =@ProjeId) p
left join ( select  opp.new_projeid ,count(*) tpl, opp.CreatedOn from new_satisfirsat opp 
			where 1=1
				and new_gorusmeturu = 1
				AND YEAR(Createdon)= @Year
				and new_projeid = @ProjeId
			group by opp.CreatedOn,opp.new_projeid) sf on sf.new_projeid = p.new_projeId
where p.statecode = 0 
	and YEAR(sf.CreatedOn)= @Year
Group by MONTH (sf.CreatedOn), YEAR(sf.CreatedOn),sf.tpl


/*
*******************************************
*******************************************
				TOPLAM SATIS / IPTAL 
*******************************************
*******************************************
*/


Declare @x int = 1


while @x < 13
BEGIN
insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
select  'Satis_Adedi' as [Satis Adedi]
		,@Year as Yil
		,@x as Ay
		,isnull(s.tpl,0) as satissay
 from 
 (select * from new_proje where new_projeId =@ProjeId) p
left join (
select  opp.new_projeid ,count(*) tpl from new_satisfirsat opp
inner join Contact c on opp.new_contactid=c.ContactId
where 1=1
and opp.new_gorusmeturu=1
and MONTH(opp.createdon)=@x AND YEAR(opp.Createdon)=@Year
and opp.new_projeid = @ProjeId and c.new_milliyet IN (1,3)
group by opp.new_projeid) sf on sf.new_projeid = p.new_projeId
left join (
select  opp.new_projeid ,count(*) tpl from new_satisfirsat opp
inner join Contact c on opp.new_contactid=c.ContactId
where 1=1
and opp.new_gorusmeturu=1
and MONTH(opp.createdon)=@x AND YEAR(opp.Createdon)=@Year
and opp.new_projeid =@ProjeId and c.new_milliyet IN (2)
group by opp.new_projeid) sfy on sf.new_projeid = p.new_projeId

left join (
select   new_projeid , count(*) tpl from new_satis
where 1=1
and new_projeid =@ProjeId
and MONTH(createdon)=@x AND YEAR(Createdon)=@Year
and statecode = 0
group by new_projeid
) s on s.new_projeid = p.new_projeId
left join (
select   new_projeid,  sum(isnull((case s.new_satisdoviz when 2 then
(case when new_networkkomisyon is null then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) when new_NetworkKomisyon=0 then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) else dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)-(dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)*(new_NetworkKomisyon/100)) end) 
else
(case when new_networkkomisyon is null then new_kdvharic when new_NetworkKomisyon=0 then new_kdvharic else s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)) end) end ),0)) tpl from new_satis s
where 1=1
and MONTH(createdon)=@x AND YEAR(Createdon)=@Year
and new_projeid= @ProjeId
and statecode = 0
group by new_projeid
) sc on sc.new_projeid = s.new_projeid
left join (
select   s.new_projeid,  sum(isnull((case when new_networkkomisyon is null then new_kdvharic when new_NetworkKomisyon=0 then new_kdvharic else s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)) end),0)) tpl from new_satis s
inner join Contact c on c.ContactId=s.new_contactid
where 1=1
and MONTH(s.createdon)=@x AND YEAR(s.Createdon)=@Year
and s.new_projeid= @ProjeId
and s.statecode = 0 and s.new_satisdoviz=1
group by s.new_projeid
) syerli on syerli.new_projeid = s.new_projeid
left join (
select   s.new_projeid,  sum(isnull((case when new_networkkomisyon is null then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) when new_NetworkKomisyon=0 then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) else dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)-(dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)*(new_NetworkKomisyon/100)) end) ,0)) tpl from new_satis s
inner join Contact c on c.ContactId=s.new_contactid
where 1=1
and MONTH(s.createdon)=@x AND YEAR(s.Createdon)=@Year
and s.new_projeid= @ProjeId
and s.statecode = 0 and s.new_satisdoviz=2
group by s.new_projeid
) sYAB on syab.new_projeid = s.new_projeid
left join 
(select d.new_projeid ,sum(isnull(d.new_brtm2,0)) satism2
, sum(isnull(s.new_kdvharic,0)) satisfiyat
 from new_satis s
inner join new_daire d on d.new_daireId = s.new_daireid
left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
where 1=1 and d.new_satisdurumu in (3,5,6)
and s.new_projeid = @ProjeId
and MONTH(s.createdon)=@x AND YEAR(s.Createdon)=@Year
and s.statecode = 0
group by d.new_projeid
)ss on ss.new_projeid = p.new_projeId
left join (
select   new_projeid , count(*) tpl from new_satis
where 1=1
and new_projeid =@ProjeId
and MONTH(createdon)=@x AND YEAR(Createdon)=@Year
group by new_projeid
) tot on s.new_projeid = p.new_projeId
left join (
select   new_projeid , count(*) tpl from new_satis s
where 1=1
and s.new_projeid = @ProjeId
and MONTH(s.createdon)=@x AND YEAR(s.Createdon)=@Year
and s.new_iptaldurum not in (100000005, 100000007,100000006)
and s.statecode=1
group by new_projeid
) ipt on ipt.new_projeid = p.new_projeId

left join(
Select t.new_projeid, sum(t.tah) tah from
(select o.new_odemeId, sa.new_projeid, Sum(o.new_miktar) tah from new_odeme o 
left join new_senet s on s.new_senetId=o.new_senetid 
left join new_satis sa on sa.new_satisId=s.new_satisid 
left join Contact c on c.ContactId=sa.new_contactid
where sa.new_projeid = @ProjeId
and o.statecode=0 and sa.statecode=0 and MONTH(o.new_odemezamani)=1 AND YEAR(o.new_odemezamani)=@Year and sa.new_satisdoviz=1 and s.new_senettipi in (5,1,2,3,4,9,6,7,19,25) 
group by sa.new_projeid,o.new_odemeId)t group by t.new_projeid
) 
tahyerli on tahyerli.new_projeid=p.new_projeId
left join(
Select t.new_projeid, sum(t.tah) tah from
(select o.new_odemeId, sa.new_projeid, ISNULL(sum(dbo.GetUSDPrice(o.new_miktar,o.new_odemezamani)),0)tah from new_odeme o 
left join new_senet s on s.new_senetId=o.new_senetid 
left join new_satis sa on sa.new_satisId=s.new_satisid 
left join Contact c on c.ContactId=sa.new_contactid
where sa.new_projeid = @ProjeId 
and o.statecode=0 and sa.statecode=0 and MONTH(o.new_odemezamani)=1 AND YEAR(o.new_odemezamani)=@Year and sa.new_satisdoviz=2 and s.new_senettipi in (5,1,2,3,4,9,6,7,19,25) 
group by sa.new_projeid,o.new_odemeId)t group by t.new_projeid) 
tahyab on tahyab.new_projeid=p.new_projeId
left join
(select new_proje, count(*) tpl from PhoneCall p
where  new_proje = @ProjeId
and MONTH(p.ModifiedOn)=@x AND YEAR(p.ModifiedOn)=@Year
and new_derecelendirme not in ('100000005','100000007','100000017','100000008') and p.statecode=1 and p.ModifiedBy NOT IN ('{D83A1502-3D63-E911-8110-E4115B13BF35}','{827C3532-A222-E811-80E5-E4115B13BF35}','{EADECB3A-886A-E911-8110-E4115B13BF35}','{5B37C0C9-2E2E-EA11-8111-E4115B13BF35}','{171DD2B8-D760-E911-8110-E4115B13BF35}')
group by new_proje
) arama on arama.new_Proje=p.new_projeId

/*******************************************************************************/
/*******************************************************************************/
/*******************************************************************************/
/*******************************************************************************/
/*******************************************************************************/

insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam) 
select  'Iptal_Adedi' as [Iptal Adedi]
		,@Year as Yil
		,@x as Ay
		,CAST(isnull(ipt.tpl,0) as DECIMAL (18,0)) as iptaladet
 from 
 (select * from new_proje where new_projeId =@ProjeId) p
left join (
select  opp.new_projeid ,count(*) tpl from new_satisfirsat opp
inner join Contact c on opp.new_contactid=c.ContactId
where 1=1
and opp.new_gorusmeturu=1
and MONTH(opp.createdon)=@x AND YEAR(opp.Createdon)=@Year
and opp.new_projeid = @ProjeId and c.new_milliyet IN (1,3)
group by opp.new_projeid) sf on sf.new_projeid = p.new_projeId
left join (
select  opp.new_projeid ,count(*) tpl from new_satisfirsat opp
inner join Contact c on opp.new_contactid=c.ContactId
where 1=1
and opp.new_gorusmeturu=1
and MONTH(opp.createdon)=@x AND YEAR(opp.Createdon)=@Year
and opp.new_projeid =@ProjeId and c.new_milliyet IN (2)
group by opp.new_projeid) sfy on sf.new_projeid = p.new_projeId

left join (
select   new_projeid , count(*) tpl from new_satis
where 1=1
and new_projeid =@ProjeId
and MONTH(createdon)=@x AND YEAR(Createdon)=@Year
and statecode = 0
group by new_projeid
) s on s.new_projeid = p.new_projeId
left join (
select   new_projeid,  sum(isnull((case s.new_satisdoviz when 2 then
(case when new_networkkomisyon is null then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) when new_NetworkKomisyon=0 then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) else dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)-(dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)*(new_NetworkKomisyon/100)) end) 
else
(case when new_networkkomisyon is null then new_kdvharic when new_NetworkKomisyon=0 then new_kdvharic else s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)) end) end ),0)) tpl from new_satis s
where 1=1
and MONTH(createdon)=@x AND YEAR(Createdon)=@Year
and new_projeid= @ProjeId
and statecode = 0
group by new_projeid
) sc on sc.new_projeid = s.new_projeid
left join (
select   s.new_projeid,  sum(isnull((case when new_networkkomisyon is null then new_kdvharic when new_NetworkKomisyon=0 then new_kdvharic else s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)) end),0)) tpl from new_satis s
inner join Contact c on c.ContactId=s.new_contactid
where 1=1
and MONTH(s.createdon)=@x AND YEAR(s.Createdon)=@Year
and s.new_projeid= @ProjeId
and s.statecode = 0 and s.new_satisdoviz=1
group by s.new_projeid
) syerli on syerli.new_projeid = s.new_projeid
left join (
select   s.new_projeid,  sum(isnull((case when new_networkkomisyon is null then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) when new_NetworkKomisyon=0 then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) else dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)-(dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)*(new_NetworkKomisyon/100)) end) ,0)) tpl from new_satis s
inner join Contact c on c.ContactId=s.new_contactid
where 1=1
and MONTH(s.createdon)=@x AND YEAR(s.Createdon)=@Year
and s.new_projeid= @ProjeId
and s.statecode = 0 and s.new_satisdoviz=2
group by s.new_projeid
) sYAB on syab.new_projeid = s.new_projeid
left join 
(select d.new_projeid ,sum(isnull(d.new_brtm2,0)) satism2
, sum(isnull(s.new_kdvharic,0)) satisfiyat
 from new_satis s
inner join new_daire d on d.new_daireId = s.new_daireid
left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
where 1=1 and d.new_satisdurumu in (3,5,6)
and s.new_projeid = @ProjeId
and MONTH(s.createdon)=@x AND YEAR(s.Createdon)=@Year
and s.statecode = 0
group by d.new_projeid
)ss on ss.new_projeid = p.new_projeId
left join (
select   new_projeid , count(*) tpl from new_satis
where 1=1
and new_projeid =@ProjeId
and MONTH(createdon)=@x AND YEAR(Createdon)=@Year
group by new_projeid
) tot on s.new_projeid = p.new_projeId
left join (
select   new_projeid , count(*) tpl from new_satis s
where 1=1
and s.new_projeid = @ProjeId
and MONTH(s.createdon)=@x AND YEAR(s.Createdon)=@Year
and s.new_iptaldurum not in (100000005, 100000007,100000006)
and s.statecode=1
group by new_projeid
) ipt on ipt.new_projeid = p.new_projeId

left join(
Select t.new_projeid, sum(t.tah) tah from
(select o.new_odemeId, sa.new_projeid, Sum(o.new_miktar) tah from new_odeme o 
left join new_senet s on s.new_senetId=o.new_senetid 
left join new_satis sa on sa.new_satisId=s.new_satisid 
left join Contact c on c.ContactId=sa.new_contactid
where sa.new_projeid = @ProjeId
and o.statecode=0 and sa.statecode=0 and MONTH(o.new_odemezamani)=1 AND YEAR(o.new_odemezamani)=@Year and sa.new_satisdoviz=1 and s.new_senettipi in (5,1,2,3,4,9,6,7,19,25) 
group by sa.new_projeid,o.new_odemeId)t group by t.new_projeid
) 
tahyerli on tahyerli.new_projeid=p.new_projeId
left join(
Select t.new_projeid, sum(t.tah) tah from
(select o.new_odemeId, sa.new_projeid, ISNULL(sum(dbo.GetUSDPrice(o.new_miktar,o.new_odemezamani)),0)tah from new_odeme o 
left join new_senet s on s.new_senetId=o.new_senetid 
left join new_satis sa on sa.new_satisId=s.new_satisid 
left join Contact c on c.ContactId=sa.new_contactid
where sa.new_projeid = @ProjeId 
and o.statecode=0 and sa.statecode=0 and MONTH(o.new_odemezamani)=1 AND YEAR(o.new_odemezamani)=@Year and sa.new_satisdoviz=2 and s.new_senettipi in (5,1,2,3,4,9,6,7,19,25) 
group by sa.new_projeid,o.new_odemeId)t group by t.new_projeid) 
tahyab on tahyab.new_projeid=p.new_projeId
left join
(select new_proje, count(*) tpl from PhoneCall p
where  new_proje = @ProjeId
and MONTH(p.ModifiedOn)=@x AND YEAR(p.ModifiedOn)=@Year
and new_derecelendirme not in ('100000005','100000007','100000017','100000008') and p.statecode=1 and p.ModifiedBy NOT IN ('{D83A1502-3D63-E911-8110-E4115B13BF35}','{827C3532-A222-E811-80E5-E4115B13BF35}','{EADECB3A-886A-E911-8110-E4115B13BF35}','{5B37C0C9-2E2E-EA11-8111-E4115B13BF35}','{171DD2B8-D760-E911-8110-E4115B13BF35}')
group by new_proje
) arama on arama.new_Proje=p.new_projeId

Set @x = @x + 1
END



/*
*******************************************
*******************************************
				PIVOT TABLE 
*******************************************
*******************************************
*/

declare @Count int
Set @Count = (select COUNT(*) from #tmp_pivot t where t.SubjectName = ISNULL(@TargetName,t.SubjectName))


IF @Count >0
BEGIN
SELECT   SubjectName  as HedefTipi
		, isnull([01],0) as [OCAK]
		, isnull([02],0) as [SUBAT] 
		, isnull([03],0) as [MART]
		, isnull([04],0) as [NISAN]
		, isnull([05],0) as [MAYIS]
		, isnull([06],0) as [HAZIRAN]
		, isnull([07],0) as [TEMMUZ]
		, isnull([08],0) as [AGUSTOS]
		, isnull([09],0) as [EYLUL]
		, isnull([10],0) as [EKIM]
		, isnull([11],0) as [KASIM]
		, isnull([12],0) as [ARALIK]
		, isnull([01],0)+isnull([02],0)+isnull([03],0)+isnull([04],0)+isnull([05],0)+isnull([06],0)+isnull([07],0)+isnull([08],0)+isnull([09],0)+isnull([10],0)+isnull([11],0)+isnull([12],0) as [TOPLAMHEDEF]
		, 2 as FLAG
FROM  
(

  SELECT t.SubjectName,t.Yil, t.Ay, t.Toplam   
  FROM #tmp_pivot t
  where t.SubjectName = Isnull(@TargetName,t.SubjectName)

) AS SourceTable  
PIVOT  
(  
  SUM(Toplam)  
  FOR Ay IN ([01], [02], [03], [04], [05], [06], [07], [08], [09], [10], [11], [12])  
) AS PivotTable;  
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
					<td>TestDashboard2023_GerceklesenHedefler</td>
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

		EXEC msdb..sp_send_dbmail @profile_name = 'EgeYapi', @recipients = 'onur.gultekin@egeyapi.com', @subject = 'TestDashboard2023_GerceklesenHedefler SPsinde ERROR', @body = @Body, @body_format='HTML'
END CATCH
GO


