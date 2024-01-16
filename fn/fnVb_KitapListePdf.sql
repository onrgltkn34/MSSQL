USE [lib03_test_veribase_com]
GO

/****** Object:  UserDefinedFunction [dbo].[fnVb_KitapListePdf]    Script Date: 14.10.2021 17:15:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Function [dbo].[fnVb_KitapListePdf] (@userid varchar(100))
RETURNS varchar(MAX)
AS
BEGIN
Declare @PdfSource varchar(max) 
		,@x int = 1 
		,@SonucCount int 
		,@KutuphaneName varchar(100)
Declare @Tmp_yazarlar  table(YazarId varchar(100), KitapId int)
Declare @Tmp_Sonuc  table(Row_number_ int, Kitap varchar(100), Yazar varchar(100), Kategori varchar(100), Kutuphane varchar(100), StokAdedi int, VerilenAdet int)

insert into @Tmp_yazarlar (YazarId , KitapId)
select  (select contentkey from patient07 where contentid =128131 and patientid =p1.id) as YazarId
		,p1.id as KitapId
from patient05 p5 
inner join patient01 p1 on p1.id =p5.patient and p1.recstatus='A'
where p5.project =799
	and (select contentkey from patient07 where contentid =128131 and patientid =p1.id)
		in
		(
			select id from patient05 p5 
			inner join patient01 p1 on p1.id =p5.patient and p1.recstatus='A'
			where p5.project =792
					and p1.id in
					(select patientid from patient07 p7 
					where contentid = 122901					 
			)
		)

insert into @Tmp_Sonuc (Row_number_, Kitap, Yazar, Kategori, Kutuphane, StokAdedi, VerilenAdet)
select  ROW_NUMBER() OVER(ORDER BY p7.id) AS Row_number_
		,(select title from patient01 where id = p7.Contentkey) as Kitap
		,(select title from patient01 where id =  (select contentkey from patient07 where contentid= 128131 and patientid = (select id from patient01 where id = p7.Contentkey))) as Yazar
		, (select string_Agg(title,', ') from patient01 where id in (select contentkey from patient07 where contentid =122901 and patientid = 
			((select contentkey from patient07 where contentid= 128131 and patientid = (select id from patient01 where id = p7.Contentkey))))) as Kategori
		,(select title from patient01 where id = (select contentkey from patient07 where  contentid =128157 and patientid =p7.patientid)) as Kutuphane
		,p7.subkey1 as StokAdedi
		,(select count(contentkey) from patient07 where contentid=128172
				and patientid in
				(select patientid from patient07 where contentid=128173 
						and patientid in(select patientid from patient07 where contentid=128163 and contentkey in ('26403','26404'))
						and contentkey = (select patientid from patient07 where  contentid =128157 and patientid =p7.patientid)
						)
						and contentkey = (select id from patient01 where id = p7.Contentkey)
		 ) as VerilenAdet
	from patient07 p7
inner join patient01 p1 on p1.id=p7.patientid and p1.recstatus='A'
where p7.contentid =128158
	and p7.subkey1>0
	and (select id from patient01 where id = p7.Contentkey) in (select KitapId from @Tmp_yazarlar)
	and (select contentkey from patient07 where  contentid =128157 and patientid =p7.patientid) =
			(case when @userid <>'system.admin'
			      then(select contentkey from patient07 where contentid=128157 and patientid= (select dbo.Vb_KutuphaneStok (@userid)))
				  else (select contentkey from patient07 where  contentid =128157 and patientid =p7.patientid)
				  End
			)
order by (select title from patient01 where id = p7.Contentkey) 


Set @KutuphaneName = (select (select Title from patient01 where id =(select contentkey from patient07 where contentid=128161 and patientid = p1.id) ) from patient01 p1 where p1.userid =@userid)

set @PdfSource ='<b><center>' + case when @userid <>'system.admin' then Upper(@KutuphaneName) when @userid='system.admin' then 'SÝSTEM YÖNETÝCÝSÝ' End + '<br><br>KÝTAP LÝSTESÝ BILGILERI<br></center><br><table style="border: 1px  border-collapse: collapse;" cellspacing="2" cellpadding="2" bgcolor="#F9F9F5">
<tbody>
<tr bgcolor="#003366">
<th><div style="font-size:12px;   border-collapse: collapse; color:#ffffff; "><p>Kitap</p></div></th>
<th><div style="font-size:12px;   border-collapse: collapse; color:#ffffff; "><p>Yazar</p></div></th>
<th><div style="font-size:12px;   border-collapse: collapse; color:#ffffff; "><p>Kategori</p></div></th>'
+case  when @userid ='system.admin' then '<th><div style="font-size:12px;   border-collapse: collapse; color:#ffffff; "><p>Kutuphane</p></div></th>' else '' End+
'<th><div style="font-size:12px;   border-collapse: collapse; color:#ffffff; "><p>Stok Adedi</p></div></th>
<th><div style="font-size:12px;   border-collapse: collapse; color:#ffffff; "><p>Verilen Adet</p></div></th>
</tr>'


Set @SonucCount = (select count(*) from @Tmp_Sonuc )

While @x < @SonucCount + 1
Begin
	


Set @PdfSource = @PdfSource + '<tr bgcolor="#FFFFFF"><th><div style="font-size:12px;   border-collapse: collapse;"><p>'+(select Kitap from @Tmp_Sonuc where Row_number_=@x)+'</p></div></th>'
							+ '<th><div style="font-size:12px;   border-collapse: collapse;"><p>'+(select Yazar from @Tmp_Sonuc where Row_number_=@x)+'</p></div></th>'
							+ '<th><div style="font-size:12px;   border-collapse: collapse;"><p>'+(select Kategori from @Tmp_Sonuc where Row_number_=@x)+'</p></div></th>'
							+case  when @userid ='system.admin' then '<th><div style="font-size:12px;   border-collapse: collapse;"><p>'+(select Kutuphane from @Tmp_Sonuc where Row_number_=@x)+'</p></div></th>' else '' End
							+ '<th><div style="font-size:12px;   border-collapse: collapse;"><p>'+(select cast (StokAdedi as varchar(5)) from @Tmp_Sonuc where Row_number_=@x)+'</p></div></th>'
							+ '<th><div style="font-size:12px;   border-collapse: collapse;"><p>'+(select cast (VerilenAdet as varchar(5)) from @Tmp_Sonuc where Row_number_=@x)+'</p></div></th></tr>'


Set @x = @x + 1
End

Set @PdfSource = @PdfSource + '</table>'


return @PdfSource

End
GO


