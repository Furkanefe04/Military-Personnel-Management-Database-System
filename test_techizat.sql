USE AskeriYonetimSistemi;
GO

PRINT '=== Techizat Tablosu UNIQUE Kısıtlaması Testi ===';
PRINT 'Mevcut bir Seri Numarası (TCH-0001) ile yeni bir teçhizat eklenmeye çalışılıyor...';

-- Bu ekleme işlemi UNIQUE constraint (seri_numarasi) nedeniyle hata vermelidir.
INSERT INTO Techizat (seri_numarasi, ad, aciklama, durum, techizat_tur_no)
VALUES ('TCH-0001', N'Test Cihazı', N'Hata testi açıklaması', N'AKTIF', 1);
GO
