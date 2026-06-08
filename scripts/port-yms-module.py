# -*- coding: utf-8 -*-
"""Port ruoyi-yms reference to yudao-module-yms with Yudao conventions."""
import os
import re
import shutil
from pathlib import Path

REF_JAVA = Path(r"e:\WMSProject\overallSystem\WMSRuoYi-Vue-Plus\ruoyi-modules\ruoyi-yms\src\main\java\org\dromara\yms")
REF_XML = Path(r"e:\WMSProject\overallSystem\WMSRuoYi-Vue-Plus\ruoyi-modules\ruoyi-yms\src\main\resources\mapper\yms")
DST_JAVA = Path(r"e:\wms\ruoyi-vue-pro\yudao-module-yms\src\main\java\cn\iocoder\yudao\module\yms")
DST_XML = Path(r"e:\wms\ruoyi-vue-pro\yudao-module-yms\src\main\resources\mapper\yms")
DST_BASE_JAVA = Path(r"e:\wms\ruoyi-vue-pro\yudao-module-base\src\main\java\cn\iocoder\yudao\module\base")

ENTITY_NAMES = set()


def list_java_files(root: Path):
    for p in root.rglob("*.java"):
        yield p


def rel_under_yms(p: Path) -> Path:
    return p.relative_to(REF_JAVA)


def target_java_path(rel: Path) -> Path:
    parts = list(rel.parts)
    name = parts[-1]
    if parts[0] == "domain" and len(parts) == 2 and parts[1].endswith(".java") and parts[1] not in ("bo", "vo"):
        # domain entity -> dal/dataobject
        entity = name.replace(".java", "")
        if not entity.endswith("DO"):
            ENTITY_NAMES.add(entity)
        do_name = entity if entity.endswith("DO") else entity + "DO"
        return DST_JAVA / "dal" / "dataobject" / f"{do_name}.java"
    if parts[0] == "domain" and parts[1] in ("bo", "vo"):
        sub = "vo"
        vo_name = name.replace("Bo.java", "ReqVO.java").replace("Vo.java", "RespVO.java")
        return DST_JAVA / "controller" / "admin" / sub / vo_name
    if parts[0] == "mapper":
        mapper_name = name
        return DST_JAVA / "dal" / "mysql" / mapper_name
    if parts[0] == "service" and parts[1] == "impl":
        return DST_JAVA / "service" / name
    if parts[0] == "service":
        iface = name.replace("I", "", 1) if name.startswith("IYms") else name
        return DST_JAVA / "service" / iface
    if parts[0] == "controller":
        if name == "YmsPublicController.java":
            return DST_JAVA / "controller" / "app" / "YmsPublicController.java"
        return DST_JAVA / "controller" / "admin" / name
    if parts[0] in ("integration", "support"):
        return DST_JAVA / parts[0] / name
    return DST_JAVA / Path(*parts)


def transform_content(text: str, src_rel: Path) -> str:
    text = text.replace("org.dromara.yms", "cn.iocoder.yudao.module.yms")
    text = text.replace("org.dromara.base.domain.YardDock", "cn.iocoder.yudao.module.base.dal.dataobject.yarddock.YardDockDO")
    text = text.replace("org.dromara.base.mapper.YardDockMapper", "cn.iocoder.yudao.module.base.dal.mysql.yarddock.YardDockMapper")
    text = text.replace("org.dromara.common.core.exception.ServiceException", "cn.iocoder.yudao.framework.common.exception.ServiceException")
    text = text.replace("org.dromara.common.core.utils.MapstructUtils", "cn.iocoder.yudao.framework.common.util.object.BeanUtils")
    text = text.replace("MapstructUtils.convert", "BeanUtils.toBean")
    text = text.replace("org.dromara.common.mybatis.core.page.TableDataInfo", "cn.iocoder.yudao.framework.common.pojo.PageResult")
    text = text.replace("org.dromara.common.mybatis.core.page.PageQuery", "cn.iocoder.yudao.framework.common.pojo.PageParam")
    text = text.replace("org.dromara.common.core.domain.R", "cn.iocoder.yudao.framework.common.pojo.CommonResult")
    text = text.replace("org.dromara.common.web.core.BaseController", "java.lang.Object")
    text = text.replace("org.dromara.common.tenant.helper.TenantHelper", "cn.iocoder.yudao.framework.tenant.core.util.TenantUtils")
    text = text.replace("TenantHelper.dynamic", "TenantUtils.execute")
    text = text.replace("R.ok(", "CommonResult.success(")
    text = text.replace("return R.ok", "return CommonResult.success")
    text = text.replace("cn.dev33.satoken.annotation.SaCheckPermission", "org.springframework.security.access.prepost.PreAuthorize")
    text = re.sub(
        r'@SaCheckPermission\("([^"]+)"\)',
        r'@PreAuthorize("@ss.hasPermission(\'\1\')")',
        text,
    )
    text = text.replace("cn.dev33.satoken.annotation.SaIgnore", "jakarta.annotation.security.PermitAll")
    text = text.replace("@SaIgnore", "@PermitAll")
    text = text.replace("org.dromara.common.idempotent.annotation.RepeatSubmit", "")
    text = re.sub(r"\s*@RepeatSubmit\s*\n", "\n", text)
    text = re.sub(r"\s*// @Log\([^\n]+\n", "\n", text)
    text = re.sub(r"import org\.dromara\.common\.(idempotent|log)[^\n]+\n", "", text)
    text = text.replace("import lombok.RequiredArgsConstructor;", "import jakarta.annotation.Resource;")
    text = text.replace("@RequiredArgsConstructor", "")
    text = text.replace("private final ", "@Resource\n    private ")
    text = re.sub(
        r"return TableDataInfo\.build\(([^)]+)\);",
        r"return new PageResult<>(\1.getRecords(), \1.getTotal());",
        text,
    )
    text = text.replace("TableDataInfo.build(", "/*TableDataInfo.build*/")

    # Entity renames in types
    for ent in sorted(ENTITY_NAMES, key=len, reverse=True):
        if ent.endswith("DO"):
            continue
        text = re.sub(rf"\b{ent}\b", f"{ent}DO", text)

    # Bo/Vo renames
    text = re.sub(r"\b(Yms\w+)Bo\b", r"\1ReqVO", text)
    text = re.sub(r"\b(Yms\w+)Vo\b", r"\1RespVO", text)
    text = re.sub(r"domain\.bo", "controller.admin.vo", text)
    text = re.sub(r"domain\.vo", "controller.admin.vo", text)

    # Service interface IYms -> Yms
    text = re.sub(r"\bIYms(\w+)Service\b", r"Yms\1Service", text)

    # Package imports for relocated types
    text = text.replace("cn.iocoder.yudao.module.yms.domain.", "cn.iocoder.yudao.module.yms.dal.dataobject.")
    text = text.replace("cn.iocoder.yudao.module.yms.mapper.", "cn.iocoder.yudao.module.yms.dal.mysql.")
    text = text.replace("cn.iocoder.yudao.module.yms.dal.dataobject.bo", "cn.iocoder.yudao.module.yms.controller.admin.vo")
    text = text.replace("cn.iocoder.yudao.module.yms.dal.dataobject.vo", "cn.iocoder.yudao.module.yms.controller.admin.vo")

    # Mapper extends BaseMapperX
    if "interface Yms" in text and "Mapper" in text and src_rel.parts[0] == "mapper":
        text = text.replace("import com.baomidou.mybatisplus.core.mapper.BaseMapper;",
                            "import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;\n")
        text = re.sub(r"extends BaseMapper<(\w+)>", r"extends BaseMapperX<\1>", text)
        text = re.sub(r"extends BaseMapperX<(\w+)DO>", r"extends BaseMapperX<\1DO>", text)

    # Entity file body transform
    if src_rel.parts[0] == "domain" and len(src_rel.parts) == 2 and src_rel.parts[1] not in ("bo", "vo"):
        ent = src_rel.stem
        do = ent + "DO"
        text = re.sub(rf"public class {ent}\b", f"public class {do}", text)
        text = re.sub(rf"@AutoMapper[^)]+\)\s*\n", "", text)
        text = re.sub(r"import io\.github\.linpeilie\.annotations\.AutoMapper;\s*\n", "", text)
        text = re.sub(r"import org\.dromara\.common\.tenant\.core\.TenantEntity;\s*\n",
                      "import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;\n", text)
        text = re.sub(r"extends TenantEntity", "extends TenantBaseDO", text)
        text = re.sub(r"@TableLogic\s+private (Integer|Long) deleted;\s*\n", "", text)
        text = re.sub(r"private Long delFlag;\s*\n", "", text)
        text = re.sub(r"@Serial\s+private static final long serialVersionUID = 1L;\s*\n", "", text)
        text = re.sub(r"import java\.io\.Serial;\s*\n", "", text)
        if "TenantBaseDO" not in text:
            text = text.replace("import lombok.Data;",
                                "import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;\nimport lombok.Data;\nimport lombok.EqualsAndHashCode;")
        if "@EqualsAndHashCode" not in text:
            text = text.replace("@Data\n", "@Data\n@EqualsAndHashCode(callSuper = true)\n")

    # Controller return types
    if "Controller" in src_rel.name:
        text = text.replace("extends BaseController", "")
        text = text.replace("return toAjax(", "return CommonResult.success(")
        text = text.replace("public TableDataInfo<", "public PageResult<")
        text = text.replace("public R<", "public CommonResult<")
        text = text.replace("import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;",
                            "import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;\n")
        if "import static" not in text and "CommonResult.success" in text:
            text = text.replace(
                "import cn.iocoder.yudao.framework.common.pojo.CommonResult;",
                "import cn.iocoder.yudao.framework.common.pojo.CommonResult;\n\nimport static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;",
            )
        text = text.replace("@RequestMapping(\"/yms/", '@RequestMapping("/yms/')

    # PageQuery -> PageParam in method signatures
    text = text.replace("PageQuery pageQuery", "PageParam pageParam")
    text = text.replace("pageQuery.build()", "pageParam")
    text = text.replace(", pageQuery)", ", pageParam)")
    text = text.replace("pageQuery)", "pageParam)")

    # ServiceExceptionUtil for services
    if "ServiceImpl" in src_rel.name:
        if "ServiceExceptionUtil" not in text and "throw new ServiceException" in text:
            pass  # keep ServiceException for now - yudao has same class

    return text


def fix_sa_permission(text: str) -> str:
    """Fix @PreAuthorize quoting from SaCheckPermission migration."""
    def repl(m):
        perm = m.group(1)
        return f'@PreAuthorize("@ss.hasPermission(\'{perm}\')")'
    return re.sub(r'@PreAuthorize\("@ss\.hasPermission\(([^)]+)\)"\)', repl, text)


def port_java():
    for src in list_java_files(REF_JAVA):
        rel = rel_under_yms(src)
        if rel.parts[0] == "domain" and len(rel.parts) == 2 and rel.parts[1] not in ("bo", "vo"):
            ENTITY_NAMES.add(rel.stem)
    for src in list_java_files(REF_JAVA):
        rel = rel_under_yms(src)
        dst = target_java_path(rel)
        dst.parent.mkdir(parents=True, exist_ok=True)
        content = src.read_text(encoding="utf-8")
        content = transform_content(content, rel)
        content = fix_sa_permission(content)
        dst.write_text(content, encoding="utf-8")
        print("java", dst.relative_to(DST_JAVA.parent.parent.parent))


def port_xml():
    if not REF_XML.exists():
        return
    for src in REF_XML.glob("*.xml"):
        dst = DST_XML / src.name
        dst.parent.mkdir(parents=True, exist_ok=True)
        content = src.read_text(encoding="utf-8")
        content = content.replace("org.dromara.yms", "cn.iocoder.yudao.module.yms")
        content = content.replace("org.dromara.yms.domain.vo", "cn.iocoder.yudao.module.yms.controller.admin.vo")
        content = content.replace("org.dromara.yms.domain.bo", "cn.iocoder.yudao.module.yms.controller.admin.vo")
        for ent in sorted(ENTITY_NAMES, key=len, reverse=True):
            content = re.sub(rf"org\.dromara\.yms\.domain\.{ent}\b", f"cn.iocoder.yudao.module.yms.dal.dataobject.{ent}DO", content)
            content = content.replace(f"domain.{ent}", f"dal.dataobject.{ent}DO")
        content = re.sub(r"domain\.vo\.(Yms\w+)Vo", r"controller.admin.vo.\1RespVO", content)
        content = re.sub(r"resultType=\"org\.dromara\.yms\.domain\.vo\.(\w+)Vo\"",
                         r'resultType="cn.iocoder.yudao.module.yms.controller.admin.vo.\1RespVO"', content)
        dst.write_text(content, encoding="utf-8")
        print("xml", dst.name)


def write_yard_dock():
    """Skip if base module already has YardDock."""
    if (DST_BASE_JAVA / "dal" / "dataobject" / "yarddock" / "YardDockDO.java").exists():
        print("base YardDock already exists, skip")
        return
    do_path = DST_BASE_JAVA / "dal" / "dataobject" / "yarddock" / "YardDockDO.java"
    mapper_path = DST_BASE_JAVA / "dal" / "mysql" / "yarddock" / "YardDockMapper.java"
    do_path.parent.mkdir(parents=True, exist_ok=True)
    do_path.write_text('''package cn.iocoder.yudao.module.base.dal.dataobject.yarddock;

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

@TableName("yard_dock")
@Data
@EqualsAndHashCode(callSuper = true)
public class YardDockDO extends TenantBaseDO {

    @TableId
    private Long id;
    private String dockCode;
    private String dockName;
    private String locationType;
    private Long warehouseId;
    private String warehouseCode;
    private String warehouseName;
    private Long zoneId;
    private String zoneCode;
    private Long businessTypeId;
    private String businessTypeCode;
    private String businessTypeName;
    private String dockLocation;
    private Integer gridRow;
    private Integer gridCol;
    private String allowedVehicleTypes;
    private Integer appointmentSupported;
    private Integer maxConcurrent;
    private String dockStatus;
    private String occupiedObjectType;
    private Long occupiedObjectId;
    private String occupiedObjectNo;
    private LocalDateTime occupiedSince;
    private Integer enabledFlag;
    private Integer sortOrder;
    private Integer dispatchPriority;
    private String dockType;
    private Integer enableQueue;
    private Integer maxQueueCount;
    private String remark;
}
''', encoding="utf-8")
    mapper_path.write_text('''package cn.iocoder.yudao.module.base.dal.mysql.yarddock;

import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.module.base.dal.dataobject.yarddock.YardDockDO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface YardDockMapper extends BaseMapperX<YardDockDO> {
}
''', encoding="utf-8")
    print("base YardDockDO + Mapper")


if __name__ == "__main__":
    if DST_JAVA.exists():
        shutil.rmtree(DST_JAVA)
    port_java()
    port_xml()
    write_yard_dock()
    print("DONE")
