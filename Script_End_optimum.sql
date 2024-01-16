USE [Test]
GO

/****** Object:  Trigger [dbo].[TR_GIDER]    Script Date: 5.12.2021 01:38:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [dbo].[TR_GIDER]
   ON  [dbo].[GIDER]
   AFTER  INSERT,DELETE,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	Declare @MNO smallint
			,@TARIH date
			,@TUTAR money
			,@Inserted smallint
			,@Deleted smallint
			,@Status smallint

	If Exists (select * from deleted) Set @Deleted = 1 Else Set @Deleted = 0
	If Exists (select * from inserted) Set @Inserted = 1 Else Set @Inserted = 0

	If @Deleted = 1 and @Inserted = 1 Set @Status = 2 --- Güncelleme yapýldý
	If @Deleted = 0 and @Inserted = 1 Set @Status = 1 --- Veri Eklendi
	If @Deleted = 1 and @Inserted = 0 Set @Status = 0 --- Veri Silindi


DECLARE @MNO_ smallint
		,@TARIH_ date
		,@TUTAR_ money
		,@NEWNUM2 numeric(20)
	
IF @Status in (1,2)
BEGIN
			 DECLARE my_Cursor CURSOR FAST_FORWARD FOR SELECT MNO,TARIH,TUTAR FROM INSERTED;

					 OPEN my_Cursor 
					 FETCH NEXT FROM my_Cursor into @MNO_, @TARIH_ , @TUTAR_

					 WHILE @@FETCH_STATUS = 0 
					 BEGIN 

					 select @NEWNUM2 = MAX(MNO) from GIDER
					 if @NEWNUM2 is null
					 Begin
						set  @NEWNUM2  = 0
					 End
					 set @NEWNUM2 = @NEWNUM2 + 1
						exec SP_TRIGER_GIDER_OZET_END @MNO_, @TARIH_ , @TUTAR_

					 FETCH NEXT FROM my_Cursor into @MNO_, @TARIH_ , @TUTAR_  
					 END

			CLOSE my_Cursor
			DEALLOCATE my_Cursor
END
ELSE IF @Status = 0
BEGIN 
			 DECLARE my_Cursor CURSOR FAST_FORWARD FOR SELECT MNO,TARIH,TUTAR FROM DELETED;

					 OPEN my_Cursor 
					 FETCH NEXT FROM my_Cursor into @MNO_, @TARIH_ , @TUTAR_

					 WHILE @@FETCH_STATUS = 0 
					 BEGIN 

					 select @NEWNUM2 = MAX(MNO) from GIDER
					 if @NEWNUM2 is null
					 Begin
						set  @NEWNUM2  = 0
					 End
					 set @NEWNUM2 = @NEWNUM2 + 1
						exec SP_TRIGER_GIDER_OZET_END @MNO_, @TARIH_ , @TUTAR_

					 FETCH NEXT FROM my_Cursor into @MNO_, @TARIH_ , @TUTAR_  
					 END

			CLOSE my_Cursor
			DEALLOCATE my_Cursor

END


END

GO

ALTER TABLE [dbo].[GIDER] ENABLE TRIGGER [TR_GIDER]
GO




/************************************************************
******************************************
*****************************************
*****************************************/

CREATE PROCEDURE [dbo].[SP_TRIGER_GIDER_OZET_END] 
(
	@MNO SMALLINT
	,@TARIH DATE
	,@TUTAR MONEY
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @BEGINDATE date = dateadd(MONTH,-1,getdate())

	DECLARE @SOURCE_DATA OVERALL_GIDER_TABLE
	
	INSERT INTO @SOURCE_DATA (MNO, TARIH, TUTAR)
	select MNO
			,TARIH
			,sum (Toplam) Over(Order By MNO,TARIH ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as BAKIYE
	from
	(SELECT MNO
			,TARIH
			,Sum(Tutar) as Toplam
	FROM GIDER
	where MNO = @MNO 
		and TARIH >= @BEGINDATE
	group by MNO, TARIH) as tbl

	
	MERGE dbo.GIDER_OZET AS TARGET
	USING (select MNO,TARIH,TUTAR from @SOURCE_DATA group by MNO,TARIH,TUTAR) 	AS SOURCE
	ON SOURCE.MNO = Target.MNO
		AND SOURCE.TARIH = TARGET.TARIH
    
	-- For Inserts
	WHEN NOT MATCHED BY TARGET THEN
		INSERT (MNO,TARIH, BAKIYE) 
		VALUES (SOURCE.MNO,SOURCE.TARIH, SOURCE.TUTAR)
    
	-- For Updates
	WHEN MATCHED THEN UPDATE SET
		TARGET.BAKIYE	= SOURCE.TUTAR
		
   -- For Deletes
	WHEN NOT MATCHED BY SOURCE AND MNO = @MNO THEN
		DELETE;

	
END

