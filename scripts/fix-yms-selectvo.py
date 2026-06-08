# -*- coding: utf-8 -*-
import re
from pathlib import Path

ROOT = Path(r"e:\wms\ruoyi-vue-pro\yudao-module-yms\src\main\java\cn\iocoder\yudao\module\yms\service")
MAPPING = {
    "yardTaskMapper": "YmsYardTaskRespVO",
    "baseMapper": None,
    "checkInMapper": "YmsCheckInRespVO",
    "itemMapper": "YmsYardInventoryItemRespVO",
}

def infer_vo(text: str, mapper: str) -> str:
    if MAPPING.get(mapper):
        return MAPPING[mapper]
    if "YmsAppointmentServiceImpl" in str(text):
        return "YmsAppointmentRespVO"
    if "YmsYardgoServiceImpl" in str(text):
        return "YmsYardgoTaskRespVO"
    if "YmsTrailerResourceServiceImpl" in str(text):
        return "YmsTrailerResourceRespVO"
    if "YmsContainerResourceServiceImpl" in str(text):
        return "YmsContainerResourceRespVO"
    if "YmsSlotTemplateServiceImpl" in str(text):
        return "YmsSlotTemplateRespVO"
    if "YmsInternalTaskServiceImpl" in str(text):
        return "YmsInternalTaskRespVO"
    if "YmsBlacklistServiceImpl" in str(text):
        return "YmsBlacklistRespVO"
    if "YmsCallRuleServiceImpl" in str(text):
        return "YmsCallRuleRespVO"
    return "Object"

for f in ROOT.glob("*.java"):
    text = f.read_text(encoding="utf-8")
    if "selectVoById" not in text:
        continue
    if "import cn.iocoder.yudao.framework.common.util.object.BeanUtils;" not in text:
        text = text.replace(
            "package cn.iocoder.yudao.module.yms.service;\n",
            "package cn.iocoder.yudao.module.yms.service;\n\nimport cn.iocoder.yudao.framework.common.util.object.BeanUtils;\n",
        )

    def repl(m):
        mapper, arg = m.group(1), m.group(2)
        vo = infer_vo(f.name, mapper)
        if mapper == "baseMapper":
            # read return type from method signature above - use file-specific
            vo = infer_vo(f.name, mapper)
        return f"return BeanUtils.toBean({mapper}.selectById({arg}), {vo}.class)"

    text2 = re.sub(r"return\s+(\w+)\.selectVoById\(([^)]+)\)\s*;", repl, text)
    # assignment pattern
    text2 = re.sub(
        r"(\w+RespVO\s+\w+\s*=\s*)(\w+)\.selectVoById\(([^)]+)\)\s*;",
        lambda m: f"{m.group(1)}BeanUtils.toBean({m.group(2)}.selectById({m.group(3)}), {infer_vo(f.name, m.group(2))}.class);",
        text2,
    )
    f.write_text(text2, encoding="utf-8")
    print("fixed", f.name)
