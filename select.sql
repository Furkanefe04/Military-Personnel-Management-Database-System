USE AskeriYonetimSistemi;
GO

/*
1) En cok nobet yeri olan ilk uc birimin hepsinde askerlik yapmis kisilerin
   T.C. kimlik numarasini, son nobet tarihini, son birliginin ismini ve
   gecen sene ciktiklari toplam operasyon sayisini getirir.
*/
SELECT
    Sorgu1.tc_kimlik_no,
    Sorgu1.son_nobet_tarihi,
    Sorgu1.son_birlik_ismi,
    Sorgu1.gecen_sene_operasyon_sayisi
FROM (
    SELECT
        A.asker_no,
        A.tc_kimlik_no,
        (
            SELECT MAX(N2.baslangic_tarih_saat)
            FROM NobetTutar N2
            WHERE N2.asker_no = A.asker_no
        ) AS son_nobet_tarihi,
        (
            SELECT TOP 1 B2.birim_adi
            FROM GorevYapar ABG2
            INNER JOIN Birim B2 ON B2.birim_no = ABG2.birim_no
            WHERE ABG2.asker_no = A.asker_no
            ORDER BY
                ISNULL(ABG2.ayrilma_tarihi, '9999-12-31') DESC,
                ABG2.baslama_tarihi DESC,
                ABG2.asker_birim_gorev_no DESC
        ) AS son_birlik_ismi,
        (
            SELECT COUNT(DISTINCT OA2.operasyon_no)
            FROM OpKatilir OA2
            INNER JOIN Operasyon O2 ON O2.operasyon_no = OA2.operasyon_no
            WHERE
                OA2.asker_no = A.asker_no AND
                YEAR(O2.baslangic_tarihi) = YEAR(GETDATE()) - 1
        ) AS gecen_sene_operasyon_sayisi
    FROM Asker A
    WHERE
        (
            SELECT COUNT(DISTINCT ABG.birim_no)
            FROM GorevYapar ABG
            WHERE
                ABG.asker_no = A.asker_no AND
                ABG.birim_no IN (
                    SELECT TOP 3 NobetYeriSayisi.birim_no
                    FROM (
                        SELECT NY.birim_no, COUNT(*) AS nobet_yeri_sayisi
                        FROM NobetYeri NY
                        GROUP BY NY.birim_no
                    ) NobetYeriSayisi
                    ORDER BY NobetYeriSayisi.nobet_yeri_sayisi DESC, NobetYeriSayisi.birim_no ASC
                )
        ) = 3
) Sorgu1
ORDER BY
    CASE WHEN Sorgu1.gecen_sene_operasyon_sayisi > 20 THEN Sorgu1.tc_kimlik_no ELSE NULL END DESC,
    CASE WHEN Sorgu1.gecen_sene_operasyon_sayisi <= 20 THEN Sorgu1.son_birlik_ismi ELSE NULL END ASC;
GO

/*
2) Yalova ilindeki birliklerde bulunan patlayici turundeki tum techizatlarin
   seri numaralarini, kac defa bir askere verildigini, kac farkli askere
   verildigini ve Istanbullu kac askere verildigini getirir.
   Verilmemis techizatlar icin sayilar 0 olur.
*/
SELECT
    T.seri_numarasi,
    COUNT(TAZ.techizat_asker_zimmet_no) AS askere_verilme_sayisi,
    COUNT(DISTINCT TAZ.asker_no) AS farkli_asker_sayisi,
    COUNT(DISTINCT CASE
        WHEN AskerIl.il_adi IN (N'İstanbul', N'Istanbul') THEN TAZ.asker_no
        ELSE NULL
    END) AS istanbullu_asker_sayisi
FROM Techizat T
INNER JOIN TechizatTuru TT ON TT.techizat_tur_no = T.techizat_tur_no
INNER JOIN TransferOlur TBT ON TBT.techizat_no = T.techizat_no
INNER JOIN Birim B ON B.birim_no = TBT.birim_no
INNER JOIN Ilce BirimIlce ON BirimIlce.ilce_no = B.ilce_no
INNER JOIN Il BirimIl ON BirimIl.il_no = BirimIlce.il_no
LEFT JOIN Zimmetlenir TAZ ON TAZ.techizat_no = T.techizat_no
LEFT JOIN Asker A ON A.asker_no = TAZ.asker_no
LEFT JOIN CaddeSokak CS ON CS.cadde_sokak_no = A.cadde_sokak_no
LEFT JOIN Mahalle M ON M.mahalle_no = CS.mahalle_no
LEFT JOIN Ilce ILC ON ILC.ilce_no = M.ilce_no
LEFT JOIN Il AskerIl ON AskerIl.il_no = ILC.il_no
WHERE
    BirimIl.il_adi = N'Yalova' AND
    TT.tur_adi IN (N'Patlayıcı', N'Patlayici') AND
    TBT.baslama_tarihi <= CAST(GETDATE() AS DATE) AND
    (TBT.bitis_tarihi IS NULL OR TBT.bitis_tarihi >= CAST(GETDATE() AS DATE))
GROUP BY
    T.techizat_no,
    T.seri_numarasi
ORDER BY
    T.seri_numarasi ASC;
GO
