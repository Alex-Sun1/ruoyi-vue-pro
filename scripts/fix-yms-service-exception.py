import re
from pathlib import Path

for f in Path(r"e:\wms\ruoyi-vue-pro\yudao-module-yms\src\main\java").rglob("*.java"):
    t = f.read_text(encoding="utf-8")
    t2 = re.sub(r'new ServiceException\("', 'new ServiceException(500, "', t)
    if t2 != t:
        f.write_text(t2, encoding="utf-8")
        print(f.relative_to(Path(r"e:\wms\ruoyi-vue-pro\yudao-module-yms")))
