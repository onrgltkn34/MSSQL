DECLARE @TypeStartDate datetime
DECLARE @TypeEndDate datetime 

SET @TypeStartDate = '20111201'
SET @TypeEndDate = '20121225'

select ReportType,MemberId,Price,CodeId,Impression,Click,ForeignImpression,ForeignClick,BannerOwnerId,BannerOwnerName,BannerLocationId,BannerLocationName from(
select
			-2 ReportType,0 MemberId,null Price,
			BC.CodeId,
			isnull((select isnull(sum(BID_.Impression),0) Click from BannerImpressionDaily BID_ (nolock)where BID_.CodeId=BC.CodeId
				and  BID_.Date>= @TypeStartDate  and BID_.Date< @TypeEndDate and BID_.CountryCode = 'tr'
				),0) Impression,
			isnull((select isnull(count(*),0) Click from BannerLogs BL (nolock) where BL.CodeId=BC.CodeId
				and BL.ClickDate >= @TypeStartDate and BL.ClickDate<=@TypeEndDate and BL.CountryCode = 'tr'
				),0) Click,
			isnull((select isnull(sum(BID_.Impression),0) Click from BannerImpressionDaily BID_ (nolock)where BID_.CodeId=BC.CodeId
				and  BID_.Date>= @TypeStartDate  and BID_.Date< @TypeEndDate and BID_.CountryCode != 'tr'
				),0) ForeignImpression,
			isnull((select isnull(count(*),0) Click from BannerLogs BL (nolock) where BL.CodeId=BC.CodeId
				and BL.ClickDate >= @TypeStartDate and BL.ClickDate<=@TypeEndDate and BL.CountryCode != 'tr'
				),0) ForeignClick,
			BO.BannerOwnerId,BO.BannerOwnerName,
			BL.BannerLocationId,BL.BannerLocationName
		from 
			BannerCodes BC (nolock) 
			left join BannerImpressionDaily BID (nolock) on BC.CodeId=BID.CodeId 
					and BID.Date >= @TypeStartDate 
					and BID.Date <= @TypeEndDate
			inner join BannerOwners BO (nolock) on BO.BannerOwnerId=BC.BannerOwnerId
			inner join BannerLocations BL (nolock) on BL.BannerLocationId=BC.BannerLocationId)
			 t
		 where t.BannerLocationId in (40,65)
			group by ReportType,MemberId,Price,CodeId,Impression,Click,BannerOwnerId,BannerOwnerName,BannerLocationId,BannerLocationName,ForeignClick,ForeignImpression
 
 