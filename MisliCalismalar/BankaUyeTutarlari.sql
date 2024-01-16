declare @AccountId int,  
 @ChannelsId int=0,
 @StartDate datetime,  
 @EndDate datetime,
 @KisiSayisi int
    

set @AccountId= '152' -- bankanin accountIdsi yazýlýr. (select * from BankAccounts) sorgulanarak
set @StartDate = '12.26.2011'
set @EndDate = '12.26.2011'

BEGIN  
 SET NOCOUNT ON;  
   
 if @AccountId!=0 begin   
  Select    
    AT.AccountId,
    case when BA.BankAccountType IN(2) then   
     (select MA.MemberId from dbo.MemberAccounts(Nolock) MA,Members M(NOLOCK),MemberPaybackTransactions MPT(NOLOCK) where M.MemberId=MA.MemberId And MA.AccountId=MPT.AccountId and MPT.PaybackId=AT.RefNo)   
    else   
     (select MA.MemberId from dbo.MemberAccounts(Nolock) MA,Members M(NOLOCK) where M.MemberId=MA.MemberId And MA.AccountId=AT.RefNo)  
    end MemberId,
    case when BA.BankAccountType IN(2) then   
     (select  [Name] + ' ' + LastName + ' ( ' +  convert(varchar,MA.MemberId) + ' )'   from dbo.MemberAccounts(Nolock) MA,Members M(NOLOCK),MemberPaybackTransactions MPT(NOLOCK) where M.MemberId=MA.MemberId And MA.AccountId=MPT.AccountId and MPT.PaybackId=AT.RefNo)   
    else   
     (select  [Name] + ' ' + LastName + ' ( ' +  convert(varchar,MA.MemberId) + ' )'   from dbo.MemberAccounts(Nolock) MA,Members M(NOLOCK) where M.MemberId=MA.MemberId And MA.AccountId=AT.RefNo)  
    end Member,  
    BB.BranchName,  
    B.BankName,  
    A.AccountCode,  
    BA.BankAccountType,  
    AT.TransactionType,  
    AT.Debit,  
    AT.Credit,  
    AT.Balance,  
    AT.Date ,
    BAC.ChannelName 
    Into #tmp_table_tmp
  From   
    AccountTransactions (Nolock) AT
	Inner  Join BankAccounts(Nolock) BA    on   BA.AccountId=AT.AccountId  
	Inner  Join BankBranchs(Nolock) BB on BB.BankBranchId=BA.BankBranchId  
	Inner  Join Accounts(Nolock) A   on A.AccountId=AT.AccountId  
	Inner  Join Banks(Nolock) B on B.BankId=BA.BankId  
	Left Outer Join BankAccountChannels BAC on   BAC.ChannelId=AT.ChannelCode  and BAC.AccountId=BA.AccountId 
  Where   
    A.AccountId=@AccountId
    And Date >= @StartDate and Date <=@EndDate  
    And ((@ChannelsId=0) Or (AT.ChannelCode=@ChannelsId)) 
  Order by Date desc  
 end else begin  
  Select    
    AT.AccountId,
    case when BA.BankAccountType IN(2) then   
     (select MA.MemberId from dbo.MemberAccounts(Nolock) MA,Members M(NOLOCK),MemberPaybackTransactions MPT(NOLOCK) where M.MemberId=MA.MemberId And MA.AccountId=MPT.AccountId and MPT.PaybackId=AT.RefNo)   
    else   
     (select MA.MemberId from dbo.MemberAccounts(Nolock) MA,Members M(NOLOCK) where M.MemberId=MA.MemberId And MA.AccountId=AT.RefNo)  
    end MemberId,
    case when BA.BankAccountType IN(2) then   
     (select  [Name] + ' ' + LastName + ' ( ' +  convert(varchar,MA.MemberId) + ' )'   from dbo.MemberAccounts(Nolock) MA,Members M(NOLOCK),MemberPaybackTransactions MPT(NOLOCK) where M.MemberId=MA.MemberId And MA.AccountId=MPT.AccountId and MPT.PaybackId=AT.RefNo)   
    else   
     (select  [Name] + ' ' + LastName + ' ( ' +  convert(varchar,MA.MemberId) + ' )'   from dbo.MemberAccounts(Nolock) MA,Members M(NOLOCK) where M.MemberId=MA.MemberId And MA.AccountId=AT.RefNo)  
    end Member,  
    BB.BranchName,  
    B.BankName,  
    A.AccountCode,  
    BA.BankAccountType,  
    AT.TransactionType,  
    AT.Debit,  
    AT.Credit,  
    AT.Balance,  
    AT.Date ,
    BAC.ChannelName 
  From   
    AccountTransactions (Nolock) AT  
	Inner  Join BankAccounts(Nolock) BA    on   BA.AccountId=AT.AccountId  
	Inner  Join BankBranchs(Nolock) BB on BB.BankBranchId=BA.BankBranchId  
	Inner  Join Accounts(Nolock) A   on A.AccountId=AT.AccountId  
	Inner  Join Banks(Nolock) B on B.BankId=BA.BankId  
	Left Outer Join BankAccountChannels BAC on   BAC.ChannelId=AT.ChannelCode  and BAC.AccountId=BA.AccountId 
  Where   
    A.AccountId=AT.AccountId  
    And Date >= @StartDate and Date <=@EndDate
    And ((@ChannelsId=0) Or (AT.ChannelCode=@ChannelsId))   
  Order by Date desc  
 end   
 SET NOCOUNT OFF;  
END  



select t.MemberId
		,t.Member
		,m.MobilePhone
		,t.Debit Yatirilan
		,CONVERT(nvarchar(19),t.Date,120)  Tarih
from #tmp_table_tmp t -- Odeme Yapanlarin Listesi
Inner Join Members m (nolock) on m.MemberId=t.MemberId
order by t.Date


--select COUNT(distinct MemberId) ÜyeSayýsý, SUM(Debit) Tutar   ------ Bankalardan aylýk kaç kiþi para yatýrmýþ ve toplam tutarý verir. 
--	into #tmpTableSnc
--from #tmp_table_tmp
--group by MemberId
--select COUNT(*) ÜyeSayisi
--	,Sum(Tutar)
--	from #tmpTableSnc
--drop table #tmpTableSnc

set @KisiSayisi = (select COUNT(Distinct MemberId) from #tmp_table_tmp)


Create table #tmp_kupons
(
	MemberId int,
	KuponAdeti int,
	ToplamTutar money
)

insert into #tmp_kupons --iddaa kuponlarý insert ediliyor
select MemberId
		,COUNT(IntegrationId) KuponAdeti
		,SUM(Price) ToplamTutar 
from EventCouponMasters (nolock)
where MemberId in (select MemberId from #tmp_table_tmp)
	and Status<>3
Group by MemberId

insert into #tmp_kupons --Tjk kuponlarý insert ediliyor
select MemberId
		,COUNT(IntegrationId) KuponAdeti
		,SUM(Price) ToplamTutar 
from HorseRaceCouponMasters (nolock)
where MemberId in (select MemberId from #tmp_table_tmp)
	and Status<>3
Group by MemberId

insert into #tmp_kupons --Loto kuponlarý insert ediliyor
select MemberId
		,COUNT(IntegrationId) KuponAdeti
		,SUM(Price) ToplamTutar 
from SoccerPoolCouponMasters (nolock)
where MemberId in (select MemberId from #tmp_table_tmp)
	and Status<>3
Group by MemberId

select SUM(KuponAdeti) KuponAdeti
		,SUM(ToplamTutar) ToplamTutar
into #tmp_sonuc -- Sonuclar bu tabloda toplanýr. 
from #tmp_kupons
group by MemberId

select @KisiSayisi KisiSayisi
		,SUM(KuponAdeti) KuponAdeti
		,SUM(ToplamTutar) ToplamTutar
from #tmp_sonuc



--select m.MemberId,m.Name +' ' +m.LastName AsSoyad,m.MobilePhone,b.BankName,bb.BranchName,replace(ma.IBAN,' ','') IBAN
--from Members m (nolock)
--left join MemberBankAccounts ma(nolock) on ma.MemberId=m.MemberId and ma.Status=1
--left Join BankBranchs bb (nolock) on bb.BankBranchId=ma.BankBranchId
--left join Banks b (nolock) on b.BankId=bb.BankId
--where m.MemberId in  (select MemberId from #tmp_table_tmp)

drop table #tmp_table_tmp
drop table #tmp_kupons
drop table #tmp_sonuc