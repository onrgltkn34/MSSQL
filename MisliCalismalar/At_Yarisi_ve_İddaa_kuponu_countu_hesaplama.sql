declare @HorseRaceCouponCountUpperLimit int,
            @HorseRaceCouponCountLowerLimit int,
            @EventCouponCountUpperLimit int,
            @EventCouponCountLowerLimit int,
            @StartDate datetime
            
set @HorseRaceCouponCountUpperLimit=1000000
set @HorseRaceCouponCountLowerLimit=1
set @EventCouponCountUpperLimit=100000
set @EventCouponCountLowerLimit=0
set @StartDate ='01.01.2011'

Select
     count(*)--MemberId,FullName,Email
from
      (select 
                  M.MemberId,
                  M.Name +' '+ M.LastName FullName,
                  M.EMail Email ,
                  (select COUNT(*) from HorseRaceCouponMasters HRCM(Nolock) where HRCM.MemberId= M.MemberId and HRCM.Status<>3 and HRCM.CreateDate>=@StartDate) HorseRaceCouponCount ,
                  (select COUNT(*) from EventCouponMasters ECM(Nolock) where ECM.MemberId= M.MemberId and ECM.Status<>3) EventCouponCount
      from 
                  Members M(Nolock)) T1
where 
            T1.HorseRaceCouponCount>=@HorseRaceCouponCountLowerLimit
      and T1.HorseRaceCouponCount<=@HorseRaceCouponCountUpperLimit
      and T1.EventCouponCount<=@EventCouponCountUpperLimit 
      and T1.EventCouponCount>=@EventCouponCountLowerLimit

      and
      
      MemberId not in
      (SELECT Members.MemberId from Members(nolock), MemberChoices(nolock) where Members.MemberId=MemberChoices.MemberId and (Members.Status<>1 or MemberChoices.NewsLetter<>1) )
