USE AskeriYonetimSistemi;
GO

PRINT '=== Asker Tablosu UNIQUE Kısıtlaması Testi ===';
PRINT 'Mevcut bir TC Kimlik Numarası (11000000331) ile yeni bir asker eklenmeye çalışılıyor...';

-- Bu ekleme işlemi UNIQUE constraint (tc_kimlik_no) nedeniyle hata vermelidir.
INSERT INTO Asker (
    tc_kimlik_no, ad, soyad, cinsiyet, dogum_tarihi, yas, cadde_sokak_no,
    dis_kapi_no, ic_kapi_no, adres_aciklamasi, telefon, atis_durumu,
    askerlik_suresi_gun, toplam_izin_suresi_gun, kullanilan_izin_suresi_gun,
    kalan_izin_suresi_gun, disiplin_cezasi_gun, teslim_tarihi, rutbe_no, durum
)
VALUES (
    '11000000331', N'TestAd', N'TestSoyad', 'E', '2000-01-01', 26, 1,
    '1', '1', N'Test Adres', '05555555555', N'YAPTI',
    180, 24, 0, 24, 0, CAST(GETDATE() AS DATE), 1, N'DEVAM_EDIYOR'
);
GO
