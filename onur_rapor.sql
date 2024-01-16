Declare @startDate date,@Enddate date,@MemberID int


Set @startDate='12.01.2018'
Set @Enddate='01.01.2019'

Create table #tmp_sonuc
(
	Baslik nvarchar(250),
	Tutar money
)

-----------------------######### Toplam iddaa + sportoto cirosu
insert into #tmp_sonuc
select 'ToplamCiro_Iddaa_Sportoto' Baslik,
(
Select  -1*ISNULL(
		sum((Case  when At.TransactionType in (13,15,14,16) then  At.Debit/1000.0 else At.Debit end))
		-sum((Case  when At.TransactionType in (13,15,14,16) then  At.Credit/1000.0 else At.Credit end)),0) 
from 
	AccountTransactions AT(Nolock) 
where AT.TransactionType in (1,2,13,15,4,5,14,16)  
		and convert(date,at.Date)>=@startDate
		and convert(date,at.Date)<@Enddate
)
ToplamCiro_Iddaa_SporToto


-----##Milli Piyango Ciro
insert into #tmp_sonuc
select 'ToplamCiro_MilliPiyango' Baslik,
	(Select -1* ISNULL(
		sum((Case  when At.TransactionType in (24) then  At.Debit/1000.0 else At.Debit end))
		-sum((Case  when At.TransactionType in (24) then  At.Credit/1000.0 else At.Credit end)),0) 
from 
	AccountTransactions AT(Nolock) 
where AT.TransactionType in (22,24)  
		and convert(date,at.Date)>=@startDate
		and convert(date,at.Date)<@Enddate)
ToplamCiro_MilliPiyango


----##TJK Ciro
insert into #tmp_sonuc
select 'ToplamCiro_TJK' Baslik,
	(
Select  -1*ISNULL(
		sum((Case  when At.TransactionType in (20,21) then  At.Debit/1000.0 else At.Debit end))
		-sum((Case  when At.TransactionType in (20,21) then  At.Credit/1000.0 else At.Credit end)),0) 
from 
	AccountTransactions AT(Nolock) 
where AT.TransactionType in (17,18,20,21)  
		and convert(date,at.Date)>=@startDate
		and convert(date,at.Date)<@Enddate)
ToplamCiro_TJK



----###İddaa+Sportoto Kazanç
insert into #tmp_sonuc
select 'ToplamKazanilanTutarIddaaSporToto' Baslik, 
	 (
	 
Select  ISNULL(
		sum((Case  when At.TransactionType in (0) then  At.Debit/1000.0 else At.Debit end))
		-sum((Case  when At.TransactionType in (0) then  At.Credit/1000.0 else At.Credit end)),0) 
from 
	AccountTransactions AT(Nolock) 
where AT.TransactionType in (3,6)  
		and convert(date,at.Date)>=@startDate
		and convert(date,at.Date)<@Enddate
	 
	 )ToplamKazanilanIddaaSportoto


----###Milli Piyango Kazanç
insert into #tmp_sonuc
select 'ToplamKazanilanTutarMilliPiyango' Baslik, 
	(
	
Select  ISNULL(
		sum((Case  when At.TransactionType in (0) then  At.Debit/1000.0 else At.Debit end))
		-sum((Case  when At.TransactionType in (0) then  At.Credit/1000.0 else At.Credit end)),0) 
from 
	AccountTransactions AT(Nolock) 
where AT.TransactionType in (23)  
		and convert(date,at.Date)>=@startDate
		and convert(date,at.Date)<@Enddate
	)
ToplamKazanilanMilliPiyango

------###TJK Kazanç

insert into #tmp_sonuc
select 'ToplamKazanilanTJK' Baslik, 
	(select isnull(sum(Isnull(hrc.Prize,0)),0) from HorseRaceCouponMasters hrc (nolocK) where Status=1 and convert(date,hrc.ResultDate)>=@startDate and convert(date,hrc.ResultDate)<@Enddate   )
ToplamKazanilanTJK


----------------########################################## Misli Puanlı Toplam iddaa+ sportoto+milli piyango cirosu 
insert into #tmp_sonuc
select 'MisliPuantoplamCiro_Iddaa_SporToto_MilliPiyango' Baslik, 
(select isnull(sum(ecm.Price),0) from EventCouponMasters ecm (nolocK) 
		inner join Accounts a (nolock) on a.AccountId=ecm.AccountId and a.CurrencyId=2
		where convert(date,CreateDate)>=@startDate and convert(date,CreateDate)<@Enddate 
		and ecm.Status<>3)
+
(select isnull(sum(ecm.Price),0) from SoccerPoolCouponMasters ecm (nolocK) 
		inner join Accounts a (nolock) on a.AccountId=ecm.AccountId and a.CurrencyId=2
		where convert(date,CreateDate)>=@startDate and convert(date,CreateDate)<@Enddate 
		and ecm.Status<>3)
+
(select isnull(sum(ecm.Price),0) from LotteryTicketMembers ecm (nolocK) 
		inner join Accounts a (nolock) on a.AccountId=ecm.AccountId and a.CurrencyId=2
		where convert(date,CreateDate)>=@startDate and convert(date,CreateDate)<@Enddate 
		and ecm.Status<>3)
+
(select isnull(sum(ecm.Price),0) from HorseRaceCouponMasters ecm (nolocK) 
		inner join Accounts a (nolock) on a.AccountId=ecm.AccountId and a.CurrencyId=2
		where convert(date,CreateDate)>=@startDate and convert(date,CreateDate)<@Enddate 
		and ecm.Status<>3)
MisliPuanToplamCiro_Iddaa_SporToto_MilliPiyango


insert into #tmp_sonuc
select 'ToplamParaYatirma' Baslik, 
	 isnull(sum(at.Debit)-sum(at.Credit),0) ToplamParaYatirma
from AccountTransactions at (nolock) 
inner join Accounts a (nolock) on a.AccountId=at.AccountId and a.CurrencyId=1
where at.TransactionType=7
		and convert(date,at.Date)>=@startDate
		and convert(date,at.Date)<@Enddate
		and a.AccountId in (select AccountId from MemberAccounts (nolock)
			) 
insert into #tmp_sonuc
select 'ToplamParaCekme' Baslik, 
		isnull(sum(at.Debit)-sum(at.Credit),0)*-1 ToplamParaCekme
from AccountTransactions at (nolock) 
inner join Accounts a (nolock) on a.AccountId=at.AccountId and a.CurrencyId=1
where at.TransactionType=8
		and convert(date,at.Date)>=@startDate
		and convert(date,at.Date)<@Enddate
		and a.AccountId in (select AccountId from MemberAccounts(nolock) 
			) 			

--7 Para Yatırma
--8 Para Çekme

select * from #tmp_sonuc

Drop table #tmp_sonuc



--------------------###Uyelerin hesaplarındaki toplam Balans Bilgileri

Select ISNULL(sum(At.Debit)-sum(At.Credit),0)
From AccountTransactions AT(nolock), 
     Accounts A(nolock)
Where A.AccountId in (Select AccountId From MemberAccounts(nolock)) 
And A.CurrencyId=1
And A.AccountId = AT.AccountId
And convert(date,AT.Date)<@Enddate


 