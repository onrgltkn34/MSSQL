select  YEAR(ecm.CreateDate) Y�l
		,count(distinct m.MemberId) UyeSayisi
		--, MONTH (ecm.CreateDate) Ay 
		, COUNT(CouponId) Ka�KereOynad�m
from Members m (nolock) 
inner join EventCouponMasters ecm(nolock) 
		on ecm.MemberId=m.MemberId and ecm.Status<>3
where m.Status=1 --and m.MemberId=32679371 
group by YEAR(ecm.CreateDate)--,MONTH (ecm.CreateDate),m.MemberId
order by YEAR (ecm.CreateDate)



select  YEAR(ecm.CreateDate) Y�l
		, MONTH (ecm.CreateDate) Ay
		,count(distinct m.MemberId) UyeSayisi
		, COUNT(CouponId) Ka�KereOynad�m
from Members m (nolock) 
inner join EventCouponMasters ecm(nolock) 
		on ecm.MemberId=m.MemberId and ecm.Status<>3
where m.Status=1 --and m.MemberId=32679371 
group by YEAR(ecm.CreateDate),MONTH (ecm.CreateDate)--,m.MemberId
order by YEAR (ecm.CreateDate), MONTH (ecm.CreateDate)