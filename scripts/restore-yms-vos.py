# -*- coding: utf-8 -*-
"""Restore YMS VO files from reference with UTF-8 and Yudao naming."""
from pathlib import Path
import re

REF = Path(r"e:\WMSProject\overallSystem\WMSRuoYi-Vue-Plus\ruoyi-modules\ruoyi-yms\src\main\java\org\dromara\yms\domain")
OUT = Path(r"e:\wms\ruoyi-vue-pro\yudao-module-yms\src\main\java\cn\iocoder\yudao\module\yms\controller\admin\vo")

NAME_MAP = {
    "Bo": "ReqVO",
    "Vo": "RespVO",
    "QueryBo": "QueryReqVO",
    "AddBo": "AddReqVO",
    "EditBo": "EditReqVO",
}

def convert_name(name: str) -> str:
    for old, new in NAME_MAP.items():
        if name.endswith(old):
            return "Yms" + name[3:-len(old)] + new if name.startswith("Yms") else name.replace(old, new)
    return name

def transform(content: str, fname: str) -> str:
    pkg = "package cn.iocoder.yudao.module.yms.controller.admin.vo;"
    content = re.sub(r"package\s+org\.dromara\.yms\.domain\.(bo|vo);", pkg, content)
    content = re.sub(r"import org\.dromara\.yms\.domain\.(\w+);",
                     lambda m: f"import cn.iocoder.yudao.module.yms.dal.dataobject.{m.group(1)}DO;",
                     content)
    content = re.sub(r"import org\.dromara\.yms\.domain\.bo\.(\w+);",
                     lambda m: f"import cn.iocoder.yudao.module.yms.controller.admin.vo.{convert_name(m.group(1))};",
                     content)
    content = re.sub(r"import org\.dromara\.yms\.domain\.vo\.(\w+);",
                     lambda m: f"import cn.iocoder.yudao.module.yms.controller.admin.vo.{convert_name(m.group(1))};",
                     content)
    content = re.sub(r"import io\.github\.linpeilie\.annotations\.AutoMapper;\n", "", content)
    content = re.sub(r"@AutoMapper\([^\)]+\)\n", "", content)
    content = re.sub(r"import org\.dromara\.common\.mybatis\.core\.domain\.BaseEntity;\n",
                     "import cn.iocoder.yudao.framework.common.pojo.PageParam;\n", content)
    content = re.sub(r"extends BaseEntity", "extends PageParam", content)
    content = re.sub(r"org\.dromara\.yms\.domain\.(\w+)(?!DO)", r"cn.iocoder.yudao.module.yms.dal.dataobject.\1DO", content)
    # class renames in file
    base = fname.replace(".java", "")
    for old, new in NAME_MAP.items():
        if base.endswith(old.replace("Bo", "").replace("Vo", "")) or True:
            pass
    for pat, repl in [
        (r"class (Yms\w+)QueryBo\b", r"class \1QueryReqVO"),
        (r"class (Yms\w+)AddBo\b", r"class \1AddReqVO"),
        (r"class (Yms\w+)EditBo\b", r"class \1EditReqVO"),
        (r"class (Yms\w+)Vo\b", r"class \1RespVO"),
        (r"class (Yms\w+)Bo\b", r"class \1ReqVO"),
    ]:
        content = re.sub(pat, repl, content)
    return content

def main():
    OUT.mkdir(parents=True, exist_ok=True)
    for sub in ("bo", "vo"):
        src_dir = REF / sub
        if not src_dir.exists():
            continue
        for f in src_dir.glob("*.java"):
            text = f.read_text(encoding="utf-8")
            out_name = f.name.replace("QueryBo", "QueryReqVO").replace("AddBo", "AddReqVO").replace("EditBo", "EditReqVO")
            out_name = out_name.replace("Vo.java", "RespVO.java").replace("Bo.java", "ReqVO.java")
            out = OUT / out_name
            out.write_text(transform(text, out_name), encoding="utf-8")
            print("restored", out_name)

if __name__ == "__main__":
    main()
