declare @startdate datetime,@enddate datetime
set @startdate=GETDATE()-3
set @enddate=GETDATE()+1

select ecd.CouponId,ecm.IntegrationId
	,ecd.MBC
	,convert (decimal(18,2),ecd.Odd) Secim
	,case 
		when ecd.Status=0 then 'Bekliyor'
		when ecd.Status=1 then 'Kazandý'
		when ecd.Status=2 then 'Kaybetti' 
		when ecd.Status=3 then 'Ýptal'
	end Sonuc
	,m.tr_Value
	,eb.CloseDate
	,eb.Code
	into #tmp_control
from EventCouponDetails ecd(nolock) 
inner join EventCouponMasters ecm(nolock) on ecm.CouponId=ecd.CouponId
inner join EventBets eb (nolock) on eb.BetId=ecd.BetId
inner join Multilinguals m (nolock) on m.MultilingualId=eb.BetName
where convert (date,ecm.CreateDate) >=  convert (date,@startdate) and convert (date,ecm.CreateDate) <= convert (date,@enddate)
		and ecd.GameTypeId in(12,15) 
		and ecd.Status=0 
		and ecd.MBC<=4
		and convert (decimal(18,2),ecd.Odd)>10
order by eb.Code

select Code, tr_Value,MBC,Secim,COUNT(*) oynayantoplam
from #tmp_control
group by Code, tr_Value,MBC,Secim

drop table #tmp_control