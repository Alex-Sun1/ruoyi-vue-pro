from pathlib import Path

DIR = Path(r"e:\wms\ruoyi-vue-pro\yudao-module-yms\src\main\java\cn\iocoder\yudao\module\yms\dal\mysql")
for f in DIR.glob("*.java"):
    t = f.read_text(encoding="utf-8")
    t = t.replace("`n", "\n")
    t = t.replace("package cn.iocoder.yudao.module.yms.mapper;", "package cn.iocoder.yudao.module.yms.dal.mysql;")
    if "@Mapper" in t and "import org.apache.ibatis.annotations.Mapper;" not in t:
        t = t.replace(
            "package cn.iocoder.yudao.module.yms.dal.mysql;\n",
            "package cn.iocoder.yudao.module.yms.dal.mysql;\n\n"
            "import org.apache.ibatis.annotations.Mapper;\n"
            "import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;\n",
            1,
        )
    f.write_text(t, encoding="utf-8")
print("done")
