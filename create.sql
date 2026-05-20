USE master;
GO

IF DB_ID('AskeriYonetimSistemi') IS NOT NULL
BEGIN
    ALTER DATABASE AskeriYonetimSistemi SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE AskeriYonetimSistemi;
END
GO

CREATE DATABASE AskeriYonetimSistemi;
GO

USE AskeriYonetimSistemi;
GO

CREATE TABLE Il (
    il_no INT IDENTITY(1,1) PRIMARY KEY,
    il_adi NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Ilce (
    ilce_no INT IDENTITY(1,1) PRIMARY KEY,
    il_no INT NOT NULL,
    ilce_adi NVARCHAR(100) NOT NULL,
    CONSTRAINT FK_Ilce_Il FOREIGN KEY (il_no) REFERENCES Il(il_no),
    CONSTRAINT UQ_Ilce UNIQUE (il_no, ilce_adi)
);

CREATE TABLE Mahalle (
    mahalle_no INT IDENTITY(1,1) PRIMARY KEY,
    ilce_no INT NOT NULL,
    mahalle_adi NVARCHAR(100) NOT NULL,
    CONSTRAINT FK_Mahalle_Ilce FOREIGN KEY (ilce_no) REFERENCES Ilce(ilce_no),
    CONSTRAINT UQ_Mahalle UNIQUE (ilce_no, mahalle_adi)
);

CREATE TABLE CaddeSokak (
    cadde_sokak_no INT IDENTITY(1,1) PRIMARY KEY,
    mahalle_no INT NOT NULL,
    cadde_sokak_adi NVARCHAR(150) NOT NULL,
    CONSTRAINT FK_CaddeSokak_Mahalle FOREIGN KEY (mahalle_no) REFERENCES Mahalle(mahalle_no),
    CONSTRAINT UQ_CaddeSokak UNIQUE (mahalle_no, cadde_sokak_adi)
);

CREATE TABLE Rutbe (
    rutbe_no INT IDENTITY(1,1) PRIMARY KEY,
    rutbe_adi NVARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE BirimSinifi (
    birim_sinif_no INT IDENTITY(1,1) PRIMARY KEY,
    sinif_adi NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE TechizatTuru (
    techizat_tur_no INT IDENTITY(1,1) PRIMARY KEY,
    tur_adi NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE CezaSebebi (
    ceza_sebep_no INT IDENTITY(1,1) PRIMARY KEY,
    sebep_adi NVARCHAR(200) NOT NULL UNIQUE
);

CREATE TABLE EgitimTuru (
    egitim_tur_no INT IDENTITY(1,1) PRIMARY KEY,
    tur_adi NVARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE AtisTuru (
    atis_tur_no INT IDENTITY(1,1) PRIMARY KEY,
    tur_adi NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE AtisLokasyonu (
    atis_lokasyon_no INT IDENTITY(1,1) PRIMARY KEY,
    lokasyon_adi NVARCHAR(150) NOT NULL,
    il_no INT NULL,
    ilce_no INT NULL,
    adres_aciklamasi NVARCHAR(300) NULL,
    CONSTRAINT FK_AtisLokasyonu_Il FOREIGN KEY (il_no) REFERENCES Il(il_no),
    CONSTRAINT FK_AtisLokasyonu_Ilce FOREIGN KEY (ilce_no) REFERENCES Ilce(ilce_no)
);

CREATE TABLE Asker (
    asker_no INT IDENTITY(1,1) PRIMARY KEY,
    tc_kimlik_no CHAR(11) NOT NULL UNIQUE,
    ad NVARCHAR(80) NOT NULL,
    soyad NVARCHAR(80) NOT NULL,
    cinsiyet CHAR(1) NOT NULL,
    dogum_tarihi DATE NOT NULL,
    yas INT NOT NULL,
    cadde_sokak_no INT NOT NULL,
    dis_kapi_no NVARCHAR(20) NOT NULL,
    ic_kapi_no NVARCHAR(20) NULL,
    adres_aciklamasi NVARCHAR(300) NULL,
    telefon NVARCHAR(25) NOT NULL,
    atis_durumu NVARCHAR(15) NOT NULL,
    askerlik_suresi_gun INT NOT NULL,
    toplam_izin_suresi_gun INT NOT NULL DEFAULT 0,
    kullanilan_izin_suresi_gun INT NOT NULL DEFAULT 0,
    kalan_izin_suresi_gun INT NOT NULL DEFAULT 0,
    disiplin_cezasi_gun INT NOT NULL DEFAULT 0,
    teslim_tarihi DATE NOT NULL,
    terhis_tarihi AS DATEADD(DAY, askerlik_suresi_gun + disiplin_cezasi_gun - toplam_izin_suresi_gun, teslim_tarihi),
    rutbe_no INT NOT NULL,
    durum NVARCHAR(20) NOT NULL,
    CONSTRAINT FK_Asker_CaddeSokak FOREIGN KEY (cadde_sokak_no) REFERENCES CaddeSokak(cadde_sokak_no),
    CONSTRAINT FK_Asker_Rutbe FOREIGN KEY (rutbe_no) REFERENCES Rutbe(rutbe_no),
    CONSTRAINT CK_Asker_TCKimlik CHECK (tc_kimlik_no NOT LIKE '%[^0-9]%' AND LEN(tc_kimlik_no) = 11),
    CONSTRAINT CK_Asker_Cinsiyet CHECK (cinsiyet IN ('E', 'K')),
    CONSTRAINT CK_Asker_AtisDurumu CHECK (atis_durumu IN (N'YAPTI', N'YAPMADI')),
    CONSTRAINT CK_Asker_Durum CHECK (durum IN (N'DEVAM_EDIYOR', N'BITIRDI')),
    CONSTRAINT CK_Asker_Gun CHECK (
        yas >= 0 AND askerlik_suresi_gun > 0 AND toplam_izin_suresi_gun >= 0 AND
        kullanilan_izin_suresi_gun >= 0 AND kalan_izin_suresi_gun >= 0 AND disiplin_cezasi_gun >= 0
    )
);

CREATE TABLE Birim (
    birim_no INT IDENTITY(1,1) PRIMARY KEY,
    ust_birim_no INT NULL,
    birim_adi NVARCHAR(150) NOT NULL,
    ilce_no INT NOT NULL,
    adres_aciklamasi NVARCHAR(300) NULL,
    telefon NVARCHAR(25) NULL,
    durum NVARCHAR(10) NOT NULL,
    kurulus_tarihi DATE NOT NULL,
    birim_sinif_no INT NOT NULL,
    CONSTRAINT FK_Birim_UstBirim FOREIGN KEY (ust_birim_no) REFERENCES Birim(birim_no),
    CONSTRAINT FK_Birim_Ilce FOREIGN KEY (ilce_no) REFERENCES Ilce(ilce_no),
    CONSTRAINT FK_Birim_BirimSinifi FOREIGN KEY (birim_sinif_no) REFERENCES BirimSinifi(birim_sinif_no),
    CONSTRAINT UQ_Birim_BirimAdi UNIQUE (birim_adi),
    CONSTRAINT CK_Birim_Durum CHECK (durum IN (N'AKTIF', N'PASIF'))
);

CREATE TABLE GorevYapar (
    asker_birim_gorev_no INT IDENTITY(1,1) PRIMARY KEY,
    asker_no INT NOT NULL,
    birim_no INT NOT NULL,
    baslama_tarihi DATE NOT NULL,
    ayrilma_tarihi DATE NULL,
    CONSTRAINT FK_GorevYapar_Asker FOREIGN KEY (asker_no) REFERENCES Asker(asker_no),
    CONSTRAINT FK_GorevYapar_Birim FOREIGN KEY (birim_no) REFERENCES Birim(birim_no),
    CONSTRAINT CK_GorevYapar_Tarih CHECK (ayrilma_tarihi IS NULL OR ayrilma_tarihi >= baslama_tarihi)
);

CREATE TABLE Izin (
    izin_no INT IDENTITY(1,1) PRIMARY KEY,
    asker_no INT NOT NULL,
    izin_suresi_gun INT NOT NULL,
    yol_suresi_gun INT NOT NULL,
    baslangic_tarihi DATE NOT NULL,
    bitis_tarihi AS DATEADD(DAY, izin_suresi_gun + yol_suresi_gun, baslangic_tarihi),
    gercek_ayrilis_tarih_saat DATETIME2 NULL,
    gercek_donus_tarih_saat DATETIME2 NULL,
    CONSTRAINT FK_Izin_Asker FOREIGN KEY (asker_no) REFERENCES Asker(asker_no),
    CONSTRAINT CK_Izin_Gun CHECK (izin_suresi_gun >= 0 AND yol_suresi_gun >= 0),
    CONSTRAINT CK_Izin_GercekTarih CHECK (
        gercek_donus_tarih_saat IS NULL OR gercek_ayrilis_tarih_saat IS NULL OR
        gercek_donus_tarih_saat >= gercek_ayrilis_tarih_saat
    )
);

CREATE TABLE Techizat (
    techizat_no INT IDENTITY(1,1) PRIMARY KEY,
    seri_numarasi NVARCHAR(100) NOT NULL UNIQUE,
    ad NVARCHAR(150) NOT NULL,
    aciklama NVARCHAR(300) NULL,
    durum NVARCHAR(10) NOT NULL,
    techizat_tur_no INT NOT NULL,
    CONSTRAINT FK_Techizat_TechizatTuru FOREIGN KEY (techizat_tur_no) REFERENCES TechizatTuru(techizat_tur_no),
    CONSTRAINT CK_Techizat_Durum CHECK (durum IN (N'AKTIF', N'PASIF'))
);

CREATE TABLE TransferOlur (
    techizat_birim_transfer_no INT IDENTITY(1,1) PRIMARY KEY,
    techizat_no INT NOT NULL,
    birim_no INT NOT NULL,
    baslama_tarihi DATE NOT NULL,
    bitis_tarihi DATE NULL,
    CONSTRAINT FK_TransferOlur_Techizat FOREIGN KEY (techizat_no) REFERENCES Techizat(techizat_no),
    CONSTRAINT FK_TransferOlur_Birim FOREIGN KEY (birim_no) REFERENCES Birim(birim_no),
    CONSTRAINT CK_TransferOlur_Tarih CHECK (bitis_tarihi IS NULL OR bitis_tarihi >= baslama_tarihi)
);

CREATE TABLE Zimmetlenir (
    techizat_asker_zimmet_no INT IDENTITY(1,1) PRIMARY KEY,
    techizat_no INT NOT NULL,
    asker_no INT NOT NULL,
    baslama_tarihi DATE NOT NULL,
    bitis_tarihi DATE NULL,
    CONSTRAINT FK_Zimmetlenir_Techizat FOREIGN KEY (techizat_no) REFERENCES Techizat(techizat_no),
    CONSTRAINT FK_Zimmetlenir_Asker FOREIGN KEY (asker_no) REFERENCES Asker(asker_no),
    CONSTRAINT CK_Zimmetlenir_Tarih CHECK (bitis_tarihi IS NULL OR bitis_tarihi >= baslama_tarihi)
);

CREATE TABLE NobetYeri (
    nobet_yeri_no INT IDENTITY(1,1) PRIMARY KEY,
    birim_no INT NOT NULL,
    ad NVARCHAR(150) NOT NULL,
    silah_durumu NVARCHAR(10) NOT NULL,
    CONSTRAINT FK_NobetYeri_Birim FOREIGN KEY (birim_no) REFERENCES Birim(birim_no),
    CONSTRAINT CK_NobetYeri_SilahDurumu CHECK (silah_durumu IN (N'SILAHLI', N'SILAHSIZ')),
    CONSTRAINT UQ_NobetYeri_Ad UNIQUE (ad),
    CONSTRAINT UQ_NobetYeri UNIQUE (birim_no, ad)
);

CREATE TABLE NobetTutar (
    nobet_no INT IDENTITY(1,1) PRIMARY KEY,
    asker_no INT NOT NULL,
    nobet_yeri_no INT NOT NULL,
    baslangic_tarih_saat DATETIME2 NOT NULL,
    bitis_tarih_saat DATETIME2 NOT NULL,
    verilen_mermi_gramaj DECIMAL(10,2) NULL,
    getirilen_mermi_gramaj DECIMAL(10,2) NULL,
    CONSTRAINT FK_NobetTutar_Asker FOREIGN KEY (asker_no) REFERENCES Asker(asker_no),
    CONSTRAINT FK_NobetTutar_NobetYeri FOREIGN KEY (nobet_yeri_no) REFERENCES NobetYeri(nobet_yeri_no),
    CONSTRAINT CK_NobetTutar_Tarih CHECK (bitis_tarih_saat >= baslangic_tarih_saat),
    CONSTRAINT CK_NobetTutar_Mermi CHECK (
        (verilen_mermi_gramaj IS NULL OR verilen_mermi_gramaj >= 0) AND
        (getirilen_mermi_gramaj IS NULL OR getirilen_mermi_gramaj >= 0)
    )
);

CREATE TABLE Ictima (
    ictima_no INT IDENTITY(1,1) PRIMARY KEY,
    birim_no INT NOT NULL,
    ictima_tarih_saat DATETIME2 NOT NULL,
    olmasi_gereken_asker_sayisi INT NOT NULL,
    olan_asker_sayisi INT NOT NULL,
    onaylayan_asker_no INT NOT NULL,
    CONSTRAINT FK_Ictima_Birim FOREIGN KEY (birim_no) REFERENCES Birim(birim_no),
    CONSTRAINT FK_Ictima_OnaylayanAsker FOREIGN KEY (onaylayan_asker_no) REFERENCES Asker(asker_no),
    CONSTRAINT UQ_Ictima_Zaman UNIQUE (ictima_tarih_saat),
    CONSTRAINT CK_Ictima_Sayi CHECK (
        olmasi_gereken_asker_sayisi >= 0 AND olan_asker_sayisi >= 0 AND
        olan_asker_sayisi <= olmasi_gereken_asker_sayisi
    )
);

CREATE TABLE YoklamadaBulunur (
    ictima_no INT NOT NULL,
    asker_no INT NOT NULL,
    PRIMARY KEY (ictima_no, asker_no),
    CONSTRAINT FK_YoklamadaBulunur_Ictima FOREIGN KEY (ictima_no) REFERENCES Ictima(ictima_no),
    CONSTRAINT FK_YoklamadaBulunur_Asker FOREIGN KEY (asker_no) REFERENCES Asker(asker_no)
);

CREATE TABLE DisiplinCezasi (
    disiplin_ceza_no INT IDENTITY(1,1) PRIMARY KEY,
    asker_no INT NOT NULL,
    ceza_sebep_no INT NOT NULL,
    baslangic_tarihi DATE NOT NULL,
    bitis_tarihi DATE NOT NULL,
    CONSTRAINT FK_DisiplinCezasi_Asker FOREIGN KEY (asker_no) REFERENCES Asker(asker_no),
    CONSTRAINT FK_DisiplinCezasi_CezaSebebi FOREIGN KEY (ceza_sebep_no) REFERENCES CezaSebebi(ceza_sebep_no),
    CONSTRAINT CK_DisiplinCezasi_Tarih CHECK (bitis_tarihi >= baslangic_tarihi)
);

CREATE TABLE Operasyon (
    operasyon_no INT IDENTITY(1,1) PRIMARY KEY,
    operasyon_adi NVARCHAR(150) NOT NULL,
    baslangic_tarihi DATE NOT NULL,
    bitis_tarihi DATE NOT NULL,
    aciklama NVARCHAR(500) NULL,
    CONSTRAINT UQ_Operasyon_OperasyonAdi UNIQUE (operasyon_adi),
    CONSTRAINT CK_Operasyon_Tarih CHECK (bitis_tarihi >= baslangic_tarihi)
);

CREATE TABLE BirimOpKatilir (
    operasyon_no INT NOT NULL,
    birim_no INT NOT NULL,
    PRIMARY KEY (operasyon_no, birim_no),
    CONSTRAINT FK_BirimOpKatilir_Operasyon FOREIGN KEY (operasyon_no) REFERENCES Operasyon(operasyon_no),
    CONSTRAINT FK_BirimOpKatilir_Birim FOREIGN KEY (birim_no) REFERENCES Birim(birim_no)
);

CREATE TABLE OpKatilir (
    operasyon_no INT NOT NULL,
    asker_no INT NOT NULL,
    PRIMARY KEY (operasyon_no, asker_no),
    CONSTRAINT FK_OpKatilir_Operasyon FOREIGN KEY (operasyon_no) REFERENCES Operasyon(operasyon_no),
    CONSTRAINT FK_OpKatilir_Asker FOREIGN KEY (asker_no) REFERENCES Asker(asker_no)
);

CREATE TABLE OpKullanilir (
    operasyon_no INT NOT NULL,
    techizat_no INT NOT NULL,
    PRIMARY KEY (operasyon_no, techizat_no),
    CONSTRAINT FK_OpKullanilir_Operasyon FOREIGN KEY (operasyon_no) REFERENCES Operasyon(operasyon_no),
    CONSTRAINT FK_OpKullanilir_Techizat FOREIGN KEY (techizat_no) REFERENCES Techizat(techizat_no)
);

CREATE TABLE Egitim (
    egitim_no INT IDENTITY(1,1) PRIMARY KEY,
    egitim_tur_no INT NOT NULL,
    baslangic_tarih_saat DATETIME2 NOT NULL,
    bitis_tarih_saat DATETIME2 NOT NULL,
    CONSTRAINT FK_Egitim_EgitimTuru FOREIGN KEY (egitim_tur_no) REFERENCES EgitimTuru(egitim_tur_no),
    CONSTRAINT CK_Egitim_Tarih CHECK (bitis_tarih_saat >= baslangic_tarih_saat)
);

CREATE TABLE EgitimAlir (
    egitim_no INT NOT NULL,
    asker_no INT NOT NULL,
    PRIMARY KEY (egitim_no, asker_no),
    CONSTRAINT FK_EgitimAlir_Egitim FOREIGN KEY (egitim_no) REFERENCES Egitim(egitim_no),
    CONSTRAINT FK_EgitimAlir_Asker FOREIGN KEY (asker_no) REFERENCES Asker(asker_no)
);

CREATE TABLE Atis (
    atis_no INT IDENTITY(1,1) PRIMARY KEY,
    asker_no INT NOT NULL,
    atis_tur_no INT NOT NULL,
    atis_lokasyon_no INT NOT NULL,
    atis_tarihi DATE NOT NULL,
    CONSTRAINT FK_Atis_Asker FOREIGN KEY (asker_no) REFERENCES Asker(asker_no),
    CONSTRAINT FK_Atis_AtisTuru FOREIGN KEY (atis_tur_no) REFERENCES AtisTuru(atis_tur_no),
    CONSTRAINT FK_Atis_AtisLokasyonu FOREIGN KEY (atis_lokasyon_no) REFERENCES AtisLokasyonu(atis_lokasyon_no)
);
GO
