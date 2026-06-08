# -*- coding: utf-8 -*-
import re
from pathlib import Path

ROOT = Path(r"e:\wms\ruoyi-vue-pro\yudao-module-yms\src\main\java\cn\iocoder\yudao\module\yms")


def fix_file(path: Path):
    text = path.read_text(encoding="utf-8")
    orig = text

    text = text.replace("/*PageResult.build*/", "")
    text = text.replace("/*TableDataInfo.build*/", "")
    text = re.sub(r"selectVoById\(([^)]+)\)\)", r"selectVoById(\1)", text)
    text = re.sub(r"queryById\(([^)]+)\)\)", r"queryById(\1)", text)

    # return mapper.selectPageList(...) -> PageResult wrapper
    def page_list_repl(m):
        expr = m.group(1)
        return (
            f"Page<?> page = {expr};\n"
            f"        return new PageResult<>(page.getRecords(), page.getTotal());"
        )

    text = re.sub(
        r"return (\w+Mapper\.selectPageList\(pageParam, \w+\));",
        page_list_repl,
        text,
    )
    text = re.sub(
        r"return (\w+Mapper\.selectInYardPageList\(pageParam, \w+\));",
        page_list_repl,
        text,
    )

    if "Page<?>" in text and "import com.baomidou.mybatisplus.extension.plugins.pagination.Page;" not in text:
        text = text.replace(
            "import com.baomidou.mybatisplus.core.toolkit.Wrappers;",
            "import com.baomidou.mybatisplus.core.toolkit.Wrappers;\nimport com.baomidou.mybatisplus.extension.plugins.pagination.Page;",
            1,
        )

    # YardDock type in dispatch
    text = text.replace("LambdaQueryWrapper<YardDock>", "LambdaQueryWrapper<YardDockDO>")
    text = text.replace("YardDock::", "YardDockDO::")
    text = text.replace("List<YardDock>", "List<YardDockDO>")
    text = text.replace("YardDock dock", "YardDockDO dock")
    text = text.replace("YardDock slot", "YardDockDO slot")
    text = text.replace("YardDock position", "YardDockDO position")
    text = text.replace("YardDock location", "YardDockDO location")
    if "YardDockDO" in text and "YardDockMapper" in text and "YardDockDO" not in text.split("import")[0]:
        if "import cn.iocoder.yudao.module.base.dal.dataobject.yarddock.YardDockDO;" not in text:
            text = text.replace(
                "import cn.iocoder.yudao.module.base.dal.mysql.yarddock.YardDockMapper;",
                "import cn.iocoder.yudao.module.base.dal.dataobject.yarddock.YardDockDO;\n"
                "import cn.iocoder.yudao.module.base.dal.mysql.yarddock.YardDockMapper;",
            )

    if text != orig:
        path.write_text(text, encoding="utf-8")
        return True
    return False


n = sum(1 for p in ROOT.rglob("*.java") if fix_file(p))
print(f"pass3 fixed {n}")
