Declare @StartDate as datetime,
              @EndDate as datetime,
              @MemberId as nvarchar(50)
      
      Set @StartDate='01.01.2011'
      Set @EndDate='01.01.2012'
      
      
select SUM(Price) ToplamOynama
	into #tmp_sonuc
from EventCouponMasters ECM(nolock) 
      ,Accounts A(NOLOCK)
where ecm.MemberId not in ('32679757')
and A.AccountId=Ecm.AccountId
and ecm.Status in (1,2)
and A.CurrencyId  in (2) 
and Ecm.CreateDate  between @StartDate and @EndDate


insert #tmp_sonuc
select SUM(Price) ToplamOynama
from SoccerPoolCouponMasters ECM(nolock) 
      ,Accounts A(NOLOCK)
where ecm.MemberId not in ('32679757')
and A.AccountId=Ecm.AccountId
and ecm.Status in (1,2)
and A.CurrencyId  in (2) 
and Ecm.CreateDate  between @StartDate and @EndDate

insert #tmp_sonuc
select SUM(Price) ToplamOynama
from LotteryTicketMembers ECM(nolock) 
      ,Accounts A(NOLOCK)
where ecm.MemberId not in ('32679757')
and A.AccountId=Ecm.AccountId
and ecm.Status in (1,2)
and A.CurrencyId in (2) 
and Ecm.CreateDate  between @StartDate and @EndDate


select SUM(ToplamOynama)
from #tmp_sonuc

drop table #tmp_sonuc



 