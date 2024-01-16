Declare @StartDate date

set @StartDate='11.07.2012'


select ecm.MemberId
		,SUM(ecm.Price) Ciro
		,mp.MultiCoupon
	into #tmp_kontrol
from EventCouponMasters ecm(nolock)
inner join MemberProperties mp (nolock) on mp.MemberId=ecm.MemberId and (mp.MultiCoupon=0 or mp.MultiCoupon is null)
where ecm.Status<>3 and convert(date,ecm.CreateDate)<=@StartDate
group by ecm.MemberId,mp.MultiCoupon
having SUM(ecm.Price)>=50000

select ecm.MemberId
		,SUM(ecm.Price) Ciro
		,mp.MultiCoupon
	into #tmp_kontrol2
from EventCouponMasters ecm(nolock)
inner join MemberProperties mp (nolock) on mp.MemberId=ecm.MemberId and (mp.MultiCoupon=0 or mp.MultiCoupon is null)
where ecm.Status<>3 and ecm.MemberId not in (select MemberId from #tmp_kontrol (nolock))
group by ecm.MemberId,mp.MultiCoupon
having SUM(ecm.Price)>=50000



--update MemberProperties set MultiCoupon=1
--where MemberId in (select MemberId from #tmp_kontrol2 where MultiCoupon is not null)


--## Çoklu kupon açýlmamýþ üyelerdir. Manuel bacooficeten ekleme yapýlacaktýr.
select *
from #tmp_kontrol2 where MultiCoupon is  null  

drop table #tmp_kontrol
drop table #tmp_kontrol2