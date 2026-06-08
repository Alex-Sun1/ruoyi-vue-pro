# -*- coding: utf-8 -*-
"""Re-port service layer with minimal transforms to preserve business logic syntax."""
import re
from pathlib import Path

REF = Path(r"e:\WMSProject\overallSystem\WMSRuoYi-Vue-Plus\ruoyi-modules\ruoyi-yms\src\main\java\org\dromara\yms\service")
DST = Path(r"e:\wms\ruoyi-vue-pro\yudao-module-yms\src\main\java\cn\iocoder\yudao\module\yms\service")

ENTITIES = [
    "YmsYardTask", "YmsDockQueue", "YmsYardTaskLog", "YmsCheckIn", "YmsContainerResource",
    "YmsTrailerResource", "YmsInternalTask", "YmsAppointment", "YmsAppointmentRule",
    "YmsBlacklist", "YmsCallRule", "YmsCallRecord", "YmsException", "YmsSlotTemplate",
    "YmsWaitingPool", "YmsYardZone", "YmsYardPosition", "YmsYardInventoryTask",
    "YmsYardInventoryItem", "YmsYardgoTask",
]


def transform(text: str) -> str:
    text = text.replace("package org.dromara.yms.service", "package cn.iocoder.yudao.module.yms.service")
    text = text.replace("package org.dromara.yms.service.impl", "package cn.iocoder.yudao.module.yms.service")
    text = text.replace("org.dromara.yms", "cn.iocoder.yudao.module.yms")
    text = text.replace("org.dromara.base.domain.YardDock", "cn.iocoder.yudao.module.base.dal.dataobject.yarddock.YardDockDO")
    text = text.replace("org.dromara.base.mapper.YardDockMapper", "cn.iocoder.yudao.module.base.dal.mysql.yarddock.YardDockMapper")
    text = text.replace("org.dromara.common.core.exception.ServiceException",
                        "cn.iocoder.yudao.framework.common.exception.ServiceException")
    text = text.replace("org.dromara.common.core.utils.MapstructUtils",
                        "cn.iocoder.yudao.framework.common.util.object.BeanUtils")
    text = text.replace("MapstructUtils.convert", "BeanUtils.toBean")
    text = text.replace("org.dromara.common.mybatis.core.page.TableDataInfo",
                        "cn.iocoder.yudao.framework.common.pojo.PageResult")
    text = text.replace("org.dromara.common.mybatis.core.page.PageQuery",
                        "cn.iocoder.yudao.framework.common.pojo.PageParam")
    text = text.replace("TableDataInfo.build(", "YmsPageUtils.toPageResult(")
    text = text.replace("import lombok.RequiredArgsConstructor;", "import jakarta.annotation.Resource;")
    text = text.replace("@RequiredArgsConstructor", "")
    text = text.replace("private final ", "@Resource\n    private ")
    text = text.replace("org.dromara.yms.domain.", "cn.iocoder.yudao.module.yms.dal.dataobject.")
    text = text.replace("org.dromara.yms.mapper.", "cn.iocoder.yudao.module.yms.dal.mysql.")
    text = text.replace("cn.iocoder.yudao.module.yms.dal.dataobject.bo",
                        "cn.iocoder.yudao.module.yms.controller.admin.vo")
    text = text.replace("cn.iocoder.yudao.module.yms.dal.dataobject.vo",
                        "cn.iocoder.yudao.module.yms.controller.admin.vo")
    text = re.sub(r"\bIYms(\w+)Service\b", r"Yms\1Service", text)
    text = re.sub(r"\bIYms(\w+)", r"Yms\1", text)
    for ent in sorted(ENTITIES, key=len, reverse=True):
        text = re.sub(rf"\b{ent}\b", f"{ent}DO", text)
    text = re.sub(r"\b(Yms\w+)Bo\b", r"\1ReqVO", text)
    text = re.sub(r"\b(Yms\w+)Vo\b", r"\1RespVO", text)
    text = text.replace("LambdaQueryWrapper<YardDockDO>", "LambdaQueryWrapper<YardDockDO>")
    text = text.replace("YardDock ", "YardDockDO ")
    text = text.replace("YardDockDODO", "YardDockDO")
    if "YmsPageUtils" not in text and "toPageResult" in text:
        text = text.replace(
            "package cn.iocoder.yudao.module.yms.service;",
            "package cn.iocoder.yudao.module.yms.service;\n\nimport cn.iocoder.yudao.module.yms.util.YmsPageUtils;",
        )
    text = text.replace("PageQuery pageQuery", "PageParam pageParam")
    text = text.replace("pageQuery.build()", "pageParam")
    text = text.replace(", pageQuery)", ", pageParam)")
    return text


for src in REF.rglob("*.java"):
    rel = src.relative_to(REF)
    dst = DST / rel.name if rel.parent.name == "impl" else DST / rel.name
    dst.parent.mkdir(parents=True, exist_ok=True)
    dst.write_text(transform(src.read_text(encoding="utf-8")), encoding="utf-8")
    print("service", dst.name)
