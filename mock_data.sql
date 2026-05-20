USE AskeriYonetimSistemi;
GO

SET NOCOUNT ON;

INSERT INTO Il (il_adi)
SELECT V.il_adi
FROM (VALUES (N'İstanbul'), (N'Yalova'), (N'Ankara'), (N'İzmir'), (N'Adana'), (N'Trabzon')) V(il_adi)
WHERE NOT EXISTS (SELECT 1 FROM Il I WHERE I.il_adi = V.il_adi);

INSERT INTO Ilce (il_no, ilce_adi)
SELECT I.il_no, V.ilce_adi
FROM Il I
INNER JOIN (VALUES
    (N'İstanbul', N'Kadıköy'), (N'İstanbul', N'Üsküdar'), (N'İstanbul', N'Beyoğlu'),
    (N'Yalova', N'Merkez'), (N'Yalova', N'Çiftlikköy'),
    (N'Ankara', N'Çankaya'), (N'İzmir', N'Konak'),
    (N'Adana', N'Seyhan'), (N'Trabzon', N'Ortahisar')
) V(il_adi, ilce_adi) ON V.il_adi = I.il_adi
WHERE NOT EXISTS (SELECT 1 FROM Ilce ILCE WHERE ILCE.il_no = I.il_no AND ILCE.ilce_adi = V.ilce_adi);

INSERT INTO Mahalle (ilce_no, mahalle_adi)
SELECT ILCE.ilce_no, V.mahalle_adi
FROM Ilce ILCE
INNER JOIN Il I ON I.il_no = ILCE.il_no
INNER JOIN (VALUES
    (N'İstanbul', N'Kadıköy', N'Koşuyolu'), (N'İstanbul', N'Üsküdar', N'Altunizade'), (N'İstanbul', N'Beyoğlu', N'Cihangir'),
    (N'Yalova', N'Merkez', N'Bahçelievler'), (N'Yalova', N'Çiftlikköy', N'Sahil'),
    (N'Ankara', N'Çankaya', N'Kızılay'), (N'İzmir', N'Konak', N'Alsancak'),
    (N'Adana', N'Seyhan', N'Barajyolu'), (N'Trabzon', N'Ortahisar', N'Boztepe')
) V(il_adi, ilce_adi, mahalle_adi)
    ON V.il_adi = I.il_adi AND V.ilce_adi = ILCE.ilce_adi
WHERE NOT EXISTS (SELECT 1 FROM Mahalle M WHERE M.ilce_no = ILCE.ilce_no AND M.mahalle_adi = V.mahalle_adi);

INSERT INTO CaddeSokak (mahalle_no, cadde_sokak_adi)
SELECT M.mahalle_no, V.cadde_sokak_adi
FROM Mahalle M
INNER JOIN Ilce ILCE ON ILCE.ilce_no = M.ilce_no
INNER JOIN Il I ON I.il_no = ILCE.il_no
INNER JOIN (VALUES
    (N'İstanbul', N'Kadıköy', N'Koşuyolu', N'Vadi Sokak'),
    (N'İstanbul', N'Üsküdar', N'Altunizade', N'Karaeski Caddesi'),
    (N'İstanbul', N'Beyoğlu', N'Cihangir', N'İçerde Sokak'),
    (N'Yalova', N'Merkez', N'Bahçelievler', N'Komando Sokak'),
    (N'Yalova', N'Çiftlikköy', N'Sahil', N'Liman Caddesi'),
    (N'Ankara', N'Çankaya', N'Kızılay', N'Kuzey Caddesi'),
    (N'İzmir', N'Konak', N'Alsancak', N'Güney Sokak'),
    (N'Adana', N'Seyhan', N'Barajyolu', N'Sıfır Bir Sokak'),
    (N'Trabzon', N'Ortahisar', N'Boztepe', N'Kartal Caddesi')
) V(il_adi, ilce_adi, mahalle_adi, cadde_sokak_adi)
    ON V.il_adi = I.il_adi AND V.ilce_adi = ILCE.ilce_adi AND V.mahalle_adi = M.mahalle_adi
WHERE NOT EXISTS (SELECT 1 FROM CaddeSokak CS WHERE CS.mahalle_no = M.mahalle_no AND CS.cadde_sokak_adi = V.cadde_sokak_adi);

INSERT INTO Rutbe (rutbe_adi)
SELECT V.rutbe_adi
FROM (VALUES (N'Er'), (N'Onbaşı'), (N'Çavuş'), (N'Uzman Çavuş'), (N'Asteğmen')) V(rutbe_adi)
WHERE NOT EXISTS (SELECT 1 FROM Rutbe R WHERE R.rutbe_adi = V.rutbe_adi);

INSERT INTO BirimSinifi (sinif_adi)
SELECT V.sinif_adi
FROM (VALUES (N'Kara'), (N'Hava'), (N'Deniz'), (N'Tank'), (N'Komando'), (N'Lojistik')) V(sinif_adi)
WHERE NOT EXISTS (SELECT 1 FROM BirimSinifi BS WHERE BS.sinif_adi = V.sinif_adi);

INSERT INTO TechizatTuru (tur_adi)
SELECT V.tur_adi
FROM (VALUES (N'Silah'), (N'Araç'), (N'Giysi'), (N'Patlayıcı'), (N'Haberleşme'), (N'Tıbbi')) V(tur_adi)
WHERE NOT EXISTS (SELECT 1 FROM TechizatTuru TT WHERE TT.tur_adi = V.tur_adi);

INSERT INTO CezaSebebi (sebep_adi)
SELECT V.sebep_adi
FROM (VALUES (N'İzinsiz birliği terk etme'), (N'İzinden geç gelme'), (N'Emre itaatsizlik'), (N'Nöbet ihlali'), (N'Eğitime geç katılma')) V(sebep_adi)
WHERE NOT EXISTS (SELECT 1 FROM CezaSebebi CS WHERE CS.sebep_adi = V.sebep_adi);

INSERT INTO EgitimTuru (tur_adi)
SELECT V.tur_adi
FROM (VALUES (N'Temel Eğitim'), (N'Atış Eğitimi'), (N'İlk Yardım'), (N'Operasyon Hazırlık'), (N'Araç Kullanımı')) V(tur_adi)
WHERE NOT EXISTS (SELECT 1 FROM EgitimTuru ET WHERE ET.tur_adi = V.tur_adi);

INSERT INTO AtisTuru (tur_adi)
SELECT V.tur_adi
FROM (VALUES (N'25m'), (N'100m'), (N'200m'), (N'400m')) V(tur_adi)
WHERE NOT EXISTS (SELECT 1 FROM AtisTuru AT WHERE AT.tur_adi = V.tur_adi);

INSERT INTO AtisLokasyonu (lokasyon_adi, il_no, ilce_no, adres_aciklamasi)
SELECT V.lokasyon_adi, I.il_no, ILCE.ilce_no, V.adres_aciklamasi
FROM (VALUES
    (N'Yalova Merkez Atış Alanı', N'Yalova', N'Merkez', N'Bahçelievler eğitim sahası'),
    (N'Ankara Kapalı Poligon', N'Ankara', N'Çankaya', N'Kızılay kapalı poligon'),
    (N'Adana Açık Atış Sahası', N'Adana', N'Seyhan', N'Barajyolu açık saha')
) V(lokasyon_adi, il_adi, ilce_adi, adres_aciklamasi)
INNER JOIN Il I ON I.il_adi = V.il_adi
INNER JOIN Ilce ILCE ON ILCE.il_no = I.il_no AND ILCE.ilce_adi = V.ilce_adi
WHERE NOT EXISTS (SELECT 1 FROM AtisLokasyonu AL WHERE AL.lokasyon_adi = V.lokasyon_adi);

INSERT INTO Birim (ust_birim_no, birim_adi, ilce_no, adres_aciklamasi, telefon, durum, kurulus_tarihi, birim_sinif_no)
SELECT NULL, V.birim_adi, ILCE.ilce_no, V.adres_aciklamasi, V.telefon, N'AKTIF', V.kurulus_tarihi, BS.birim_sinif_no
FROM (VALUES
    (N'Yalova 1. Komando Tugayı', N'Yalova', N'Merkez', N'Yalova merkez komando yerleşkesi', N'02260000001', CAST('2001-01-10' AS DATE), N'Komando'),
    (N'Yalova 2. Kara Tugayı', N'Yalova', N'Çiftlikköy', N'Çiftlikköy kara birlikleri sahası', N'02260000002', CAST('2003-04-12' AS DATE), N'Kara'),
    (N'Ankara 3. Tank Taburu', N'Ankara', N'Çankaya', N'Ankara zırhlı birlik sahası', N'03120000001', CAST('1999-09-01' AS DATE), N'Tank'),
    (N'İzmir Hava Bakım Birliği', N'İzmir', N'Konak', N'İzmir hava bakım sahası', N'02320000001', CAST('2005-06-17' AS DATE), N'Hava'),
    (N'Adana Lojistik Birliği', N'Adana', N'Seyhan', N'Adana lojistik destek alanı', N'03220000001', CAST('2010-02-20' AS DATE), N'Lojistik'),
    (N'Trabzon Deniz Destek Birliği', N'Trabzon', N'Ortahisar', N'Trabzon deniz destek alanı', N'04620000001', CAST('2012-03-22' AS DATE), N'Deniz')
) V(birim_adi, il_adi, ilce_adi, adres_aciklamasi, telefon, kurulus_tarihi, sinif_adi)
INNER JOIN Il I ON I.il_adi = V.il_adi
INNER JOIN Ilce ILCE ON ILCE.il_no = I.il_no AND ILCE.ilce_adi = V.ilce_adi
INNER JOIN BirimSinifi BS ON BS.sinif_adi = V.sinif_adi
WHERE NOT EXISTS (SELECT 1 FROM Birim B WHERE B.birim_adi = V.birim_adi);

INSERT INTO Birim (ust_birim_no, birim_adi, ilce_no, adres_aciklamasi, telefon, durum, kurulus_tarihi, birim_sinif_no)
SELECT Ust.birim_no, V.birim_adi, Ust.ilce_no, V.adres_aciklamasi, V.telefon, N'AKTIF', V.kurulus_tarihi, Ust.birim_sinif_no
FROM (VALUES
    (N'Yalova 1. Komando Tugayı', N'1. Komando Bölüğü', N'Birinci komando bölüğü', N'02260000101', CAST('2015-01-01' AS DATE)),
    (N'Yalova 1. Komando Tugayı', N'2. Komando Bölüğü', N'İkinci komando bölüğü', N'02260000102', CAST('2015-01-01' AS DATE)),
    (N'Yalova 2. Kara Tugayı', N'1. Piyade Bölüğü', N'Birinci piyade bölüğü', N'02260000201', CAST('2016-02-01' AS DATE)),
    (N'Ankara 3. Tank Taburu', N'1. Tank Bölüğü', N'Birinci tank bölüğü', N'03120000101', CAST('2014-07-07' AS DATE)),
    (N'Adana Lojistik Birliği', N'1. Bakım Bölüğü', N'Bakım ve ikmal bölüğü', N'03220000101', CAST('2017-08-08' AS DATE)),
    (N'Trabzon Deniz Destek Birliği', N'1. Destek Bölüğü', N'Deniz destek bölüğü', N'04620000101', CAST('2018-09-09' AS DATE))
) V(ust_birim_adi, birim_adi, adres_aciklamasi, telefon, kurulus_tarihi)
INNER JOIN Birim Ust ON Ust.birim_adi = V.ust_birim_adi
WHERE NOT EXISTS (SELECT 1 FROM Birim B WHERE B.birim_adi = V.birim_adi);

DECLARE @i INT;
DECLARE @cadde_sayisi INT = (SELECT COUNT(*) FROM CaddeSokak);
DECLARE @rutbe_sayisi INT = (SELECT COUNT(*) FROM Rutbe);
DECLARE @birim_sayisi INT = (SELECT COUNT(*) FROM Birim);
DECLARE @techizat_tur_sayisi INT = (SELECT COUNT(*) FROM TechizatTuru);
DECLARE @ceza_sebep_sayisi INT = (SELECT COUNT(*) FROM CezaSebebi);
DECLARE @egitim_tur_sayisi INT = (SELECT COUNT(*) FROM EgitimTuru);
DECLARE @atis_tur_sayisi INT = (SELECT COUNT(*) FROM AtisTuru);
DECLARE @atis_lokasyon_sayisi INT = (SELECT COUNT(*) FROM AtisLokasyonu);
DECLARE @current_datetime DATETIME2 = CAST(GETDATE() AS DATE);

SET @i = 1;
WHILE @i <= 48
BEGIN
    DECLARE @nobet_birim_no INT = (
        SELECT birim_no FROM (
            SELECT birim_no, ROW_NUMBER() OVER (ORDER BY birim_no) AS rn FROM Birim
        ) X WHERE rn = ((@i - 1) % @birim_sayisi) + 1
    );

    IF NOT EXISTS (SELECT 1 FROM NobetYeri WHERE ad = CONCAT(N'Nöbet Noktası ', RIGHT(CONCAT('00', @i), 2)))
        INSERT INTO NobetYeri (birim_no, ad, silah_durumu)
        VALUES (@nobet_birim_no, CONCAT(N'Nöbet Noktası ', RIGHT(CONCAT('00', @i), 2)), CASE WHEN @i % 2 = 0 THEN N'SILAHLI' ELSE N'SILAHSIZ' END);

    SET @i = @i + 1;
END

CREATE TABLE #Karakter (
    sira INT IDENTITY(1,1) PRIMARY KEY,
    dizi NVARCHAR(40) NOT NULL,
    ad NVARCHAR(80) NOT NULL,
    soyad NVARCHAR(80) NOT NULL,
    cinsiyet CHAR(1) NOT NULL
);

INSERT INTO #Karakter (dizi, ad, soyad, cinsiyet)
VALUES
(N'Kurtlar Vadisi', N'Polat', N'Alemdar', 'E'), (N'Kurtlar Vadisi', N'Süleyman', N'Çakır', 'E'), (N'Kurtlar Vadisi', N'Memati', N'Baş', 'E'), (N'Kurtlar Vadisi', N'Abdülhey', N'Çoban', 'E'), (N'Kurtlar Vadisi', N'Aslan', N'Akbey', 'E'),
(N'Kurtlar Vadisi', N'Elif', N'Eylül', 'K'), (N'Kurtlar Vadisi', N'Laz', N'Ziya', 'E'), (N'Kurtlar Vadisi', N'Hüsrev', N'Ağa', 'E'), (N'Kurtlar Vadisi', N'Tuncay', N'Kantarcı', 'E'), (N'Kurtlar Vadisi', N'Erhan', N'Ufak', 'E'),
(N'Kurtlar Vadisi', N'Derya', N'Çakır', 'K'), (N'Kurtlar Vadisi', N'İplikçi', N'Nedim', 'E'), (N'Kurtlar Vadisi', N'Testere', N'Necmi', 'E'), (N'Kurtlar Vadisi', N'Seyfo', N'Dayı', 'E'), (N'Kurtlar Vadisi', N'Kılıç', N'Karahanlı', 'E'),
(N'Ezel', N'Ezel', N'Bayraktar', 'E'), (N'Ezel', N'Ömer', N'Uçar', 'E'), (N'Ezel', N'Eyşan', N'Tezcan', 'K'), (N'Ezel', N'Cengiz', N'Atay', 'E'), (N'Ezel', N'Ali', N'Kırgız', 'E'),
(N'Ezel', N'Ramiz', N'Karaeski', 'E'), (N'Ezel', N'Kenan', N'Birkan', 'E'), (N'Ezel', N'Selma', N'Hünel', 'K'), (N'Ezel', N'Tevfik', N'Zaim', 'E'), (N'Ezel', N'Bade', N'Uysal', 'K'),
(N'Ezel', N'Serdar', N'Tezcan', 'E'), (N'Ezel', N'Mert', N'Uçar', 'E'), (N'Ezel', N'Azad', N'Karaeski', 'K'), (N'Ezel', N'Mümtaz', N'Uçar', 'E'), (N'Ezel', N'Meliha', N'Uçar', 'K'),
(N'Sıfır Bir', N'Savaş', N'Satıroğlu', 'E'), (N'Sıfır Bir', N'Cio', N'Baba', 'E'), (N'Sıfır Bir', N'Özgür', N'Mermer', 'E'), (N'Sıfır Bir', N'Burak', N'Şahin', 'E'), (N'Sıfır Bir', N'Anafor', N'Ali', 'E'),
(N'Sıfır Bir', N'Azad', N'Yılmaz', 'E'), (N'Sıfır Bir', N'Berto', N'Demir', 'E'), (N'Sıfır Bir', N'Salim', N'Kara', 'E'), (N'Sıfır Bir', N'Mahmut', N'Yıldız', 'E'), (N'Sıfır Bir', N'Berfin', N'Kaya', 'K'),
(N'İçerde', N'Sarp', N'Yılmaz', 'E'), (N'İçerde', N'Mert', N'Karadağ', 'E'), (N'İçerde', N'Celal', N'Duman', 'E'), (N'İçerde', N'Melek', N'Yıldız', 'K'), (N'İçerde', N'Eylem', N'Aydın', 'K'),
(N'İçerde', N'Füsun', N'Yılmaz', 'K'), (N'İçerde', N'Coşkun', N'Kaya', 'E'), (N'İçerde', N'Davut', N'Aktaş', 'E'), (N'İçerde', N'Yusuf', N'Kaya', 'E'), (N'İçerde', N'Mustafa', N'Karadağ', 'E'),
(N'Kuzey Güney', N'Kuzey', N'Tekinoğlu', 'E'), (N'Kuzey Güney', N'Güney', N'Tekinoğlu', 'E'), (N'Kuzey Güney', N'Cemre', N'Çayak', 'K'), (N'Kuzey Güney', N'Banu', N'Sinaner', 'K'), (N'Kuzey Güney', N'Simay', N'Canay', 'K'),
(N'Kuzey Güney', N'Zeynep', N'Taşkın', 'K'), (N'Kuzey Güney', N'Sami', N'Tekinoğlu', 'E'), (N'Kuzey Güney', N'Handan', N'Tekinoğlu', 'K'), (N'Kuzey Güney', N'Barış', N'Hakmen', 'E'), (N'Kuzey Güney', N'Ferhat', N'Şadoğlu', 'E');

SET @i = 1;
WHILE @i <= 200
BEGIN
    DECLARE @karakter_sira INT = ((@i - 1) % (SELECT COUNT(*) FROM #Karakter)) + 1;
    DECLARE @ad NVARCHAR(80) = (SELECT ad FROM #Karakter WHERE sira = @karakter_sira);
    DECLARE @soyad NVARCHAR(80) = (SELECT soyad FROM #Karakter WHERE sira = @karakter_sira);
    DECLARE @cinsiyet CHAR(1) = (SELECT cinsiyet FROM #Karakter WHERE sira = @karakter_sira);
    DECLARE @tc_kimlik_no CHAR(11) = RIGHT(CONCAT('00000000000', 11000000000 + @i), 11);
    DECLARE @cadde_sokak_no INT = (SELECT cadde_sokak_no FROM (SELECT cadde_sokak_no, ROW_NUMBER() OVER (ORDER BY cadde_sokak_no) rn FROM CaddeSokak) X WHERE rn = ((@i - 1) % @cadde_sayisi) + 1);
    DECLARE @rutbe_no INT = (SELECT rutbe_no FROM (SELECT rutbe_no, ROW_NUMBER() OVER (ORDER BY rutbe_no) rn FROM Rutbe) X WHERE rn = ((@i - 1) % @rutbe_sayisi) + 1);

    IF NOT EXISTS (SELECT 1 FROM Asker WHERE tc_kimlik_no = @tc_kimlik_no)
        INSERT INTO Asker (
            tc_kimlik_no, ad, soyad, cinsiyet, dogum_tarihi, yas, cadde_sokak_no,
            dis_kapi_no, ic_kapi_no, adres_aciklamasi, telefon, atis_durumu,
            askerlik_suresi_gun, toplam_izin_suresi_gun, kullanilan_izin_suresi_gun,
            kalan_izin_suresi_gun, disiplin_cezasi_gun, teslim_tarihi, rutbe_no, durum
        )
        VALUES (
            @tc_kimlik_no, @ad, @soyad, @cinsiyet, DATEADD(YEAR, -20 - (@i % 15), CAST(GETDATE() AS DATE)),
            20 + (@i % 15), @cadde_sokak_no, CONVERT(NVARCHAR(20), 10 + @i), CONVERT(NVARCHAR(20), 1 + (@i % 24)),
            CONCAT((SELECT dizi FROM #Karakter WHERE sira = @karakter_sira), N' ekibi mock adresi ', @i),
            CONCAT(N'05', RIGHT(CONCAT('000000000', 300000000 + @i), 9)),
            CASE WHEN @i % 4 = 0 THEN N'YAPMADI' ELSE N'YAPTI' END,
            180 + (@i % 181), 24 + (@i % 8), @i % 12, (24 + (@i % 8)) - (@i % 12),
            @i % 7, DATEADD(DAY, -(@i % 260), CAST(GETDATE() AS DATE)), @rutbe_no,
            CASE WHEN @i % 11 = 0 THEN N'BITIRDI' ELSE N'DEVAM_EDIYOR' END
        );

    SET @i = @i + 1;
END

SET @i = 1;
WHILE @i <= 180
BEGIN
    DECLARE @techizat_tur_no INT = (SELECT techizat_tur_no FROM (SELECT techizat_tur_no, ROW_NUMBER() OVER (ORDER BY techizat_tur_no) rn FROM TechizatTuru) X WHERE rn = ((@i - 1) % @techizat_tur_sayisi) + 1);

    IF NOT EXISTS (SELECT 1 FROM Techizat WHERE seri_numarasi = CONCAT(N'TCH-', RIGHT(CONCAT('0000', @i), 4)))
        INSERT INTO Techizat (seri_numarasi, ad, aciklama, durum, techizat_tur_no)
        VALUES (CONCAT(N'TCH-', RIGHT(CONCAT('0000', @i), 4)), CONCAT(N'Teçhizat ', @i), CONCAT(N'Gerçekçi mock teçhizat kaydı ', @i), CASE WHEN @i % 17 = 0 THEN N'PASIF' ELSE N'AKTIF' END, @techizat_tur_no);

    DECLARE @techizat_no INT = (SELECT techizat_no FROM Techizat WHERE seri_numarasi = CONCAT(N'TCH-', RIGHT(CONCAT('0000', @i), 4)));
    DECLARE @birim_no INT = (SELECT birim_no FROM (SELECT birim_no, ROW_NUMBER() OVER (ORDER BY birim_no) rn FROM Birim) X WHERE rn = ((@i - 1) % @birim_sayisi) + 1);

    IF NOT EXISTS (SELECT 1 FROM TransferOlur WHERE techizat_no = @techizat_no AND birim_no = @birim_no AND bitis_tarihi IS NULL)
        INSERT INTO TransferOlur (techizat_no, birim_no, baslama_tarihi, bitis_tarihi)
        VALUES (@techizat_no, @birim_no, DATEADD(DAY, -300 - @i, CAST(GETDATE() AS DATE)), NULL);

    SET @i = @i + 1;
END

SET @i = 1;
WHILE @i <= 70
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Operasyon WHERE operasyon_adi = CONCAT(N'Operasyon ', RIGHT(CONCAT('00', @i), 2)))
        INSERT INTO Operasyon (operasyon_adi, baslangic_tarihi, bitis_tarihi, aciklama)
        VALUES (CONCAT(N'Operasyon ', RIGHT(CONCAT('00', @i), 2)), DATEADD(DAY, -(@i * 11), CAST(GETDATE() AS DATE)), DATEADD(DAY, -(@i * 11) + 3, CAST(GETDATE() AS DATE)), CONCAT(N'Büyük veri mock operasyonu ', @i));

    DECLARE @operasyon_no INT = (SELECT operasyon_no FROM Operasyon WHERE operasyon_adi = CONCAT(N'Operasyon ', RIGHT(CONCAT('00', @i), 2)));
    DECLARE @op_birim_no INT = (SELECT birim_no FROM (SELECT birim_no, ROW_NUMBER() OVER (ORDER BY birim_no) rn FROM Birim) X WHERE rn = ((@i - 1) % @birim_sayisi) + 1);
    DECLARE @op_techizat_no INT = (SELECT techizat_no FROM (SELECT techizat_no, ROW_NUMBER() OVER (ORDER BY techizat_no) rn FROM Techizat) X WHERE rn = ((@i - 1) % 180) + 1);

    IF NOT EXISTS (SELECT 1 FROM BirimOpKatilir WHERE operasyon_no = @operasyon_no AND birim_no = @op_birim_no)
        INSERT INTO BirimOpKatilir (operasyon_no, birim_no) VALUES (@operasyon_no, @op_birim_no);

    IF NOT EXISTS (SELECT 1 FROM OpKullanilir WHERE operasyon_no = @operasyon_no AND techizat_no = @op_techizat_no)
        INSERT INTO OpKullanilir (operasyon_no, techizat_no) VALUES (@operasyon_no, @op_techizat_no);

    SET @i = @i + 1;
END

SET @i = 1;
WHILE @i <= 60
BEGIN
    DECLARE @egitim_tur_no INT = (SELECT egitim_tur_no FROM (SELECT egitim_tur_no, ROW_NUMBER() OVER (ORDER BY egitim_tur_no) rn FROM EgitimTuru) X WHERE rn = ((@i - 1) % @egitim_tur_sayisi) + 1);
    IF NOT EXISTS (SELECT 1 FROM Egitim WHERE baslangic_tarih_saat = DATEADD(DAY, -@i, @current_datetime))
        INSERT INTO Egitim (egitim_tur_no, baslangic_tarih_saat, bitis_tarih_saat)
        VALUES (@egitim_tur_no, DATEADD(DAY, -@i, @current_datetime), DATEADD(HOUR, 4, DATEADD(DAY, -@i, @current_datetime)));
    SET @i = @i + 1;
END

DECLARE @top_birim_1 INT = (
    SELECT birim_no
    FROM (
        SELECT NYS.birim_no, ROW_NUMBER() OVER (ORDER BY NYS.nobet_yeri_sayisi DESC, NYS.birim_no ASC) rn
        FROM (
            SELECT birim_no, COUNT(*) AS nobet_yeri_sayisi
            FROM NobetYeri
            GROUP BY birim_no
        ) NYS
    ) X
    WHERE rn = 1
);
DECLARE @top_birim_2 INT = (
    SELECT birim_no
    FROM (
        SELECT NYS.birim_no, ROW_NUMBER() OVER (ORDER BY NYS.nobet_yeri_sayisi DESC, NYS.birim_no ASC) rn
        FROM (
            SELECT birim_no, COUNT(*) AS nobet_yeri_sayisi
            FROM NobetYeri
            GROUP BY birim_no
        ) NYS
    ) X
    WHERE rn = 2
);
DECLARE @top_birim_3 INT = (
    SELECT birim_no
    FROM (
        SELECT NYS.birim_no, ROW_NUMBER() OVER (ORDER BY NYS.nobet_yeri_sayisi DESC, NYS.birim_no ASC) rn
        FROM (
            SELECT birim_no, COUNT(*) AS nobet_yeri_sayisi
            FROM NobetYeri
            GROUP BY birim_no
        ) NYS
    ) X
    WHERE rn = 3
);
DECLARE @nobet_yeri_sayisi INT = (SELECT COUNT(*) FROM NobetYeri);
DECLARE @operasyon_sayisi INT = (SELECT COUNT(*) FROM Operasyon);
DECLARE @egitim_sayisi INT = (SELECT COUNT(*) FROM Egitim);

SET @i = 1;
WHILE @i <= 200
BEGIN
    DECLARE @asker_no INT = (SELECT asker_no FROM Asker WHERE tc_kimlik_no = RIGHT(CONCAT('00000000000', 11000000000 + @i), 11));
    DECLARE @ana_birim_no INT = (SELECT birim_no FROM (SELECT birim_no, ROW_NUMBER() OVER (ORDER BY birim_no) rn FROM Birim) X WHERE rn = ((@i - 1) % @birim_sayisi) + 1);

    IF NOT EXISTS (SELECT 1 FROM GorevYapar WHERE asker_no = @asker_no AND birim_no = @ana_birim_no)
        INSERT INTO GorevYapar (asker_no, birim_no, baslama_tarihi, ayrilma_tarihi)
        VALUES (@asker_no, @ana_birim_no, DATEADD(DAY, -260 - @i, CAST(GETDATE() AS DATE)), NULL);

    IF @i <= 40
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM GorevYapar WHERE asker_no = @asker_no AND birim_no = @top_birim_1)
            INSERT INTO GorevYapar (asker_no, birim_no, baslama_tarihi, ayrilma_tarihi) VALUES (@asker_no, @top_birim_1, DATEADD(DAY, -520 - @i, CAST(GETDATE() AS DATE)), DATEADD(DAY, -480 - @i, CAST(GETDATE() AS DATE)));
        IF NOT EXISTS (SELECT 1 FROM GorevYapar WHERE asker_no = @asker_no AND birim_no = @top_birim_2)
            INSERT INTO GorevYapar (asker_no, birim_no, baslama_tarihi, ayrilma_tarihi) VALUES (@asker_no, @top_birim_2, DATEADD(DAY, -470 - @i, CAST(GETDATE() AS DATE)), DATEADD(DAY, -430 - @i, CAST(GETDATE() AS DATE)));
        IF NOT EXISTS (SELECT 1 FROM GorevYapar WHERE asker_no = @asker_no AND birim_no = @top_birim_3)
            INSERT INTO GorevYapar (asker_no, birim_no, baslama_tarihi, ayrilma_tarihi) VALUES (@asker_no, @top_birim_3, DATEADD(DAY, -420 - @i, CAST(GETDATE() AS DATE)), DATEADD(DAY, -380 - @i, CAST(GETDATE() AS DATE)));
    END

    DECLARE @nobet_yeri_no INT = (SELECT nobet_yeri_no FROM (SELECT nobet_yeri_no, ROW_NUMBER() OVER (ORDER BY nobet_yeri_no) rn FROM NobetYeri) X WHERE rn = ((@i - 1) % @nobet_yeri_sayisi) + 1);
    IF NOT EXISTS (SELECT 1 FROM NobetTutar WHERE asker_no = @asker_no AND nobet_yeri_no = @nobet_yeri_no)
        INSERT INTO NobetTutar (asker_no, nobet_yeri_no, baslangic_tarih_saat, bitis_tarih_saat, verilen_mermi_gramaj, getirilen_mermi_gramaj)
        VALUES (@asker_no, @nobet_yeri_no, DATEADD(HOUR, -(@i * 3), @current_datetime), DATEADD(HOUR, -(@i * 3) + 4, @current_datetime), CASE WHEN @i % 2 = 0 THEN 250 ELSE NULL END, CASE WHEN @i % 2 = 0 THEN 250 - (@i % 4) ELSE NULL END);

    IF @i % 4 = 0 AND NOT EXISTS (SELECT 1 FROM Izin WHERE asker_no = @asker_no)
        INSERT INTO Izin (asker_no, izin_suresi_gun, yol_suresi_gun, baslangic_tarihi, gercek_ayrilis_tarih_saat, gercek_donus_tarih_saat)
        VALUES (@asker_no, 5 + (@i % 5), @i % 3, DATEADD(DAY, -(@i % 120), CAST(GETDATE() AS DATE)), DATEADD(DAY, -(@i % 120), @current_datetime), DATEADD(DAY, -(@i % 120) + 7, @current_datetime));

    IF @i % 8 = 0 AND NOT EXISTS (SELECT 1 FROM DisiplinCezasi WHERE asker_no = @asker_no)
    BEGIN
        DECLARE @ceza_sebep_no INT = (SELECT ceza_sebep_no FROM (SELECT ceza_sebep_no, ROW_NUMBER() OVER (ORDER BY ceza_sebep_no) rn FROM CezaSebebi) X WHERE rn = ((@i - 1) % @ceza_sebep_sayisi) + 1);
        INSERT INTO DisiplinCezasi (asker_no, ceza_sebep_no, baslangic_tarihi, bitis_tarihi)
        VALUES (@asker_no, @ceza_sebep_no, DATEADD(DAY, -(@i % 90), CAST(GETDATE() AS DATE)), DATEADD(DAY, -(@i % 90) + 2, CAST(GETDATE() AS DATE)));
    END

    DECLARE @katilim_operasyon_no INT = (SELECT operasyon_no FROM (SELECT operasyon_no, ROW_NUMBER() OVER (ORDER BY operasyon_no) rn FROM Operasyon) X WHERE rn = ((@i - 1) % @operasyon_sayisi) + 1);
    IF NOT EXISTS (SELECT 1 FROM OpKatilir WHERE operasyon_no = @katilim_operasyon_no AND asker_no = @asker_no)
        INSERT INTO OpKatilir (operasyon_no, asker_no) VALUES (@katilim_operasyon_no, @asker_no);

    DECLARE @zimmet_techizat_no INT = (SELECT techizat_no FROM (SELECT techizat_no, ROW_NUMBER() OVER (ORDER BY techizat_no) rn FROM Techizat) X WHERE rn = ((@i - 1) % 180) + 1);
    IF NOT EXISTS (SELECT 1 FROM Zimmetlenir WHERE techizat_no = @zimmet_techizat_no AND asker_no = @asker_no)
        INSERT INTO Zimmetlenir (techizat_no, asker_no, baslama_tarihi, bitis_tarihi)
        VALUES (@zimmet_techizat_no, @asker_no, DATEADD(DAY, -(@i + 10), CAST(GETDATE() AS DATE)), CASE WHEN @i % 5 = 0 THEN DATEADD(DAY, -@i, CAST(GETDATE() AS DATE)) ELSE NULL END);

    DECLARE @egitim_no INT = (SELECT egitim_no FROM (SELECT egitim_no, ROW_NUMBER() OVER (ORDER BY egitim_no) rn FROM Egitim) X WHERE rn = ((@i - 1) % @egitim_sayisi) + 1);
    IF NOT EXISTS (SELECT 1 FROM EgitimAlir WHERE egitim_no = @egitim_no AND asker_no = @asker_no)
        INSERT INTO EgitimAlir (egitim_no, asker_no) VALUES (@egitim_no, @asker_no);

    IF @i % 3 <> 0 AND NOT EXISTS (SELECT 1 FROM Atis WHERE asker_no = @asker_no)
    BEGIN
        DECLARE @atis_tur_no INT = (SELECT atis_tur_no FROM (SELECT atis_tur_no, ROW_NUMBER() OVER (ORDER BY atis_tur_no) rn FROM AtisTuru) X WHERE rn = ((@i - 1) % @atis_tur_sayisi) + 1);
        DECLARE @atis_lokasyon_no INT = (SELECT atis_lokasyon_no FROM (SELECT atis_lokasyon_no, ROW_NUMBER() OVER (ORDER BY atis_lokasyon_no) rn FROM AtisLokasyonu) X WHERE rn = ((@i - 1) % @atis_lokasyon_sayisi) + 1);
        INSERT INTO Atis (asker_no, atis_tur_no, atis_lokasyon_no, atis_tarihi)
        VALUES (@asker_no, @atis_tur_no, @atis_lokasyon_no, DATEADD(DAY, -(@i % 180), CAST(GETDATE() AS DATE)));
    END

    IF @i % 20 = 0
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Ictima WHERE ictima_tarih_saat = DATEADD(DAY, -@i, @current_datetime))
            INSERT INTO Ictima (birim_no, ictima_tarih_saat, olmasi_gereken_asker_sayisi, olan_asker_sayisi, onaylayan_asker_no)
            VALUES (@ana_birim_no, DATEADD(DAY, -@i, @current_datetime), 60, 58, @asker_no);

        DECLARE @ictima_no INT = (SELECT ictima_no FROM Ictima WHERE ictima_tarih_saat = DATEADD(DAY, -@i, @current_datetime));
        IF NOT EXISTS (SELECT 1 FROM YoklamadaBulunur WHERE ictima_no = @ictima_no AND asker_no = @asker_no)
            INSERT INTO YoklamadaBulunur (ictima_no, asker_no) VALUES (@ictima_no, @asker_no);
    END

    SET @i = @i + 1;
END

SET @i = 1;
WHILE @i <= 25
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Operasyon WHERE operasyon_adi = CONCAT(N'Geçen Yıl Kritik Operasyon ', RIGHT(CONCAT('00', @i), 2)))
        INSERT INTO Operasyon (operasyon_adi, baslangic_tarihi, bitis_tarihi, aciklama)
        VALUES (CONCAT(N'Geçen Yıl Kritik Operasyon ', RIGHT(CONCAT('00', @i), 2)), DATEFROMPARTS(YEAR(GETDATE()) - 1, ((@i - 1) % 12) + 1, ((@i - 1) % 20) + 1), DATEADD(DAY, 2, DATEFROMPARTS(YEAR(GETDATE()) - 1, ((@i - 1) % 12) + 1, ((@i - 1) % 20) + 1)), N'Sorgu 1 için geçen yıl operasyonu');

    DECLARE @gecen_yil_operasyon_no INT = (SELECT operasyon_no FROM Operasyon WHERE operasyon_adi = CONCAT(N'Geçen Yıl Kritik Operasyon ', RIGHT(CONCAT('00', @i), 2)));
    DECLARE @test_asker_sira INT = 1;
    WHILE @test_asker_sira <= 6
    BEGIN
        DECLARE @test_asker_no INT = (SELECT asker_no FROM Asker WHERE tc_kimlik_no = RIGHT(CONCAT('00000000000', 11000000000 + @test_asker_sira), 11));
        IF NOT EXISTS (SELECT 1 FROM OpKatilir WHERE operasyon_no = @gecen_yil_operasyon_no AND asker_no = @test_asker_no)
            INSERT INTO OpKatilir (operasyon_no, asker_no) VALUES (@gecen_yil_operasyon_no, @test_asker_no);
        SET @test_asker_sira = @test_asker_sira + 1;
    END
    SET @i = @i + 1;
END

DECLARE @yalova_birim_no INT = (
    SELECT TOP 1 B.birim_no
    FROM Birim B
    INNER JOIN Ilce ILCE ON ILCE.ilce_no = B.ilce_no
    INNER JOIN Il I ON I.il_no = ILCE.il_no
    WHERE I.il_adi = N'Yalova'
    ORDER BY B.birim_no
);
DECLARE @patlayici_tur_no INT = (SELECT techizat_tur_no FROM TechizatTuru WHERE tur_adi = N'Patlayıcı');

SET @i = 1;
WHILE @i <= 15
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Techizat WHERE seri_numarasi = CONCAT(N'PAT-YLV-', RIGHT(CONCAT('000', @i), 3)))
        INSERT INTO Techizat (seri_numarasi, ad, aciklama, durum, techizat_tur_no)
        VALUES (CONCAT(N'PAT-YLV-', RIGHT(CONCAT('000', @i), 3)), CONCAT(N'Yalova Patlayıcı Teçhizat ', @i), N'Sorgu 2 için Yalova birliğinde bulunan patlayıcı teçhizat', N'AKTIF', @patlayici_tur_no);

    DECLARE @patlayici_techizat_no INT = (SELECT techizat_no FROM Techizat WHERE seri_numarasi = CONCAT(N'PAT-YLV-', RIGHT(CONCAT('000', @i), 3)));
    IF NOT EXISTS (SELECT 1 FROM TransferOlur WHERE techizat_no = @patlayici_techizat_no AND birim_no = @yalova_birim_no AND bitis_tarihi IS NULL)
        INSERT INTO TransferOlur (techizat_no, birim_no, baslama_tarihi, bitis_tarihi)
        VALUES (@patlayici_techizat_no, @yalova_birim_no, DATEADD(DAY, -200 - @i, CAST(GETDATE() AS DATE)), NULL);

    DECLARE @zimmet_asker_1 INT = (SELECT asker_no FROM Asker WHERE tc_kimlik_no = RIGHT(CONCAT('00000000000', 11000000000 + @i), 11));
    DECLARE @zimmet_asker_2 INT = (SELECT asker_no FROM Asker WHERE tc_kimlik_no = RIGHT(CONCAT('00000000000', 11000000000 + @i + 20), 11));

    IF NOT EXISTS (SELECT 1 FROM Zimmetlenir WHERE techizat_no = @patlayici_techizat_no AND asker_no = @zimmet_asker_1)
        INSERT INTO Zimmetlenir (techizat_no, asker_no, baslama_tarihi, bitis_tarihi)
        VALUES (@patlayici_techizat_no, @zimmet_asker_1, DATEADD(DAY, -120 - @i, CAST(GETDATE() AS DATE)), DATEADD(DAY, -90 - @i, CAST(GETDATE() AS DATE)));
    IF NOT EXISTS (SELECT 1 FROM Zimmetlenir WHERE techizat_no = @patlayici_techizat_no AND asker_no = @zimmet_asker_2)
        INSERT INTO Zimmetlenir (techizat_no, asker_no, baslama_tarihi, bitis_tarihi)
        VALUES (@patlayici_techizat_no, @zimmet_asker_2, DATEADD(DAY, -80 - @i, CAST(GETDATE() AS DATE)), NULL);

    SET @i = @i + 1;
END

DROP TABLE #Karakter;

SELECT
    (SELECT COUNT(*) FROM Asker) AS asker_sayisi,
    (SELECT COUNT(*) FROM Techizat) AS techizat_sayisi,
    (SELECT COUNT(*) FROM Operasyon) AS operasyon_sayisi,
    (SELECT COUNT(*) FROM Techizat WHERE seri_numarasi LIKE N'PAT-YLV-%') AS sorgu2_patlayici_techizat_sayisi;
GO
