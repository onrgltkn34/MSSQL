Use ATGBet
declare @HorseRaceCouponCountUpperLimit int,
            @HorseRaceCouponCountLowerLimit int,
            @EventCouponCountUpperLimit int,
            @EventCouponCountLowerLimit int
                      
set @HorseRaceCouponCountUpperLimit=0
set @HorseRaceCouponCountLowerLimit=0
set @EventCouponCountUpperLimit=100000
set @EventCouponCountLowerLimit=0

declare @HorseRaceCouponCountUpperLimit_ int,
            @HorseRaceCouponCountLowerLimit_ int,
            @EventCouponCountUpperLimit_ int,
            @EventCouponCountLowerLimit_ int


set @HorseRaceCouponCountUpperLimit_=100000
set @HorseRaceCouponCountLowerLimit_=1
set @EventCouponCountUpperLimit_=100000
set @EventCouponCountLowerLimit_=1

Select
     MemberId,FullName,Email
from
      (select 
                  M.MemberId,
                  M.Name +' '+ M.LastName FullName,
                  M.EMail Email ,
                  (select COUNT(*) from HorseRaceCouponMasters HRCM(Nolock) where HRCM.MemberId= M.MemberId and HRCM.Status<>3) HorseRaceCouponCount ,
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


Union All

Select
     MemberId,FullName,Email
from
      (select 
                  M.MemberId,
                  M.Name +' '+ M.LastName FullName,
                  M.EMail Email ,
                  (select COUNT(*) from HorseRaceCouponMasters HRCM(Nolock) where HRCM.MemberId= M.MemberId and HRCM.Status<>3) HorseRaceCouponCount ,
                  (select COUNT(*) from EventCouponMasters ECM(Nolock) where ECM.MemberId= M.MemberId and ECM.Status<>3) EventCouponCount
      from 
                  Members M(Nolock)) T1
where 
            T1.HorseRaceCouponCount>=@HorseRaceCouponCountLowerLimit_
      and T1.HorseRaceCouponCount<=@HorseRaceCouponCountUpperLimit_
      and T1.EventCouponCount<=@EventCouponCountUpperLimit_ 
      and T1.EventCouponCount>=@EventCouponCountLowerLimit_

      and
      
      MemberId not in
      (SELECT Members.MemberId from Members(nolock), MemberChoices(nolock) where Members.MemberId=MemberChoices.MemberId and (Members.Status<>1 or MemberChoices.NewsLetter<>1) )
	