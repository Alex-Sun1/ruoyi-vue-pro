package cn.iocoder.yudao.module.base.service.sku;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.base.controller.admin.sku.vo.*;
import cn.iocoder.yudao.module.base.dal.dataobject.client.ClientDO;
import cn.iocoder.yudao.module.base.dal.dataobject.feeitem.FeeItemDO;
import cn.iocoder.yudao.module.base.dal.dataobject.packaging.PackagingDO;
import cn.iocoder.yudao.module.base.dal.dataobject.sku.SkuDO;
import cn.iocoder.yudao.module.base.dal.dataobject.sku.SkuDefaultFeeDO;
import cn.iocoder.yudao.module.base.dal.dataobject.sku.SkuInventoryDO;
import cn.iocoder.yudao.module.base.dal.mysql.client.BaseClientMapper;
import cn.iocoder.yudao.module.base.dal.mysql.feeitem.FeeItemMapper;
import cn.iocoder.yudao.module.base.dal.mysql.packaging.PackagingMapper;
import cn.iocoder.yudao.module.base.dal.mysql.sku.SkuDefaultFeeMapper;
import cn.iocoder.yudao.module.base.dal.mysql.sku.SkuInventoryMapper;
import cn.iocoder.yudao.module.base.dal.mysql.sku.SkuMapper;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.base.enums.ErrorCodeConstants.*;

@Service
@Validated
public class SkuServiceImpl implements SkuService {

    private static final Pattern HS_CODE_PATTERN = Pattern.compile("^\\d{6,10}$");

    @Resource
    private SkuMapper skuMapper;
    @Resource
    private SkuDefaultFeeMapper skuDefaultFeeMapper;
    @Resource
    private SkuInventoryMapper skuInventoryMapper;
    @Resource
    private BaseClientMapper baseClientMapper;
    @Resource
    private PackagingMapper packagingMapper;
    @Resource
    private FeeItemMapper feeItemMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createSku(SkuSaveReqVO createReqVO) {
        normalizeFields(createReqVO);
        validateClient(createReqVO.getClientId());
        validateHsCode(createReqVO.getHsCode());
        validateDefaultFeeCodes(createReqVO.getDefaultFeeCodes());
        recalcVolumeIfNeeded(createReqVO);
        validateUnique(null, createReqVO.getClientId(), createReqVO.getSkuCode());
        if (createReqVO.getStatus() == null) {
            createReqVO.setStatus(CommonStatusEnum.ENABLE.getStatus());
        }
        if (StrUtil.isBlank(createReqVO.getUnit())) {
            createReqVO.setUnit("pcs");
        }
        SkuDO row = BeanUtils.toBean(createReqVO, SkuDO.class);
        skuMapper.insert(row);
        saveDefaultFees(row.getId(), createReqVO.getDefaultFeeCodes());
        return row.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateSku(SkuSaveReqVO updateReqVO) {
        SkuDO existing = validateExists(updateReqVO.getId());
        normalizeFields(updateReqVO);
        validateClient(updateReqVO.getClientId());
        validateHsCode(updateReqVO.getHsCode());
        validateDefaultFeeCodes(updateReqVO.getDefaultFeeCodes());
        recalcVolumeIfNeeded(updateReqVO);
        if (!Objects.equals(existing.getClientId(), updateReqVO.getClientId())) {
            throw exception(SKU_CLIENT_NOT_MODIFIABLE);
        }
        updateReqVO.setClientId(existing.getClientId());
        boolean codeLocked = isSkuCodeLocked(existing.getId());
        if (codeLocked && !Objects.equals(existing.getSkuCode(), updateReqVO.getSkuCode())) {
            throw exception(SKU_CODE_NOT_MODIFIABLE);
        }
        if (!codeLocked) {
            validateUnique(updateReqVO.getId(), updateReqVO.getClientId(), updateReqVO.getSkuCode());
        } else {
            updateReqVO.setSkuCode(existing.getSkuCode());
        }
        SkuDO updateObj = BeanUtils.toBean(updateReqVO, SkuDO.class);
        updateObj.setStatus(existing.getStatus());
        skuMapper.updateById(updateObj);
        saveDefaultFees(updateReqVO.getId(), updateReqVO.getDefaultFeeCodes());
    }

    @Override
    public void updateSkuStatus(SkuUpdateStatusReqVO reqVO) {
        validateExists(reqVO.getId());
        SkuDO update = new SkuDO();
        update.setId(reqVO.getId());
        update.setStatus(reqVO.getStatus());
        skuMapper.updateById(update);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteSku(Long id) {
        validateExists(id);
        if (skuInventoryMapper.hasStock(id)) {
            throw exception(SKU_DELETE_HAS_STOCK);
        }
        skuDefaultFeeMapper.deleteBySkuId(id);
        skuMapper.deleteById(id);
    }

    @Override
    public SkuRespVO getSku(Long id) {
        SkuDO row = validateExists(id);
        return buildRespVO(row, loadContext(Collections.singletonList(row)));
    }

    @Override
    public PageResult<SkuRespVO> getSkuPage(SkuPageReqVO pageReqVO) {
        PageResult<SkuDO> pageResult = skuMapper.selectPage(pageReqVO);
        SkuBuildContext ctx = loadContext(pageResult.getList());
        List<SkuRespVO> list = pageResult.getList().stream()
                .map(row -> buildRespVO(row, ctx))
                .collect(Collectors.toList());
        return new PageResult<>(list, pageResult.getTotal());
    }

    @Override
    public List<SkuRespVO> getSkuSimpleList(Long clientId, Integer status) {
        List<SkuDO> list = skuMapper.selectSimpleList(clientId, status);
        SkuBuildContext ctx = loadContext(list);
        return list.stream().map(row -> buildRespVO(row, ctx)).collect(Collectors.toList());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public SkuImportRespVO importSkuList(List<SkuImportExcelVO> importList, boolean updateSupport) {
        if (CollUtil.isEmpty(importList)) {
            throw exception(SKU_IMPORT_LIST_IS_EMPTY);
        }
        SkuImportRespVO resp = SkuImportRespVO.builder()
                .createKeys(new ArrayList<>())
                .updateKeys(new ArrayList<>())
                .failureKeys(new LinkedHashMap<>())
                .build();
        AtomicInteger index = new AtomicInteger(1);
        for (SkuImportExcelVO row : importList) {
            int line = index.getAndIncrement();
            String key = StrUtil.blankToDefault(row.getSkuCode(), "第" + line + "行");
            try {
                SkuSaveReqVO saveReq = BeanUtils.toBean(row, SkuSaveReqVO.class);
                saveReq.setStatus(CommonStatusEnum.ENABLE.getStatus());
                normalizeFields(saveReq);
                if (saveReq.getClientId() == null) {
                    throw exception(SKU_IMPORT_ROW_INVALID, "客户ID不能为空");
                }
                if (StrUtil.isBlank(saveReq.getSkuCode()) || StrUtil.isBlank(saveReq.getSkuName())) {
                    throw exception(SKU_IMPORT_ROW_INVALID, "SKU编码与名称不能为空");
                }
                validateClient(saveReq.getClientId());
                recalcVolumeIfNeeded(saveReq);
                SkuDO exist = skuMapper.selectByUnique(saveReq.getClientId(), saveReq.getSkuCode());
                String successKey = saveReq.getClientId() + ":" + saveReq.getSkuCode();
                if (exist == null) {
                    createSku(saveReq);
                    resp.getCreateKeys().add(successKey);
                } else if (!updateSupport) {
                    resp.getFailureKeys().put(key, SKU_DUPLICATE.getMsg());
                } else {
                    saveReq.setId(exist.getId());
                    updateSku(saveReq);
                    resp.getUpdateKeys().add(successKey);
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
    public List<SkuExportExcelVO> getSkuExportList(SkuPageReqVO pageReqVO) {
        pageReqVO.setPageSize(PageParam.PAGE_SIZE_NONE);
        PageResult<SkuRespVO> page = getSkuPage(pageReqVO);
        return page.getList().stream().map(vo -> {
            SkuExportExcelVO excel = BeanUtils.toBean(vo, SkuExportExcelVO.class);
            excel.setClientName(vo.getClientName());
            return excel;
        }).collect(Collectors.toList());
    }

    private SkuRespVO buildRespVO(SkuDO row, SkuBuildContext ctx) {
        SkuRespVO vo = BeanUtils.toBean(row, SkuRespVO.class);
        vo.setClientName(ctx.clientNameMap.getOrDefault(row.getClientId(), String.valueOf(row.getClientId())));
        if (row.getDefaultPkgId() != null) {
            vo.setDefaultPkgName(ctx.pkgNameMap.getOrDefault(row.getDefaultPkgId(), null));
        }
        vo.setDefaultFeeCodes(ctx.feeCodesBySkuId.getOrDefault(row.getId(), Collections.emptyList()));
        boolean hasStock = ctx.stockSkuIds.contains(row.getId());
        vo.setHasStock(hasStock);
        vo.setSkuCodeEditable(!hasStock && !ctx.lockedSkuIds.contains(row.getId()));
        return vo;
    }

    private SkuBuildContext loadContext(List<SkuDO> rows) {
        if (CollUtil.isEmpty(rows)) {
            return SkuBuildContext.empty();
        }
        Set<Long> skuIds = rows.stream().map(SkuDO::getId).collect(Collectors.toSet());
        Set<Long> clientIds = rows.stream().map(SkuDO::getClientId).collect(Collectors.toSet());
        Set<Long> pkgIds = rows.stream().map(SkuDO::getDefaultPkgId).filter(Objects::nonNull).collect(Collectors.toSet());

        Map<Long, String> clientNameMap = new HashMap<>();
        if (CollUtil.isNotEmpty(clientIds)) {
            baseClientMapper.selectListByIds(clientIds).forEach(c ->
                    clientNameMap.put(c.getId(), c.getClientName()));
        }
        Map<Long, String> pkgNameMap = new HashMap<>();
        if (CollUtil.isNotEmpty(pkgIds)) {
            packagingMapper.selectListByIds(pkgIds).forEach(p ->
                    pkgNameMap.put(p.getId(), p.getPkgName()));
        }
        Map<Long, List<String>> feeCodesBySkuId = skuDefaultFeeMapper.selectListBySkuIds(skuIds).stream()
                .collect(Collectors.groupingBy(SkuDefaultFeeDO::getSkuId,
                        Collectors.mapping(SkuDefaultFeeDO::getFeeCode, Collectors.toList())));

        Set<Long> stockSkuIds = skuInventoryMapper.selectListBySkuIds(skuIds).stream()
                .filter(inv -> inv.getQtyOnHand() != null && inv.getQtyOnHand().compareTo(BigDecimal.ZERO) > 0)
                .map(SkuInventoryDO::getSkuId)
                .collect(Collectors.toSet());

        return new SkuBuildContext(clientNameMap, pkgNameMap, feeCodesBySkuId, stockSkuIds, Collections.emptySet());
    }

    private boolean isSkuCodeLocked(Long skuId) {
        return skuInventoryMapper.hasStock(skuId);
    }

    private void saveDefaultFees(Long skuId, List<String> feeCodes) {
        skuDefaultFeeMapper.deleteBySkuId(skuId);
        if (CollUtil.isEmpty(feeCodes)) {
            return;
        }
        for (String feeCode : feeCodes) {
            if (StrUtil.isBlank(feeCode)) {
                continue;
            }
            SkuDefaultFeeDO fee = new SkuDefaultFeeDO();
            fee.setSkuId(skuId);
            fee.setFeeCode(feeCode.trim().toUpperCase());
            skuDefaultFeeMapper.insert(fee);
        }
    }

    private void validateClient(Long clientId) {
        ClientDO client = baseClientMapper.selectById(clientId);
        if (client == null || !Objects.equals(client.getStatus(), CommonStatusEnum.ENABLE.getStatus())) {
            throw exception(SKU_CLIENT_NOT_EXISTS);
        }
    }

    private void validateHsCode(String hsCode) {
        if (StrUtil.isBlank(hsCode)) {
            return;
        }
        if (!HS_CODE_PATTERN.matcher(hsCode.trim()).matches()) {
            throw exception(SKU_HS_CODE_INVALID);
        }
    }

    private void validateDefaultFeeCodes(List<String> feeCodes) {
        if (CollUtil.isEmpty(feeCodes)) {
            return;
        }
        for (String feeCode : feeCodes) {
            if (StrUtil.isBlank(feeCode)) {
                continue;
            }
            FeeItemDO feeItem = feeItemMapper.selectByUnique(feeCode.trim().toUpperCase());
            if (feeItem == null || !Objects.equals(feeItem.getStatus(), CommonStatusEnum.ENABLE.getStatus())) {
                throw exception(SKU_DEFAULT_FEE_INVALID, feeCode);
            }
        }
    }

    private void recalcVolumeIfNeeded(SkuSaveReqVO reqVO) {
        if (reqVO.getVolumeCbm() != null) {
            return;
        }
        if (reqVO.getLengthCm() == null || reqVO.getWidthCm() == null || reqVO.getHeightCm() == null) {
            return;
        }
        BigDecimal volume = reqVO.getLengthCm()
                .multiply(reqVO.getWidthCm())
                .multiply(reqVO.getHeightCm())
                .divide(BigDecimal.valueOf(1_000_000), 6, RoundingMode.HALF_UP);
        reqVO.setVolumeCbm(volume);
    }

    private void normalizeFields(SkuSaveReqVO reqVO) {
        if (reqVO.getSkuCode() != null) {
            reqVO.setSkuCode(reqVO.getSkuCode().trim().toUpperCase());
        }
        if (reqVO.getSkuName() != null) {
            reqVO.setSkuName(reqVO.getSkuName().trim());
        }
        if (reqVO.getSkuNameEn() != null) {
            reqVO.setSkuNameEn(reqVO.getSkuNameEn().trim());
        }
        if (reqVO.getBarcode() != null) {
            reqVO.setBarcode(reqVO.getBarcode().trim());
        }
        if (reqVO.getUnit() != null) {
            reqVO.setUnit(reqVO.getUnit().trim());
        }
        if (reqVO.getOriginCountryCode() != null) {
            reqVO.setOriginCountryCode(reqVO.getOriginCountryCode().trim().toUpperCase());
        }
        if (reqVO.getDeclaredCurrency() != null) {
            reqVO.setDeclaredCurrency(reqVO.getDeclaredCurrency().trim().toUpperCase());
        }
        if (reqVO.getHsCode() != null) {
            reqVO.setHsCode(reqVO.getHsCode().trim());
        }
        reqVO.setIsFragile(defaultFlag(reqVO.getIsFragile()));
        reqVO.setIsLiquid(defaultFlag(reqVO.getIsLiquid()));
        reqVO.setIsBattery(defaultFlag(reqVO.getIsBattery()));
        reqVO.setIsMagnetic(defaultFlag(reqVO.getIsMagnetic()));
        reqVO.setIsDangerous(defaultFlag(reqVO.getIsDangerous()));
        reqVO.setIsOversize(defaultFlag(reqVO.getIsOversize()));
        if (reqVO.getDefaultFeeCodes() != null) {
            reqVO.setDefaultFeeCodes(reqVO.getDefaultFeeCodes().stream()
                    .filter(StrUtil::isNotBlank)
                    .map(c -> c.trim().toUpperCase())
                    .distinct()
                    .collect(Collectors.toList()));
        }
    }

    private static int defaultFlag(Integer flag) {
        return flag != null && flag == 1 ? 1 : 0;
    }

    private SkuDO validateExists(Long id) {
        SkuDO row = skuMapper.selectById(id);
        if (row == null) {
            throw exception(SKU_NOT_EXISTS);
        }
        return row;
    }

    private void validateUnique(Long id, Long clientId, String skuCode) {
        SkuDO exist = skuMapper.selectByUnique(clientId, skuCode);
        if (exist != null && (id == null || !exist.getId().equals(id))) {
            throw exception(SKU_DUPLICATE);
        }
    }

    private record SkuBuildContext(
            Map<Long, String> clientNameMap,
            Map<Long, String> pkgNameMap,
            Map<Long, List<String>> feeCodesBySkuId,
            Set<Long> stockSkuIds,
            Set<Long> lockedSkuIds) {

        static SkuBuildContext empty() {
            return new SkuBuildContext(Collections.emptyMap(), Collections.emptyMap(),
                    Collections.emptyMap(), Collections.emptySet(), Collections.emptySet());
        }
    }

}
