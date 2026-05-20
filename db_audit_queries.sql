USE AskeriYonetimSistemi;
GO

SELECT 
    A.asker_no AS [Asker No],
    A.ad AS [Ad],
    A.soyad AS [Soyad],
    A.yas AS [Yaş],
    I.il_adi AS [İl],
    ILCE.ilce_adi AS [İlçe],
    M.mahalle_adi AS [Semt/Mahalle],
    CS.cadde_sokak_adi AS [Cadde/Sokak],
    -- En son katıldığı içtima tarihi
    (
        SELECT MAX(ICT.ictima_tarih_saat) 
        FROM YoklamadaBulunur YB 
        INNER JOIN Ictima ICT ON ICT.ictima_no = YB.ictima_no 
        WHERE YB.asker_no = A.asker_no
    ) AS [Son İçtima Tarihi],
    -- En son aldığı eğitimin türü
    (
        SELECT TOP 1 ET.tur_adi 
        FROM EgitimAlir EA 
        INNER JOIN Egitim EG ON EG.egitim_no = EA.egitim_no 
        INNER JOIN EgitimTuru ET ON ET.egitim_tur_no = EG.egitim_tur_no 
        WHERE EA.asker_no = A.asker_no 
        ORDER BY EG.baslangic_tarih_saat DESC
    ) AS [Son Eğitim Türü],
    -- En son yaptığı atışın türü (mesafesi)
    (
        SELECT TOP 1 ATT.tur_adi 
        FROM Atis AT 
        INNER JOIN AtisTuru ATT ON ATT.atis_tur_no = AT.atis_tur_no 
        WHERE AT.asker_no = A.asker_no 
        ORDER BY AT.atis_tarihi DESC
    ) AS [Son Atış Türü]
FROM Asker A
INNER JOIN CaddeSokak CS ON CS.cadde_sokak_no = A.cadde_sokak_no
INNER JOIN Mahalle M ON M.mahalle_no = CS.mahalle_no
INNER JOIN Ilce ILCE ON ILCE.ilce_no = M.ilce_no
INNER JOIN Il I ON I.il_no = ILCE.il_no
WHERE 
    -- 1. En az bir içtimada bulunmuş olması şartı
    EXISTS (SELECT 1 FROM YoklamadaBulunur YB WHERE YB.asker_no = A.asker_no)
    -- 2. En az bir eğitime katılmış olması şartı
    AND EXISTS (SELECT 1 FROM EgitimAlir EA WHERE EA.asker_no = A.asker_no)
    -- 3. En az bir atış faaliyetinde bulunmuş olması şartı
    AND EXISTS (SELECT 1 FROM Atis AT WHERE AT.asker_no = A.asker_no)
ORDER BY A.yas ASC;
GO