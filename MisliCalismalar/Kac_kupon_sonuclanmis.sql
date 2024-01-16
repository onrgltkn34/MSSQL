declare @Date Date, @StartTime nvarchar(4), @EndTime nvarchar(4)

set @Date='10.13.2011'
set @StartTime='12:00'
set @EndTime='23:59'

select CONVERT (date,ResultDate) Tarih
	,convert (nvarchar(5), convert (time,ResultDate)) Saat
	,COUNT(*) Toplam
	into #tmp_sonuc
from EventCouponMasters (nolock) 
where Status in (1,2) 
	and convert (nvarchar(5), convert (time,ResultDate)) <= @EndTime
	and convert (nvarchar(5), convert (time,ResultDate)) >= @StartTime
	and CONVERT (date,ResultDate) = convert (date,@Date)
group by ResultDate
order by ResultDate desc 


select Tarih,Saat,SUM(Toplam) SonuclananKuponSayisi 
from #tmp_sonuc
group by Tarih,Saat
order by Saat

drop table #tmp_sonuc