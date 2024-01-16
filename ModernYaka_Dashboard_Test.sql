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

Declare @ProjeId varchar(50)= '361D6FC3-22A7-EB11-844C-000C292E580F'
		,@Year varchar(4) ='2022'
		,@SubjectName varchar(50) = null

DROP TABLE IF EXISTS  #tmp_pivot

Create table #tmp_pivot
(
	SubjectName varchar(50),
	Yil int, 
	Ay int,
	Toplam float  
)

/*************************************************************************************************************************/
/*************************************************************************************************************************/
/********************************** YERLÝ KONUTLARLAR (YERLÝ/YABANCI) ***************************************************/
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
select 'Yerli Konut KDV Hariç Satýþlar' as [Yerli Konut KDV Hariç Satýþlar]
		,YEAR(ns.CreatedOn) as Yil
		,MONTH (ns.CreatedOn) as Ay
		,Isnull(sum(ns.new_kdvharic),0) Toplam
from new_satis ns (nolock) 
inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi in('1','10','2','3','6') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
where ns.new_projeid = @ProjeId
	and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
	and YEAR(ns.CreatedOn) = @Year
	and ns.statecode = 0
Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn)

	
insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
select 'Yerli KonutKDV Dahil Nakit Satýþý' as [Yerli KonutKDV Dahil Nakit Satýþý]
		,YEAR(ns.CreatedOn) as Yil
		,MONTH (ns.CreatedOn) as Ay
		,Isnull(sum(ns.new_toplamtutar),0) Toplam
from new_satis ns (nolock) 
inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi in('1','10','2','3','6') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
where ns.new_projeid = @ProjeId
	and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
	and YEAR(ns.CreatedOn) = @Year
	and ns.statecode = 0
Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn)

	
insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
select 'Yerli Konut Brüt M2 Hedefleri Satýþ' as [Yerli Konut Brüt M2 Hedefleri Satýþ]
		,YEAR(ns.CreatedOn) as Yil
		,MONTH (ns.CreatedOn) as Ay
		,Isnull(sum(nd.new_brtm2),0) Toplam
from new_satis ns (nolock) 
inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi in('1','10','2','3','6') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
where ns.new_projeid = @ProjeId
	and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
	and YEAR(ns.CreatedOn) = @Year
	and ns.statecode = 0
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
select 'Yabancý Konut KDV Hariç Satýþlar' as [Yabancý Konut KDV Hariç Satýþlar]
		,YEAR(ns.CreatedOn) as Yil
		,MONTH (ns.CreatedOn) as Ay
		,Isnull(sum(ns.new_ssftlkdvharic),0) Toplam
from new_satis ns (nolock) 
inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi in('1','10','2','3','6') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
where ns.new_projeid = @ProjeId
	and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
	and YEAR(ns.CreatedOn) = @Year
	and ns.statecode = 0
Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn)


insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
select 'Yabancý KonutKDV Dahil Nakit Satýþý' as [Yabancý KonutKDV Dahil Nakit Satýþý]
		,YEAR(ns.CreatedOn) as Yil
		,MONTH (ns.CreatedOn) as Ay
		,Isnull(sum(ns.new_ssftl),0) Toplam
from new_satis ns (nolock) 
inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi in('1','10','2','3','6') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
where ns.new_projeid = @ProjeId
	and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
	and YEAR(ns.CreatedOn) = @Year
	and ns.statecode = 0
Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn)


insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
select 'Yabancý Konut Brüt M2 Hedefleri Satýþ' as [Yabancý Konut Brüt M2 Hedefleri Satýþ]
		,YEAR(ns.CreatedOn) as Yil
		,MONTH (ns.CreatedOn) as Ay
		,Isnull(sum(nd.new_brtm2),0) Toplam
from new_satis ns (nolock) 
inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi in('1','10','2','3','6') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
where ns.new_projeid = @ProjeId
	and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
	and YEAR(ns.CreatedOn) = @Year
	and ns.statecode = 0
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
select 'Yerli Ticari KDV Hariç Satýþlar' as [Yerli Ticari KDV Hariç Satýþlar]
		,YEAR(ns.CreatedOn) as Yil
		,MONTH (ns.CreatedOn) as Ay
		,Isnull(sum(ns.new_kdvharic),0) Toplam
from new_satis ns (nolock) 
inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi not in('1','10','2','3','6') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
where ns.new_projeid = @ProjeId
	and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
	and YEAR(ns.CreatedOn) = @Year
	and ns.statecode = 0
Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn)

	
insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
select 'Yerli Ticari Dahil Nakit Satýþý' as [Yerli Ticari Dahil Nakit Satýþý]
		,YEAR(ns.CreatedOn) as Yil
		,MONTH (ns.CreatedOn) as Ay
		,Isnull(sum(ns.new_toplamtutar),0) Toplam
from new_satis ns (nolock) 
inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi not in('1','10','2','3','6') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
where ns.new_projeid = @ProjeId
	and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
	and YEAR(ns.CreatedOn) = @Year
	and ns.statecode = 0
Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn)

	
insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
select 'Yerli Ticari Brüt M2 Hedefleri Satýþ' as [Yerli Ticari Brüt M2 Hedefleri Satýþ]
		,YEAR(ns.CreatedOn) as Yil
		,MONTH (ns.CreatedOn) as Ay
		,Isnull(sum(nd.new_brtm2),0) Toplam
from new_satis ns (nolock) 
inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 1 /*1-Tc , 2-Yb*/
inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi not in('1','10','2','3','6') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
where ns.new_projeid = @ProjeId
	and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
	and YEAR(ns.CreatedOn) = @Year
	and ns.statecode = 0
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
select 'Yabancý Ticari KDV Hariç Satýþlar' as [Yabancý Ticari KDV Hariç Satýþlar]
		,YEAR(ns.CreatedOn) as Yil
		,MONTH (ns.CreatedOn) as Ay
		,Isnull(sum(ns.new_ssftlkdvharic),0) Toplam
from new_satis ns (nolock) 
inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi not in('1','10','2','3','6') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
where ns.new_projeid = @ProjeId
	and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
	and YEAR(ns.CreatedOn) = @Year
	and ns.statecode = 0
Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn)


insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
select 'Yabancý Ticari Dahil Nakit Satýþý' as [Yabancý Ticari Dahil Nakit Satýþý]
		,YEAR(ns.CreatedOn) as Yil
		,MONTH (ns.CreatedOn) as Ay
		,Isnull(sum(ns.new_ssftl),0) Toplam
from new_satis ns (nolock) 
inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi not in('1','10','2','3','6') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
where ns.new_projeid = @ProjeId
	and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
	and YEAR(ns.CreatedOn) = @Year
	and ns.statecode = 0
Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn)


insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
select 'Yabancý Ticari Brüt M2 Hedefleri Satýþ' as [Yabancý Ticari Brüt M2 Hedefleri Satýþ]
		,YEAR(ns.CreatedOn) as Yil
		,MONTH (ns.CreatedOn) as Ay
		,Isnull(sum(nd.new_brtm2),0) Toplam
from new_satis ns (nolock) 
inner join Contact c (nolock) on c.ContactId = ns.new_contactid and c.new_milliyet = 2 /*1-Tc , 2-Yb*/
inner join new_daire nd (nolock) on nd.new_daireId = ns.new_daireid and nd.new_konuttipi not in('1','10','2','3','6') /*1-Daire , 10-Konut , 100000000-Dukkan, 2 Dubleks, 3 Home Ofice , 4 Villa, 5 Bahçe, 6 Loft, 7 Teras, 8 Magaza, 9 Ofice  */
where ns.new_projeid = @ProjeId
	and ns.new_satisdurumu in (3,5,7) /*satýldý/noterli - satýldý/notersiz - kaporalý opsiyon */
	and YEAR(ns.CreatedOn) = @Year
	and ns.statecode = 0
Group by MONTH (ns.CreatedOn), YEAR(ns.CreatedOn)


/*YERLÝ ZÝYARETÇÝ HEDEF*/
insert into #tmp_pivot (SubjectName,Yil,Ay,Toplam)
select 'Yerli Ziyaretçi Hedefi ' as [Yerli Ziyaretçi Hedefi]
		,YEAR(sf.CreatedOn) as Yil
		,MONTH (sf.CreatedOn) as Ay
		,isnull(sum(sf.tpl),0) Toplam
 from 
 (select * from new_proje where new_projeId =@ProjeId) p
left join ( select  opp.new_projeid ,count(*) tpl, opp.CreatedOn from new_satisfirsat opp 
			where 1=1
				and new_gorusmeturu = 1
				AND YEAR(Createdon)= @Year
				and new_projeid = @ProjeId
			group by opp.CreatedOn,opp.new_projeid) sf on sf.new_projeid = p.new_projeId
where p.statecode = 0
Group by MONTH (sf.CreatedOn), YEAR(sf.CreatedOn),sf.tpl

/*
*******************************************
*******************************************
				PIVOT TABLE 
*******************************************
*******************************************
*/

SELECT  SubjectName
		,isnull([01],0) as [OCAK]
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
FROM  
(

  SELECT t.SubjectName,t.Yil, t.Ay, t.Toplam   
  FROM #tmp_pivot t
  where t.SubjectName = Isnull(@SubjectName,t.SubjectName)

) AS SourceTable  
PIVOT  
(  
  SUM(Toplam)  
  FOR Ay IN ([01], [02], [03], [04], [05], [06], [07], [08], [09], [10], [11], [12])  
) AS PivotTable;  

