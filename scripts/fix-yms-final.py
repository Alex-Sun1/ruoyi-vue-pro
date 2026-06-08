# -*- coding: utf-8 -*-
"""Final YMS module compile fixes."""
from pathlib import Path
import re

ROOT = Path(r"e:\wms\ruoyi-vue-pro\yudao-module-yms")
JAVA = ROOT / "src" / "main" / "java"
XML = ROOT / "src" / "main" / "resources" / "mapper" / "yms"
VO_DIR = JAVA / "cn" / "iocoder" / "yudao" / "module" / "yms" / "controller" / "admin" / "vo"

REPLACEMENTS = [
    ("package cn.iocoder.yudao.module.yms.service.impl;", "package cn.iocoder.yudao.module.yms.service;"),
    ("cn.iocoder.yudao.module.yms.domain.", "cn.iocoder.yudao.module.yms.dal.dataobject."),
    ("cn.iocoder.yudao.module.yms.mapper.", "cn.iocoder.yudao.module.yms.dal.mysql."),
    ("org.dromara.yms.domain.", "cn.iocoder.yudao.module.yms.dal.dataobject."),
    ("org.dromara.yms.mapper.", "cn.iocoder.yudao.module.yms.dal.mysql."),
    ("TableDataInfo<", "PageResult<"),
    ("import org.dromara.common.mybatis.core.page.TableDataInfo;", ""),
    ("import com.baomidou.mybatisplus.core.mapper.BaseMapperPlus;", ""),
    ("extends BaseMapperPlus<", "extends BaseMapperX<"),
    ("BaseMapperPlus<", "BaseMapperX<"),
    (", Yms", ", "),  # fix accidental BaseMapperX<DO, VO> -> need careful
]

# Fix mapper extends: BaseMapperX<DO, RespVO> -> BaseMapperX<DO>
MAPPER_EXT_RE = re.compile(
    r"extends BaseMapperX<([^,>]+),\s*[^>]+>"
)

def patch_file(path: Path, text: str) -> str:
    if path.suffix == ".xml":
        text = text.replace("cn.iocoder.yudao.module.yms.mapper.", "cn.iocoder.yudao.module.yms.dal.mysql.")
        return text
    for old, new in REPLACEMENTS:
        if old == ", Yms":
            continue
        text = text.replace(old, new)
    text = MAPPER_EXT_RE.sub(r"extends BaseMapperX<\1>", text)
    if "dal/mysql" in str(path).replace("\\", "/") or path.name.endswith("Mapper.java"):
        if "@Mapper" not in text and "interface " in text and "Mapper" in path.name:
            text = text.replace(
                "package cn.iocoder.yudao.module.yms.dal.mysql;",
                "package cn.iocoder.yudao.module.yms.dal.mysql;\n\nimport org.apache.ibatis.annotations.Mapper;\nimport cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;",
            )
            text = text.replace("public interface", "@Mapper\npublic interface", 1)
    return text

def fix_query_vo(path: Path, text: str) -> str:
    if not path.name.endswith("QueryReqVO.java"):
        return text
    text = re.sub(
        r"public class (\w+) extends BaseEntity",
        r"public class \1 extends PageParam",
        text,
    )
    if "PageParam" in text and "import cn.iocoder.yudao.framework.common.pojo.PageParam" not in text:
        text = text.replace(
            "package cn.iocoder.yudao.module.yms.controller.admin.vo;\n",
            "package cn.iocoder.yudao.module.yms.controller.admin.vo;\n\nimport cn.iocoder.yudao.framework.common.pojo.PageParam;\n",
        )
    text = text.replace("import lombok.EqualsAndHashCode;\n", "")
    text = text.replace("@EqualsAndHashCode(callSuper = true)\n", "")
    return text

def fix_vo_automapper(path: Path, text: str) -> str:
    if path.parent != VO_DIR:
        return text
    lines = [ln for ln in text.splitlines(True) if "linpeilie" not in ln and "@AutoMapper" not in ln]
    return "".join(lines)

def fix_serializable_do(path: Path, text: str) -> str:
    if "implements Serializable" in text and "@EqualsAndHashCode(callSuper = true)" in text:
        text = text.replace("@EqualsAndHashCode(callSuper = true)", "@EqualsAndHashCode(callSuper = false)")
    if "implements Serializable" in text:
        text = text.replace("import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;\n", "")
    return text

def fix_select_page_list_calls(text: str) -> str:
    # baseMapper.selectPageList(pageParam, bo) -> selectPageList(YmsPageUtils.toPage(pageParam), bo)
    return re.sub(
        r"(\w+Mapper)\.selectPageList\(\s*pageParam\s*,",
        r"\1.selectPageList(YmsPageUtils.toPage(pageParam),",
        text,
    )

def fix_select_vo_by_id(text: str) -> str:
    # Simple pattern: return baseMapper.selectVoById(id);
    def repl(m):
        mapper, idvar = m.group(1), m.group(2)
        return f"return cn.iocoder.yudao.framework.common.util.object.BeanUtils.toBean({mapper}.selectById({idvar}), "
    # Too risky globally - skip
    return text

def main():
    for path in list(JAVA.rglob("*.java")) + list(XML.glob("*.xml")):
        text = path.read_text(encoding="utf-8")
        orig = text
        text = patch_file(path, text)
        if path.parent == VO_DIR or path.name.endswith("QueryReqVO.java"):
            text = fix_query_vo(path, text)
        if path.parent == VO_DIR:
            text = fix_vo_automapper(path, text)
        if "dal/dataobject" in str(path).replace("\\", "/"):
            text = fix_serializable_do(path, text)
        if "service" in str(path).replace("\\", "/") and path.suffix == ".java":
            text = fix_select_page_list_calls(text)
            if "YmsPageUtils" in text and "import cn.iocoder.yudao.module.yms.util.YmsPageUtils" not in text:
                if "package cn.iocoder.yudao.module.yms.service;" in text:
                    text = text.replace(
                        "package cn.iocoder.yudao.module.yms.service;\n",
                        "package cn.iocoder.yudao.module.yms.service;\n\nimport cn.iocoder.yudao.module.yms.util.YmsPageUtils;\n",
                    )
        if text != orig:
            path.write_text(text, encoding="utf-8")
            print("patched", path.relative_to(ROOT))

if __name__ == "__main__":
    main()
