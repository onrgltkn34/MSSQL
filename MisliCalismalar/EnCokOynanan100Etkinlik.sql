
Declare @StartDate datetime,@EndDate datetime

set @StartDate = '12.16.2011'	--- Sezon baþlangýç tarihi (MM,DD,YYYY)
set @EndDate='12.19.2011'		--- Sezon bitiþ tarihi (MM,DD,YYYY)

select
      top 100  EB.BetId
      ,ECD.MBC
      ,EL.ProgramDesc
      ,EL.ShortName
      ,M.tr_Value
      ,EB.CloseDate
      , Count(Distinct MemberId) UniqueMemberCount,Count(*) CouponCount,SUM(ECM.Price) as Price
from 
      EventBets EB(Nolock),
      EventCouponMasters ECM(Nolock),
      EventCouponDetails ECD(Nolock),
      Multilinguals M(Nolock),
      EventLeagues EL (Nolock)
where 
      EB.BetId=ECD.BetId
      and EB.LeagueId=EL.LeagueId
      and ECD.CouponId=ECM.CouponId
      and EB.BetName=M.MultilingualId
      and EB.CloseDate between @StartDate and @EndDate 
      and ECM.Status<>3
group by EB.BetId
		,M.tr_Value
		,EB.CloseDate
		,ECD.MBC
		,EL.ProgramDesc
		,EL.ShortName
order by SUM(ECM.Price) desc
  
