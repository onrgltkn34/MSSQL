USE [Test]
GO
/****** Object:  UserDefinedTableType [dbo].[OVERALL_GIDER_TABLE]    Script Date: 3.12.2021 16:56:35 ******/
CREATE TYPE [dbo].[OVERALL_GIDER_TABLE] AS TABLE(
	[MNO] [int] NULL,
	[TARIH] [date] NULL,
	[TUTAR] [money] NULL
)
GO
/****** Object:  Table [dbo].[GIDER]    Script Date: 3.12.2021 16:56:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GIDER](
	[MNO] [int] NOT NULL,
	[TARIH] [date] NOT NULL CONSTRAINT [TARIH]  DEFAULT (getdate()),
	[TUTAR] [money] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GIDER_OZET]    Script Date: 3.12.2021 16:56:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GIDER_OZET](
	[MNO] [int] NOT NULL,
	[TARIH] [date] NOT NULL,
	[BAKIYE] [money] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MUSTERI]    Script Date: 3.12.2021 16:56:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MUSTERI](
	[MNO] [int] NOT NULL,
	[UNVANI] [varchar](100) NOT NULL,
	[KAYIT_ANI] [date] NOT NULL CONSTRAINT [KAYIT_ANI]  DEFAULT (getdate()),
 CONSTRAINT [PK_MUSTERI] PRIMARY KEY CLUSTERED 
(
	[MNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[SP_TRIGER_GIDER_OZET]    Script Date: 3.12.2021 16:56:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_TRIGER_GIDER_OZET] 
(
	@MNO SMALLINT
	,@TARIH DATE
	,@TUTAR MONEY
	,@STATUS SMALLINT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @BAKIYE MONEY 

	--DECLARE @SOURCE_DATA OVERALL_GIDER_TABLE
	
	--INSERT INTO @SOURCE_DATA (MNO, TARIH, TUTAR)
	--SELECT  G.MNO
	--		,G.TARIH As TARIH
	--		,sum (G.TUTAR) as TUTAR
	--FROM GIDER G (NOLOCK)
	--WHERE G.MNO = @MNO
	--	and G.TARIH = @TARIH
	--GROUP BY MNO,TARIH


IF @STATUS = 0 
BEGIN
	PRINT 'TRİGER KAYIT SİLİNDİ.' +'MUSTERİ NO : '+ CAST (@MNO AS VARCHAR(10)) + ' ' + CAST (@TARIH AS VARCHAR(50))
END



IF @STATUS = 1 
BEGIN
	--PRINT 'TRİGER EKLEME YAPILDI.' +'MUSTERİ NO : '+ CAST (@MNO AS VARCHAR(10)) + ' ' + CAST (@TARIH AS VARCHAR(50))
	SET @BAKIYE = ISNULL((SELECT SUM(G.BAKIYE) FROM GIDER_OZET AS G(NOLOCK) WHERE G.MNO = @MNO AND G.TARIH <= @TARIH),0)
	
	IF @BAKIYE = 0 
	BEGIN
		INSERT INTO GIDER_OZET (MNO , TARIH , BAKIYE)
				VALUES (@MNO, @TARIH, @TUTAR)
	END
	ELSE IF NOT EXISTS  (SELECT * FROM GIDER_OZET AS G(NOLOCK) WHERE G.MNO = @MNO AND G.TARIH = @TARIH)
	BEGIN
				INSERT INTO GIDER_OZET (MNO , TARIH , BAKIYE)
								VALUES (@MNO, @TARIH, (@BAKIYE + @TUTAR))
	END
	ELSE
	BEGIN
		SET @BAKIYE = ISNULL((SELECT SUM(BAKIYE) FROM GIDER_OZET AS G(NOLOCK) WHERE G.MNO = @MNO AND G.TARIH < @TARIH ),0)
						+
						(SELECT SUM(G.TUTAR) FROM GIDER AS G(NOLOCK) WHERE G.MNO = @MNO AND G.TARIH = @TARIH )
					

		UPDATE GIDER_OZET 
		SET BAKIYE =  @BAKIYE 
		WHERE MNO = @MNO 
			AND TARIH = @TARIH
		

		/*GİRİLEN TARİHTEN SONRA BAŞKA BİR KAYIT VAR İSE*/
		IF EXISTS (SELECT * FROM GIDER_OZET AS G(NOLOCK) WHERE G.MNO = @MNO AND G.TARIH > @TARIH)
			BEGIN
						DECLARE @G_MNO SMALLINT
								, @G_TARIH DATE
								, @G_BAKIYE MONEY
						
						DECLARE db_cursor CURSOR FOR      (SELECT G.MNO, G.TARIH, G.BAKIYE FROM GIDER_OZET AS G(NOLOCK) WHERE G.MNO = @MNO AND G.TARIH > @TARIH )
						
						OPEN db_cursor  
						FETCH NEXT FROM db_cursor INTO @G_MNO, @G_TARIH, @G_BAKIYE

						WHILE @@FETCH_STATUS = 0  
						BEGIN  
							  UPDATE GIDER_OZET
							  SET BAKIYE = @BAKIYE + (SELECT TOP 1 G.BAKIYE FROM GIDER_OZET AS G(NOLOCK) WHERE G.MNO = @MNO AND G.TARIH < @TARIH ORDER BY G.TARIH DESC)
							  WHERE MNO = @G_MNO 
									AND TARIH = @G_TARIH

							  SET @BAKIYE = @BAKIYE + @G_BAKIYE

							  FETCH NEXT FROM db_cursor INTO @G_MNO, @G_TARIH, @G_BAKIYE 
						END 

						CLOSE db_cursor  
						DEALLOCATE db_cursor 				
			END
	END
	--PRINT 'TRİGER EKLEME YAPILDI.' + CAST (@BAKIYE AS VARCHAR(10)) + ' ' + CAST (@TUTAR AS VARCHAR(50))

END



IF @STATUS = 2 
BEGIN
	PRINT 'TRİGER GUNCELLEME YAPILDI.' +'MUSTERİ NO : '+ CAST (@MNO AS VARCHAR(10)) + ' ' + CAST (@TARIH AS VARCHAR(50))
END

--PRINT CAST (ISNULL(@STATUS,' ') AS VARCHAR(10)) + ' , INSERT_FLAG : ' + CAST (@INSERT_FLAG AS VARCHAR(10)) + + ' , DELETE_FLAG : ' + CAST (@DELETE_FLAG AS VARCHAR(10))



END


/*
--select * from MUSTERI

--insert into MUSTERI (MNO, UNVANI)
--		values (3,'TEST UNVAN 3')



SELECT * FROM GIDER order by MNO,TARIH
SELECT * FROM GIDER_OZET order by MNO,TARIH

/*
DELETE FROM GIDER 
DELETE FROM GIDER_OZET
*/




DECLARE @MNO INT = 2
		,@TARIH DATETIME= GETDATE() +5
		,@TUTAR MONEY = 25


insert into GIDER (MNO,TARIH,TUTAR)
		values (@MNO,@TARIH,@TUTAR)



--UPDATE GIDER 
--SET TUTAR = 6
--WHERE MNO = @MNO 
--	AND TUTAR = @TUTAR


--DELETE GIDER 
--WHERE MNO = @MNO 
--	AND TUTAR = @TUTAR 
--	AND TARIH = CONVERT (VARCHAR, @TARIH , 106)

*/
GO
/****** Object:  StoredProcedure [dbo].[SP_TRIGER_GIDER_OZET_YDK]    Script Date: 3.12.2021 16:56:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_TRIGER_GIDER_OZET_YDK] 
(
	@MNO SMALLINT
	,@TARIH DATE
	,@STATUS SMALLINT
)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @SOURCE_DATA OVERALL_GIDER_TABLE
	

	--/* MUSTERININ TUM GIDER TABLOSUNDAKI GRUPLU DATASI ALINIR */
	INSERT INTO @SOURCE_DATA (MNO, TARIH, TUTAR)
	SELECT  G.MNO
			,G.TARIH As TARIH
			,sum (G.TUTAR) as TUTAR
	FROM GIDER G (nolock)
	WHERE G.MNO = @MNO
		and G.TARIH = @TARIH
	GROUP BY MNO,TARIH


	/*GIDER_OZET TABLOSU KONTROL EDILIYOR.... INSERT-UPDATE-DELETE */
	MERGE dbo.GIDER_OZET AS TARGET
	USING @SOURCE_DATA	AS SOURCE
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




/*
IF @STATUS = 0 
BEGIN
	PRINT 'TRİGER KAYIT SİLİNDİ.' +'MUSTERİ NO : '+ CAST (@MNO AS VARCHAR(10)) + ' ' + CAST (@TARIH AS VARCHAR(50))
END
IF @STATUS = 1 
BEGIN
	PRINT 'TRİGER EKLEME YAPILDI.' +'MUSTERİ NO : '+ CAST (@MNO AS VARCHAR(10)) + ' ' + CAST (@TARIH AS VARCHAR(50))
END
IF @STATUS = 2 
BEGIN
	PRINT 'TRİGER GUNCELLEME YAPILDI.' +'MUSTERİ NO : '+ CAST (@MNO AS VARCHAR(10)) + ' ' + CAST (@TARIH AS VARCHAR(50))
END
*/
--PRINT CAST (ISNULL(@STATUS,' ') AS VARCHAR(10)) + ' , INSERT_FLAG : ' + CAST (@INSERT_FLAG AS VARCHAR(10)) + + ' , DELETE_FLAG : ' + CAST (@DELETE_FLAG AS VARCHAR(10))



END
GO
