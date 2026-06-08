package cn.iocoder.yudao.module.base.service.warehouse;

import cn.hutool.core.collection.CollUtil;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.base.controller.admin.warehouse.vo.*;
import cn.iocoder.yudao.module.base.dal.dataobject.company.CompanyDO;
import cn.iocoder.yudao.module.base.dal.dataobject.timezone.TimezoneDO;
import cn.iocoder.yudao.module.base.dal.dataobject.warehouse.WarehouseDO;
import cn.iocoder.yudao.module.base.dal.mysql.company.CompanyMapper;
import cn.iocoder.yudao.module.base.dal.mysql.timezone.TimezoneMapper;
import cn.iocoder.yudao.module.base.dal.mysql.warehouse.BaseWarehouseMapper;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.util.*;
import java.util.stream.Collectors;
import java.util.Set;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.base.enums.ErrorCodeConstants.*;

@Service
@Validated
public class WarehouseServiceImpl implements WarehouseService {

    @Resource
    private BaseWarehouseMapper baseWarehouseMapper;
    @Resource
    private CompanyMapper companyMapper;
    @Resource
    private TimezoneMapper timezoneMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createWarehouse(WarehouseSaveReqVO createReqVO) {
        normalizeFields(createReqVO);
        validateBusiness(createReqVO);
        validateUnique(null, createReqVO.getWarehouseCode());
        if (createReqVO.getStatus() == null) {
            createReqVO.setStatus(CommonStatusEnum.ENABLE.getStatus());
        }
        WarehouseDO row = BeanUtils.toBean(createReqVO, WarehouseDO.class);
        baseWarehouseMapper.insert(row);
        return row.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateWarehouse(WarehouseSaveReqVO updateReqVO) {
        WarehouseDO existing = validateExists(updateReqVO.getId());
        normalizeFields(updateReqVO);
        validateBusiness(updateReqVO);
        if (!Objects.equals(existing.getWarehouseCode(), updateReqVO.getWarehouseCode())) {
            throw exception(WAREHOUSE_CODE_NOT_MODIFIABLE);
        }
        updateReqVO.setWarehouseCode(existing.getWarehouseCode());
        WarehouseDO updateObj = BeanUtils.toBean(updateReqVO, WarehouseDO.class);
        updateObj.setStatus(existing.getStatus());
        baseWarehouseMapper.updateById(updateObj);
    }

    @Override
    public void updateWarehouseStatus(WarehouseUpdateStatusReqVO reqVO) {
        validateExists(reqVO.getId());
        WarehouseDO update = new WarehouseDO();
        update.setId(reqVO.getId());
        update.setStatus(reqVO.getStatus());
        baseWarehouseMapper.updateById(update);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteWarehouse(Long id) {
        validateExists(id);
        baseWarehouseMapper.deleteById(id);
    }

    @Override
    public WarehouseRespVO getWarehouse(Long id) {
        WarehouseDO row = validateExists(id);
        return buildRespVO(row, loadCompanyNameMap(Collections.singletonList(row)));
    }

    @Override
    public PageResult<WarehouseRespVO> getWarehousePage(WarehousePageReqVO pageReqVO) {
        PageResult<WarehouseDO> pageResult = baseWarehouseMapper.selectPage(pageReqVO);
        Map<Long, String> companyNameMap = loadCompanyNameMap(pageResult.getList());
        List<WarehouseRespVO> list = pageResult.getList().stream()
                .map(row -> buildRespVO(row, companyNameMap))
                .collect(Collectors.toList());
        return new PageResult<>(list, pageResult.getTotal());
    }

    @Override
    public List<WarehouseRespVO> getWarehouseSimpleList(Integer status) {
        // 数据权限：二期按角色 warehouse_id 列表过滤；当前返回租户内符合条件的全部仓库
        List<WarehouseDO> list = baseWarehouseMapper.selectSimpleList(status, null);
        Map<Long, String> companyNameMap = loadCompanyNameMap(list);
        return list.stream().map(row -> buildRespVO(row, companyNameMap)).collect(Collectors.toList());
    }

    @Override
    public List<WarehouseExportExcelVO> getWarehouseExportList(WarehousePageReqVO pageReqVO) {
        pageReqVO.setPageSize(PageParam.PAGE_SIZE_NONE);
        return getWarehousePage(pageReqVO).getList().stream().map(vo -> {
            WarehouseExportExcelVO excel = BeanUtils.toBean(vo, WarehouseExportExcelVO.class);
            excel.setCompanyName(vo.getCompanyName());
            return excel;
        }).collect(Collectors.toList());
    }

    private WarehouseRespVO buildRespVO(WarehouseDO row, Map<Long, String> companyNameMap) {
        WarehouseRespVO vo = BeanUtils.toBean(row, WarehouseRespVO.class);
        if (row.getCompanyId() != null) {
            vo.setCompanyName(companyNameMap.get(row.getCompanyId()));
        }
        return vo;
    }

    private Map<Long, String> loadCompanyNameMap(List<WarehouseDO> rows) {
        if (CollUtil.isEmpty(rows)) {
            return Collections.emptyMap();
        }
        Set<Long> companyIds = rows.stream()
                .map(WarehouseDO::getCompanyId)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());
        if (CollUtil.isEmpty(companyIds)) {
            return Collections.emptyMap();
        }
        Map<Long, String> map = new HashMap<>();
        companyMapper.selectListByIds(companyIds).forEach(c -> map.put(c.getId(), c.getCompanyName()));
        return map;
    }

    private void validateBusiness(WarehouseSaveReqVO reqVO) {
        TimezoneDO timezone = timezoneMapper.selectByUnique(reqVO.getTimezoneCode());
        if (timezone == null || !Objects.equals(timezone.getStatus(), CommonStatusEnum.ENABLE.getStatus())) {
            throw exception(WAREHOUSE_TIMEZONE_INVALID);
        }
        if (reqVO.getCompanyId() != null) {
            CompanyDO company = companyMapper.selectById(reqVO.getCompanyId());
            if (company == null || !Objects.equals(company.getStatus(), CommonStatusEnum.ENABLE.getStatus())) {
                throw exception(WAREHOUSE_COMPANY_NOT_EXISTS);
            }
        }
    }

    private void normalizeFields(WarehouseSaveReqVO reqVO) {
        if (reqVO.getWarehouseCode() != null) {
            reqVO.setWarehouseCode(reqVO.getWarehouseCode().trim().toUpperCase());
        }
        if (reqVO.getWarehouseName() != null) {
            reqVO.setWarehouseName(reqVO.getWarehouseName().trim());
        }
        if (reqVO.getTimezoneCode() != null) {
            reqVO.setTimezoneCode(reqVO.getTimezoneCode().trim());
        }
        if (reqVO.getCountryCode() != null) {
            reqVO.setCountryCode(reqVO.getCountryCode().trim().toUpperCase());
        }
        if (reqVO.getAddress() != null) {
            reqVO.setAddress(reqVO.getAddress().trim());
        }
        if (reqVO.getRemark() != null) {
            reqVO.setRemark(reqVO.getRemark().trim());
        }
    }

    private WarehouseDO validateExists(Long id) {
        WarehouseDO row = baseWarehouseMapper.selectById(id);
        if (row == null) {
            throw exception(WAREHOUSE_NOT_EXISTS);
        }
        return row;
    }

    private void validateUnique(Long id, String warehouseCode) {
        WarehouseDO exist = baseWarehouseMapper.selectByUnique(warehouseCode);
        if (exist != null && (id == null || !exist.getId().equals(id))) {
            throw exception(WAREHOUSE_DUPLICATE);
        }
    }

    @Override
    public Set<Long> getEnabledWarehouseIds() {
        return baseWarehouseMapper.selectAllEnabledList().stream()
                .map(WarehouseDO::getId)
                .collect(Collectors.toSet());
    }

    @Override
    public Set<Long> getEnabledWarehouseIdsByIds(Collection<Long> warehouseIds) {
        if (CollUtil.isEmpty(warehouseIds)) {
            return Set.of();
        }
        return baseWarehouseMapper.selectListByIds(warehouseIds).stream()
                .filter(w -> Objects.equals(w.getStatus(), CommonStatusEnum.ENABLE.getStatus()))
                .map(WarehouseDO::getId)
                .collect(Collectors.toSet());
    }

    @Override
    public Set<Long> getEnabledWarehouseIdsByCompanyIds(Collection<Long> companyIds) {
        if (CollUtil.isEmpty(companyIds)) {
            return Set.of();
        }
        return baseWarehouseMapper.selectEnabledListByCompanyIds(companyIds).stream()
                .map(WarehouseDO::getId)
                .collect(Collectors.toSet());
    }

}
