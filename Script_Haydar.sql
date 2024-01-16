USE [Test]
GO
/****** Object:  Trigger [dbo].[TR_GIDER]    Script Date: 6.12.2021 16:10:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[TR_GIDER]
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




DECLARE my_Cursor CURSOR FAST_FORWARD FOR 
SELECT 
MNO,TARIH,SUM(TUTAR)
FROM 
(
SELECT MNO,TARIH,TUTAR FROM INSERTED
UNION ALL
SELECT MNO,TARIH,-TUTAR FROM DELETED
) X
GROUP BY MNO,TARIH

		OPEN my_Cursor 
		FETCH NEXT FROM my_Cursor into @MNO_, @TARIH_ , @TUTAR_

		WHILE @@FETCH_STATUS = 0 
		BEGIN 
		exec SP_TRIGER_GIDER_OZET_HAYDAR @MNO_, @TARIH_ , @TUTAR_ 

			FETCH NEXT FROM my_Cursor into @MNO_, @TARIH_ , @TUTAR_  
		END

CLOSE my_Cursor
DEALLOCATE my_Cursor

/*

IF @Status in (1,2)
BEGIN
			 DECLARE my_Cursor CURSOR FAST_FORWARD FOR SELECT MNO,TARIH,TUTAR FROM INSERTED;

					 OPEN my_Cursor 
					 FETCH NEXT FROM my_Cursor into @MNO_, @TARIH_ , @TUTAR_

					 WHILE @@FETCH_STATUS = 0 
					 BEGIN 
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

				
						exec SP_TRIGER_GIDER_OZET_END @MNO_, @TARIH_ , @TUTAR_

					 FETCH NEXT FROM my_Cursor into @MNO_, @TARIH_ , @TUTAR_  
					 END

			CLOSE my_Cursor
			DEALLOCATE my_Cursor

END

*/
END



ALTER PROCEDURE [dbo].[SP_TRIGER_GIDER_OZET_HAYDAR] 
(
	@MNO SMALLINT
	,@TARIH DATE
	,@TUTAR MONEY
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @PREV_TUTAR MONEY

	SET @PREV_TUTAR = ISNULL(
	(SELECT TOP 1 BAKIYE
	FROM GIDER_OZET
	WHERE MNO = @MNO AND TARIH<=@TARIH
	ORDER BY TARIH DESC),0)

	IF NOT EXISTS(SELECT *FROM GIDER_OZET WHERE MNO = @MNO AND TARIH=@TARIH)
		INSERT INTO GIDER_OZET(MNO,TARIH,BAKIYE)
		SELECT @MNO, @TARIH, @PREV_TUTAR

	UPDATE P
	SET BAKIYE = BAKIYE + @TUTAR
	FROM GIDER_OZET P
	WHERE MNO = @MNO AND TARIH>=@TARIH

	
	
END