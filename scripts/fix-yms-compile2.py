# -*- coding: utf-8 -*-
import re
from pathlib import Path

ROOT = Path(r"e:\wms\ruoyi-vue-pro\yudao-module-yms\src\main\java\cn\iocoder\yudao\module\yms")


def fix_file(path: Path):
    text = path.read_text(encoding="utf-8")
    orig = text

    # TableDataInfo.build removal artifacts
    text = re.sub(r"\.set\(([^)]+)\)\);", r".set(\1));", text)
    text = re.sub(r"selectVoById\(([^;)]+)\);", r"selectVoById(\1));", text)
    text = re.sub(r"return ([a-zA-Z]+Mapper\.selectVoById\([^)]+\));", r"return \1);", text)

    # return Page -> PageResult
    text = re.sub(
        r"Page<([^>]+)> result = ([^;]+);\s*return result\);",
        r"Page<\1> result = \2;\n        return new PageResult<>(result.getRecords(), result.getTotal());",
        text,
    )

    # success double-paren fix: success(x)); -> success(x);
    text = re.sub(r"return success\(([^)]+)\)\);", r"return success(\1);", text)

    # CommonResult.success still missing paren
    text = re.sub(
        r"return (?:CommonResult\.)?success\(([^;]+)\);",
        lambda m: f"return success({m.group(1)});"
        if m.group(1).count("(") == m.group(1).count(")")
        else f"return success({m.group(1)}));",
        text,
    )

    if text != orig:
        path.write_text(text, encoding="utf-8")
        return True
    return False


n = sum(1 for p in ROOT.rglob("*.java") if fix_file(p))
print(f"pass2 fixed {n} files")
