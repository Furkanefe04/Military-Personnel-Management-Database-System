import PyPDF2

def extract_pdf_text(pdf_name, txt_name):
    try:
        reader = PyPDF2.PdfReader(pdf_name)
        text = ""
        for i, page in enumerate(reader.pages):
            text += f"--- Page {i+1} ---\n"
            t = page.extract_text()
            if t:
                text += t + "\n"
        with open(txt_name, "w", encoding="utf-8") as f:
            f.write(text)
        print(f"Extracted {pdf_name} to {txt_name}")
    except Exception as e:
        print(f"Error reading {pdf_name}: {e}")

extract_pdf_text(r"c:\Users\FURKAN\Desktop\Military-Personnel-Management-Database-System\Proje.pdf", "Proje_text.txt")
extract_pdf_text(r"c:\Users\FURKAN\Desktop\Military-Personnel-Management-Database-System\ASKERİ SİSTEM YÖNETİMİ.pdf", "Askeri_Sistem_text.txt")
