# -*- coding: utf-8 -*-
from pathlib import Path

ROOT = Path(r"e:\wms\ruoyi-vue-pro\yudao-module-yms\src\main\java\cn\iocoder\yudao\module\yms")


def fix_do_update_closing(text: str) -> str:
    lines = text.split("\n")
    out = []
    for i, line in enumerate(lines):
        stripped = line.rstrip()
        if stripped.endswith(");") and not stripped.endswith("));"):
            window = "\n".join(lines[max(0, i - 20) : i + 1])
            if "lambdaUpdate()" in window or "lambdaUpdate(" in window:
                if "yardTaskMapper.update" in window or "doUpdate(" in window or "Mapper.update" in window:
                    if ".set(" in stripped or ".eq(" in stripped or ".set(" in window.split("\n")[-1]:
                        line = stripped[:-2] + "));"
        out.append(line)
    return "\n".join(out)


n = 0
for p in ROOT.rglob("*ServiceImpl.java"):
    t = p.read_text(encoding="utf-8")
    t2 = fix_do_update_closing(t)
    if t2 != t:
        p.write_text(t2, encoding="utf-8")
        n += 1
print(f"pass4 fixed {n} service impls")
