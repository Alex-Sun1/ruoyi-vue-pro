from pathlib import Path

for f in Path(r"e:\wms\ruoyi-vue-pro\yudao-module-yms\src\main\java\cn\iocoder\yudao\module\yms\controller").rglob("*.java"):
    t = f.read_text(encoding="utf-8")
    t2 = t.replace("\\'", "'")
    if t2 != t:
        f.write_text(t2, encoding="utf-8")
        print(f.name)
