# -*- coding: utf-8 -*-
import re
from pathlib import Path

ROOT = Path(r"e:\wms\ruoyi-vue-pro\yudao-module-yms\src\main\java\cn\iocoder\yudao\module\yms")


def fix_file(path: Path):
    text = path.read_text(encoding="utf-8")
    orig = text
    text = re.sub(r"^import\s*;\s*\n", "", text, flags=re.M)
    text = text.replace("import java.lang.Object;\n", "")
    text = text.replace("TableDataInfo<", "PageResult<")
    text = text.replace("TableDataInfo", "PageResult")
    text = re.sub(r"return ([^;]+)\)\);", r"return \1);", text)
    text = re.sub(r"\bIYms(\w+)", r"Yms\1", text)
    if "controller.admin" not in text and path.name.endswith("Controller.java"):
        text = text.replace("package cn.iocoder.yudao.module.yms.controller;",
                            "package cn.iocoder.yudao.module.yms.controller.admin;")
    if path.name == "YmsPublicController.java":
        text = text.replace("package cn.iocoder.yudao.module.yms.controller;",
                            "package cn.iocoder.yudao.module.yms.controller.app;")
    text = text.replace("TenantUtils.execute(bo.getTenantId(), () ->",
                        "TenantUtils.execute(Long.valueOf(bo.getTenantId()), () ->")
    text = text.replace("TenantUtils.execute(tenantId, () ->",
                        "TenantUtils.execute(Long.valueOf(tenantId), () ->")
    text = text.replace("'\\''", "'")
    text = re.sub(
        r"return (?:CommonResult\.)?success\(([^;]+)\);",
        lambda m: f"return success({m.group(1)}));"
        if m.group(1).count("(") >= m.group(1).count(")")
        else f"return success({m.group(1)});",
        text,
    )
    if text != orig:
        path.write_text(text, encoding="utf-8")
        return True
    return False


def fix_xml():
    xml_dir = Path(r"e:\wms\ruoyi-vue-pro\yudao-module-yms\src\main\resources\mapper\yms")
    if not xml_dir.exists():
        return
    for p in xml_dir.glob("*.xml"):
        t = p.read_text(encoding="utf-8")
        t2 = t.replace("org.dromara.yms", "cn.iocoder.yudao.module.yms")
        if t2 != t:
            p.write_text(t2, encoding="utf-8")


count = 0
for p in ROOT.rglob("*.java"):
    if fix_file(p):
        count += 1
fix_xml()
print(f"fixed {count} java files")
