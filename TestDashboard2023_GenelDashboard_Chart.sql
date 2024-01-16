USE [egeyapi_MSCRM]
GO

/****** Object:  StoredProcedure [dbo].[TestDashboard2023_GenelDashboard_Chart]    Script Date: 27.02.2023 11:04:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Onur Gültekin
-- Create date: 15.02.2023
-- Description:	Genel Dashboard Grafik ve Tablolarýn beslendiði sp.
-- =============================================
CREATE PROCEDURE [dbo].[TestDashboard2023_GenelDashboard_Chart]
	@TargetNumber varchar(50) =null
	
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
	*/
   /*
	1- Toptan Satýþ Ciro
	2- Satýþ/Stok Gelir
	3- Satýþ/Stok Alan
	4- Grafik Chart
	5- Stok Konut Tablosu
	6- Stok Ticari Tablosu
	7- Satýlan Konut Tablosu
	8- Satýlan Ticari Tablosu
   */

If @TargetNumber = 1
BEGIN
		Drop table if exists #tmp1

		Create Table #tmp1
		(
			toplam float
		)

		/************************	CER ÝSTANBUL ************
		***********************---- BEGIN ----************/
		insert into #tmp1 (toplam)
		select case ns.new_satisdoviz
					when 1 then Isnull(sum(ns.new_kdvharic),0) 
					when 2 then Isnull(sum(ns.new_ssftlkdvharic),dbo.GetUSDPrice(ns.new_kdvharic,ns.CreatedOn))
					End Toplam
		from new_satis ns
		where  new_projeid= '9F2C9D29-59D6-E611-80FE-3417EBEAECF3'
		and statecode = 0
		group by new_satisdoviz, ns.new_kdvharic,ns.CreatedOn
		
		/******************** ÇAMLIYAKA KONAKLARI *********
		***********************---- BEGIN ----************/
		insert into #tmp1
		select case ns.new_satisdoviz
			when 1 then Isnull(sum(ns.new_kdvharic),0) 
			when 2 then Isnull(sum(ns.new_ssftlkdvharic),dbo.GetUSDPrice(ns.new_kdvharic,ns.CreatedOn))
			End Toplam
		from new_satis ns
		where  new_projeid= '7265A677-66AA-E611-80E6-3417EBEAECF3'
		and statecode = 0
		group by new_satisdoviz, ns.new_kdvharic,ns.CreatedOn

		/******************** KEKLÝKTEPE ******************
		***********************---- BEGIN ----************/
		insert into #tmp1
		select case ns.new_satisdoviz
			when 1 then Isnull(sum(ns.new_kdvharic),0) 
			when 2 then Isnull(sum(ns.new_ssftlkdvharic),dbo.GetUSDPrice(ns.new_kdvharic,ns.CreatedOn))
			End Toplam
		from new_satis ns
		where  new_projeid= '0C13E4A5-F358-EC11-85A7-000C292E580F'
		and statecode = 0
		group by new_satisdoviz, ns.new_kdvharic,ns.CreatedOn

		/******************** KORDON **********************
		***********************---- BEGIN ----************/
		insert into #tmp1
		select case ns.new_satisdoviz
			when 1 then Isnull(sum(ns.new_kdvharic),0) 
			when 2 then Isnull(sum(ns.new_ssftlkdvharic),dbo.GetUSDPrice(ns.new_kdvharic,ns.CreatedOn))
			End Toplam
		from new_satis ns
		where  new_projeid= 'BE547B6F-B78F-E611-80D2-3417EBEAECF3'
		and statecode = 0
		group by new_satisdoviz, ns.new_kdvharic,ns.CreatedOn

		/******************** MODERNYAKA ******************
		***********************---- BEGIN ----************/
		insert into #tmp1
		select case ns.new_satisdoviz
			when 1 then Isnull(sum(ns.new_kdvharic),0) 
			when 2 then Isnull(sum(ns.new_ssftlkdvharic),dbo.GetUSDPrice(ns.new_kdvharic,ns.CreatedOn))
			End Toplam
		from new_satis ns
		where  new_projeid= '361D6FC3-22A7-EB11-844C-000C292E580F'
		and statecode = 0
		group by new_satisdoviz, ns.new_kdvharic,ns.CreatedOn

		/******************** RADISSON BLU ******************
		***********************---- BEGIN ----************/
		--insert into #tmp1
		--select case ns.new_satisdoviz
		--	when 1 then Isnull(sum(ns.new_kdvharic),0) 
		--	when 2 then Isnull(sum(ns.new_ssftlkdvharic),dbo.GetUSDPrice(ns.new_kdvharic,ns.CreatedOn))
		--	End Toplam
		--from new_satis ns
		--where  new_projeid= 'DE4F981E-27F1-EB11-853A-000C292E580F'
		--and statecode = 0
		--group by new_satisdoviz, ns.new_kdvharic,ns.CreatedOn

		/******************** THE SPORIOR...******************
		***********************---- BEGIN ----************/
		insert into #tmp1
		select case ns.new_satisdoviz
					when 1 then Isnull(sum(ns.new_kdvharic),0) 
					when 2 then Isnull(sum(ns.new_ssftlkdvharic),dbo.GetUSDPrice(ns.new_kdvharic,ns.CreatedOn))
					End Toplam
		from new_satis ns
		where  new_projeid= 'B94D6764-1D20-EB11-82A7-000C292E580F'
		and statecode = 0
		group by new_satisdoviz, ns.new_kdvharic,ns.CreatedOn


		select sum(toplam) as total from #tmp1

END

IF @TargetNumber = 2
BEGIN
			Drop table if exists #tmp2
			Drop table if exists #tmp2_

			Declare @TargetYear varchar(10)
					,@New_PesinFiyatOran float

			Set @TargetYear = (select top 1 sm.AttributeValue 
										from StringMapBase (nolock) sm 
										where sm.AttributeName = 'new_HedefYil' 
											and sm.value = Year(GETDATE())
								)



			Create table #tmp2
			(
			 a varchar(10),
			 b float
			)

			Create table #tmp2_
			(
			 a varchar(10),
			 total varchar(10),
			 b float
			)

		/************************************************* 
		******************** CER ÝSTANBUL ****************
		***********************---- BEGIN ----************/
			Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																when 0 then 1
																else max(nsh.new_PesinFiyatOran)
															End) as float)  
			
												from new_satishedef nsh (nolock)
												where nsh.statecode = 0
													and nsh.new_projeid = '9F2C9D29-59D6-E611-80FE-3417EBEAECF3'
													and nsh.new_HedefYil = @TargetYear
													and nsh.new_PesinFiyatOran is not null )

			insert into #tmp2
			select 'Stok' as a
				, sum(new_kdvharicfiyat)* @New_PesinFiyatOran b 
				from new_daire ns
				where new_projeid='9F2C9D29-59D6-E611-80FE-3417EBEAECF3' and new_satisdurumu in (1,6)

			insert into #tmp2
			select 'Satýþ' as a
					,case s.new_satisdoviz
						when 1 then Isnull(sum(s.new_kdvharic),0) 
						when 2 then Isnull(sum(s.new_ssftlkdvharic) , dbo.GetUSDPrice(s.new_kdvharic,s.CreatedOn))
						End  b
			from new_satis s
			inner join new_daire d on d.new_daireId=s.new_daireid
			where  s.new_projeid= '9F2C9D29-59D6-E611-80FE-3417EBEAECF3' 
			and s.statecode = 0
			group by new_satisdoviz, s.new_kdvharic,s.CreatedOn

			insert into #tmp2_ (a,b)
			select a
					,sum(b) b
			from #tmp2
			group by a
		/************************************************* 
		******************** CER ÝSTANBUL ****************
		***********************---- END  ---**************/


		/************************************************* 
		******************** ÇAMLIYAKA KONAKLARI *********
		***********************---- BEGIN ----************/
			Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																when 0 then 1
																else max(nsh.new_PesinFiyatOran)
															End) as float)  
			
												from new_satishedef nsh (nolock)
												where nsh.statecode = 0
													and nsh.new_projeid = '7265A677-66AA-E611-80E6-3417EBEAECF3'
													and nsh.new_HedefYil = @TargetYear
													and nsh.new_PesinFiyatOran is not null )

			insert into #tmp2
			select 'Stok' as a
				, sum(new_kdvharicfiyat)* @New_PesinFiyatOran b 
				from new_daire ns
				where new_projeid='7265A677-66AA-E611-80E6-3417EBEAECF3' and new_satisdurumu in (1)

			insert into #tmp2
			select 'Satýþ' as a
					,case s.new_satisdoviz
						when 1 then Isnull(sum(s.new_kdvharic),0) 
						when 2 then Isnull(sum(s.new_ssftlkdvharic) , dbo.GetUSDPrice(s.new_kdvharic,s.CreatedOn))
						End  b
			from new_satis s
			inner join new_daire d on d.new_daireId=s.new_daireid
			where  s.new_projeid= '7265A677-66AA-E611-80E6-3417EBEAECF3' 
			and s.statecode = 0
			group by new_satisdoviz, s.new_kdvharic,s.CreatedOn


			insert into #tmp2_ (a,b)
			select a
					,sum(b) b
			from #tmp2
			group by a
		/************************************************* 
		******************** ÇAMLIYAKA KONAKLARI *********
		***********************---- END ----**************/

		/************************************************* 
		******************** KEKLÝKTEPE ******************
		***********************---- BEGIN ----************/
			Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																when 0 then 1
																else max(nsh.new_PesinFiyatOran)
															End) as float)  
			
												from new_satishedef nsh (nolock)
												where nsh.statecode = 0
													and nsh.new_projeid = '0C13E4A5-F358-EC11-85A7-000C292E580F'
													and nsh.new_HedefYil = @TargetYear
													and nsh.new_PesinFiyatOran is not null )


			insert into #tmp2
			select 'Stok' as a
				, sum(new_kdvharicfiyat)* @New_PesinFiyatOran b 
				from new_daire ns
				where new_projeid='0C13E4A5-F358-EC11-85A7-000C292E580F' and new_satisdurumu in (1,6,7)

			insert into #tmp2
			select 'Satýþ' as a
					,case s.new_satisdoviz
						when 1 then Isnull(sum(s.new_kdvharic),0) 
						when 2 then Isnull(sum(s.new_ssftlkdvharic) , dbo.GetUSDPrice(s.new_kdvharic,s.CreatedOn))
						End  b
			from new_satis s
			inner join new_daire d on d.new_daireId=s.new_daireid
			where  s.new_projeid= '0C13E4A5-F358-EC11-85A7-000C292E580F' 
			and s.statecode = 0
			group by new_satisdoviz, s.new_kdvharic,s.CreatedOn

			insert into #tmp2_ (a,b)
			select a
					,sum(b) b
			from #tmp2
			group by a
		/************************************************* 
		******************** KEKLÝKTEPE ******************
		***********************---- BEGIN ----************/


		/************************************************* 
		******************** KORDON **********************
		***********************---- BEGIN ----************/
			Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																when 0 then 1
																else max(nsh.new_PesinFiyatOran)
															End) as float)  
			
												from new_satishedef nsh (nolock)
												where nsh.statecode = 0
													and nsh.new_projeid = 'BE547B6F-B78F-E611-80D2-3417EBEAECF3'
													and nsh.new_HedefYil = @TargetYear
													and nsh.new_PesinFiyatOran is not null )


			insert into #tmp2
			select 'Stok' as a
				, sum(new_kdvharicfiyat)* @New_PesinFiyatOran b 
				from new_daire ns
				where new_projeid='BE547B6F-B78F-E611-80D2-3417EBEAECF3' and new_satisdurumu in (1,6)

			insert into #tmp2
			select 'Satýþ' as a
					,case s.new_satisdoviz
						when 1 then Isnull(sum(s.new_kdvharic),0) 
						when 2 then Isnull(sum(s.new_ssftlkdvharic) , dbo.GetUSDPrice(s.new_kdvharic,s.CreatedOn))
						End  b
			from new_satis s
			inner join new_daire d on d.new_daireId=s.new_daireid
			where  s.new_projeid= 'BE547B6F-B78F-E611-80D2-3417EBEAECF3' 
			and s.statecode = 0
			group by new_satisdoviz, s.new_kdvharic,s.CreatedOn


			insert into #tmp2_ (a,b)
			select a
					,sum(b) b
			from #tmp2
			group by a
		/************************************************* 
		******************** KORDON **********************
		***********************---- END ----**************/

		/************************************************* 
		******************** MODERNYAKA *******************
		***********************---- BEGIN ----*************/
			Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																when 0 then 1
																else max(nsh.new_PesinFiyatOran)
															End) as float)  
			
												from new_satishedef nsh (nolock)
												where nsh.statecode = 0
													and nsh.new_projeid = '361D6FC3-22A7-EB11-844C-000C292E580F'
													and nsh.new_HedefYil = @TargetYear
													and nsh.new_PesinFiyatOran is not null )

			insert into #tmp2
			select 'Stok' as a
				, sum(new_kdvharicfiyat)* @New_PesinFiyatOran b 
				from new_daire ns
				where new_projeid='361D6FC3-22A7-EB11-844C-000C292E580F' and new_satisdurumu in (1,6,7)

			insert into #tmp2
			select 'Satýþ' as a
					,case s.new_satisdoviz
						when 1 then Isnull(sum(s.new_kdvharic),0) 
						when 2 then Isnull(sum(s.new_ssftlkdvharic) , dbo.GetUSDPrice(s.new_kdvharic,s.CreatedOn))
						End  b
			from new_satis s
			inner join new_daire d on d.new_daireId=s.new_daireid
			where  s.new_projeid= '361D6FC3-22A7-EB11-844C-000C292E580F' 
			and s.statecode = 0
			group by new_satisdoviz, s.new_kdvharic,s.CreatedOn

			insert into #tmp2_ (a,b)
			select a
					,sum(b) b
			from #tmp2
			group by a
		/************************************************* 
		******************** MODERNYAKA *******************
		***********************---- END ----**************/

		/************************************************* 
		******************** RADISSON BLU *******************
		***********************---- BEGIN ----**************/
		--Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
		--											when 0 then 1
		--											else max(nsh.new_PesinFiyatOran)
		--										End) as float)  
			
		--							from new_satishedef nsh (nolock)
		--							where nsh.statecode = 0
		--								and nsh.new_projeid = 'DE4F981E-27F1-EB11-853A-000C292E580F'
		--								and nsh.new_HedefYil = @TargetYear
		--								and nsh.new_PesinFiyatOran is not null )

		--	insert into #tmp2
		--	select 'Stok' as a
		--		--,format((sum(new_kdvharicfiyat)*0.70),'0,,M TL') totalv 
		--		, sum(new_kdvharicfiyat)* @New_PesinFiyatOran b 
		--		from new_daire ns
		--		where new_projeid='DE4F981E-27F1-EB11-853A-000C292E580F' and new_satisdurumu in (1,6,7)

		--	insert into #tmp2
		--	select 'Satýþ' as a
		--			--, format(sum(new_fiyat),'0,,M TL') as total 
		--			,case s.new_satisdoviz
		--				when 1 then Isnull(sum(s.new_kdvharic),0) 
		--				when 2 then Isnull(sum(s.new_ssftlkdvharic) , dbo.GetUSDPrice(s.new_kdvharic,s.CreatedOn))
		--				End  b
		--				--sum(new_fiyat) b 
		--	from new_satis s
		--	inner join new_daire d on d.new_daireId=s.new_daireid
		--	where  s.new_projeid= 'DE4F981E-27F1-EB11-853A-000C292E580F' 
		--	and s.statecode = 0
		--	group by new_satisdoviz, s.new_kdvharic,s.CreatedOn


		--	insert into #tmp2_ (a,b)
		--	select a
		--			,sum(b) b
		--	from #tmp2
		--	group by a
		/************************************************* 
		******************** RADISSON BLU *******************
		***********************---- END ----**************/

		/************************************************* 
		******************** THE SPORIOR...*******************
		***********************---- BEGIN ----**************/
			Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																when 0 then 1
																else max(nsh.new_PesinFiyatOran)
															End) as float)  
			
												from new_satishedef nsh (nolock)
												where nsh.statecode = 0
													and nsh.new_projeid = 'B94D6764-1D20-EB11-82A7-000C292E580F'
													and nsh.new_HedefYil = @TargetYear
													and nsh.new_PesinFiyatOran is not null )


			insert into #tmp2
			select 'Stok' as a
				, sum(new_kdvharicfiyat)* @New_PesinFiyatOran b 
				from new_daire ns
				where new_projeid='B94D6764-1D20-EB11-82A7-000C292E580F' and new_satisdurumu in (1,6)

			insert into #tmp2
			select 'Satýþ' as a
					,case s.new_satisdoviz
						when 1 then Isnull(sum(s.new_kdvharic),0) 
						when 2 then Isnull(sum(s.new_ssftlkdvharic) , dbo.GetUSDPrice(s.new_kdvharic,s.CreatedOn))
						End  b
			from new_satis s
			inner join new_daire d on d.new_daireId=s.new_daireid
			where  s.new_projeid= 'B94D6764-1D20-EB11-82A7-000C292E580F' 
			and s.statecode = 0
			group by new_satisdoviz, s.new_kdvharic,s.CreatedOn

			insert into #tmp2_ (a,b)
			select a
					,sum(b) b
			from #tmp2
			group by a
		/************************************************* 
		******************** THE SPORIOR...*******************
		***********************---- END ----**************/

			select a
					,format(sum(b),'#,,M TL') total
					,sum(b) as b
			from #tmp2_
			Group by a

END

IF @TargetNumber = 3
BEGIN
		Drop table if exists #tmp3
		Create table #tmp3
		(
			a varchar(10),
			total float,
			n float
		)

		/************************************************* 
		******************** CER ÝSTANBUL ****************
		***********************---- BEGIN ----************/
		insert into #tmp3 (a,total,n)
		select  'Stok' a
				,sum(isnull(d.new_uygulamasatm2,0)) total
				,sum(isnull(d.new_uygulamasatm2,0)) n
		from  new_daire d
		 where 1=1 and d.new_satisdurumu in (1,6,7,100000000) 
		 and d.new_projeid = '9F2C9D29-59D6-E611-80FE-3417EBEAECF3'
		group by d.new_parsel,d.new_blok,d.new_dairetip
		insert into #tmp3 (a,total,n)
		select 'Satýþ' a 
				,sum(isnull(d.new_uygulamasatm2,0)) total
				,sum(isnull(d.new_uygulamasatm2,0)) n
		from new_satis s
		inner join new_daire d on d.new_daireId = s.new_daireid
		left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
		where 1=1 and s.new_satisdurumu   in (3,5,6,7,8) and s.statecode=0  
		and s.new_projeid = '9F2C9D29-59D6-E611-80FE-3417EBEAECF3' 
		group by d.new_parsel,d.new_blok,d.new_dairetip
		/************************************************* 
		******************** CER ÝSTANBUL ****************
		***********************---- END ----**************/

		
		/************************************************* 
		******************** ÇAMLIYAKA KONAKLARI *********
		***********************---- BEGIN ----************/
		insert into #tmp3 (a,total,n)
		select  'Stok' a
				,sum(isnull(d.new_uygulamasatm2,0)) total
				,sum(isnull(d.new_uygulamasatm2,0)) n
		from  new_daire d
			where 1=1 and d.new_satisdurumu in (1) and d.new_paylasimdurum!=100000011
			and d.new_projeid = '7265A677-66AA-E611-80E6-3417EBEAECF3'
		group by d.new_parsel,d.new_blok,d.new_dairetip
		insert into #tmp3 (a,total,n)
		select 'Satýþ' a 
				,sum(isnull(d.new_uygulamasatm2,0)) total
				,sum(isnull(d.new_uygulamasatm2,0)) n
		from new_satis s
		inner join new_daire d on d.new_daireId = s.new_daireid
		left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
		where 1=1 and s.new_satisdurumu   in (3,5,6,7,8) and s.statecode=0  
		and s.new_projeid = '7265A677-66AA-E611-80E6-3417EBEAECF3' 
		group by d.new_parsel,d.new_blok,d.new_dairetip
		/************************************************* 
		******************** ÇAMLIYAKA KONAKLARI *********
		***********************---- END ----**************/

		/************************************************* 
		******************** KEKLÝKTEPE ******************
		***********************---- BEGIN ----************/
		insert into #tmp3 (a,total,n)
		select  'Stok' a
				,sum(isnull(d.new_uygulamasatm2,0)) total
				,sum(isnull(d.new_uygulamasatm2,0)) n
		from  new_daire d
		 where 1=1 and d.new_satisdurumu in (1,6,7) --and d.new_paylasimdurum!=100000011
		 and d.new_projeid = '0C13E4A5-F358-EC11-85A7-000C292E580F'
		group by d.new_dairetip
		insert into #tmp3 (a,total,n)
		select 'Satýþ' a 
				,sum(isnull(d.new_uygulamasatm2,0)) total
				,sum(isnull(d.new_uygulamasatm2,0)) n
		from new_satis s
		inner join new_daire d on d.new_daireId = s.new_daireid
		left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
		where 1=1 and s.new_satisdurumu   in (3,5,6,7,8) and s.statecode=0  
		and s.new_projeid = '0C13E4A5-F358-EC11-85A7-000C292E580F' 
		group by d.new_dairetip
		/************************************************* 
		******************** KEKLÝKEPE *******************
		***********************---- END ----**************/
		
		/************************************************* 
		******************** KORDON **********************
		***********************---- END ----**************/
		insert into #tmp3 (a,total,n)
		select  'Stok' a
				,sum(isnull(d.new_uygulamasatm2,0)) total
				,sum(isnull(d.new_uygulamasatm2,0)) n
		from  new_daire d
			where 1=1 and d.new_satisdurumu in (1,6,7,100000000) and d.new_paylasimdurum!=100000011
			and d.new_projeid = 'BE547B6F-B78F-E611-80D2-3417EBEAECF3'
		group by d.new_parsel,d.new_blok,d.new_dairetip
		insert into #tmp3 (a,total,n)
		select 'Satýþ' a 
				,sum(isnull(d.new_uygulamasatm2,0)) total
				,sum(isnull(d.new_uygulamasatm2,0)) n
		from new_satis s
		inner join new_daire d on d.new_daireId = s.new_daireid
		left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
		where 1=1 and s.new_satisdurumu   in (3,5,6,7,8) and s.statecode=0  
		and s.new_projeid = 'BE547B6F-B78F-E611-80D2-3417EBEAECF3' 
		group by d.new_parsel,d.new_blok,d.new_dairetip
		/************************************************* 
		******************** KORDON **********************
		***********************---- END ----**************/

		/************************************************* 
		******************** MODERNYAKA********************
		***********************---- BEGIN ----**************/		
		insert into #tmp3 (a,total,n)
		select  'Stok' a
				,sum(isnull(d.new_uygulamasatm2,0)) total
				,sum(isnull(d.new_uygulamasatm2,0)) n
		from  new_daire d
			where 1=1 and d.new_satisdurumu in (1,6,7) --and d.new_paylasimdurum!=100000011
			and d.new_projeid = '361D6FC3-22A7-EB11-844C-000C292E580F'
		group by d.new_parsel,d.new_blok,d.new_dairetip
		
		insert into #tmp3 (a,total,n)
		select 'Satýþ' a 
				,sum(isnull(d.new_uygulamasatm2,0)) total
				,sum(isnull(d.new_uygulamasatm2,0)) n
		from new_satis s
		inner join new_daire d on d.new_daireId = s.new_daireid
		left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
		where 1=1 and s.new_satisdurumu   in (3,5,6,7,8) and s.statecode=0  
		and s.new_projeid = '361D6FC3-22A7-EB11-844C-000C292E580F' 
		group by d.new_parsel,d.new_blok,d.new_dairetip
		/************************************************* 
		******************** MODERNYAKA********************
		***********************---- END ----**************/	

		/************************************************* 
		******************** RADISSON BLU *******************
		***********************---- BEGIN ----**************/	
		--insert into #tmp3 (a,total,n)
		--select  'Stok' a
		--		,sum(isnull(d.new_netm2,0)) total
		--		,sum(isnull(d.new_netm2,0)) n
		--from  new_daire d
		-- where 1=1 and d.new_satisdurumu in (1,6,7) 
		-- and d.new_projeid = 'DE4F981E-27F1-EB11-853A-000C292E580F'
		--group by d.new_parsel,d.new_blok,d.new_dairetip


		--insert into #tmp3 (a,total,n)
		--select 'Satýþ' a 
		--		,sum(isnull(d.new_netm2,0)) total
		--		,sum(isnull(d.new_netm2,0)) n
		--from new_satis s
		--inner join new_daire d on d.new_daireId = s.new_daireid
		--left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
		--where 1=1 and s.new_satisdurumu   in (3,5,6,7,8) and s.statecode=0  
		--and s.new_projeid = 'DE4F981E-27F1-EB11-853A-000C292E580F' 
		--group by d.new_parsel,d.new_blok,d.new_dairetip
		/************************************************* 
		******************** RADISSON BLU *****************
		***********************---- END ----**************/	

		/************************************************* 
		******************** THE SUPORIOR ....*****************
		***********************---- BEGIN ----**************/	
		insert into #tmp3 (a,total,n)
		select  'Stok' a
				,sum(isnull(d.new_uygulamasatm2,0)) total
				,sum(isnull(d.new_uygulamasatm2,0)) n
		from  new_daire d
		 where 1=1 and d.new_satisdurumu in (1,6,7,100000000) and d.new_paylasimdurum!=100000011
		 and d.new_projeid = 'B94D6764-1D20-EB11-82A7-000C292E580F'
		group by d.new_parsel,d.new_blok,d.new_dairetip


		insert into #tmp3 (a,total,n)
		select 'Satýþ' a 
				,sum(isnull(d.new_uygulamasatm2,0)) total
				,sum(isnull(d.new_uygulamasatm2,0)) n
		from new_satis s
		inner join new_daire d on d.new_daireId = s.new_daireid
		left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
		where 1=1 and s.new_satisdurumu   in (3,5,6,7,8) and s.statecode=0  
		and s.new_projeid = 'B94D6764-1D20-EB11-82A7-000C292E580F' 
		group by d.new_parsel,d.new_blok,d.new_dairetip
		/************************************************* 
		******************** THE SUPORIOR ....*****************
		***********************---- END ----**************/	

		select t.a
			,cast(sum(t.total) as int) as total
			,cast(sum(t.n) as int) as n
		from #tmp3 t
		group by t.a
END

IF @TargetNumber = 4
BEGIN
			Set @TargetYear = (select top 1 sm.AttributeValue 
										from StringMapBase (nolock) sm 
										where sm.AttributeName = 'new_HedefYil' 
											and sm.value = Year(GETDATE())
								)

			drop table if exists #tmp4
			drop table if exists #tmp_ticari4
			drop table if exists #tmp_son4
			

			Create table #tmp_son4
			(
				dairetip varchar(50)
				,satistl decimal (18,2)
				,stok decimal (18,2)
			)					


		/************************************************* 
		******************** CER ÝSTANBUL ****************
		***********************---- BEGIN ----************/
					
			Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																when 0 then 1
																else max(nsh.new_PesinFiyatOran)
															End) as float)  
			
												from new_satishedef nsh (nolock)
												where nsh.statecode = 0
													and nsh.new_projeid = '9F2C9D29-59D6-E611-80FE-3417EBEAECF3'
													and nsh.new_HedefYil = @TargetYear
													and nsh.new_PesinFiyatOran is not null )

			select d.new_parsel,
			case when d.new_uygulamatip='Ticari' then 'T5' else  new_uygulamatip END
			 new_dairetip
			 , count(*) stokadet
			 , sum(isnull(d.new_UygulamaSatM2,0)) stokm2
			 , sum(CAST( new_UygulamaFiyat as DECIMAL(18,0))* @New_PesinFiyatOran)/1.18 stokm2tl12
			 , AVG((CAST( new_UygulamaFiyat as DECIMAL(18,0))* @New_PesinFiyatOran)/1.18/(new_uygulamasatm2)) Pesinm2Fiyat
			 into #tmp4
			 from  new_daire d
			 where 1=1 and d.new_satisdurumu in (1,6,7,100000000) 
			 and d.new_projeid = '9F2C9D29-59D6-E611-80FE-3417EBEAECF3'
			 and new_UygulamaTip is not null and statecode=0  and d.new_UygulamaTip != 'T1-BLOK' 
				and d.new_name not in (
									 'CER-T1-19',
									'CER-T1-20',
									'CER-T1-21',
									'CER-T1-22',
									'CER-T1-23',
									'CER-T1A-10')
			group by d.new_parsel,d.new_uygulamatip

			insert into #tmp4 
			select d.new_parsel,
			'Ticari'
			 new_dairetip, count(*) stokadet, sum(isnull(d.new_UygulamaSatM2,0)) stokm2
			,sum(CAST( new_UygulamaFiyat as DECIMAL(18,0))*@New_PesinFiyatOran)/1.18 stokm2tl12
			, AVG((CAST( new_UygulamaFiyat as DECIMAL(18,0))* @New_PesinFiyatOran)/1.18/(new_uygulamasatm2)) Pesinm2Fiyat
			 from  new_daire d
			 where 1=1 and d.new_satisdurumu in (1,6,7,100000000) 
			 and d.new_projeid = '9F2C9D29-59D6-E611-80FE-3417EBEAECF3'
			 and new_UygulamaTip is not null and statecode=0  and d.new_name  in (
			 'CER-T1-19',
			'CER-T1-20',
			'CER-T1-21',
			'CER-T1-22',
			'CER-T1-23',
			'CER-T1A-10')
			group by d.new_parsel,d.new_uygulamatip

			insert into #tmp4 
			select d.new_parsel,
			'T1-Loft'
			 new_dairetip, count(*) stokadet, sum(isnull(d.new_UygulamaSatM2,0)) stokm2
			,sum(CAST( new_UygulamaFiyat as DECIMAL(18,0))*@New_PesinFiyatOran)/1.18 stokm2tl12
			, AVG((CAST( new_UygulamaFiyat as DECIMAL(18,0))* @New_PesinFiyatOran)/1.18/(new_uygulamasatm2)) stok12
			 from  new_daire d
			 where 1=1 and d.new_satisdurumu in (1,6,7,100000000) 
			 and d.new_projeid = '9F2C9D29-59D6-E611-80FE-3417EBEAECF3'
			 and new_UygulamaTip is not null and statecode=0  and d.new_UygulamaTip = 'T1-BLOK'
			group by d.new_parsel,d.new_uygulamatip


			/***************
				Satislar #tmp_ticari atýlýyor.
			****************/

			select 
			 toplam.new_parsel as new_ada
			,left(daire.new_dairetip,11) as new_dairetip
			,toplam.stokadet toplamadet
			,satis.satisadet satisadet
			,ISNULL(stok.stokadet,0) stokadet
			,(isnull(satis.satism2,0) + isnull(stok.stokm2,0)) toplamm2
			,satis.satism2 
			,stok.stokm2
			,(isnull(satis.satisfiyat,0) + isnull(stok.stokfiyat,0)*@New_PesinFiyatOran) toplamfiyat
			,satis.satisfiyat 
			,stok.stokfiyat*@New_PesinFiyatOran  stokfiyat
			,toplam.toplamlistefiyat
			,(CAST( satis.satisfiyat as DECIMAL(18,0) )  / CAST(satis.satism2 as DECIMAL(18,0) ) ) satism2tl
			,(CAST( stok.stokfiyat as DECIMAL(18,0) )  / CAST(stok.stokm2 as DECIMAL(18,0) ) ) stokm2tl
			,(CAST( stok.stokfiyat as DECIMAL(18,0) )  / CAST(stok.stokm2 as DECIMAL(18,0) ) )* @New_PesinFiyatOran  stok12
			,(CAST( stok.stokfiyat as DECIMAL(18,0) ))* @New_PesinFiyatOran stokm2tl12
			,(satis.satisfiyat+(stok.stokfiyat *@New_PesinFiyatOran))/(satis.satism2+stok.stokm2) as hedefrealize
			,toplam.new_islembitiskdvharic
			,toplam.new_isbitimkdvdahil
			 into #tmp_ticari4
			 from 
			 (select DISTINCT new_dairetip from new_daire where new_projeid='9F2C9D29-59D6-E611-80FE-3417EBEAECF3' AND new_dairetip<>'Ofis') daire
			 left join 
			  ( select d.new_parsel,d.new_dairetip,d.new_paylasimdurum , count(*) stokadet , sum(isnull(d.new_sataesasdairebrtalan,0)) stokm2
			, sum(isnull(d.new_kdvharicfiyat,0)) toplamlistefiyat , sum(isnull(d.new_isbitimkdvharic,0)) new_islembitiskdvharic, sum(isnull(d.new_isbitimkdvdahil,0)) new_isbitimkdvdahil
			 from  new_daire d
			 where 1=1 and d.new_satisdurumu   in (1,3,5,6,7,8,100000000) and  new_paylasimdurum = 1
			 and d.new_projeid='9F2C9D29-59D6-E611-80FE-3417EBEAECF3' 
			group by d.new_parsel,d.new_dairetip,d.new_paylasimdurum
			 )toplam on daire.new_dairetip=toplam.new_dairetip
			  left join
			(select d.new_parsel,d.new_dairetip , count(*) stokadet, sum(isnull(d.new_sataesasdairebrtalan,0)) stokm2
			, sum(isnull(d.new_kdvharicfiyat,0)) stokfiyat 
			 from  new_daire d
			 where 1=1 and d.new_satisdurumu in (1,6,7,100000000) and  new_paylasimdurum = 1
			 and d.new_projeid ='9F2C9D29-59D6-E611-80FE-3417EBEAECF3'
			group by d.new_parsel,d.new_dairetip
			)stok on toplam.new_dairetip = stok.new_dairetip and toplam.new_parsel=stok.new_parsel --and toplam.new_blok=stok.new_blok
			left join
			(select d.new_parsel,d.new_dairetip , count(*) satisadet , sum(isnull(d.new_sataesasdairebrtalan,0)) satism2
			, sum(isnull((case s.new_satisdoviz when 2 then
			(case when new_networkkomisyon is null then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) when new_NetworkKomisyon=0 then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) else dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) end) 
			else
			(new_kdvharic) end),0))  satisfiyat
			 from new_satis s
			inner join new_daire d on d.new_daireId = s.new_daireid
			left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
			where 1=1 and  s.statecode=0  
			and s.new_projeid ='9F2C9D29-59D6-E611-80FE-3417EBEAECF3'
			group by d.new_parsel,d.new_dairetip) satis
			 on satis.new_dairetip = toplam.new_dairetip and satis.new_parsel=toplam.new_parsel

			insert into #tmp_son4
			select tc.new_dairetip as dairetip
					,tc.satism2tl as satistl
					,Isnull((select t.Pesinm2Fiyat from #tmp4 t where tc.new_dairetip = t.new_dairetip),0) as stok
			from #tmp_ticari4 tc
			
			insert into #tmp_son4
			select t.new_dairetip as dairetip
					,0 as satistl
					,t.Pesinm2Fiyat as stok
			from #tmp4 t
			where t.new_dairetip not in (select distinct new_dairetip from #tmp_ticari4)
		/************************************************* 
		******************** CER ÝSTANBUL ****************
		***********************---- END ----**************/
		


		/************************************************* 
		******************** ÇAMLIYAKA KONAKLARI *********
		***********************---- BEGIN ----************/
				
			Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																when 0 then 1
																else max(nsh.new_PesinFiyatOran)
															End) as float)  
			
												from new_satishedef nsh (nolock)
												where nsh.statecode = 0
													and nsh.new_projeid = '7265A677-66AA-E611-80E6-3417EBEAECF3'
													and nsh.new_HedefYil = @TargetYear
													and nsh.new_PesinFiyatOran is not null )

			drop table if exists #tmp_camliyaka
			select	left(d.new_UygulamaTip,3) as new_dairetip
					,count(left(d.new_UygulamaTip,3)) stokadet 
					,sum(isnull(d.new_uygulamasatm2,0)) stokm2
					,sum(isnull(d.new_kdvharicfiyat,0)) * @New_PesinFiyatOran stokfiyat 
					,((sum(isnull(d.new_kdvharicfiyat,0)) * @New_PesinFiyatOran) / sum(d.new_UygulamaSatM2)) as Pesinm2Fiyat
					into #tmp_camliyaka
			from  new_daire d
			where 1=1 and d.new_satisdurumu in (1) and d.new_paylasimdurum!=100000011
						and d.new_projeid = '7265A677-66AA-E611-80E6-3417EBEAECF3'
			group by left(d.new_UygulamaTip,3) --,new_UygulamaSatM2

			
			drop table if exists #tmp_satistl_camliyaka
			select left(d.new_UygulamaTip,3) as new_dairetip 
					,count(*) satisadet 
					,sum(isnull(d.new_uygulamasatm2,0)) satism2
					, sum(isnull((case s.new_satisdoviz when 2 then
									(case when new_networkkomisyon is null then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) 
											when new_NetworkKomisyon=0 then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) 
										else dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)-(dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)*(new_NetworkKomisyon/100)) end) 
									else
									(case when new_networkkomisyon is null then new_kdvharic when new_NetworkKomisyon=0 then new_kdvharic else s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)) end) end),0))  satisfiyat
					, AVG ((s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)))/d.new_uygulamasatm2) as PesinM2Fiyat
					into #tmp_satistl_camliyaka
			from new_satis s
				inner join new_daire d on d.new_daireId = s.new_daireid
				left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
				where 1=1 and s.new_satisdurumu   in (3,5,6,7,8) and s.statecode=0 
						and s.new_projeid = '7265A677-66AA-E611-80E6-3417EBEAECF3'
				group by left(d.new_UygulamaTip,3)

			insert into #tmp_son4
			select  Isnull(t.new_dairetip,ts.new_dairetip) dairetip
					,Isnull(AVG(ts.Pesinm2Fiyat),0) satistl
					,Isnull(AVG(t.Pesinm2Fiyat),0) stok
			from #tmp_camliyaka t 
			right join #tmp_satistl_camliyaka ts on ts.new_dairetip = t.new_dairetip
			group by t.new_dairetip,ts.new_dairetip
		/************************************************* 
		******************** ÇAMLIYAKA KONAKLARI *********
		***********************---- END ----**************/
		


		/************************************************* 
		******************** KEKLÝKTEPE ******************
		***********************---- BEGIN ----************/		
			Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																when 0 then 1
																else max(nsh.new_PesinFiyatOran)
															End) as float)  
			
												from new_satishedef nsh (nolock)
												where nsh.statecode = 0
													and nsh.new_projeid = '0C13E4A5-F358-EC11-85A7-000C292E580F'
													and nsh.new_HedefYil = @TargetYear
													and nsh.new_PesinFiyatOran is not null )


			drop table if exists #tmp_keliktepe
			select	left(d.new_UygulamaTip,3) as new_dairetip
					,count(left(d.new_UygulamaTip,3)) stokadet 
					,sum(isnull(d.new_uygulamasatm2,0)) stokm2
					,sum(isnull(d.new_kdvharicfiyat,0)) * @New_PesinFiyatOran stokfiyat 
					,((sum(isnull(d.new_kdvharicfiyat,0)) * @New_PesinFiyatOran) / sum(d.new_UygulamaSatM2)) as Pesinm2Fiyat
					into #tmp_keliktepe
			from  new_daire d
			where 1=1 and d.new_satisdurumu in (1) 
						and d.new_projeid = '0C13E4A5-F358-EC11-85A7-000C292E580F'
			group by left(d.new_UygulamaTip,3) 

			
			drop table if exists #tmp_satistl_kekliktepe
			select left(d.new_UygulamaTip,3) as new_dairetip 
				,count(*) satisadet 
				,sum(isnull(d.new_uygulamasatm2,0)) satism2
				, sum(isnull((case s.new_satisdoviz when 2 then
								(case when new_networkkomisyon is null then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) 
										when new_NetworkKomisyon=0 then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) 
									else dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)-(dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)*(new_NetworkKomisyon/100)) end) 
								else
								(case when new_networkkomisyon is null then new_kdvharic when new_NetworkKomisyon=0 then new_kdvharic else s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)) end) end),0))  satisfiyat
				, AVG ((s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)))/d.new_uygulamasatm2) as PesinM2Fiyat
				into #tmp_satistl_kekliktepe
			from new_satis s
			inner join new_daire d on d.new_daireId = s.new_daireid
			left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
			where 1=1 and s.new_satisdurumu   in (3,5,6,7,8) and s.statecode=0 
					and s.new_projeid = '0C13E4A5-F358-EC11-85A7-000C292E580F'
			group by left(d.new_UygulamaTip,3)

			insert into #tmp_son4
			select  Isnull(t.new_dairetip,ts.new_dairetip) dairetip
					,Isnull(AVG(ts.Pesinm2Fiyat),0) satistl
					,Isnull(AVG(t.Pesinm2Fiyat),0) stok
			from #tmp_keliktepe t 
			left join #tmp_satistl_kekliktepe ts on ts.new_dairetip = t.new_dairetip
			group by t.new_dairetip,ts.new_dairetip
		/************************************************* 
		******************** KEKLÝKTEPE ******************
		***********************---- END ----**************/
		

		/************************************************* 
		******************** KORDON **********************
		***********************---- BEGIN ----*************/		
			Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																when 0 then 1
																else max(nsh.new_PesinFiyatOran)
															End) as float)  
			
												from new_satishedef nsh (nolock)
												where nsh.statecode = 0
													and nsh.new_projeid = 'BE547B6F-B78F-E611-80D2-3417EBEAECF3'
													and nsh.new_HedefYil = @TargetYear
													and nsh.new_PesinFiyatOran is not null )

			drop table if exists #tmp_kordon
			select	left(d.new_UygulamaTip,3) as new_dairetip
										,count(left(d.new_UygulamaTip,3)) stokadet 
										,sum(isnull(d.new_uygulamasatm2,0)) stokm2
										,sum(isnull(d.new_kdvharicfiyat,0)) * @New_PesinFiyatOran stokfiyat 
										,AVG((isnull(d.new_kdvharicfiyat,0) * @New_PesinFiyatOran) / d.new_UygulamaSatM2) as Pesinm2Fiyat
										into #tmp_kordon
								from  new_daire d
								where 1=1 and d.new_satisdurumu in (1,6,7) 
											and d.new_projeid = 'BE547B6F-B78F-E611-80D2-3417EBEAECF3'
								group by left(d.new_UygulamaTip,3) --,new_UygulamaSatM2

			Drop table if exists #tmp_satistl_kordon
			select left(d.new_UygulamaTip,3) as new_dairetip 
										,count(*) satisadet 
										,sum(isnull(d.new_uygulamasatm2,0)) satism2
										, sum(isnull((case s.new_satisdoviz when 2 then
														(case when new_networkkomisyon is null then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) 
																when new_NetworkKomisyon=0 then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) 
															else dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)-(dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)*(new_NetworkKomisyon/100)) end) 
														else
														(case when new_networkkomisyon is null then new_kdvharic when new_NetworkKomisyon=0 then new_kdvharic else s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)) end) end),0))  satisfiyat
										, AVG ((s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)))/d.new_uygulamasatm2) as PesinM2Fiyat
										into #tmp_satistl_kordon
								from new_satis s
									inner join new_daire d on d.new_daireId = s.new_daireid
									left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
									where 1=1 and s.new_satisdurumu   in (3,5,6,7,8) and s.statecode=0 
											and s.new_projeid = 'BE547B6F-B78F-E611-80D2-3417EBEAECF3'
						group by left(d.new_UygulamaTip,3)

			insert into #tmp_son4
			select  Isnull(t.new_dairetip,ts.new_dairetip) dairetip
					,Isnull(AVG(ts.Pesinm2Fiyat),0) satistl
					,Isnull(AVG(t.Pesinm2Fiyat),0) stok
			from #tmp_kordon t 
			right join #tmp_satistl_kordon ts on ts.new_dairetip = t.new_dairetip
			group by t.new_dairetip,ts.new_dairetip
		/************************************************* 
		******************** KORDON **********************
		***********************---- END ----**************/

		/************************************************* 
		******************** MODERNYAKA *******************
		***********************---- BEGIN ----**************/		
			Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																when 0 then 1
																else max(nsh.new_PesinFiyatOran)
															End) as float)  
			
												from new_satishedef nsh (nolock)
												where nsh.statecode = 0
													and nsh.new_projeid = '361D6FC3-22A7-EB11-844C-000C292E580F'
													and nsh.new_HedefYil = @TargetYear
													and nsh.new_PesinFiyatOran is not null )

			drop table if exists #tmp_modernyaka
			select	left(d.new_UygulamaTip,3) as new_dairetip
										,count(left(d.new_UygulamaTip,3)) stokadet 
										,sum(isnull(d.new_uygulamasatm2,0)) stokm2
										,sum(isnull(d.new_kdvharicfiyat,0)) * @New_PesinFiyatOran stokfiyat 
										,AVG((isnull(d.new_kdvharicfiyat,0) * @New_PesinFiyatOran) / d.new_UygulamaSatM2) as Pesinm2Fiyat
										into #tmp_modernyaka
								from  new_daire d
								where 1=1 and d.new_satisdurumu in (1,6,7) 
											and d.new_projeid = '361D6FC3-22A7-EB11-844C-000C292E580F'
								group by left(d.new_UygulamaTip,3) 

			Drop table if exists #tmp_satistl_modernyaka
			select left(d.new_UygulamaTip,3) as new_dairetip 
										,count(*) satisadet 
										,sum(isnull(d.new_uygulamasatm2,0)) satism2
										, sum(isnull((case s.new_satisdoviz when 2 then
														((isnull( s.new_ssftlkdvharic - ( new_ssftlkdvharic * (s.new_NetworkKomisyon/100))
														, dbo.GetUSDPrice (new_kdvharic, s.CreatedOn) - (dbo.GetUSDPrice (new_kdvharic, s.CreatedOn) *(s.new_NetworkKomisyon/100))  
													  )
											  )) 
														else
														(case when new_networkkomisyon is null then new_kdvharic when new_NetworkKomisyon=0 then new_kdvharic else s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)) end) end),0))  satisfiyat
										, AVG ( Case s.new_satisdoviz
														when 1 then (s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)))/d.new_uygulamasatm2
														else
															(Isnull(s.new_ssftlkdvharic,dbo.GetUSDPrice (new_kdvharic, s.CreatedOn))
																-(Isnull(s.new_ssftlkdvharic,dbo.GetUSDPrice (new_kdvharic, s.CreatedOn))*(new_NetworkKomisyon/100)))/d.new_uygulamasatm2
														End
												) as PesinM2Fiyat
										into #tmp_satistl_modernyaka
								from new_satis s
									inner join new_daire d on d.new_daireId = s.new_daireid
									left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
									where 1=1 and s.new_satisdurumu   in (3,5,7) and s.statecode=0 
											and s.new_projeid = '361D6FC3-22A7-EB11-844C-000C292E580F'

									group by left(d.new_UygulamaTip,3)

			insert into #tmp_son4
			select  Isnull(t.new_dairetip,ts.new_dairetip) dairetip
					,Isnull(AVG(ts.Pesinm2Fiyat),0) satistl
					,Isnull(AVG(t.Pesinm2Fiyat),0) stok
			from #tmp_modernyaka t 
			right join #tmp_satistl_modernyaka ts on ts.new_dairetip = t.new_dairetip
			group by t.new_dairetip,ts.new_dairetip
		/************************************************* 
		******************** MODERNYAKA *******************
		***********************---- END ----**************/

		/************************************************* 
		******************** RADISSON BLU *******************
		***********************---- BEGIN ----**************/
			--Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
			--													when 0 then 1
			--													else max(nsh.new_PesinFiyatOran)
			--												End) as float)  
			
			--									from new_satishedef nsh (nolock)
			--									where nsh.statecode = 0
			--										and nsh.new_projeid = 'DE4F981E-27F1-EB11-853A-000C292E580F'
			--										and nsh.new_HedefYil = @TargetYear
			--										and nsh.new_PesinFiyatOran is not null )



			--drop table if exists #tmp_radisson
			--select	left(d.new_UygulamaTip,3) as new_dairetip
			--							,count(left(d.new_UygulamaTip,3)) stokadet 
			--							,sum(isnull(d.new_sataesasdairebrtalan,0)) stokm2
			--							,sum(isnull(d.new_kdvharicfiyat,0)) * @New_PesinFiyatOran stokfiyat 
			--							,((sum(isnull(d.new_kdvharicfiyat,0)) * @New_PesinFiyatOran) / sum(d.new_sataesasdairebrtalan)) as Pesinm2Fiyat
			--							into #tmp_radisson
			--					from  new_daire d
			--					where 1=1 and d.new_satisdurumu in (1,6,7) 
			--								and d.new_projeid = 'DE4F981E-27F1-EB11-853A-000C292E580F'
			--					group by left(d.new_UygulamaTip,3) 



			--Drop table if exists #tmp_satistl_radisson
			--select left(d.new_UygulamaTip,3) as new_dairetip 
			--							,count(*) satisadet 
			--							,sum(isnull(d.new_sataesasdairebrtalan,0)) satism2
			--														, sum(isnull((case s.new_satisdoviz when 2 then
			--											(case when new_networkkomisyon is null then Isnull(dbo.GetUSDPrice(new_kdvharic,s.CreatedOn),s.new_ssftlkdvharic) 
			--													when new_NetworkKomisyon=0 then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) 
			--											 else Isnull(dbo.GetUSDPrice(new_kdvharic,s.CreatedOn),s.new_ssftlkdvharic) - ( Isnull(dbo.GetUSDPrice(new_kdvharic,s.CreatedOn),s.new_ssftlkdvharic) *(new_NetworkKomisyon/100)) end) 
			--											else
			--											(case when new_networkkomisyon is null then new_kdvharic when new_NetworkKomisyon=0 then new_kdvharic else s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)) end) end),0))  satisfiyat
			--							, AVG ((Isnull(dbo.GetUSDPrice(s.new_kdvharic,s.CreatedOn),s.new_ssftlkdvharic) 
			--									-
			--									 (Isnull(dbo.GetUSDPrice(s.new_kdvharic,s.CreatedOn),s.new_ssftlkdvharic) * (s.new_NetworkKomisyon/100))
			--									)
			--									/d.new_sataesasdairebrtalan) as PesinM2Fiyat
			--							into #tmp_satistl_radisson
			--					from new_satis s
			--						inner join new_daire d on d.new_daireId = s.new_daireid
			--						left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
			--						where 1=1 and s.new_satisdurumu   in (3,5,6,7,8) and s.statecode=0 
			--								and s.new_projeid = 'DE4F981E-27F1-EB11-853A-000C292E580F'
			--						group by left(d.new_UygulamaTip,3)

			--insert into #tmp_son4
			--select  Isnull(t.new_dairetip,ts.new_dairetip) dairetip
			--		,Isnull(AVG(ts.Pesinm2Fiyat),0) satistl
			--		,Isnull(AVG(t.Pesinm2Fiyat),0) stok
			--from #tmp_radisson t 
			--right join #tmp_satistl_radisson ts on ts.new_dairetip = t.new_dairetip
			--group by t.new_dairetip,ts.new_dairetip
		/************************************************* 
		******************** RADISSON BLU *******************
		***********************---- END ----**************/

		/************************************************* 
		******************** THE SPORRÝORS..*******************
		***********************---- BEGIN ----**************/
			Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																when 0 then 1
																else max(nsh.new_PesinFiyatOran)
															End) as float)  
			
												from new_satishedef nsh (nolock)
												where nsh.statecode = 0
													and nsh.new_projeid = 'B94D6764-1D20-EB11-82A7-000C292E580F'
													and nsh.new_HedefYil = @TargetYear
													and nsh.new_PesinFiyatOran is not null )



			drop table if exists #tmp_thespor
			select	left(d.new_UygulamaTip,3) as new_dairetip
										,count(left(d.new_UygulamaTip,3)) stokadet 
										,sum(isnull(d.new_uygulamasatm2,0)) stokm2
										,sum(isnull(d.new_kdvharicfiyat,0)) * @New_PesinFiyatOran stokfiyat 
										,((sum(isnull(d.new_kdvharicfiyat,0)) * @New_PesinFiyatOran) / sum(d.new_UygulamaSatM2)) as Pesinm2Fiyat
										into #tmp_thespor
								from  new_daire d
								where 1=1 and d.new_satisdurumu in (1) and d.new_paylasimdurum!=100000011
											and d.new_projeid = 'B94D6764-1D20-EB11-82A7-000C292E580F'
								group by left(d.new_UygulamaTip,3)



			Drop table if exists #tmp_satistl_thespor
			select 0 parsel, left(d.new_UygulamaTip,3) as new_dairetip 
										,count(*) satisadet 
										,sum(isnull(d.new_uygulamasatm2,0)) satism2
										, sum(isnull((case s.new_satisdoviz when 2 then
														(case when new_networkkomisyon is null then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) 
																when new_NetworkKomisyon=0 then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) 
														 else dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)-(dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)*(new_NetworkKomisyon/100)) end) 
														else
														(case when new_networkkomisyon is null then new_kdvharic when new_NetworkKomisyon=0 then new_kdvharic else s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)) end) end),0))  satisfiyat
										, AVG ((s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)))/d.new_uygulamasatm2) as PesinM2Fiyat
										into #tmp_satistl_thespor
								from new_satis s
									inner join new_daire d on d.new_daireId = s.new_daireid
									left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
									where 1=1 and s.new_satisdurumu   in (3,5,6,7,8) and s.statecode=0 
											and s.new_projeid = 'B94D6764-1D20-EB11-82A7-000C292E580F'
									group by d.new_UygulamaTip

			insert into #tmp_son4
			select  Isnull(t.new_dairetip,ts.new_dairetip) dairetip
					,Isnull(AVG(ts.Pesinm2Fiyat),0) satistl
					,Isnull(AVG(t.Pesinm2Fiyat),0) stok
			from #tmp_thespor t 
			right join #tmp_satistl_thespor ts on ts.new_dairetip = t.new_dairetip
			group by t.new_dairetip,ts.new_dairetip
		/************************************************* 
		******************** THE SPORRÝORS..*******************
		***********************---- END---**************/


			select dairetip
					,AVG(satistl) as satistl
					,AVG(stok) as stok
			from #tmp_son4 t
			group by dairetip


END

IF @TargetNumber = 5
BEGIN
Set @TargetYear = (select top 1 sm.AttributeValue 
							from StringMapBase (nolock) sm 
							where sm.AttributeName = 'new_HedefYil' 
								and sm.value = Year(GETDATE())
					)

				Drop table if exists #tmp5
				Drop table if exists #tmp_son5

				Create table #tmp_son5
				(
					new_parsel varchar(10)
					,new_dairetip varchar(50)
					,stokadet int
					,stokm2 float
					,satism2tl12 decimal (18,2)
					,stok12 decimal (18,2)
				)

		/************************************************* 
		******************** CER ÝSTANBUL ****************
		***********************---- BEGIN ----************/		
				Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																	when 0 then 1
																	else max(nsh.new_PesinFiyatOran)
																End) as float)  
			
													from new_satishedef nsh (nolock)
													where nsh.statecode = 0
														and nsh.new_projeid = '9F2C9D29-59D6-E611-80FE-3417EBEAECF3'
														and nsh.new_HedefYil = @TargetYear

														and nsh.new_PesinFiyatOran is not null )

				select d.new_parsel,
				case when d.new_uygulamatip='Ticari' then 'T5' else  new_uygulamatip END
				 new_dairetip
				 , count(*) stokadet
				 , sum(isnull(d.new_UygulamaSatM2,0)) stokm2
				 , sum(CAST( new_UygulamaFiyat as DECIMAL(18,0))* @New_PesinFiyatOran)/1.18 stokm2tl12
				 , AVG((CAST( new_UygulamaFiyat as DECIMAL(18,0))* @New_PesinFiyatOran)/1.18/(new_uygulamasatm2)) stok12
				 into #tmp5
				 from  new_daire d
				 where 1=1 and d.new_satisdurumu in (1,6,7,100000000) 
				 and d.new_projeid = '9F2C9D29-59D6-E611-80FE-3417EBEAECF3'
				 and new_UygulamaTip is not null and statecode=0  and d.new_UygulamaTip != 'T1-BLOK' 
					and d.new_name not in (
										 'CER-T1-19',
										'CER-T1-20',
										'CER-T1-21',
										'CER-T1-22',
										'CER-T1-23',
										'CER-T1A-10')

				group by d.new_parsel,d.new_uygulamatip

				insert into #tmp5 
				select d.new_parsel,
				'Ticari'
				 new_dairetip, count(*) stokadet, sum(isnull(d.new_UygulamaSatM2,0)) stokm2
				,sum(CAST( new_UygulamaFiyat as DECIMAL(18,0))*@New_PesinFiyatOran)/1.18 stokm2tl12
				, AVG((CAST( new_UygulamaFiyat as DECIMAL(18,0))* @New_PesinFiyatOran)/1.18/(new_uygulamasatm2)) stok12
				 from  new_daire d
				 where 1=1 and d.new_satisdurumu in (1,6,7,100000000) 
				 and d.new_projeid = '9F2C9D29-59D6-E611-80FE-3417EBEAECF3'
				 and new_UygulamaTip is not null and statecode=0  and d.new_name  in (
				 'CER-T1-19',
				'CER-T1-20',
				'CER-T1-21',
				'CER-T1-22',
				'CER-T1-23',
				'CER-T1A-10')

				group by d.new_parsel,d.new_uygulamatip

				insert into #tmp5
				select d.new_parsel,
				'T1-Loft'
				 new_dairetip, count(*) stokadet, sum(isnull(d.new_UygulamaSatM2,0)) stokm2
				,sum(CAST( new_UygulamaFiyat as DECIMAL(18,0))*@New_PesinFiyatOran)/1.18 stokm2tl12
				, AVG((CAST( new_UygulamaFiyat as DECIMAL(18,0))* @New_PesinFiyatOran)/1.18/(new_uygulamasatm2)) stok12
				 from  new_daire d
				 where 1=1 and d.new_satisdurumu in (1,6,7,100000000) 
				 and d.new_projeid = '9F2C9D29-59D6-E611-80FE-3417EBEAECF3'
				 and new_UygulamaTip is not null and statecode=0  and d.new_UygulamaTip = 'T1-BLOK'

				group by d.new_parsel,d.new_uygulamatip

				insert into #tmp_son5
				select new_parsel
						,Left(new_dairetip,7) new_dairetip
						,stokadet
						,stokm2
						,stokm2tl12
						,stok12
				from #tmp5
				where stokm2tl12 is not null
					and new_dairetip not in ('Ticari')
		/************************************************* 
		******************** CER ÝSTANBUL ****************
		***********************---- END ----**************/
		

		/************************************************* 
		******************** ÇAMLIYAKA KONAKLARI *********
		***********************---- BEGIN ----************/
		Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
															when 0 then 1
															else max(nsh.new_PesinFiyatOran)
														End) as float)  
			
											from new_satishedef nsh (nolock)
											where nsh.statecode = 0
												and nsh.new_projeid = '7265A677-66AA-E611-80E6-3417EBEAECF3'
												and nsh.new_HedefYil = @TargetYear
												and nsh.new_PesinFiyatOran is not null )


		insert into #tmp_son5
		select	 0 new_parsel,left(d.new_UygulamaTip,3) as new_dairetip
									,count(left(d.new_UygulamaTip,3)) stokadet 
									,sum(isnull(d.new_uygulamasatm2,0)) stokm2
									,sum(isnull(d.new_kdvharicfiyat,0)) * @New_PesinFiyatOran stokfiyat 
									,AVG((isnull(d.new_kdvharicfiyat,0) * @New_PesinFiyatOran) / d.new_UygulamaSatM2) as Pesinm2Fiyat
							from  new_daire d
							where 1=1 and d.new_satisdurumu in (1) and d.new_paylasimdurum!=100000011
										and d.new_projeid = '7265A677-66AA-E611-80E6-3417EBEAECF3'
		and new_UygulamaTip not in ('Dükkan','Ofis')
		group by left(d.new_UygulamaTip,3) 
		/************************************************* 
		******************** ÇAMLIYAKA KONAKLARI *********
		***********************---- END ----**************/
		

		/************************************************* 
		******************** KEKLÝKTEPE ******************
		***********************---- BEGIN ----************/		
				Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																	when 0 then 1
																	else max(nsh.new_PesinFiyatOran)
																End) as float)  
			
													from new_satishedef nsh (nolock)
													where nsh.statecode = 0
														and nsh.new_projeid = '0C13E4A5-F358-EC11-85A7-000C292E580F'
														and nsh.new_HedefYil = @TargetYear
														and nsh.new_PesinFiyatOran is not null )


				insert into #tmp_son5
				select	0 parsel,left(d.new_UygulamaTip,3) as new_dairetip
											,count(left(d.new_UygulamaTip,3)) stokadet 
											,sum(isnull(d.new_uygulamasatm2,0)) stokm2
											,sum(isnull(d.new_kdvharicfiyat,0)) * @New_PesinFiyatOran stokfiyat 
											,AVG((isnull(d.new_kdvharicfiyat,0) * @New_PesinFiyatOran) / d.new_UygulamaSatM2) as Pesinm2Fiyat
									from  new_daire d
									where 1=1 and d.new_satisdurumu in (1) 
												and d.new_projeid = '0C13E4A5-F358-EC11-85A7-000C292E580F'
				and new_UygulamaTip not in ('Dükkan','Ofis')
				group by left(d.new_UygulamaTip,3) 
		/************************************************* 
		******************** KEKLÝKTEPE ******************
		***********************---- END ----**************/
				
		/************************************************* 
		******************** KORDON **********************
		***********************---- BEGIN ----*************/		
				Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																	when 0 then 1
																	else max(nsh.new_PesinFiyatOran)
																End) as float)  
			
													from new_satishedef nsh (nolock)
													where nsh.statecode = 0
														and nsh.new_projeid = 'BE547B6F-B78F-E611-80D2-3417EBEAECF3'
														and nsh.new_HedefYil = @TargetYear
														and nsh.new_PesinFiyatOran is not null )
				insert into #tmp_son5
				select	0 parsel,left(d.new_UygulamaTip,3) as new_dairetip
											,count(left(d.new_UygulamaTip,3)) stokadet 
											,sum(isnull(d.new_uygulamasatm2,0)) stokm2
											,sum(isnull(d.new_kdvharicfiyat,0)) * @New_PesinFiyatOran stokfiyat 
											,AVG((isnull(d.new_kdvharicfiyat,0) * @New_PesinFiyatOran) / d.new_UygulamaSatM2) as Pesinm2Fiyat
									from  new_daire d
									where 1=1 and d.new_satisdurumu in (1,6,7) 
												and d.new_projeid = 'BE547B6F-B78F-E611-80D2-3417EBEAECF3'
				and new_UygulamaTip not in ('Dükkan')
				group by left(d.new_UygulamaTip,3)
		/************************************************* 
		******************** KORDON **********************
		***********************---- END ----**************/

		/************************************************* 
		******************** MODERNYAKA *********************
		***********************---- BEGIN ----**************/
				Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																	when 0 then 1
																	else max(nsh.new_PesinFiyatOran)
																End) as float)  
			
													from new_satishedef nsh (nolock)
													where nsh.statecode = 0
														and nsh.new_projeid = '361D6FC3-22A7-EB11-844C-000C292E580F'
														and nsh.new_HedefYil = @TargetYear
														and nsh.new_PesinFiyatOran is not null )
				insert into #tmp_son5
				select	0 parsel, left(d.new_UygulamaTip,3) as new_dairetip
											,count(left(d.new_UygulamaTip,3)) stokadet 
											,sum(isnull(d.new_uygulamasatm2,0)) stokm2
											,sum(isnull(d.new_kdvharicfiyat,0)) * @New_PesinFiyatOran stokfiyat 
											,AVG((isnull(d.new_kdvharicfiyat,0) * @New_PesinFiyatOran) / d.new_UygulamaSatM2) as Pesinm2Fiyat
									from  new_daire d
									where 1=1 and d.new_satisdurumu in (1,6,7) 
												and d.new_projeid = '361D6FC3-22A7-EB11-844C-000C292E580F'
				and new_UygulamaTip not in ('Dükkan')
				group by left(d.new_UygulamaTip,3)
		/************************************************* 
		******************** MODERNYAKA *********************
		***********************---- END ----**************/

		/************************************************* 
		******************** RADISSON BLU *********************
		***********************---- BEGIN ----**************/
				--Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
				--													when 0 then 1
				--													else max(nsh.new_PesinFiyatOran)
				--												End) as float)  
			
				--									from new_satishedef nsh (nolock)
				--									where nsh.statecode = 0
				--										and nsh.new_projeid = 'DE4F981E-27F1-EB11-853A-000C292E580F'
				--										and nsh.new_HedefYil = @TargetYear
				--										and nsh.new_PesinFiyatOran is not null )


				--insert into #tmp_son5
				--select	0 parsel, left(d.new_UygulamaTip,3) as new_dairetip
				--							,count(left(d.new_UygulamaTip,3)) stokadet 
				--							,sum(isnull(d.new_sataesasdairebrtalan,0)) stokm2
				--							,sum(isnull(d.new_kdvharicfiyat,0)) * @New_PesinFiyatOran stokfiyat 
				--							,AVG((isnull(d.new_kdvharicfiyat,0) * @New_PesinFiyatOran) / d.new_sataesasdairebrtalan) as Pesinm2Fiyat
				--					from  new_daire d
				--					where 1=1 and d.new_satisdurumu in (1,6,7) 
				--								and d.new_projeid = 'DE4F981E-27F1-EB11-853A-000C292E580F'
				--and new_UygulamaTip not in ('Dükkan','Ofis')
				--group by left(d.new_UygulamaTip,3) 
		/************************************************* 
		******************** RADISSON BLU *********************
		***********************---- END ----**************/

		/************************************************* 
		******************** THE SPORRÝORS.. *********************
		***********************---- BEGIN ----**************/
				Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																	when 0 then 1
																	else max(nsh.new_PesinFiyatOran)
																End) as float)  
			
													from new_satishedef nsh (nolock)
													where nsh.statecode = 0
														and nsh.new_projeid = 'B94D6764-1D20-EB11-82A7-000C292E580F'
														and nsh.new_HedefYil = @TargetYear
														and nsh.new_PesinFiyatOran is not null )


				insert into #tmp_son5
				select	0 parsel, left(d.new_UygulamaTip,3) as new_dairetip
											,count(left(d.new_UygulamaTip,3)) stokadet 
											,sum(isnull(d.new_uygulamasatm2,0)) stokm2
											,sum(isnull(d.new_kdvharicfiyat,0)) * @New_PesinFiyatOran stokfiyat 
											,((sum(isnull(d.new_kdvharicfiyat,0)) * @New_PesinFiyatOran) / sum(d.new_UygulamaSatM2)) as Pesinm2Fiyat
									from  new_daire d
									where 1=1 and d.new_satisdurumu in (1) and d.new_paylasimdurum!=100000011
									and d.new_projeid = 'B94D6764-1D20-EB11-82A7-000C292E580F'
									and new_UygulamaTip not in ('Dükkan','Ofis')
									group by left(d.new_UygulamaTip,3) 
		/************************************************* 
		******************** THE SPORRÝORS.. *********************
		***********************---- END ----**************/


				select  new_dairetip
						,SUM(stokadet) as stokadet
						,SUM(stokm2) as stokm2
						,SUM(satism2tl12) as stokfiyat
						,AVG(stok12) as Pesinm2Fiyat
				from #tmp_son5
				group by new_dairetip
END

IF @TargetNumber = 6
BEGIN
Set @TargetYear = (select top 1 sm.AttributeValue 
							from StringMapBase (nolock) sm 
							where sm.AttributeName = 'new_HedefYil' 
								and sm.value = Year(GETDATE())
					)
				
				Drop table if exists #tmp6
				Drop table if exists #tmp_son6

				Create table #tmp_son6
				(
					new_parsel varchar(10)
					,new_dairetip varchar(50)
					,stokadet int
					,stokm2 float
					,satism2tl12 decimal (18,2)
					,stok12 decimal (18,2)
				)

		/************************************************* 
		******************** CER ÝSTANBUL ****************
		***********************---- BEGIN ----************/		
				Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																	when 0 then 1
																	else max(nsh.new_PesinFiyatOran)
																End) as float)  
			
													from new_satishedef nsh (nolock)
													where nsh.statecode = 0
														and nsh.new_projeid = '9F2C9D29-59D6-E611-80FE-3417EBEAECF3'
														and nsh.new_HedefYil = @TargetYear

														and nsh.new_PesinFiyatOran is not null )

				select d.new_parsel,
				case when d.new_uygulamatip='Ticari' then 'T5' else  new_uygulamatip END
				 new_dairetip
				 , count(*) stokadet
				 , sum(isnull(d.new_UygulamaSatM2,0)) stokm2
				 , sum(CAST( new_UygulamaFiyat as DECIMAL(18,0))* @New_PesinFiyatOran)/1.18 stokm2tl12
				 , AVG((CAST( new_UygulamaFiyat as DECIMAL(18,0))* @New_PesinFiyatOran)/1.18/(new_uygulamasatm2)) stok12
				 into #tmp6
				 from  new_daire d
				 where 1=1 and d.new_satisdurumu in (1,6,7,100000000) 
				 and d.new_projeid = '9F2C9D29-59D6-E611-80FE-3417EBEAECF3'
				 and new_UygulamaTip is not null and statecode=0  and d.new_UygulamaTip != 'T1-BLOK' 
					and d.new_name not in (
										 'CER-T1-19',
										'CER-T1-20',
										'CER-T1-21',
										'CER-T1-22',
										'CER-T1-23',
										'CER-T1A-10')
				group by d.new_parsel,d.new_uygulamatip

				insert into #tmp6 
				select d.new_parsel,
				'Ticari'
				 new_dairetip, count(*) stokadet, sum(isnull(d.new_UygulamaSatM2,0)) stokm2
				,sum(CAST( new_UygulamaFiyat as DECIMAL(18,0))*@New_PesinFiyatOran)/1.18 stokm2tl12
				, AVG((CAST( new_UygulamaFiyat as DECIMAL(18,0))* @New_PesinFiyatOran)/1.18/(new_uygulamasatm2)) stok12
				 from  new_daire d
				 where 1=1 and d.new_satisdurumu in (1,6,7,100000000) 
				 and d.new_projeid = '9F2C9D29-59D6-E611-80FE-3417EBEAECF3'
				 and new_UygulamaTip is not null and statecode=0  and d.new_name  in (
				 'CER-T1-19',
				'CER-T1-20',
				'CER-T1-21',
				'CER-T1-22',
				'CER-T1-23',
				'CER-T1A-10')
				group by d.new_parsel,d.new_uygulamatip

				insert into #tmp6 
				select d.new_parsel,
				'T1-Loft'
				 new_dairetip, count(*) stokadet, sum(isnull(d.new_UygulamaSatM2,0)) stokm2
				,sum(CAST( new_UygulamaFiyat as DECIMAL(18,0))*@New_PesinFiyatOran)/1.18 stokm2tl12
				, AVG((CAST( new_UygulamaFiyat as DECIMAL(18,0))* @New_PesinFiyatOran)/1.18/(new_uygulamasatm2)) stok12
				 from  new_daire d
				 where 1=1 and d.new_satisdurumu in (1,6,7,100000000) 
				 and d.new_projeid = '9F2C9D29-59D6-E611-80FE-3417EBEAECF3'
				 and new_UygulamaTip is not null and statecode=0  and d.new_UygulamaTip = 'T1-BLOK'

				group by d.new_parsel,d.new_uygulamatip

				insert into #tmp_son6
				select new_parsel
						,Left(new_dairetip,7) new_dairetip
						,stokadet
						,stokm2
						,stokm2tl12
						,stok12
				from #tmp6
				where stokm2tl12 is not null
				and new_dairetip  in ('Ticari')
		/************************************************* 
		******************** CER ÝSTANBUL ****************
		***********************---- END ----**************/
		

		/************************************************* 
		******************** ÇAMLIYAKA KONAKLARI *********
		***********************---- BEGIN ----************/		
		Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
															when 0 then 1
															else max(nsh.new_PesinFiyatOran)
														End) as float)  
			
											from new_satishedef nsh (nolock)
											where nsh.statecode = 0
												and nsh.new_projeid = '7265A677-66AA-E611-80E6-3417EBEAECF3'
												and nsh.new_HedefYil = @TargetYear
												and nsh.new_PesinFiyatOran is not null )
		insert into #tmp_son6
		select	 0 new_parsel,left(d.new_UygulamaTip,3) as new_dairetip
									,count(left(d.new_UygulamaTip,3)) stokadet 
									,sum(isnull(d.new_uygulamasatm2,0)) stokm2
									,sum(isnull(d.new_kdvharicfiyat,0)) * @New_PesinFiyatOran stokfiyat 
									,AVG((isnull(d.new_kdvharicfiyat,0) * @New_PesinFiyatOran) / d.new_UygulamaSatM2) as Pesinm2Fiyat
							from  new_daire d
							where 1=1 and d.new_satisdurumu in (1) and d.new_paylasimdurum!=100000011
										and d.new_projeid = '7265A677-66AA-E611-80E6-3417EBEAECF3'
		and new_UygulamaTip  in ('Dükkan','Ofis')
		group by left(d.new_UygulamaTip,3) 
		/************************************************* 
		******************** ÇAMLIYAKA KONAKLARI *********
		***********************---- END ----**************/
		

		/************************************************* 
		******************** KEKLÝKTEPE ******************
		***********************---- BEGIN ----************/
		
				Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																	when 0 then 1
																	else max(nsh.new_PesinFiyatOran)
																End) as float)  
			
													from new_satishedef nsh (nolock)
													where nsh.statecode = 0
														and nsh.new_projeid = '0C13E4A5-F358-EC11-85A7-000C292E580F'
														and nsh.new_HedefYil = @TargetYear
														and nsh.new_PesinFiyatOran is not null )
				insert into #tmp_son6
				select	0 parsel,left(d.new_UygulamaTip,3) as new_dairetip
											,count(left(d.new_UygulamaTip,3)) stokadet 
											,sum(isnull(d.new_uygulamasatm2,0)) stokm2
											,sum(isnull(d.new_kdvharicfiyat,0)) * @New_PesinFiyatOran stokfiyat 
											,AVG((isnull(d.new_kdvharicfiyat,0) * @New_PesinFiyatOran) / d.new_UygulamaSatM2) as Pesinm2Fiyat
									from  new_daire d
									where 1=1 and d.new_satisdurumu in (1) 
												and d.new_projeid = '0C13E4A5-F358-EC11-85A7-000C292E580F'
				and new_UygulamaTip  in ('Dükkan','Ofis')
				group by left(d.new_UygulamaTip,3) 
		/************************************************* 
		******************** KEKLÝKTEPE ******************
		***********************---- END ----**************/

		/************************************************* 
		******************** KORDON **********************
		***********************---- BEGIN ----*************/		
				Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																	when 0 then 1
																	else max(nsh.new_PesinFiyatOran)
																End) as float)  
			
													from new_satishedef nsh (nolock)
													where nsh.statecode = 0
														and nsh.new_projeid = 'BE547B6F-B78F-E611-80D2-3417EBEAECF3'
														and nsh.new_HedefYil = @TargetYear
														and nsh.new_PesinFiyatOran is not null )
				insert into #tmp_son6
				select	0 parsel,left(d.new_UygulamaTip,3) as new_dairetip
											,count(left(d.new_UygulamaTip,3)) stokadet 
											,sum(isnull(d.new_uygulamasatm2,0)) stokm2
											,sum(isnull(d.new_kdvharicfiyat,0)) * @New_PesinFiyatOran stokfiyat 
											,AVG((isnull(d.new_kdvharicfiyat,0) * @New_PesinFiyatOran) / d.new_UygulamaSatM2) as Pesinm2Fiyat
									from  new_daire d
									where 1=1 and d.new_satisdurumu in (1,6,7) 
												and d.new_projeid = 'BE547B6F-B78F-E611-80D2-3417EBEAECF3'
				and new_UygulamaTip in ('Dükkan')
				group by left(d.new_UygulamaTip,3)
		/************************************************* 
		******************** KORDON **********************
		***********************---- END ----**************/		


		/************************************************* 
		******************** MODERNYAKA *********************
		***********************---- BEGIN ----**************/
				Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																	when 0 then 1
																	else max(nsh.new_PesinFiyatOran)
																End) as float)  
			
													from new_satishedef nsh (nolock)
													where nsh.statecode = 0
														and nsh.new_projeid = '361D6FC3-22A7-EB11-844C-000C292E580F'
														and nsh.new_HedefYil = @TargetYear
														and nsh.new_PesinFiyatOran is not null )
				insert into #tmp_son6
				select	0 parsel, left(d.new_UygulamaTip,3) as new_dairetip
											,count(left(d.new_UygulamaTip,3)) stokadet 
											,sum(isnull(d.new_uygulamasatm2,0)) stokm2
											,sum(isnull(d.new_kdvharicfiyat,0)) * @New_PesinFiyatOran stokfiyat 
											,AVG((isnull(d.new_kdvharicfiyat,0) * @New_PesinFiyatOran) / d.new_UygulamaSatM2) as Pesinm2Fiyat
									from  new_daire d
									where 1=1 and d.new_satisdurumu in (1,6,7) 
												and d.new_projeid = '361D6FC3-22A7-EB11-844C-000C292E580F'
				and new_UygulamaTip in ('Dükkan')
				group by left(d.new_UygulamaTip,3)
		/************************************************* 
		******************** MODERNYAKA *********************
		***********************---- END ----**************/

		/************************************************* 
		******************** RADISSON BLU *********************
		***********************---- BEGIN ----**************/
				--Set @TargetYear = (select top 1 sm.AttributeValue 
				--							from StringMapBase (nolock) sm 
				--							where sm.AttributeName = 'new_HedefYil' 
				--								and sm.value = Year(GETDATE())
				--					)



				--Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
				--													when 0 then 1
				--													else max(nsh.new_PesinFiyatOran)
				--												End) as float)  
			
				--									from new_satishedef nsh (nolock)
				--									where nsh.statecode = 0
				--										and nsh.new_projeid = 'DE4F981E-27F1-EB11-853A-000C292E580F'
				--										and nsh.new_HedefYil = @TargetYear
				--										and nsh.new_PesinFiyatOran is not null )


				--insert into #tmp_son6
				--select	0 parsel, left(d.new_UygulamaTip,3) as new_dairetip
				--							,count(left(d.new_UygulamaTip,3)) stokadet 
				--							,sum(isnull(d.new_sataesasdairebrtalan,0)) stokm2
				--							,sum(isnull(d.new_kdvharicfiyat,0)) * @New_PesinFiyatOran stokfiyat 
				--							,AVG((isnull(d.new_kdvharicfiyat,0) * @New_PesinFiyatOran) / d.new_sataesasdairebrtalan) as Pesinm2Fiyat
				--					from  new_daire d
				--					where 1=1 and d.new_satisdurumu in (1,6,7) 
				--								and d.new_projeid = 'DE4F981E-27F1-EB11-853A-000C292E580F'
				--and new_UygulamaTip in ('Dükkan','Ofis')
				--group by left(d.new_UygulamaTip,3) 
		/************************************************* 
		******************** RADISSON BLU *********************
		***********************---- END ----**************/

		/************************************************* 
		******************** THE SPORRÝORS.. *********************
		***********************---- BEGIN ----**************/
				Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																	when 0 then 1
																	else max(nsh.new_PesinFiyatOran)
																End) as float)  
			
													from new_satishedef nsh (nolock)
													where nsh.statecode = 0
														and nsh.new_projeid = 'B94D6764-1D20-EB11-82A7-000C292E580F'
														and nsh.new_HedefYil = @TargetYear
														and nsh.new_PesinFiyatOran is not null )


				insert into #tmp_son6
				select	0 parsel, left(d.new_UygulamaTip,3) as new_dairetip
											,count(left(d.new_UygulamaTip,3)) stokadet 
											,sum(isnull(d.new_uygulamasatm2,0)) stokm2
											,sum(isnull(d.new_kdvharicfiyat,0)) * @New_PesinFiyatOran stokfiyat 
											,((sum(isnull(d.new_kdvharicfiyat,0)) * @New_PesinFiyatOran) / sum(d.new_UygulamaSatM2)) as Pesinm2Fiyat
									from  new_daire d
									where 1=1 and d.new_satisdurumu in (1) and d.new_paylasimdurum!=100000011
									and d.new_projeid = 'B94D6764-1D20-EB11-82A7-000C292E580F'
									and new_UygulamaTip in ('Dükkan','Ofis')
									group by left(d.new_UygulamaTip,3) 
		/************************************************* 
		******************** THE SPORRÝORS.. *********************
		***********************---- END ----**************/

				select  new_dairetip
						,SUM(stokadet) as stokadet
						,SUM(stokm2) as stokm2
						,SUM(satism2tl12) as stokfiyat
						,AVG(stok12) as Pesinm2Fiyat
				from #tmp_son6
				group by new_dairetip
END

IF @TargetNumber = 7
BEGIN
Set @TargetYear = (select top 1 sm.AttributeValue 
							from StringMapBase (nolock) sm 
							where sm.AttributeName = 'new_HedefYil' 
								and sm.value = Year(GETDATE())
					)

				Drop table if exists #tmp7
				Drop table if exists #tmp_son7

								Create table #tmp_son7
								(
									new_parsel varchar(10)
									,new_dairetip varchar(50)
									,stokadet int
									,satism2 float
									,satisfiyat decimal (18,2)
									,PesinM2Fiyat decimal (18,2)
								)

		/************************************************* 
		******************** CER ÝSTANBUL ****************
		***********************---- BEGIN ----************/		
				Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																	when 0 then 1
																	else max(nsh.new_PesinFiyatOran)
																End) as float)  
			
													from new_satishedef nsh (nolock)
													where nsh.statecode = 0
														and nsh.new_projeid = '9F2C9D29-59D6-E611-80FE-3417EBEAECF3'
														and nsh.new_HedefYil = @TargetYear
														and nsh.new_PesinFiyatOran is not null )

				select 
				 toplam.new_parsel as new_ada
				,left(daire.new_dairetip,11) as new_dairetip
				,toplam.stokadet toplamadet
				,satis.satisadet satisadet
				,ISNULL(stok.stokadet,0) stokadet
				,(isnull(satis.satism2,0) + isnull(stok.stokm2,0)) toplamm2
				,satis.satism2 
				,stok.stokm2
				,(isnull(satis.satisfiyat,0) + isnull(stok.stokfiyat,0)*@New_PesinFiyatOran) toplamfiyat
				,satis.satisfiyat 
				,stok.stokfiyat*@New_PesinFiyatOran  stokfiyat
				,toplam.toplamlistefiyat
				,(CAST( satis.satisfiyat as DECIMAL(18,0) )  / CAST(satis.satism2 as DECIMAL(18,0) ) ) satism2tl
				,(CAST( stok.stokfiyat as DECIMAL(18,0) )  / CAST(stok.stokm2 as DECIMAL(18,0) ) ) stokm2tl
				,(CAST( stok.stokfiyat as DECIMAL(18,0) )  / CAST(stok.stokm2 as DECIMAL(18,0) ) )* @New_PesinFiyatOran  stok12
				,(CAST( stok.stokfiyat as DECIMAL(18,0) ))* @New_PesinFiyatOran stokm2tl12
				,(satis.satisfiyat+(stok.stokfiyat *@New_PesinFiyatOran))/(satis.satism2+stok.stokm2) as hedefrealize
				,toplam.new_islembitiskdvharic
				,toplam.new_isbitimkdvdahil
				 into #tmp7
				 from 
				 (select DISTINCT new_dairetip from new_daire where new_projeid='9F2C9D29-59D6-E611-80FE-3417EBEAECF3' AND new_dairetip<>'Ofis') daire
				 left join 
				  ( select d.new_parsel,d.new_dairetip,d.new_paylasimdurum , count(*) stokadet , sum(isnull(d.new_sataesasdairebrtalan,0)) stokm2
				, sum(isnull(d.new_kdvharicfiyat,0)) toplamlistefiyat , sum(isnull(d.new_isbitimkdvharic,0)) new_islembitiskdvharic, sum(isnull(d.new_isbitimkdvdahil,0)) new_isbitimkdvdahil
				 from  new_daire d
				 where 1=1 and d.new_satisdurumu   in (1,3,5,6,7,8,100000000) and  new_paylasimdurum = 1
				 and d.new_projeid='9F2C9D29-59D6-E611-80FE-3417EBEAECF3' 
				group by d.new_parsel,d.new_dairetip,d.new_paylasimdurum
				 )toplam on daire.new_dairetip=toplam.new_dairetip
				  left join
				(select d.new_parsel,d.new_dairetip , count(*) stokadet, sum(isnull(d.new_sataesasdairebrtalan,0)) stokm2
				, sum(isnull(d.new_kdvharicfiyat,0)) stokfiyat 
				 from  new_daire d
				 where 1=1 and d.new_satisdurumu in (1,6,7,100000000) and  new_paylasimdurum = 1
				 and d.new_projeid ='9F2C9D29-59D6-E611-80FE-3417EBEAECF3'
				group by d.new_parsel,d.new_dairetip
				)stok on toplam.new_dairetip = stok.new_dairetip and toplam.new_parsel=stok.new_parsel --and toplam.new_blok=stok.new_blok
				left join
				(select d.new_parsel,d.new_dairetip , count(*) satisadet , sum(isnull(d.new_sataesasdairebrtalan,0)) satism2
				, sum(isnull((case s.new_satisdoviz when 2 then
				(case when new_networkkomisyon is null then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) when new_NetworkKomisyon=0 then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) else dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) end) 
				else
				(new_kdvharic) end),0))  satisfiyat
				 from new_satis s
				inner join new_daire d on d.new_daireId = s.new_daireid
				left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
				where 1=1 and  s.statecode=0  
				and s.new_projeid ='9F2C9D29-59D6-E611-80FE-3417EBEAECF3'
				group by d.new_parsel,d.new_dairetip) satis
				 on satis.new_dairetip = toplam.new_dairetip and satis.new_parsel=toplam.new_parsel

				insert into #tmp_son7
				Select  0
						,Left(new_dairetip,7) new_dairetip
						,satisadet
						,satism2
						,satisfiyat
						,satism2tl
				from #tmp7
				where new_dairetip <>'Ticari'
		/************************************************* 
		******************** CER ÝSTANBUL ****************
		***********************---- END ----**************/
		

		/************************************************* 
		******************** ÇAMLIYAKA KONAKLARI *********
		***********************---- BEGIN ----************/		
				Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
													when 0 then 1
													else max(nsh.new_PesinFiyatOran)
												End) as float)  
			
									from new_satishedef nsh (nolock)
									where nsh.statecode = 0
										and nsh.new_projeid = '7265A677-66AA-E611-80E6-3417EBEAECF3'
										and nsh.new_HedefYil = @TargetYear
										and nsh.new_PesinFiyatOran is not null )

				insert into #tmp_son7
				select 0 parsel,left(d.new_UygulamaTip,3) as new_dairetip 
							,count(*) satisadet 
							,sum(isnull(d.new_uygulamasatm2,0)) satism2
							, sum(isnull((case s.new_satisdoviz when 2 then
											(case when new_networkkomisyon is null then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) 
													when new_NetworkKomisyon=0 then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) 
											 else dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)-(dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)*(new_NetworkKomisyon/100)) end) 
											else
											(case when new_networkkomisyon is null then new_kdvharic when new_NetworkKomisyon=0 then new_kdvharic else s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)) end) end),0))  satisfiyat
							, AVG ((s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)))/d.new_uygulamasatm2) as PesinM2Fiyat
					from new_satis s
						inner join new_daire d on d.new_daireId = s.new_daireid
						left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
						where 1=1 and s.new_satisdurumu   in (3,5,6,7,8) and s.statecode=0 
								and s.new_projeid = '7265A677-66AA-E611-80E6-3417EBEAECF3'
					and new_UygulamaTip not in ('Dükkan','Ofis')								
				group by left(d.new_UygulamaTip,3)
		/************************************************* 
		******************** ÇAMLIYAKA KONAKLARI *********
		***********************---- END ----**************/
		

		/************************************************* 
		******************** KEKLÝKTEPE ******************
		***********************---- BEGIN ----************/		
					Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
													when 0 then 1
													else max(nsh.new_PesinFiyatOran)
												End) as float)  
			
									from new_satishedef nsh (nolock)
									where nsh.statecode = 0
										and nsh.new_projeid = '0C13E4A5-F358-EC11-85A7-000C292E580F'
										and nsh.new_HedefYil = @TargetYear
										and nsh.new_PesinFiyatOran is not null )
				
					insert into #tmp_son7
					select 0 parsel, left(d.new_UygulamaTip,3) as new_dairetip 
							,count(*) satisadet 
							,sum(isnull(d.new_uygulamasatm2,0)) satism2
							, sum(isnull((case s.new_satisdoviz when 2 then
											(case when new_networkkomisyon is null then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) 
													when new_NetworkKomisyon=0 then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) 
											 else dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)-(dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)*(new_NetworkKomisyon/100)) end) 
											else
											(case when new_networkkomisyon is null then new_kdvharic when new_NetworkKomisyon=0 then new_kdvharic else s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)) end) end),0))  satisfiyat
							, AVG ((s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)))/d.new_uygulamasatm2) as PesinM2Fiyat
					from new_satis s
						inner join new_daire d on d.new_daireId = s.new_daireid
						left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
						where 1=1 and s.new_satisdurumu   in (3,5,6,7,8) and s.statecode=0 
						and s.new_projeid = '0C13E4A5-F358-EC11-85A7-000C292E580F'
						and new_UygulamaTip not in ('Dükkan','Ofis')								
					group by left(d.new_UygulamaTip,3)
		/************************************************* 
		******************** KEKLÝKTEPE ******************
		***********************---- END ----**************/

		/************************************************* 
		******************** KORDON **********************
		***********************---- BEGIN ----*************/
			Set @TargetYear = (select top 1 sm.AttributeValue 
											from StringMapBase (nolock) sm 
											where sm.AttributeName = 'new_HedefYil' 
												and sm.value = Year(GETDATE())
									)

				Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																	when 0 then 1
																	else max(nsh.new_PesinFiyatOran)
																End) as float)  
			
													from new_satishedef nsh (nolock)
													where nsh.statecode = 0
														and nsh.new_projeid = 'BE547B6F-B78F-E611-80D2-3417EBEAECF3'
														and nsh.new_HedefYil = @TargetYear
														and nsh.new_PesinFiyatOran is not null )

				insert into #tmp_son7
				select 0 parsel,left(d.new_UygulamaTip,3) as new_dairetip 
											,count(*) satisadet 
											,sum(isnull(d.new_uygulamasatm2,0)) satism2
											, sum(isnull((case s.new_satisdoviz when 2 then
															(case when new_networkkomisyon is null then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) 
																	when new_NetworkKomisyon=0 then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) 
															 else dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)-(dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)*(new_NetworkKomisyon/100)) end) 
															else
															(case when new_networkkomisyon is null then new_kdvharic when new_NetworkKomisyon=0 then new_kdvharic else s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)) end) end),0))  satisfiyat
											, AVG ((s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)))/d.new_uygulamasatm2) as PesinM2Fiyat
									from new_satis s
										inner join new_daire d on d.new_daireId = s.new_daireid
										left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
										where 1=1 and s.new_satisdurumu   in (3,5,6,7,8) and s.statecode=0 
												and s.new_projeid = 'BE547B6F-B78F-E611-80D2-3417EBEAECF3'

				and new_UygulamaTip not in ('Dükkan','Ofis')								
				group by left(d.new_UygulamaTip,3)
		/************************************************* 
		******************** KORDON **********************
		***********************---- END ----*************/

		/************************************************* 
		******************** MODERNYAKA ********************
		***********************---- BEGIN ----*************/
			Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																when 0 then 1
																else max(nsh.new_PesinFiyatOran)
															End) as float)  
			
												from new_satishedef nsh (nolock)
												where nsh.statecode = 0
													and nsh.new_projeid = '361D6FC3-22A7-EB11-844C-000C292E580F'
													and nsh.new_HedefYil = @TargetYear
													and nsh.new_PesinFiyatOran is not null )

		    insert into #tmp_son7
			select 0 parsel,left(d.new_UygulamaTip,3) as new_dairetip 
										,count(*) satisadet 
										,sum(isnull(d.new_uygulamasatm2,0)) satism2
										, sum(isnull((case s.new_satisdoviz when 2 then
														((isnull( s.new_ssftlkdvharic - ( new_ssftlkdvharic * (s.new_NetworkKomisyon/100))
														, dbo.GetUSDPrice (new_kdvharic, s.CreatedOn) - (dbo.GetUSDPrice (new_kdvharic, s.CreatedOn) *(s.new_NetworkKomisyon/100))  
													  )
											  )) 
														else
														(case when new_networkkomisyon is null then new_kdvharic when new_NetworkKomisyon=0 then new_kdvharic else s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)) end) end),0))  satisfiyat
										, AVG ( Case s.new_satisdoviz
														when 1 then (s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)))/d.new_uygulamasatm2
														else
															(Isnull(s.new_ssftlkdvharic,dbo.GetUSDPrice (new_kdvharic, s.CreatedOn))
																-(Isnull(s.new_ssftlkdvharic,dbo.GetUSDPrice (new_kdvharic, s.CreatedOn))*(new_NetworkKomisyon/100)))/d.new_uygulamasatm2
														End
												) as PesinM2Fiyat
								from new_satis s
									inner join new_daire d on d.new_daireId = s.new_daireid
									left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
									where 1=1 and s.new_satisdurumu   in (3,5,7) and s.statecode=0 
											and s.new_projeid = '361D6FC3-22A7-EB11-844C-000C292E580F'
			and new_UygulamaTip not in ('Dükkan','Ofis')								
			group by left(d.new_UygulamaTip,3)
		/************************************************* 
		******************** MODERNYAKA *******************
		***********************---- END ----*************/

		/************************************************* 
		******************** RADISSON BLU *******************
		***********************---- BEGIN ----*************/
			--Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
			--													when 0 then 1
			--													else max(nsh.new_PesinFiyatOran)
			--												End) as float)  
			
			--									from new_satishedef nsh (nolock)
			--									where nsh.statecode = 0
			--										and nsh.new_projeid = 'DE4F981E-27F1-EB11-853A-000C292E580F'
			--										and nsh.new_HedefYil = @TargetYear
			--										and nsh.new_PesinFiyatOran is not null )

			--insert into #tmp_son7
			--select 0 parsel, left(d.new_UygulamaTip,3) as new_dairetip 
			--							,count(*) satisadet 
			--							,sum(isnull(d.new_sataesasdairebrtalan,0)) satism2
			--														, sum(isnull((case s.new_satisdoviz when 2 then
			--											(case when new_networkkomisyon is null then Isnull(dbo.GetUSDPrice(new_kdvharic,s.CreatedOn),s.new_ssftlkdvharic) 
			--													when new_NetworkKomisyon=0 then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) 
			--											 else Isnull(dbo.GetUSDPrice(new_kdvharic,s.CreatedOn),s.new_ssftlkdvharic) - ( Isnull(dbo.GetUSDPrice(new_kdvharic,s.CreatedOn),s.new_ssftlkdvharic) *(new_NetworkKomisyon/100)) end) 
			--											else
			--											(case when new_networkkomisyon is null then new_kdvharic when new_NetworkKomisyon=0 then new_kdvharic else s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)) end) end),0))  satisfiyat
			--							, AVG ((Isnull(dbo.GetUSDPrice(s.new_kdvharic,s.CreatedOn),s.new_ssftlkdvharic) 
			--									-
			--									 (Isnull(dbo.GetUSDPrice(s.new_kdvharic,s.CreatedOn),s.new_ssftlkdvharic) * (s.new_NetworkKomisyon/100))
			--									)
			--									/d.new_sataesasdairebrtalan) as PesinM2Fiyat
			--					from new_satis s
			--						inner join new_daire d on d.new_daireId = s.new_daireid
			--						left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
			--						where 1=1 and s.new_satisdurumu   in (3,5,6,7,8) and s.statecode=0 
			--								and s.new_projeid = 'DE4F981E-27F1-EB11-853A-000C292E580F'

			--and new_UygulamaTip not in ('Dükkan','Ofis')								
			--group by left(d.new_UygulamaTip,3)
		/************************************************* 
		******************** RADISSON BLU *******************
		***********************---- END ----*************/

		/************************************************* 
		******************** THE SPORRIOR....*******************
		***********************---- BEGIN ----*************/
				Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																	when 0 then 1
																	else max(nsh.new_PesinFiyatOran)
																End) as float)  
			
													from new_satishedef nsh (nolock)
													where nsh.statecode = 0
														and nsh.new_projeid = 'B94D6764-1D20-EB11-82A7-000C292E580F'
														and nsh.new_HedefYil = @TargetYear
														and nsh.new_PesinFiyatOran is not null )

				insert into #tmp_son7
				select 0 parsel,left(d.new_UygulamaTip,3) as new_dairetip 
											,count(*) satisadet 
											,sum(isnull(d.new_uygulamasatm2,0)) satism2
											, sum(isnull((case s.new_satisdoviz when 2 then
															(case when new_networkkomisyon is null then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) 
																	when new_NetworkKomisyon=0 then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) 
															 else dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)-(dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)*(new_NetworkKomisyon/100)) end) 
															else
															(case when new_networkkomisyon is null then new_kdvharic when new_NetworkKomisyon=0 then new_kdvharic else s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)) end) end),0))  satisfiyat
											, AVG ((s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)))/d.new_uygulamasatm2) as PesinM2Fiyat
									from new_satis s
										inner join new_daire d on d.new_daireId = s.new_daireid
										left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
										where 1=1 and s.new_satisdurumu   in (3,5,6,7,8) and s.statecode=0 
												and s.new_projeid = 'B94D6764-1D20-EB11-82A7-000C292E580F'

				and new_UygulamaTip not in ('Dükkan','Ofis')								
				group by d.new_UygulamaTip
		/************************************************* 
		******************** THE SPORRIOR....*******************
		***********************---- END ----*************/

				select  t.new_dairetip
						,SUM(t.stokadet) as satisadet
						,SUm(t.satism2) as satism2
						,SUM(t.satisfiyat) as satisfiyat
						,AVG(t.PesinM2Fiyat)  as PesinM2Fiyat
				from #tmp_son7 t
				group by t.new_dairetip
END

IF @TargetNumber = 8
BEGIN
Set @TargetYear = (select top 1 sm.AttributeValue 
							from StringMapBase (nolock) sm 
							where sm.AttributeName = 'new_HedefYil' 
								and sm.value = Year(GETDATE())
					)

				Drop table if exists #tmp8
				Drop table if exists #tmp_son8
								
				Create table #tmp_son8
				(
					new_parsel varchar(10)
					,new_dairetip varchar(50)
					,satisadet int
					,satism2 float
					,satisfiyat decimal (18,2)
					,PesinM2Fiyat decimal (18,2)
				)

		/************************************************* 
		******************** CER ÝSTANBUL ****************
		***********************---- BEGIN ----************/		
				Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																	when 0 then 1
																	else max(nsh.new_PesinFiyatOran)
																End) as float)  
			
													from new_satishedef nsh (nolock)
													where nsh.statecode = 0
														and nsh.new_projeid = '9F2C9D29-59D6-E611-80FE-3417EBEAECF3'
														and nsh.new_HedefYil = @TargetYear
														and nsh.new_PesinFiyatOran is not null )

				select 
				 toplam.new_parsel as new_ada
				,left(daire.new_dairetip,11) as new_dairetip
				,toplam.stokadet toplamadet
				,satis.satisadet satisadet
				,ISNULL(stok.stokadet,0) stokadet
				,(isnull(satis.satism2,0) + isnull(stok.stokm2,0)) toplamm2
				,satis.satism2 
				,stok.stokm2
				,(isnull(satis.satisfiyat,0) + isnull(stok.stokfiyat,0)*@New_PesinFiyatOran) toplamfiyat
				,satis.satisfiyat 
				,stok.stokfiyat*@New_PesinFiyatOran  stokfiyat
				,toplam.toplamlistefiyat
				,(CAST( satis.satisfiyat as DECIMAL(18,0) )  / CAST(satis.satism2 as DECIMAL(18,0) ) ) satism2tl
				,(CAST( stok.stokfiyat as DECIMAL(18,0) )  / CAST(stok.stokm2 as DECIMAL(18,0) ) ) stokm2tl
				,(CAST( stok.stokfiyat as DECIMAL(18,0) )  / CAST(stok.stokm2 as DECIMAL(18,0) ) )* @New_PesinFiyatOran  stok12
				,(CAST( stok.stokfiyat as DECIMAL(18,0) ))* @New_PesinFiyatOran stokm2tl12
				,(satis.satisfiyat+(stok.stokfiyat *@New_PesinFiyatOran))/(satis.satism2+stok.stokm2) as hedefrealize
				,toplam.new_islembitiskdvharic
				,toplam.new_isbitimkdvdahil
				 into #tmp8
				 from 
				 (select DISTINCT new_dairetip from new_daire where new_projeid='9F2C9D29-59D6-E611-80FE-3417EBEAECF3' AND new_dairetip<>'Ofis') daire
				 left join 
				  ( select d.new_parsel,d.new_dairetip,d.new_paylasimdurum , count(*) stokadet , sum(isnull(d.new_sataesasdairebrtalan,0)) stokm2
				, sum(isnull(d.new_kdvharicfiyat,0)) toplamlistefiyat , sum(isnull(d.new_isbitimkdvharic,0)) new_islembitiskdvharic, sum(isnull(d.new_isbitimkdvdahil,0)) new_isbitimkdvdahil
				 from  new_daire d
				 where 1=1 and d.new_satisdurumu   in (1,3,5,6,7,8,100000000) and  new_paylasimdurum = 1
				 and d.new_projeid='9F2C9D29-59D6-E611-80FE-3417EBEAECF3' 
				group by d.new_parsel,d.new_dairetip,d.new_paylasimdurum
				 )toplam on daire.new_dairetip=toplam.new_dairetip
				  left join
				(select d.new_parsel,d.new_dairetip , count(*) stokadet, sum(isnull(d.new_sataesasdairebrtalan,0)) stokm2
				, sum(isnull(d.new_kdvharicfiyat,0)) stokfiyat 
				 from  new_daire d
				 where 1=1 and d.new_satisdurumu in (1,6,7,100000000) and  new_paylasimdurum = 1
				 and d.new_projeid ='9F2C9D29-59D6-E611-80FE-3417EBEAECF3'
				group by d.new_parsel,d.new_dairetip
				)stok on toplam.new_dairetip = stok.new_dairetip and toplam.new_parsel=stok.new_parsel --and toplam.new_blok=stok.new_blok
				left join
				(select d.new_parsel,d.new_dairetip , count(*) satisadet , sum(isnull(d.new_sataesasdairebrtalan,0)) satism2
				, sum(isnull((case s.new_satisdoviz when 2 then
				(case when new_networkkomisyon is null then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) when new_NetworkKomisyon=0 then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) else dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) end) 
				else
				(new_kdvharic) end),0))  satisfiyat
				 from new_satis s
				inner join new_daire d on d.new_daireId = s.new_daireid
				left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
				where 1=1 and  s.statecode=0  
				and s.new_projeid ='9F2C9D29-59D6-E611-80FE-3417EBEAECF3'
				group by d.new_parsel,d.new_dairetip) satis
				 on satis.new_dairetip = toplam.new_dairetip and satis.new_parsel=toplam.new_parsel

				insert into #tmp_son8
				Select  0,Left(new_dairetip,7) new_dairetip
						,satisadet
						,satism2
						,satisfiyat
						,satism2tl
				from #tmp8
				where new_dairetip ='Ticari'
		/************************************************* 
		******************** CER ÝSTANBUL ****************
		***********************---- END ----**************/
		

		/************************************************* 
		******************** ÇAMLIYAKA KONAKLARI *********
		***********************---- BEGIN ----************/
				Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																when 0 then 1
																else max(nsh.new_PesinFiyatOran)
															End) as float)  
			
												from new_satishedef nsh (nolock)
												where nsh.statecode = 0
													and nsh.new_projeid = '7265A677-66AA-E611-80E6-3417EBEAECF3'
													and nsh.new_HedefYil = @TargetYear
													and nsh.new_PesinFiyatOran is not null )

				insert into #tmp_son8
			select 0 parsel,left(d.new_UygulamaTip,3) as new_dairetip 
										,count(*) satisadet 
										,sum(isnull(d.new_uygulamasatm2,0)) satism2
										, sum(isnull((case s.new_satisdoviz when 2 then
														(case when new_networkkomisyon is null then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) 
																when new_NetworkKomisyon=0 then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) 
														 else dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)-(dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)*(new_NetworkKomisyon/100)) end) 
														else
														(case when new_networkkomisyon is null then new_kdvharic when new_NetworkKomisyon=0 then new_kdvharic else s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)) end) end),0))  satisfiyat
										, AVG ((s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)))/d.new_uygulamasatm2) as PesinM2Fiyat
								from new_satis s
									inner join new_daire d on d.new_daireId = s.new_daireid
									left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
									where 1=1 and s.new_satisdurumu   in (3,5,6,7,8) and s.statecode=0 
											and s.new_projeid = '7265A677-66AA-E611-80E6-3417EBEAECF3'
			and new_UygulamaTip in ('Dükkan','Ofis')								
			group by left(d.new_UygulamaTip,3)
		/************************************************* 
		******************** ÇAMLIYAKA KONAKLARI *********
		***********************---- END ----**************/
		

		/************************************************* 
		******************** KEKLÝKTEPE ******************
		***********************---- BEGIN ----************/		
				Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
												when 0 then 1
												else max(nsh.new_PesinFiyatOran)
											End) as float)  
			
								from new_satishedef nsh (nolock)
								where nsh.statecode = 0
									and nsh.new_projeid = '0C13E4A5-F358-EC11-85A7-000C292E580F'
									and nsh.new_HedefYil = @TargetYear
									and nsh.new_PesinFiyatOran is not null )
				
				insert into #tmp_son8
				select 0 parsel, left(d.new_UygulamaTip,3) as new_dairetip 
						,count(*) satisadet 
						,sum(isnull(d.new_uygulamasatm2,0)) satism2
						, sum(isnull((case s.new_satisdoviz when 2 then
										(case when new_networkkomisyon is null then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) 
												when new_NetworkKomisyon=0 then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) 
											else dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)-(dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)*(new_NetworkKomisyon/100)) end) 
										else
										(case when new_networkkomisyon is null then new_kdvharic when new_NetworkKomisyon=0 then new_kdvharic else s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)) end) end),0))  satisfiyat
						, AVG ((s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)))/d.new_uygulamasatm2) as PesinM2Fiyat
				from new_satis s
					inner join new_daire d on d.new_daireId = s.new_daireid
					left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
					where 1=1 and s.new_satisdurumu   in (3,5,6,7,8) and s.statecode=0 
					and s.new_projeid = '0C13E4A5-F358-EC11-85A7-000C292E580F'
					and new_UygulamaTip in ('Dükkan','Ofis')								
				group by left(d.new_UygulamaTip,3)
		/************************************************* 
		******************** KEKLÝKTEPE ******************
		***********************---- END ----**************/

		/************************************************* 
		******************** KORDON **********************
		***********************---- BEGIN ----*************/
			Set @TargetYear = (select top 1 sm.AttributeValue 
											from StringMapBase (nolock) sm 
											where sm.AttributeName = 'new_HedefYil' 
												and sm.value = Year(GETDATE())
									)

				Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																	when 0 then 1
																	else max(nsh.new_PesinFiyatOran)
																End) as float)  
			
													from new_satishedef nsh (nolock)
													where nsh.statecode = 0
														and nsh.new_projeid = 'BE547B6F-B78F-E611-80D2-3417EBEAECF3'
														and nsh.new_HedefYil = @TargetYear
														and nsh.new_PesinFiyatOran is not null )

				insert into #tmp_son8
				select 0 parsel,left(d.new_UygulamaTip,3) as new_dairetip 
											,count(*) satisadet 
											,sum(isnull(d.new_uygulamasatm2,0)) satism2
											, sum(isnull((case s.new_satisdoviz when 2 then
															(case when new_networkkomisyon is null then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) 
																	when new_NetworkKomisyon=0 then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) 
															 else dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)-(dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)*(new_NetworkKomisyon/100)) end) 
															else
															(case when new_networkkomisyon is null then new_kdvharic when new_NetworkKomisyon=0 then new_kdvharic else s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)) end) end),0))  satisfiyat
											, AVG ((s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)))/d.new_uygulamasatm2) as PesinM2Fiyat
									from new_satis s
										inner join new_daire d on d.new_daireId = s.new_daireid
										left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
										where 1=1 and s.new_satisdurumu   in (3,5,6,7,8) and s.statecode=0 
												and s.new_projeid = 'BE547B6F-B78F-E611-80D2-3417EBEAECF3'

				and new_UygulamaTip  in ('Dükkan','Ofis')								
				group by left(d.new_UygulamaTip,3)
		/************************************************* 
		******************** KORDON **********************
		***********************---- END ----*************/		

		/************************************************* 
		******************** MODERNYAKA ********************
		***********************---- BEGIN ----*************/
			Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																when 0 then 1
																else max(nsh.new_PesinFiyatOran)
															End) as float)  
			
												from new_satishedef nsh (nolock)
												where nsh.statecode = 0
													and nsh.new_projeid = '361D6FC3-22A7-EB11-844C-000C292E580F'
													and nsh.new_HedefYil = @TargetYear
													and nsh.new_PesinFiyatOran is not null )

		    insert into #tmp_son8
			select 0 parsel,left(d.new_UygulamaTip,3) as new_dairetip 
										,count(*) satisadet 
										,sum(isnull(d.new_uygulamasatm2,0)) satism2
										, sum(isnull((case s.new_satisdoviz when 2 then
														((isnull( s.new_ssftlkdvharic - ( new_ssftlkdvharic * (s.new_NetworkKomisyon/100))
														, dbo.GetUSDPrice (new_kdvharic, s.CreatedOn) - (dbo.GetUSDPrice (new_kdvharic, s.CreatedOn) *(s.new_NetworkKomisyon/100))  
													  )
											  )) 
														else
														(case when new_networkkomisyon is null then new_kdvharic when new_NetworkKomisyon=0 then new_kdvharic else s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)) end) end),0))  satisfiyat
										, AVG ( Case s.new_satisdoviz
														when 1 then (s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)))/d.new_uygulamasatm2
														else
															(Isnull(s.new_ssftlkdvharic,dbo.GetUSDPrice (new_kdvharic, s.CreatedOn))
																-(Isnull(s.new_ssftlkdvharic,dbo.GetUSDPrice (new_kdvharic, s.CreatedOn))*(new_NetworkKomisyon/100)))/d.new_uygulamasatm2
														End
												) as PesinM2Fiyat
								from new_satis s
									inner join new_daire d on d.new_daireId = s.new_daireid
									left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
									where 1=1 and s.new_satisdurumu   in (3,5,7) and s.statecode=0 
											and s.new_projeid = '361D6FC3-22A7-EB11-844C-000C292E580F'
			and new_UygulamaTip in ('Dükkan','Ofis')								
			group by left(d.new_UygulamaTip,3)
		/************************************************* 
		******************** MODERNYAKA *******************
		***********************---- END ----*************/

		/************************************************* 
		******************** RADISSON BLU *******************
		***********************---- BEGIN ----*************/
			--Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
			--													when 0 then 1
			--													else max(nsh.new_PesinFiyatOran)
			--												End) as float)  
			
			--									from new_satishedef nsh (nolock)
			--									where nsh.statecode = 0
			--										and nsh.new_projeid = 'DE4F981E-27F1-EB11-853A-000C292E580F'
			--										and nsh.new_HedefYil = @TargetYear
			--										and nsh.new_PesinFiyatOran is not null )

			--insert into #tmp_son8
			--select 0 parsel, left(d.new_UygulamaTip,3) as new_dairetip 
			--							,count(*) satisadet 
			--							,sum(isnull(d.new_sataesasdairebrtalan,0)) satism2
			--														, sum(isnull((case s.new_satisdoviz when 2 then
			--											(case when new_networkkomisyon is null then Isnull(dbo.GetUSDPrice(new_kdvharic,s.CreatedOn),s.new_ssftlkdvharic) 
			--													when new_NetworkKomisyon=0 then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) 
			--											 else Isnull(dbo.GetUSDPrice(new_kdvharic,s.CreatedOn),s.new_ssftlkdvharic) - ( Isnull(dbo.GetUSDPrice(new_kdvharic,s.CreatedOn),s.new_ssftlkdvharic) *(new_NetworkKomisyon/100)) end) 
			--											else
			--											(case when new_networkkomisyon is null then new_kdvharic when new_NetworkKomisyon=0 then new_kdvharic else s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)) end) end),0))  satisfiyat
			--							, AVG ((Isnull(dbo.GetUSDPrice(s.new_kdvharic,s.CreatedOn),s.new_ssftlkdvharic) 
			--									-
			--									 (Isnull(dbo.GetUSDPrice(s.new_kdvharic,s.CreatedOn),s.new_ssftlkdvharic) * (s.new_NetworkKomisyon/100))
			--									)
			--									/d.new_sataesasdairebrtalan) as PesinM2Fiyat
			--					from new_satis s
			--						inner join new_daire d on d.new_daireId = s.new_daireid
			--						left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
			--						where 1=1 and s.new_satisdurumu   in (3,5,6,7,8) and s.statecode=0 
			--								and s.new_projeid = 'DE4F981E-27F1-EB11-853A-000C292E580F'

			--and new_UygulamaTip in ('Dükkan','Ofis')								
			--group by left(d.new_UygulamaTip,3)
		/************************************************* 
		******************** RADISSON BLU *******************
		***********************---- END ----*************/

		/************************************************* 
		******************** THE SPORRIOR....*******************
		***********************---- BEGIN ----*************/
				Set @New_PesinFiyatOran = ( select  top 1 cast((case count(*) 
																	when 0 then 1
																	else max(nsh.new_PesinFiyatOran)
																End) as float)  
			
													from new_satishedef nsh (nolock)
													where nsh.statecode = 0
														and nsh.new_projeid = 'B94D6764-1D20-EB11-82A7-000C292E580F'
														and nsh.new_HedefYil = @TargetYear
														and nsh.new_PesinFiyatOran is not null )

				insert into #tmp_son8
				select 0 parsel,left(d.new_UygulamaTip,3) as new_dairetip 
											,count(*) satisadet 
											,sum(isnull(d.new_uygulamasatm2,0)) satism2
											, sum(isnull((case s.new_satisdoviz when 2 then
															(case when new_networkkomisyon is null then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) 
																	when new_NetworkKomisyon=0 then dbo.GetUSDPrice(new_kdvharic,s.CreatedOn) 
															 else dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)-(dbo.GetUSDPrice(new_kdvharic,s.CreatedOn)*(new_NetworkKomisyon/100)) end) 
															else
															(case when new_networkkomisyon is null then new_kdvharic when new_NetworkKomisyon=0 then new_kdvharic else s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)) end) end),0))  satisfiyat
											, AVG ((s.new_kdvharic-(new_kdvharic*(new_NetworkKomisyon/100)))/d.new_uygulamasatm2) as PesinM2Fiyat
									from new_satis s
										inner join new_daire d on d.new_daireId = s.new_daireid
										left join new_odemeyontemi oy on oy.new_odemeyontemiId = s.new_odemeyontemiid
										where 1=1 and s.new_satisdurumu   in (3,5,6,7,8) and s.statecode=0 
												and s.new_projeid = 'B94D6764-1D20-EB11-82A7-000C292E580F'

				and new_UygulamaTip  in ('Dükkan','Ofis')								
				group by d.new_UygulamaTip
		/************************************************* 
		******************** THE SPORRIOR....*******************
		***********************---- END ----*************/
		
		
				select  t.new_dairetip
						,SUM(t.satisadet) as satisadet
						,SUm(t.satism2) as satism2
						,SUM(t.satisfiyat) as satisfiyat
						,AVG(t.PesinM2Fiyat)  as PesinM2Fiyat
				from #tmp_son8 t
				group by t.new_dairetip
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
					<td>TestDashboard2023_GenelDashboard_Chart</td>
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

		EXEC msdb..sp_send_dbmail @profile_name = 'EgeYapi', @recipients = 'onur.gultekin@egeyapi.com', @subject = 'TestDashboard2023_GenelDashboard_Chart SPsinde ERROR', @body = @Body, @body_format='HTML'
END CATCH
GO


