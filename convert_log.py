with open("sql_error.log", "r", encoding="utf-16-le") as f:
    text = f.read()

with open("sql_error_utf8.log", "w", encoding="utf-8") as f:
    f.write(text)

print("Done converting log.")
