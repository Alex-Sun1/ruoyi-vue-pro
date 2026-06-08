package cn.iocoder.yudao.module.base.service.packaging;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONUtil;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.base.controller.admin.packaging.vo.*;
import cn.iocoder.yudao.module.base.dal.dataobject.client.ClientDO;
import cn.iocoder.yudao.module.base.dal.dataobject.packaging.PackagingDO;
import cn.iocoder.yudao.module.base.dal.dataobject.warehouse.WarehouseDO;
import cn.iocoder.yudao.module.base.dal.mysql.client.BaseClientMapper;
import cn.iocoder.yudao.module.base.dal.mysql.packaging.PackagingMapper;
import cn.iocoder.yudao.module.base.dal.mysql.sku.SkuMapper;
import cn.iocoder.yudao.module.base.dal.mysql.warehouse.BaseWarehouseMapper;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.base.enums.ErrorCodeConstants.*;

@Service
@Validated
public class PackagingServiceImpl implements PackagingService {

    private static final int SOURCE_TYPE_CLIENT = 2;
    private static final Set<Integer> VALID_PKG_TYPES = Set.of(1, 2, 3, 4, 5);
    private static final Set<Integer> VALID_SOURCE_TYPES = Set.of(1, 2, 3);
    private static final Set<String> VALID_DIMENSION_UNITS = Set.of("CM", "IN");
    private static final Set<String> VALID_WEIGHT_UNITS = Set.of("KG", "LB");

    @Resource
    private PackagingMapper packagingMapper;
    @Resource
    private BaseClientMapper baseClientMapper;
    @Resource
    private BaseWarehouseMapper baseWarehouseMapper;
    @Resource
    private SkuMapper skuMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createPackaging(PackagingSaveReqVO createReqVO) {
        normalizeFields(createReqVO);
        validateBusiness(createReqVO);
        validateUnique(null, createReqVO.getPkgCode());
        if (createReqVO.getStatus() == null) {
            createReqVO.setStatus(CommonStatusEnum.ENABLE.getStatus());
        }
        if (createReqVO.getSortOrder() == null) {
            createReqVO.setSortOrder(0);
        }
        PackagingDO row = toDO(createReqVO);
        packagingMapper.insert(row);
        return row.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updatePackaging(PackagingSaveReqVO updateReqVO) {
        PackagingDO existing = validateExists(updateReqVO.getId());
        normalizeFields(updateReqVO);
        validateBusiness(updateReqVO);
        if (!Objects.equals(existing.getPkgCode(), updateReqVO.getPkgCode())) {
            throw exception(PACKAGING_CODE_NOT_MODIFIABLE);
        }
        updateReqVO.setPkgCode(existing.getPkgCode());
        PackagingDO updateObj = toDO(updateReqVO);
        updateObj.setStatus(existing.getStatus());
        if (updateReqVO.getSortOrder() == null) {
            updateObj.setSortOrder(existing.getSortOrder());
        }
        packagingMapper.updateById(updateObj);
    }

    @Override
    public void updatePackagingStatus(PackagingUpdateStatusReqVO reqVO) {
        validateExists(reqVO.getId());
        PackagingDO update = new PackagingDO();
        update.setId(reqVO.getId());
        update.setStatus(reqVO.getStatus());
        packagingMapper.updateById(update);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deletePackaging(Long id) {
        validateExists(id);
        if (skuMapper.selectCountByDefaultPkgId(id) > 0) {
            throw exception(PACKAGING_DELETE_HAS_REFERENCE);
        }
        packagingMapper.deleteById(id);
    }

    @Override
    public PackagingRespVO getPackaging(Long id) {
        PackagingDO row = validateExists(id);
        return buildRespVO(row, loadContext(Collections.singletonList(row)));
    }

    @Override
    public PageResult<PackagingRespVO> getPackagingPage(PackagingPageReqVO pageReqVO) {
        PageResult<PackagingDO> pageResult = packagingMapper.selectPage(pageReqVO);
        PackagingBuildContext ctx = loadContext(pageResult.getList());
        List<PackagingRespVO> list = pageResult.getList().stream()
                .map(row -> buildRespVO(row, ctx))
                .collect(Collectors.toList());
        return new PageResult<>(list, pageResult.getTotal());
    }

    @Override
    public List<PackagingRespVO> getPackagingSimpleList(Integer status) {
        List<PackagingDO> list = packagingMapper.selectSimpleList(status);
        return list.stream().map(row -> buildRespVO(row, PackagingBuildContext.empty())).collect(Collectors.toList());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public PackagingImportRespVO importPackagingList(List<PackagingImportExcelVO> importList, boolean updateSupport) {
        if (CollUtil.isEmpty(importList)) {
            throw exception(PACKAGING_IMPORT_LIST_IS_EMPTY);
        }
        PackagingImportRespVO resp = PackagingImportRespVO.builder()
                .createKeys(new ArrayList<>())
                .updateKeys(new ArrayList<>())
                .failureKeys(new LinkedHashMap<>())
                .build();
        AtomicInteger index = new AtomicInteger(1);
        for (PackagingImportExcelVO row : importList) {
            int line = index.getAndIncrement();
            String key = StrUtil.blankToDefault(row.getPkgCode(), "第" + line + "行");
            try {
                PackagingSaveReqVO saveReq = BeanUtils.toBean(row, PackagingSaveReqVO.class);
                saveReq.setStatus(CommonStatusEnum.ENABLE.getStatus());
                saveReq.setSourceType(row.getSourceType() != null ? row.getSourceType() : 1);
                saveReq.setIsCustom(0);
                saveReq.setIsDefault(0);
                saveReq.setScanRequired(0);
                normalizeFields(saveReq);
                if (StrUtil.isBlank(saveReq.getPkgCode()) || StrUtil.isBlank(saveReq.getPkgName())) {
                    throw exception(PACKAGING_IMPORT_ROW_INVALID, "包装编码与名称不能为空");
                }
                if (saveReq.getPkgType() == null) {
                    throw exception(PACKAGING_IMPORT_ROW_INVALID, "包装类型不能为空");
                }
                PackagingDO exist = packagingMapper.selectByUnique(saveReq.getPkgCode());
                if (exist == null) {
                    createPackaging(saveReq);
                    resp.getCreateKeys().add(saveReq.getPkgCode());
                } else if (!updateSupport) {
                    resp.getFailureKeys().put(key, PACKAGING_DUPLICATE.getMsg());
                } else {
                    saveReq.setId(exist.getId());
                    updatePackaging(saveReq);
                    resp.getUpdateKeys().add(saveReq.getPkgCode());
                }
            } catch (ServiceException ex) {
                resp.getFailureKeys().put(key, ex.getMessage());
            } catch (Exception ex) {
                resp.getFailureKeys().put(key, StrUtil.blankToDefault(ex.getMessage(), "导入失败"));
            }
        }
        return resp;
    }

    @Override
    public List<PackagingExportExcelVO> getPackagingExportList(PackagingPageReqVO pageReqVO) {
        pageReqVO.setPageSize(PageParam.PAGE_SIZE_NONE);
        return getPackagingPage(pageReqVO).getList().stream().map(vo -> {
            PackagingExportExcelVO excel = BeanUtils.toBean(vo, PackagingExportExcelVO.class);
            excel.setClientName(vo.getClientName());
            if (CollUtil.isNotEmpty(vo.getWarehouseNames())) {
                excel.setWarehouseNames(String.join(",", vo.getWarehouseNames()));
            }
            return excel;
        }).collect(Collectors.toList());
    }

    private PackagingRespVO buildRespVO(PackagingDO row, PackagingBuildContext ctx) {
        PackagingRespVO vo = new PackagingRespVO();
        vo.setId(row.getId());
        vo.setPkgCode(row.getPkgCode());
        vo.setPkgName(row.getPkgName());
        vo.setPkgType(row.getPkgType());
        vo.setSourceType(row.getSourceType());
        vo.setClientId(row.getClientId());
        if (row.getClientId() != null) {
            vo.setClientName(ctx.clientNameMap.get(row.getClientId()));
        }
        List<Long> warehouseIds = parseWarehouseIds(row.getWarehouseIds());
        vo.setWarehouseIds(warehouseIds);
        if (CollUtil.isEmpty(warehouseIds)) {
            vo.setWarehouseNames(Collections.emptyList());
        } else {
            vo.setWarehouseNames(warehouseIds.stream()
                    .map(id -> ctx.warehouseNameMap.getOrDefault(id, String.valueOf(id)))
                    .collect(Collectors.toList()));
        }
        vo.setLength(row.getPkgLength());
        vo.setWidth(row.getPkgWidth());
        vo.setHeight(row.getPkgHeight());
        vo.setDimensionUnit(row.getDimensionUnit());
        vo.setTareWeight(row.getTareWeight());
        vo.setWeightUnit(row.getWeightUnit());
        vo.setMaxLoadWeight(row.getMaxLoadWeight());
        vo.setMaterial(row.getMaterial());
        vo.setMaterialSku(row.getMaterialSku());
        vo.setUnitCost(row.getUnitCost());
        vo.setCostCurrency(row.getCostCurrency());
        vo.setIsCustom(row.getIsCustom());
        vo.setIsDefault(row.getIsDefault());
        vo.setScanRequired(row.getScanRequired());
        vo.setStatus(row.getStatus());
        vo.setSortOrder(row.getSortOrder());
        vo.setRemark(row.getRemark());
        vo.setCreateTime(row.getCreateTime());
        return vo;
    }

    private PackagingBuildContext loadContext(List<PackagingDO> rows) {
        if (CollUtil.isEmpty(rows)) {
            return PackagingBuildContext.empty();
        }
        Set<Long> clientIds = rows.stream().map(PackagingDO::getClientId).filter(Objects::nonNull).collect(Collectors.toSet());
        Map<Long, String> clientNameMap = new HashMap<>();
        if (CollUtil.isNotEmpty(clientIds)) {
            baseClientMapper.selectListByIds(clientIds).forEach(c -> clientNameMap.put(c.getId(), c.getClientName()));
        }
        Set<Long> warehouseIds = new HashSet<>();
        for (PackagingDO row : rows) {
            warehouseIds.addAll(parseWarehouseIds(row.getWarehouseIds()));
        }
        Map<Long, String> warehouseNameMap = new HashMap<>();
        if (CollUtil.isNotEmpty(warehouseIds)) {
            baseWarehouseMapper.selectListByIds(warehouseIds).forEach(w ->
                    warehouseNameMap.put(w.getId(), w.getWarehouseName()));
        }
        return new PackagingBuildContext(clientNameMap, warehouseNameMap);
    }

    private PackagingDO toDO(PackagingSaveReqVO reqVO) {
        PackagingDO row = new PackagingDO();
        row.setId(reqVO.getId());
        row.setPkgCode(reqVO.getPkgCode());
        row.setPkgName(reqVO.getPkgName());
        row.setPkgType(reqVO.getPkgType());
        row.setSourceType(reqVO.getSourceType());
        row.setClientId(reqVO.getClientId());
        row.setWarehouseIds(formatWarehouseIds(reqVO.getWarehouseIds()));
        row.setPkgLength(reqVO.getLength());
        row.setPkgWidth(reqVO.getWidth());
        row.setPkgHeight(reqVO.getHeight());
        row.setDimensionUnit(reqVO.getDimensionUnit());
        row.setTareWeight(reqVO.getTareWeight());
        row.setWeightUnit(reqVO.getWeightUnit());
        row.setMaxLoadWeight(reqVO.getMaxLoadWeight());
        row.setMaterial(reqVO.getMaterial());
        row.setMaterialSku(reqVO.getMaterialSku());
        row.setUnitCost(reqVO.getUnitCost());
        row.setCostCurrency(reqVO.getCostCurrency());
        row.setIsCustom(reqVO.getIsCustom());
        row.setIsDefault(reqVO.getIsDefault());
        row.setScanRequired(reqVO.getScanRequired());
        row.setStatus(reqVO.getStatus());
        row.setSortOrder(reqVO.getSortOrder());
        row.setRemark(reqVO.getRemark());
        return row;
    }

    private void validateBusiness(PackagingSaveReqVO reqVO) {
        if (reqVO.getPkgType() == null || !VALID_PKG_TYPES.contains(reqVO.getPkgType())) {
            throw exception(PACKAGING_PKG_TYPE_INVALID);
        }
        if (reqVO.getSourceType() == null || !VALID_SOURCE_TYPES.contains(reqVO.getSourceType())) {
            throw exception(PACKAGING_SOURCE_TYPE_INVALID);
        }
        if (!VALID_DIMENSION_UNITS.contains(reqVO.getDimensionUnit())) {
            throw exception(PACKAGING_DIMENSION_UNIT_INVALID);
        }
        if (!VALID_WEIGHT_UNITS.contains(reqVO.getWeightUnit())) {
            throw exception(PACKAGING_WEIGHT_UNIT_INVALID);
        }
        boolean needClient = Objects.equals(reqVO.getSourceType(), SOURCE_TYPE_CLIENT)
                || Objects.equals(reqVO.getIsCustom(), 1);
        if (needClient && reqVO.getClientId() == null) {
            throw exception(PACKAGING_CLIENT_REQUIRED);
        }
        if (reqVO.getClientId() != null) {
            ClientDO client = baseClientMapper.selectById(reqVO.getClientId());
            if (client == null || !Objects.equals(client.getStatus(), CommonStatusEnum.ENABLE.getStatus())) {
                throw exception(PACKAGING_CLIENT_NOT_EXISTS);
            }
        }
        if (CollUtil.isNotEmpty(reqVO.getWarehouseIds())) {
            List<WarehouseDO> warehouses = baseWarehouseMapper.selectListByIds(reqVO.getWarehouseIds());
            Set<Long> found = warehouses.stream().map(WarehouseDO::getId).collect(Collectors.toSet());
            for (Long warehouseId : reqVO.getWarehouseIds()) {
                if (!found.contains(warehouseId)) {
                    throw exception(PACKAGING_WAREHOUSE_INVALID, String.valueOf(warehouseId));
                }
            }
        }
    }

    private void normalizeFields(PackagingSaveReqVO reqVO) {
        if (reqVO.getPkgCode() != null) {
            reqVO.setPkgCode(reqVO.getPkgCode().trim().toUpperCase());
        }
        if (reqVO.getPkgName() != null) {
            reqVO.setPkgName(reqVO.getPkgName().trim());
        }
        if (reqVO.getDimensionUnit() != null) {
            reqVO.setDimensionUnit(reqVO.getDimensionUnit().trim().toUpperCase());
        } else {
            reqVO.setDimensionUnit("CM");
        }
        if (reqVO.getWeightUnit() != null) {
            reqVO.setWeightUnit(reqVO.getWeightUnit().trim().toUpperCase());
        } else {
            reqVO.setWeightUnit("KG");
        }
        if (reqVO.getCostCurrency() != null) {
            reqVO.setCostCurrency(reqVO.getCostCurrency().trim().toUpperCase());
        }
        if (reqVO.getMaterial() != null) {
            reqVO.setMaterial(reqVO.getMaterial().trim());
        }
        if (reqVO.getMaterialSku() != null) {
            reqVO.setMaterialSku(reqVO.getMaterialSku().trim());
        }
        if (reqVO.getRemark() != null) {
            reqVO.setRemark(reqVO.getRemark().trim());
        }
        reqVO.setIsCustom(defaultFlag(reqVO.getIsCustom()));
        reqVO.setIsDefault(defaultFlag(reqVO.getIsDefault()));
        reqVO.setScanRequired(defaultFlag(reqVO.getScanRequired()));
        if (reqVO.getWarehouseIds() != null) {
            reqVO.setWarehouseIds(reqVO.getWarehouseIds().stream().filter(Objects::nonNull).distinct().collect(Collectors.toList()));
            if (reqVO.getWarehouseIds().isEmpty()) {
                reqVO.setWarehouseIds(null);
            }
        }
    }

    private static int defaultFlag(Integer flag) {
        return flag != null && flag == 1 ? 1 : 0;
    }

    private static List<Long> parseWarehouseIds(String json) {
        if (StrUtil.isBlank(json)) {
            return Collections.emptyList();
        }
        return JSONUtil.parseArray(json).toList(Long.class);
    }

    private static String formatWarehouseIds(List<Long> warehouseIds) {
        if (CollUtil.isEmpty(warehouseIds)) {
            return null;
        }
        return JSONUtil.toJsonStr(warehouseIds);
    }

    private PackagingDO validateExists(Long id) {
        PackagingDO row = packagingMapper.selectById(id);
        if (row == null) {
            throw exception(PACKAGING_NOT_EXISTS);
        }
        return row;
    }

    private void validateUnique(Long id, String pkgCode) {
        PackagingDO exist = packagingMapper.selectByUnique(pkgCode);
        if (exist != null && (id == null || !exist.getId().equals(id))) {
            throw exception(PACKAGING_DUPLICATE);
        }
    }

    private record PackagingBuildContext(Map<Long, String> clientNameMap, Map<Long, String> warehouseNameMap) {
        static PackagingBuildContext empty() {
            return new PackagingBuildContext(Collections.emptyMap(), Collections.emptyMap());
        }
    }

}
