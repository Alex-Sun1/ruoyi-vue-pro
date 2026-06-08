# -*- coding: utf-8 -*-
import re
from pathlib import Path

REF = Path(r"e:\WMSProject\overallSystem\WMSRuoYi-Vue-Plus\ruoyi-modules\ruoyi-yms\src\main\java\org\dromara\yms\controller")
ADMIN_DST = Path(r"e:\wms\ruoyi-vue-pro\yudao-module-yms\src\main\java\cn\iocoder\yudao\module\yms\controller\admin")
APP_DST = Path(r"e:\wms\ruoyi-vue-pro\yudao-module-yms\src\main\java\cn\iocoder\yudao\module\yms\controller\app")


def transform(text: str) -> str:
    text = text.replace("package org.dromara.yms.controller", "package cn.iocoder.yudao.module.yms.controller.admin")
    text = text.replace("org.dromara.yms", "cn.iocoder.yudao.module.yms")
    text = text.replace("org.dromara.common.core.domain.R", "cn.iocoder.yudao.framework.common.pojo.CommonResult")
    text = text.replace("org.dromara.common.mybatis.core.page.TableDataInfo", "cn.iocoder.yudao.framework.common.pojo.PageResult")
    text = text.replace("org.dromara.common.mybatis.core.page.PageQuery", "cn.iocoder.yudao.framework.common.pojo.PageParam")
    text = text.replace("org.dromara.common.web.core.BaseController", "")
    text = text.replace("cn.dev33.satoken.annotation.SaCheckPermission", "org.springframework.security.access.prepost.PreAuthorize")
    text = re.sub(r'@SaCheckPermission\("([^"]+)"\)', r'@PreAuthorize("@ss.hasPermission(\'\1\')")', text)
    text = text.replace("cn.dev33.satoken.annotation.SaIgnore", "jakarta.annotation.security.PermitAll")
    text = text.replace("@SaIgnore", "@PermitAll")
    text = text.replace("org.dromara.common.tenant.helper.TenantHelper", "cn.iocoder.yudao.framework.tenant.core.util.TenantUtils")
    text = text.replace("TenantHelper.dynamic", "TenantUtils.execute")
    text = text.replace("R.ok(", "success(")
    text = text.replace("return R.ok", "return success")
    text = re.sub(r"\bIYms(\w+)Service\b", r"Yms\1Service", text)
    text = re.sub(r"\b(Yms\w+)Bo\b", r"\1ReqVO", text)
    text = re.sub(r"\b(Yms\w+)Vo\b", r"\1RespVO", text)
    text = text.replace("domain.bo", "controller.admin.vo")
    text = text.replace("domain.vo", "controller.admin.vo")
    text = text.replace("extends BaseController", "")
    text = text.replace("return toAjax(", "return success(")
    text = text.replace("public TableDataInfo<", "public PageResult<")
    text = text.replace("public R<", "public CommonResult<")
    text = text.replace("import lombok.RequiredArgsConstructor;", "import jakarta.annotation.Resource;")
    text = text.replace("@RequiredArgsConstructor", "")
    text = text.replace("private final ", "@Resource\n    private ")
    text = text.replace("PageQuery pageQuery", "PageParam pageParam")
    text = text.replace("pageQuery", "pageParam")
    if "success(" in text and "import static" not in text:
        text = text.replace(
            "import cn.iocoder.yudao.framework.common.pojo.CommonResult;",
            "import cn.iocoder.yudao.framework.common.pojo.CommonResult;\n\nimport static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;",
        )
    # Public tenant execute
    text = re.sub(
        r"TenantUtils\.execute\(bo\.getTenantId\(\)",
        "TenantUtils.execute(Long.valueOf(bo.getTenantId())",
        text,
    )
    text = re.sub(
        r"TenantUtils\.execute\(tenantId,",
        "TenantUtils.execute(Long.valueOf(tenantId),",
        text,
    )
    text = re.sub(
        r"TenantUtils\.execute\([^,]+,\s*\(\)\s*->\s*success\(",
        lambda m: m.group(0),  # keep
        text,
    )
    # Fix public controller tenant wrapper
    text = text.replace(
        "() -> success(gateService.",
        "() -> gateService.",
    )
    text = text.replace(
        "return TenantUtils.execute(Long.valueOf(bo.getTenantId()), () -> gateService.",
        "return success(TenantUtils.execute(Long.valueOf(bo.getTenantId()), () -> gateService.",
    )
    text = text.replace(
        "return TenantUtils.execute(Long.valueOf(tenantId), () -> gateService.",
        "return success(TenantUtils.execute(Long.valueOf(tenantId), () -> gateService.",
    )
    # close success for tenant execute - add )) at end of return lines
    text = re.sub(
        r"return success\(TenantUtils\.execute\(([^)]+)\), \(\) -> ([^;]+);",
        r"return success(TenantUtils.execute(\1, () -> \2));",
        text,
    )
    return text


for src in REF.glob("*.java"):
    if src.name == "YmsPublicController.java":
        dst = APP_DST / src.name
        t = transform(src.read_text(encoding="utf-8"))
        t = t.replace("controller.admin", "controller.app")
    else:
        dst = ADMIN_DST / src.name
        t = transform(src.read_text(encoding="utf-8"))
    dst.parent.mkdir(parents=True, exist_ok=True)
    dst.write_text(t, encoding="utf-8")
    print(dst)
