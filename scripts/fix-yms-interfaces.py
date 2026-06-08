# -*- coding: utf-8 -*-
import re
from pathlib import Path

SVC = Path(r"e:\wms\ruoyi-vue-pro\yudao-module-yms\src\main\java\cn\iocoder\yudao\module\yms\service")

for p in list(SVC.glob("IYms*.java")):
    text = p.read_text(encoding="utf-8")
    text = text.replace("package cn.iocoder.yudao.module.yms.service;", "package cn.iocoder.yudao.module.yms.service;")
    text = text.replace("org.dromara.yms", "cn.iocoder.yudao.module.yms")
    text = text.replace("org.dromara.common.mybatis.core.page.TableDataInfo", "cn.iocoder.yudao.framework.common.pojo.PageResult")
    text = text.replace("org.dromara.common.mybatis.core.page.PageQuery", "cn.iocoder.yudao.framework.common.pojo.PageParam")
    text = re.sub(r"\binterface IYms(\w+)Service\b", r"interface Yms\1Service", text)
    text = re.sub(r"\bIYms(\w+)", r"Yms\1", text)
    text = re.sub(r"\b(Yms\w+)Bo\b", r"\1ReqVO", text)
    text = re.sub(r"\b(Yms\w+)Vo\b", r"\1RespVO", text)
    text = text.replace("PageQuery pageQuery", "PageParam pageParam")
    new_name = p.name.replace("IYms", "Yms")
    (SVC / new_name).write_text(text, encoding="utf-8")
    p.unlink()
    print("iface", new_name)

# Fix impl implements clause and return types
for p in SVC.glob("*ServiceImpl.java"):
    t = p.read_text(encoding="utf-8")
    t2 = t.replace("TableDataInfo<", "PageResult<")
    t2 = t2.replace("implements IYms", "implements Yms")
    if t2 != t:
        p.write_text(t2, encoding="utf-8")
