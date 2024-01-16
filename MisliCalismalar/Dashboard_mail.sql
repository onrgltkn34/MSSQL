Declare @Body nvarchar(max),
		
		@EventPlayedUniuqeCount int,
		@EventPlayedSum money,
		@EventPlayedCount int,
		@EventPlayedAvg money,
		
		@EventCancelUniuqeCount int,
		@EventCancelSum money,
		@EventCancelCount int,
		@EventCancelAvg money,
		
		@EventPayUniuqeCount int,
		@EventPaySum money,
		@EventPayCount int,
		@EventPayAvg money,
		
		@CEventPlayedUniuqeCount int,
		@CEventPlayedSum money,
		@CEventPlayedCount int,
		@CEventPlayedAvg money,
		
		@MEventPlayedUniuqeCount int,
		@MEventPlayedSum money,
		@MEventPlayedCount int,
		@MEventPlayedAvg money,
		
		@LotteryPlayedUniuqeCount int,
		@LotteryPlayedSum money,
		@LotteryPlayedCount int,
		@LotteryPlayedAvg money,
		
		@LotteryPayUniuqeCount int,
		@LotteryPaySum money,
		@LotteryPayCount int,
		@LotteryPayAvg money,
		
		@StartDate datetime =null,
		@EndDate datetime =null
		
		set @StartDate=Convert(date, GETDATE())
		set @EndDate=DATEADD(day,1,@StartDate)
		
		
Declare @cursor cursor
Set @cursor = CURSOR static FOR select * from 
	(select 
		COUNT(Distinct(MemberId)) EventPlayedUniuqeCount,
		isnull(sum(Price),0) EventPlayedSum,
		count(*) EventPlayedCount,
		case when 	isnull(sum(Price),0)=0 then 0 else 	isnull(sum(Price),0)/count(*) end  EventPlayedAvg
	 from EventCouponMasters(NOLOCK)
	 where 
	   CreateDate>= @StartDate and CreateDate<@EndDate 
	   and Status<>3
	 ) EventPlayed,

     (select 
		COUNT(Distinct(MemberId)) EventCancelUniuqeCount,
		isnull(sum(Price),0) EventCancelSum,
		count(*) EventCancelCount,
		case when 	isnull(sum(Price),0)=0 then 0 else 	isnull(sum(Price),0)/count(*) end  EventCancelAvg
      from EventCouponMasters(NOLOCK)
      where 
	 CancelDate>= @StartDate and CancelDate<@EndDate 
		and Status=3) EventCancel, 
	(
	 select  COUNT(Distinct(MemberId)) EventPayUniuqeCount, 
			isnull(sum(Prize),0) EventPaySum,
			 count(*) EventPayCount,
			 case when 	isnull(sum(Prize),0)=0 then 0 else 	isnull(sum(Prize),0)/count(*) end  EventPayAvg
	 from EventCouponMasters(NOLOCK) where 

	  ResultDate >=@StartDate and ResultDate<@EndDate 
	and Status=1
	) EventPay, 
					 
	(select 
		COUNT(Distinct(MemberId)) LotteryPlayedUniuqeCount,
		isnull(sum(Price),0) LotteryPlayedSum,
		count(*) LotteryPlayedCount,
		case when 	isnull(sum(Price),0)=0 then 0 else 	isnull(sum(Price),0)/count(*) end  LotteryPlayedAvg
	 from LotteryTicketMembers(NOLOCK)
	 where 
	   CreateDate>= @StartDate and CreateDate<@EndDate 
	   and Status<>3
	 ) LotteryPlayed,
 
	(
	 select  COUNT(Distinct(MemberId)) LotteryPayUniuqeCount, 
			isnull(sum(Prize),0) LotteryPaySum,
			 count(*) LotteryPayCount,
			 case when 	isnull(sum(Prize),0)=0 then 0 else 	isnull(sum(Prize),0)/count(*) end  LotteryPayAvg
	 from LotteryTicketMembers(NOLOCK) where 

	  ResultDate >=@StartDate and ResultDate<@EndDate 
	and Status=1
	) LotteryPay,
	
	(select 
		COUNT(Distinct(MemberId)) CEventPlayedUniuqeCount,
		isnull(sum(Price),0) CEventPlayedSum,
		count(*) CEventPlayedCount,
		case when 	isnull(sum(Price),0)=0 then 0 else 	isnull(sum(Price),0)/count(*) end  CEventPlayedAvg
	 from EventCouponMasters CECM(NOLOCK)
	 where 
	   CreateDate>= @StartDate and CreateDate<@EndDate 
	   and Status<>3
	   and CECM.PlatformId=1
	 ) CEventPlayed,
	 
	 (select 
		COUNT(Distinct(MemberId)) MEventPlayedUniuqeCount,
		isnull(sum(Price),0) MEventPlayedSum,
		count(*) MEventPlayedCount,
		case when 	isnull(sum(Price),0)=0 then 0 else 	isnull(sum(Price),0)/count(*) end  MEventPlayedAvg
	 from EventCouponMasters MECM(NOLOCK)
	 where 
	   CreateDate>= @StartDate and CreateDate<@EndDate 
	   and Status<>3
	   and MECM.SourceId in (4,5)
	 ) MEventPlayed
			
open @cursor

fetch next from @cursor
into @EventPlayedUniuqeCount,@EventPlayedSum,@EventPlayedCount,@EventPlayedAvg,
		@EventCancelUniuqeCount,@EventCancelSum,@EventCancelCount,@EventCancelAvg ,
		@EventPayUniuqeCount ,@EventPaySum ,@EventPayCount ,@EventPayAvg ,
		@LotteryPlayedUniuqeCount ,	@LotteryPlayedSum ,	@LotteryPlayedCount ,@LotteryPlayedAvg ,
		@LotteryPayUniuqeCount ,@LotteryPaySum ,@LotteryPayCount ,@LotteryPayAvg,
		@CEventPlayedUniuqeCount ,@CEventPlayedSum,@CEventPlayedCount,@CEventPlayedAvg,
		@MEventPlayedUniuqeCount,@MEventPlayedSum,@MEventPlayedCount,@MEventPlayedAvg

Set @Body = '
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
  <head>
  <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-9" />
  <meta http-equiv="content-language" content="TR" />
   <style type="text/css">
        .style1
        {
            text-align: center;
            background-color: #99CCFF;
            color:black;
        }
        .style2
        {
            background-color: #99CCFF;
            color:black;
            width:80px;
        }
        .style3
        {
            width: 165px;
        }
        .style4
        {
            background-color: #99CCFF;
            color: black;
            width: 165px;
        }
        .style5
        {
            text-align: center;
            background-color: #99CCFF;
            color: black;
            width: 109px;
        }
        .style6
        {
            width: 109px;
        }
        .style8
        {
            background-color: #99CCFF;
            color: black;
            width: 64px;
        }
        .style9
        {
            width: 64px;
        }
        .style10
        {
            text-align: center;
            background-color: #99CCFF;
            color: black;
            width: 217px;
        }
        .style11
        {
            width: 550px;
        }
    </style>
  </head>
  <body> 
  <table cellpadding="0" cellspacing="0" bgcolor="#f3f3f3" style="width: 450px">
        <tr>
            <td align="center">
                &nbsp;
            </td>
        </tr>
        <tr>
            <td align="center">
                <table cellpadding="0" cellspacing="0" bgcolor="#ffffff" style="width: 450px">
                    <tr>
                        <td align="center">
	 			<table border="1" cellspacing="0" cellpadding="0" bordercolor="#000000" width="100%" align="center" style="font-family:Helvetica; font-size:12px; color:#666;">
					 <tr>
                                                <td align="center" colspan="9" class="style1">
                                                    <b>Tarih Araligi Kupon Durumu</b>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="center">
                                                    &nbsp;
                                                </td>
                                                <td align="center" colspan="4" class="style2">
                                                    <b>Ýddaa</b>
                                                </td>
                                                <td align="center" colspan="4" class="style2">
                                                    <b>Milli Piyango</b>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="center">
                                                    &nbsp;
                                                </td>
                                                <td class="style1">
                                                    <b>T.Uye</b>
                                                </td>
                                                <td class="style1">
                                                    <b>Kupon Adet</b>
                                                </td>
                                                <td class="style1">
                                                    <b>Kupon Tutar</b>
                                                </td>
                                                <td class="style1">
                                                    <b>Ortalama</b>
                                                </td>
                                                <td class="style1">
                                                    <b>T.Uye</b>
                                                </td>
                                                <td class="style1">
                                                    <b>Kupon Adet</b>
                                                </td>
                                                <td class="style1">
                                                    <b>Kupon Tutar</b>
                                                </td>
                                                <td class="style1">
                                                    <b>Ortalama</b>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2">
                                                    <b>Oynanan</b>
                                                </td>'

While @@FETCH_STATUS = 0
Begin
                  Set @Body = @Body + '         <td align="right">
                                                    ' + CONVERT(varchar(10),@EventPlayedUniuqeCount) + '
                                                </td>
                                                <td align="right">
                                                    ' + CONVERT(varchar(10), @EventPlayedCount) + '
                                                </td>
                                                <td align="right">
													'+ CONVERT(varchar,@EventPlayedSum,1) + '
                                                </td>
                                                <td align="right">
                                                    '+  CONVERT(varchar,@EventPlayedAvg,1) + '
                                                </td>
                                                <td align="right">
                                                    ' +  CONVERT(varchar(10), @LotteryPlayedUniuqeCount) + '
                                                </td>
                                                <td align="right">
													' +  CONVERT(varchar(10),@LotteryPlayedCount) + '
												</td>
                                                <td align="right">
													' +  CONVERT(varchar,@LotteryPlayedSum,1)  + '
                                                </td>
                                                <td align="right">
													' +  CONVERT(varchar,@LotteryPlayedAvg,1) + '
                                                </td>
                                            </tr>
		                                    <tr>
                                                <td class="style2">
                                                    <b>C Oynanan</b>
                                                </td>
                                                <td align="right">
                                                    ' +  CONVERT(varchar(10),@CEventPlayedUniuqeCount) + ' 
                                                </td>
                                                <td align="right">
                                                   ' +  CONVERT(varchar(10),@CEventPlayedCount) + '
                                                </td>
                                                <td align="right">
													' +  CONVERT(varchar,@CEventPlayedSum,1) + '
                                                </td>
                                                <td align="right">
                                                    ' +  CONVERT(varchar,@CEventPlayedAvg,1) + '
                                                </td>
                                                <td align="right">
                                                    ' +  CONVERT(varchar(10),@LotteryPayUniuqeCount) + '
                                                </td>
                                                <td align="right">
													' +  CONVERT(varchar(10),@LotteryPayCount) + '
                                                </td>
                                                <td align="right">
                                                    ' +  CONVERT(varchar,@LotteryPaySum,1)  + '
                                                </td>
                                                <td align="right">
                                                    ' +  CONVERT(varchar,@LotteryPayAvg,1) + '
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2">
                                                    <b>M Oynanan</b>
                                                </td>
                                                <td align="right">
                                                    ' +  CONVERT(varchar(10),@MEventPlayedUniuqeCount) + '
                                                </td>
                                                <td align="right">
                                                   ' +  CONVERT(varchar(10),@MEventPlayedCount) + '
                                                </td>
                                                <td align="right">
													' +  CONVERT(varchar,@MEventPlayedSum,1) + '
                                                </td>
                                                <td align="right">
                                                    ' +  CONVERT(varchar,@MEventPlayedAvg,1) + '
                                                </td>
                                                <td align="right">
                                                    ' +  CONVERT(varchar(10),@LotteryPayUniuqeCount) + '
                                                </td>
                                                <td align="right">
													' +  CONVERT(varchar(10),@LotteryPayCount) + '
                                                </td>
                                                <td align="right">
                                                    ' +  CONVERT(varchar,@LotteryPaySum,1)  + '
                                                </td>
                                                <td align="right">
                                                    ' +  CONVERT(varchar,@LotteryPayAvg,1) + '
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2">
                                                    <b>Kazanan</b>
                                                </td>
                                                <td align="right">
                                                    ' +  CONVERT(varchar(10),@EventPayUniuqeCount) + '
                                                </td>
                                                <td align="right">
                                                   ' +  CONVERT(varchar(10),@EventPayCount) + '
                                                </td>
                                                <td align="right">
													' +  CONVERT(varchar,@EventPaySum,1) + '
                                                </td>
                                                <td align="right">
                                                    ' +  CONVERT(varchar,@EventPayAvg,1) + '
                                                </td>
                                                <td align="right">
                                                    ' +  CONVERT(varchar(10),@LotteryPayUniuqeCount) + '
                                                </td>
                                                <td align="right">
													' +  CONVERT(varchar(10),@LotteryPayCount) + '
                                                </td>
                                                <td align="right">
                                                    ' +  CONVERT(varchar,@LotteryPaySum,1)  + '
                                                </td>
                                                <td align="right">
                                                    ' +  CONVERT(varchar,@LotteryPayAvg,1) + '
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2">
                                                    <b>Ýptal Edilen</b>
                                                </td>
                                                <td align="right">
                                                    ' +   CONVERT(varchar(10),@EventCancelUniuqeCount) + '
                                                </td>
                                                <td align="right">
													' +   CONVERT(varchar(10),@EventCancelCount) + '
                                                </td>
                                                <td align="right">
                                                    ' +  CONVERT(varchar,@EventCancelSum,1)  + '
                                                </td>
                                                <td align="right">
                                                    ' +  CONVERT(varchar,@EventCancelAvg,1) + '
                                                </td>
                                                <td align="right">
                                                    -
                                                </td>
                                                <td align="right">
                                                    -
                                                </td>
                                                <td align="right">
                                                    -
                                                </td>
                                                <td align="right">
                                                    -
                                                </td>
                                            </tr>
                                            </table>
                                        <br />'


					
	fetch next from @cursor
	into @EventPlayedUniuqeCount,@EventPlayedSum,@EventPlayedCount,@EventPlayedAvg,
		@EventCancelUniuqeCount,@EventCancelSum,@EventCancelCount,@EventCancelAvg ,
		@EventPayUniuqeCount ,@EventPaySum ,@EventPayCount ,@EventPayAvg ,
		@LotteryPlayedUniuqeCount ,	@LotteryPlayedSum ,	@LotteryPlayedCount ,@LotteryPlayedAvg ,
		@LotteryPayUniuqeCount ,@LotteryPaySum ,@LotteryPayCount ,@LotteryPayAvg,
		@CEventPlayedUniuqeCount ,@CEventPlayedSum,@CEventPlayedCount,@CEventPlayedAvg,
		@MEventPlayedUniuqeCount,@MEventPlayedSum,@MEventPlayedCount,@MEventPlayedAvg	
End

close @cursor
deallocate @cursor


------ 2ci tablo Tarih Araligi Uye Durumu

Declare @TotalAccountCount int,
		@TotalActiveAccountCount int,
		@TotalBalanceSum money,
		@TotalBalanceAvg money,
		
		@TotalAccountPointCount int,
		@TotalActiveAccountPointCount int,
		@TotalBalancePointSum money,
		@BalancePointAvg money

Declare @cursor2 cursor

Set @cursor2 = CURSOR static FOR select TotalAccountCount ,
		TotalActiveAccountCount ,
		TotalBalanceSum ,
		TotalBalanceAvg ,
		TotalAccountPointCount ,
		TotalActiveAccountPointCount ,
		TotalBalancePointSum ,
		BalancePointAvg  from (  
select count(*) TotalAccountCount,isnull(sum(Debit-Credit),0) TotalBalanceSum, case when  isnull(sum(Debit-Credit),0)=0 then  0 else isnull(sum(Debit-Credit),0)/(  
select count(*) TotalActiveAccountCount from   
 Accounts(NOLOCK) Acc,  
 MemberAccounts(NOLOCK) MemAcc,
 Members(Nolock) M
where   
 Acc.AccountId=MemAcc.AccountId  
 and M.MemberId=MemAcc.MemberId
 and Debit-Credit>0
  and Acc.CurrencyId=1
   and M.CreateDate between @StartDate and @EndDate 
  )  end TotalBalanceAvg from   
 Accounts(NOLOCK) Acc,  
 MemberAccounts(NOLOCK) MemAcc,
 Members(Nolock) M
where   
 Acc.AccountId=MemAcc.AccountId
 and Acc.CurrencyId=1
 and M.MemberId=MemAcc.MemberId
 and M.CreateDate between @StartDate and @EndDate 
 ) t1,(  
 
select count(*) TotalActiveAccountCount from   
 Accounts(NOLOCK) Acc,  
 MemberAccounts(NOLOCK) MemAcc , 
  Members(Nolock) M
where   
 Acc.AccountId=MemAcc.AccountId  
 and Debit-Credit>0
  and Acc.CurrencyId=1
   and M.MemberId=MemAcc.MemberId
 and M.CreateDate between @StartDate and @EndDate 
  ) t2, (  
select count(*) AccountCount,isnull(sum(Debit-Credit),0) BalanceSum,case when  isnull(sum(Debit-Credit),0)=0 then  0 else isnull(sum(Debit-Credit),0)/(  
select count(*) ActiveAccountCount from   
 Accounts(NOLOCK) Acc,  
 MemberAccounts(NOLOCK) MemAcc,  
 Members(NOLOCK) Mem  
where   
 Acc.AccountId=MemAcc.AccountId  
 and MemAcc.MemberId=Mem.MemberId  
 
 and Mem.CreateDate between @StartDate and @EndDate 
 and Acc.Debit-Acc.Credit>0
  and Acc.CurrencyId=1) end BalanceAvg  from   
 Accounts(NOLOCK) Acc,  
 MemberAccounts(NOLOCK) MemAcc,  
 Members(NOLOCK) Mem  
where   
 Acc.AccountId=MemAcc.AccountId  
 and MemAcc.MemberId=Mem.MemberId  
 and Mem.CreateDate between @StartDate and @EndDate 
  and Acc.CurrencyId=1
 ) t3,(  
select count(*) ActiveAccountCount from   
 Accounts(NOLOCK) Acc,  
 MemberAccounts(NOLOCK) MemAcc,  
 Members(NOLOCK) Mem  
where   
 Acc.AccountId=MemAcc.AccountId  
 and MemAcc.MemberId=Mem.MemberId  
 and Mem.CreateDate between @StartDate and @EndDate  
 and Acc.Debit-Acc.Credit>0
  and Acc.CurrencyId=1) t4 ,
   (
select count(*) TotalAccountPointCount,isnull(sum(Debit-Credit),0) TotalBalancePointSum,case when  isnull(sum(Debit-Credit),0)=0 then  0 else isnull(sum(Debit-Credit),0)/count(*) end  TotalBalancePointAvg  from   
 Accounts(NOLOCK) Acc,  
 MemberAccounts(NOLOCK) MemAcc  ,
  Members(Nolock) M
where   
 Acc.AccountId=MemAcc.AccountId
 and Acc.CurrencyId=2
 and M.MemberId=MemAcc.MemberId
  and M.CreateDate between @StartDate and @EndDate 
 ) t5,(  
 
select count(*) TotalActiveAccountPointCount from   
 Accounts(NOLOCK) Acc,  
 MemberAccounts(NOLOCK) MemAcc  ,
  Members(Nolock) M
where   
 Acc.AccountId=MemAcc.AccountId  
 and Debit-Credit>0
  and Acc.CurrencyId=2
   and M.MemberId=MemAcc.MemberId
 and M.CreateDate between @StartDate and @EndDate 
  ) t6, (  
select count(*) AccountPointCount,isnull(sum(Debit-Credit),0) BalancePointSum,case when  isnull(sum(Debit-Credit),0)=0 then  0 else isnull(sum(Debit-Credit),0)/count(*) end  BalancePointAvg from   
 Accounts(NOLOCK) Acc,  
 MemberAccounts(NOLOCK) MemAcc,  
 Members(NOLOCK) Mem  
where   
 Acc.AccountId=MemAcc.AccountId  
 and MemAcc.MemberId=Mem.MemberId  
 and Mem.CreateDate between @StartDate and @EndDate 
  and Acc.CurrencyId=2
 ) t7,(  
select count(*) ActiveAccountPointCount from   
 Accounts(NOLOCK) Acc,  
 MemberAccounts(NOLOCK) MemAcc,  
 Members(NOLOCK) Mem  
where   
 Acc.AccountId=MemAcc.AccountId  
 and MemAcc.MemberId=Mem.MemberId  
 and Mem.CreateDate between @StartDate and @EndDate  
 and Acc.Debit-Acc.Credit>0
  and Acc.CurrencyId=2) t8 

open @cursor2

fetch next from @cursor2
into @TotalAccountCount ,@TotalActiveAccountCount ,	@TotalBalanceSum ,	@TotalBalanceAvg ,
		@TotalAccountPointCount ,@TotalActiveAccountPointCount ,@TotalBalancePointSum ,	@BalancePointAvg 



While @@FETCH_STATUS = 0
Begin
                  Set @Body = @Body + ' <table border="1" cellspacing="0" cellpadding="0" bordercolor="#000000" align="center"
                                            style="font-family: Helvetica; font-size: 12px; color: #666; width: 99%;">
                                            <tr>
                                                <td colspan="5" class="style1">
                                                    <b>Tarih Araligi Uye Durum</b>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="center">
                                                    &nbsp;
                                                </td>
                                                <td class="style1">
                                                    <b>Adet</b>
                                                </td>
                                                <td class="style1">
                                                    <b>Artý Bakiye</b>
                                                </td>
                                                <td class="style1">
                                                    <b>Tutar</b>
                                                </td>
                                                <td class="style1">
                                                   <b>Ortalama</b>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2">
                                                    <b>Nakit Uye</b>
                                                </td>
                                                <td align="right">
                                                    ' +   CONVERT(varchar(10),@TotalAccountCount) + '
                                                </td>
                                                <td align="right">
                                                    ' +   CONVERT(varchar(10),@TotalActiveAccountCount) + '
                                                </td>
                                                <td align="right">
                                                    ' +   CONVERT(varchar,@TotalBalanceSum,1) + '
                                                </td>
                                                <td align="right">
                                                    ' +   CONVERT(varchar,@TotalBalanceAvg,1) + '
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style2">
                                                    <b>Puan Uye</b>
                                                </td>
                                                <td align="right">
                                                    ' +   CONVERT(varchar(10),@TotalAccountPointCount) + '
                                                </td>
                                                <td align="right">
                                                    ' +   CONVERT(varchar(10),@TotalActiveAccountPointCount) + '
                                                </td>
                                                <td align="right">
                                                    ' +   CONVERT(varchar,@TotalBalancePointSum,1) + '
                                                </td>
                                                <td align="right">
                                                    ' +   CONVERT(varchar,@BalancePointAvg,1) + '
                                                </td>
                                            </tr>
                                        </table>
                                        <br />'



fetch next from @cursor2
	into @TotalAccountCount ,@TotalActiveAccountCount ,	@TotalBalanceSum ,	@TotalBalanceAvg ,
		@TotalAccountPointCount ,@TotalActiveAccountPointCount ,@TotalBalancePointSum ,	@BalancePointAvg
		
End

close @cursor2
deallocate @cursor2

-----3 cu tablo Genel Uye Durumu

Declare @TotalAccountCount_ int,
		@TotalActiveAccountCount_ int,
		@TotalBalanceSum_ money,
		@TotalBalanceAvg_ money,
		
		@AccountCount int,
		@ActiveAccountCount int,
		@BalanceSum money,
		@BalanceAvg money,
		
		@TotalAccountPointCount_ int,
		@TotalActiveAccountPointCount_ int,
		@TotalBalancePointSum_ money,
		@TotalBalancePointAvg_ money,
		
		@AccountPointCount_ int,
		@ActiveAccountPointCount_ int,
		@BalancePointSum_ money,
		@BalancePointAvg_ money
		

Declare @cursor3 cursor

Set @cursor3 = CURSOR static FOR select TotalAccountCount,
	TotalActiveAccountCount,
	TotalBalanceSum,
	TotalBalanceAvg,
	AccountCount,
	ActiveAccountCount,
	BalanceSum,
	BalanceAvg,
	TotalAccountPointCount,
	TotalActiveAccountPointCount,
	TotalBalancePointSum,
	TotalBalancePointAvg,
	AccountPointCount,
	ActiveAccountPointCount,
	BalancePointSum,
	BalancePointAvg
		 from (  
select count(*) TotalAccountCount,isnull(sum(Debit-Credit),0) TotalBalanceSum, case when  isnull(sum(Debit-Credit),0)=0 then  0 else isnull(sum(Debit-Credit),0)/(  
select count(*) TotalActiveAccountCount from   
 Accounts(NOLOCK) Acc,  
 MemberAccounts(NOLOCK) MemAcc  
where   
 Acc.AccountId=MemAcc.AccountId  
 and Debit-Credit>0
  and Acc.CurrencyId=1
  )  end TotalBalanceAvg from   
 Accounts(NOLOCK) Acc,  
 MemberAccounts(NOLOCK) MemAcc  
where   
 Acc.AccountId=MemAcc.AccountId
 and Acc.CurrencyId=1
 
 ) t1,(  
 
select count(*) TotalActiveAccountCount from   
 Accounts(NOLOCK) Acc,  
 MemberAccounts(NOLOCK) MemAcc  
where   
 Acc.AccountId=MemAcc.AccountId  
 and Debit-Credit>0
  and Acc.CurrencyId=1
  ) t2, (  
select count(*) AccountCount,isnull(sum(Debit-Credit),0) BalanceSum,case when  isnull(sum(Debit-Credit),0)=0 then  0 else isnull(sum(Debit-Credit),0)/(  
select count(*) ActiveAccountCount from   
 Accounts(NOLOCK) Acc,  
 MemberAccounts(NOLOCK) MemAcc,  
 Members(NOLOCK) Mem  
where   
 Acc.AccountId=MemAcc.AccountId  
 and MemAcc.MemberId=Mem.MemberId  
 and Convert(varchar(10),Mem.CreateDate,112) =convert(varchar(10),getdate(),112)   
 and Acc.Debit-Acc.Credit>0
  and Acc.CurrencyId=1) end BalanceAvg  from   
 Accounts(NOLOCK) Acc,  
 MemberAccounts(NOLOCK) MemAcc,  
 Members(NOLOCK) Mem  
where   
 Acc.AccountId=MemAcc.AccountId  
 and MemAcc.MemberId=Mem.MemberId  
 and Convert(varchar(10),Mem.CreateDate,112) =convert(varchar(10),getdate(),112) 
  and Acc.CurrencyId=1
 ) t3,(  
select count(*) ActiveAccountCount from   
 Accounts(NOLOCK) Acc,  
 MemberAccounts(NOLOCK) MemAcc,  
 Members(NOLOCK) Mem  
where   
 Acc.AccountId=MemAcc.AccountId  
 and MemAcc.MemberId=Mem.MemberId  
 and Convert(varchar(10),Mem.CreateDate,112) =convert(varchar(10),getdate(),112)   
 and Acc.Debit-Acc.Credit>0
  and Acc.CurrencyId=1) t4 ,
   (
select count(*) TotalAccountPointCount,isnull(sum(Debit-Credit),0) TotalBalancePointSum,case when  isnull(sum(Debit-Credit),0)=0 then  0 else isnull(sum(Debit-Credit),0)/count(*) end  TotalBalancePointAvg  from   
 Accounts(NOLOCK) Acc,  
 MemberAccounts(NOLOCK) MemAcc  
where   
 Acc.AccountId=MemAcc.AccountId
 and Acc.CurrencyId=2
 
 ) t5,(  
 
select count(*) TotalActiveAccountPointCount from   
 Accounts(NOLOCK) Acc,  
 MemberAccounts(NOLOCK) MemAcc  
where   
 Acc.AccountId=MemAcc.AccountId  
 and Debit-Credit>0
  and Acc.CurrencyId=2
  ) t6, (  
select count(*) AccountPointCount,isnull(sum(Debit-Credit),0) BalancePointSum,case when  isnull(sum(Debit-Credit),0)=0 then  0 else isnull(sum(Debit-Credit),0)/count(*) end  BalancePointAvg from   
 Accounts(NOLOCK) Acc,  
 MemberAccounts(NOLOCK) MemAcc,  
 Members(NOLOCK) Mem  
where   
 Acc.AccountId=MemAcc.AccountId  
 and MemAcc.MemberId=Mem.MemberId  
 and Convert(varchar(10),Mem.CreateDate,112) =convert(varchar(10),getdate(),112) 
  and Acc.CurrencyId=2
 ) t7,(  
select count(*) ActiveAccountPointCount from   
 Accounts(NOLOCK) Acc,  
 MemberAccounts(NOLOCK) MemAcc,  
 Members(NOLOCK) Mem  
where   
 Acc.AccountId=MemAcc.AccountId  
 and MemAcc.MemberId=Mem.MemberId  
 and Convert(varchar(10),Mem.CreateDate,112) =convert(varchar(10),getdate(),112)   
 and Acc.Debit-Acc.Credit>0
  and Acc.CurrencyId=2) t8 

open @cursor3

fetch next from @cursor3
into @TotalAccountCount_ ,@TotalActiveAccountCount_ ,@TotalBalanceSum_ ,@TotalBalanceAvg_ ,
		@AccountCount ,	@ActiveAccountCount ,@BalanceSum ,@BalanceAvg ,
		@TotalAccountPointCount_ ,@TotalActiveAccountPointCount_ ,@TotalBalancePointSum_ ,@TotalBalancePointAvg_ ,
		@AccountPointCount_ ,@ActiveAccountPointCount_ ,@BalancePointSum_ ,	@BalancePointAvg_ 



While @@FETCH_STATUS = 0
Begin
                  Set @Body = @Body + '<table border="1" cellspacing="0" cellpadding="0" bordercolor="#000000" align="center"
                                            style="font-family: Helvetica; font-size: 12px; color: #666; width: 99%;">
                                            <tr>
                                                <td colspan="5" class="style1">
                                                    <b>Genel Uye Durum</b>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="center" class="style3">
                                                    &nbsp;
                                                </td>
                                                <td class="style5">
                                                    <b>Adet</b>
                                                </td>
                                                <td class="style1">
                                                    <b>Artý Bakiye</b>
                                                </td>
                                                <td class="style1">
                                                    <b>Tutar</b>
                                                </td>
                                                <td class="style1">
                                                    <b>Ortalama</b>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style4">
                                                    <b>Toplam Nakit Uye</b>
                                                </td>
                                                <td align="right" class="style6">
                                                    ' +   CONVERT(varchar(10),@TotalAccountCount_) + '
                                                </td>
                                                <td align="right">
                                                    ' +   CONVERT(varchar(10),@TotalActiveAccountCount_) + '
                                                </td>
                                                <td align="right">
                                                    ' +   CONVERT(varchar,@TotalBalanceSum_,1) + '
                                                </td>
                                                <td align="right">
                                                    ' +   CONVERT(varchar,@TotalBalanceAvg_,1) + '
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style4">
                                                    <b>Gunluk Nakit Uye</b>
                                                </td>
                                                <td align="right" class="style6">
                                                ' +   CONVERT(varchar(10),@AccountCount) + '
                                                </td>
                                                <td align="right">
                                                ' +   CONVERT(varchar(10),@ActiveAccountCount) + '
                                                </td>
                                                <td align="right">
                                                ' +   CONVERT(varchar,@BalanceSum,1)  + '
                                                </td>
                                                <td align="right">
                                                ' +   CONVERT(varchar,@BalanceAvg,1) + '
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style4">
                                                    <b>Toplam Puan Uye</b>
                                                </td>
                                                <td align="right" class="style6">
                                                    ' +   CONVERT(varchar(10),@TotalAccountPointCount_) + '
                                                </td>
                                                <td align="right">
                                                    ' +   CONVERT(varchar(10),@TotalActiveAccountPointCount_) + '
                                                </td>
                                                <td align="right">
                                                    ' +   CONVERT(varchar,@TotalBalancePointSum_,1) + '
                                                </td>
                                                <td align="right">
                                                    ' +   CONVERT(varchar,@TotalBalancePointAvg_,1) + '
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style4">
                                                    <b>Gunluk Puan Uye</b>
                                                </td>
                                                <td align="right" class="style6">
                                                    ' +   CONVERT(varchar(10),@AccountPointCount_) + '
                                                </td>
                                                <td align="right">
                                                    ' +   CONVERT(varchar(10),@ActiveAccountPointCount_) + '
                                                </td>
                                                <td align="right">
                                                    ' +  CONVERT(varchar,@BalancePointSum_,1) + '
                                                </td>
                                                <td align="right">
                                                    ' +   CONVERT(varchar,@BalancePointAvg_,1) + '
                                                </td>
                                            </tr>
                                        </table>
                                        <br />'

fetch next from @cursor3
	into @TotalAccountCount_ ,@TotalActiveAccountCount_ ,@TotalBalanceSum_ ,@TotalBalanceAvg_ ,
		@AccountCount ,	@ActiveAccountCount ,@BalanceSum ,@BalanceAvg ,
		@TotalAccountPointCount_ ,@TotalActiveAccountPointCount_ ,@TotalBalancePointSum_ ,@TotalBalancePointAvg_ ,
		@AccountPointCount_ ,@ActiveAccountPointCount_ ,@BalancePointSum_ ,	@BalancePointAvg_ 
		
End

close @cursor3
deallocate @cursor3


-----4 cu tablo Tarih araligi Kupon Haraketleri
Declare @EventPlayDate datetime,
		@EventCancelDate datetime,
		@EventPayDate datetime
				

Declare @cursor4 cursor

Set @cursor4 = CURSOR static FOR select
	(
		select top 1 Date from 
		AccountTransactions(NOLOCK) AccTran
		where 
			AccTran.TransactionType in (1,13) and AccTran.Date >= @StartDate and AccTran.Date < @EndDate order by Date Desc
	) EventPlayDate,
	(
		select top 1 Date from 
		AccountTransactions(NOLOCK) AccTran
		where 
			AccTran.TransactionType in (15,2) and AccTran.Date >= @StartDate and AccTran.Date < @EndDate  order by Date Desc
	) EventCancelDate,
	(
		select top 1 Date from 
		AccountTransactions(NOLOCK) AccTran
		where 
			AccTran.TransactionType=3 and AccTran.Date >= @StartDate and AccTran.Date < @EndDate  order by Date Desc
	) EventPayDate
	


open @cursor4

fetch next from @cursor4
into @EventPlayDate ,@EventCancelDate ,	@EventPayDate 

While @@FETCH_STATUS = 0
Begin
                  Set @Body = @Body + ' <table border="1" cellspacing="0" cellpadding="0" bordercolor="#000000" align="center"
                                            style="font-family: Helvetica; font-size: 12px; color: #666; width: 50%;">
                                            <tr>
                                                <td colspan="2" class="style1">
                                                   <b> Tarih Araligi Kupon Haraketleri</b>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style9">
                                                    &nbsp;
                                                </td>
                                                <td class="style10">
                                                    <b>Ýddaa</b>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style8">
                                                    <b>Oynama</b>
                                                </td>
                                                <td align="center" class="style11">
                                                    ' +   CONVERT(varchar(10),@EventPlayDate,104) + ' ' +   CONVERT(varchar(8),@EventPlayDate,108) + '
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style8">
                                                    <b>Iptal</b>
                                                </td>
                                                <td align="center" class="style11">
                                                    ' +   CONVERT(varchar(10),@EventCancelDate,104) + ' ' +   CONVERT(varchar(8),@EventCancelDate,108) + '
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style8">
                                                    <b>Kazanma</b>
                                                </td>
                                                <td align="center" class="style11">
                                                ' +   CONVERT(varchar(10),@EventPayDate,104) + ' ' +   CONVERT(varchar(8),@EventPayDate,108) + '
                                                </td>
                                            </tr>
                                        </table>
                                        <br />'


fetch next from @cursor4
	into @EventPlayDate ,@EventCancelDate ,	@EventPayDate 
End

close @cursor4
deallocate @cursor4

Set @Body = @Body + '				</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td align="center">
                &nbsp;
            </td>
        </tr>
    </table>
    </body>
 </html>'

exec msdb..sp_send_dbmail @profile_name = 'MisliDB', @recipients = 'yonetim@misli.com', @subject = 'Dashboard Otomatik Mail', @body = @Body, @body_format='HTML'