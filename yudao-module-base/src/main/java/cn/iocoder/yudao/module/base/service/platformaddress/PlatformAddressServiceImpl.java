package cn.iocoder.yudao.module.base.service.platformaddress;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONUtil;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.framework.security.core.util.SecurityFrameworkUtils;
import cn.iocoder.yudao.module.base.controller.admin.common.vo.BaseTranslationItemVO;
import cn.iocoder.yudao.module.base.controller.admin.platformaddress.vo.*;
import cn.iocoder.yudao.module.base.dal.dataobject.country.CountryDO;
import cn.iocoder.yudao.module.base.dal.dataobject.platform.PlatformDO;
import cn.iocoder.yudao.module.base.dal.dataobject.platformaddress.PlatformAddressChangeLogDO;
import cn.iocoder.yudao.module.base.dal.dataobject.platformaddress.PlatformAddressDO;
import cn.iocoder.yudao.module.base.dal.dataobject.state.StateProvinceDO;
import cn.iocoder.yudao.module.base.dal.mysql.country.CountryMapper;
import cn.iocoder.yudao.module.base.dal.mysql.platform.PlatformMapper;
import cn.iocoder.yudao.module.base.dal.mysql.platformaddress.PlatformAddressChangeLogMapper;
import cn.iocoder.yudao.module.base.dal.mysql.platformaddress.PlatformAddressMapper;
import cn.iocoder.yudao.module.base.dal.mysql.state.StateProvinceMapper;
import cn.iocoder.yudao.module.base.enums.BaseEntityTypeEnum;
import cn.iocoder.yudao.module.base.enums.BaseTranslationFieldEnum;
import cn.iocoder.yudao.module.base.enums.PlatformAddressChangeTypeEnum;
import cn.iocoder.yudao.module.base.framework.web.BaseLocaleUtils;
import cn.iocoder.yudao.module.base.service.i18n.EntityTranslationService;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.base.enums.ErrorCodeConstants.*;

@Service
@Validated
public class PlatformAddressServiceImpl implements PlatformAddressService {

    private static final int WEIGH_STATION_YES = 1;

    @Resource
    private PlatformAddressMapper platformAddressMapper;
    @Resource
    private PlatformAddressChangeLogMapper changeLogMapper;
    @Resource
    private PlatformMapper platformMapper;
    @Resource
    private CountryMapper countryMapper;
    @Resource
    private StateProvinceMapper stateProvinceMapper;
    @Resource
    private EntityTranslationService entityTranslationService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createPlatformAddress(PlatformAddressSaveReqVO createReqVO) {
        Long id = insertAddress(createReqVO);
        PlatformAddressDO row = platformAddressMapper.selectById(id);
        insertChangeLog(id, PlatformAddressChangeTypeEnum.CREATE.getType(),
                null, toSnapshotJson(row), null);
        return id;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updatePlatformAddress(PlatformAddressSaveReqVO updateReqVO) {
        PlatformAddressDO existing = validateExists(updateReqVO.getId());
        String beforeJson = toSnapshotJson(existing);
        updateAddress(updateReqVO, existing);
        PlatformAddressDO after = platformAddressMapper.selectById(updateReqVO.getId());
        insertChangeLog(updateReqVO.getId(), PlatformAddressChangeTypeEnum.UPDATE.getType(),
                beforeJson, toSnapshotJson(after), null);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updatePlatformAddressStatus(PlatformAddressUpdateStatusReqVO reqVO) {
        PlatformAddressDO existing = validateExists(reqVO.getId());
        String beforeJson = JSONUtil.toJsonStr(Map.of("status", existing.getStatus()));
        PlatformAddressDO update = new PlatformAddressDO();
        update.setId(reqVO.getId());
        update.setStatus(reqVO.getStatus());
        platformAddressMapper.updateById(update);
        String afterJson = JSONUtil.toJsonStr(Map.of("status", reqVO.getStatus()));
        insertChangeLog(reqVO.getId(), PlatformAddressChangeTypeEnum.STATUS_CHANGE.getType(),
                beforeJson, afterJson, reqVO.getChangeReason());
    }

    @Override
    public PlatformAddressRespVO getPlatformAddress(Long id) {
        PlatformAddressDO row = validateExists(id);
        String langCode = BaseLocaleUtils.getLangCode();
        PlatformAddressRespVO resp = buildRespVO(row, langCode);
        List<BaseTranslationItemVO> items = entityTranslationService.getTranslationList(
                        BaseEntityTypeEnum.PLATFORM_ADDRESS.getType(), id,
                        BaseTranslationFieldEnum.NAME.getFieldName())
                .stream()
                .map(t -> {
                    BaseTranslationItemVO vo = new BaseTranslationItemVO();
                    vo.setLangCode(t.getLangCode());
                    vo.setValue(t.getValue());
                    return vo;
                })
                .collect(Collectors.toList());
        resp.setTranslations(items);
        return resp;
    }

    @Override
    public PageResult<PlatformAddressRespVO> getPlatformAddressPage(PlatformAddressPageReqVO pageReqVO) {
        if (StrUtil.isNotBlank(pageReqVO.getCountryCode())) {
            pageReqVO.setCountryCode(pageReqVO.getCountryCode().trim().toUpperCase());
        }
        if (StrUtil.isNotBlank(pageReqVO.getStateCode())) {
            pageReqVO.setStateCode(pageReqVO.getStateCode().trim().toUpperCase());
        }
        PageResult<PlatformAddressDO> pageResult = platformAddressMapper.selectPage(pageReqVO);
        String langCode = BaseLocaleUtils.getLangCode();
        List<PlatformAddressRespVO> list = pageResult.getList().stream()
                .map(row -> buildRespVO(row, langCode))
                .collect(Collectors.toList());
        return new PageResult<>(list, pageResult.getTotal());
    }

    @Override
    public List<PlatformAddressRespVO> getPlatformAddressSimpleList(Long platformId, String platformCode, Integer status) {
        Long queryPlatformId = platformId;
        if (queryPlatformId == null && StrUtil.isNotBlank(platformCode)) {
            PlatformDO platform = platformMapper.selectByUnique(platformCode.trim().toUpperCase());
            if (platform == null) {
                return List.of();
            }
            queryPlatformId = platform.getId();
        }
        String langCode = BaseLocaleUtils.getLangCode();
        return platformAddressMapper.selectSimpleList(queryPlatformId, status).stream()
                .map(row -> buildRespVO(row, langCode))
                .collect(Collectors.toList());
    }

    @Override
    public List<PlatformAddressChangeLogRespVO> getPlatformAddressChangeLog(Long platformAddressId) {
        validateExists(platformAddressId);
        return changeLogMapper.selectListByPlatformAddressId(platformAddressId).stream()
                .map(log -> BeanUtils.toBean(log, PlatformAddressChangeLogRespVO.class))
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public PlatformAddressImportRespVO importPlatformAddressList(List<PlatformAddressImportExcelVO> importList,
                                                                   boolean updateSupport) {
        if (CollUtil.isEmpty(importList)) {
            throw exception(PLATFORM_ADDRESS_IMPORT_LIST_IS_EMPTY);
        }
        PlatformAddressImportRespVO resp = PlatformAddressImportRespVO.builder()
                .createKeys(new ArrayList<>())
                .updateKeys(new ArrayList<>())
                .failureKeys(new LinkedHashMap<>())
                .build();
        AtomicInteger index = new AtomicInteger(1);
        for (PlatformAddressImportExcelVO row : importList) {
            int line = index.getAndIncrement();
            String key = StrUtil.format("{}:{}",
                    StrUtil.blankToDefault(row.getPlatformCode(), "?"),
                    StrUtil.blankToDefault(row.getAddressCode(), "第" + line + "行"));
            try {
                if (StrUtil.hasBlank(row.getPlatformCode(), row.getAddressCode(), row.getNameEn(),
                        row.getCountryCode(), row.getAddressLine1())) {
                    throw exception(PLATFORM_ADDRESS_IMPORT_ROW_INVALID, "平台代码/地址编码/名称/国家/地址行1不能为空");
                }
                PlatformDO platform = platformMapper.selectByUnique(row.getPlatformCode().trim().toUpperCase());
                if (platform == null) {
                    throw exception(PLATFORM_NOT_EXISTS_FOR_ADDRESS);
                }
                PlatformAddressSaveReqVO saveReq = new PlatformAddressSaveReqVO();
                saveReq.setPlatformId(platform.getId());
                saveReq.setAddressCode(row.getAddressCode());
                saveReq.setAddressType(row.getAddressType() != null ? row.getAddressType() : 4);
                saveReq.setNameEn(row.getNameEn());
                saveReq.setCountryCode(row.getCountryCode());
                saveReq.setStateCode(row.getStateCode());
                saveReq.setCity(row.getCity());
                saveReq.setAddressLine1(row.getAddressLine1());
                saveReq.setZipCode(row.getZipCode());
                saveReq.setWhProperty(row.getWhProperty());
                saveReq.setPalletCbm(row.getPalletCbm());
                saveReq.setIsWeighStation(row.getIsWeighStation() != null ? row.getIsWeighStation() : 0);
                saveReq.setMaxWeightTon(row.getMaxWeightTon());
                saveReq.setContactName(row.getContactName());
                saveReq.setContactPhone(row.getContactPhone());
                saveReq.setRemark(row.getRemark());
                normalizeFields(saveReq);
                validateWeighStation(saveReq);
                String successKey = platform.getCode() + ":" + saveReq.getAddressCode();
                PlatformAddressDO exist = platformAddressMapper.selectByUnique(
                        saveReq.getPlatformId(), saveReq.getAddressCode());
                if (exist == null) {
                    Long id = insertAddress(saveReq);
                    insertChangeLog(id, PlatformAddressChangeTypeEnum.IMPORT.getType(),
                            null, toSnapshotJson(platformAddressMapper.selectById(id)), "Excel 导入");
                    resp.getCreateKeys().add(successKey);
                } else if (!updateSupport) {
                    resp.getFailureKeys().put(key, PLATFORM_ADDRESS_DUPLICATE.getMsg());
                } else {
                    saveReq.setId(exist.getId());
                    String beforeJson = toSnapshotJson(exist);
                    updateAddress(saveReq, exist);
                    insertChangeLog(exist.getId(), PlatformAddressChangeTypeEnum.IMPORT.getType(),
                            beforeJson, toSnapshotJson(platformAddressMapper.selectById(exist.getId())),
                            "Excel 导入更新");
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

    private PlatformAddressRespVO buildRespVO(PlatformAddressDO row, String langCode) {
        PlatformAddressRespVO vo = BeanUtils.toBean(row, PlatformAddressRespVO.class);
        PlatformDO platform = platformMapper.selectById(row.getPlatformId());
        if (platform != null) {
            vo.setPlatformCode(platform.getCode());
            Map<Long, String> platformNameMap = entityTranslationService.getDisplayNameMap(
                    BaseEntityTypeEnum.PLATFORM.getType(), BaseTranslationFieldEnum.NAME.getFieldName(),
                    Collections.singleton(platform.getId()), langCode);
            vo.setPlatformName(platformNameMap.getOrDefault(platform.getId(), platform.getNameEn()));
        }
        if (StrUtil.isNotBlank(row.getCountryCode())) {
            List<CountryDO> countries = countryMapper.selectList(new LambdaQueryWrapperX<CountryDO>()
                    .eq(CountryDO::getCode, row.getCountryCode()));
            if (CollUtil.isNotEmpty(countries)) {
                CountryDO country = countries.get(0);
                Map<Long, String> countryNameMap = entityTranslationService.getDisplayNameMap(
                        BaseEntityTypeEnum.COUNTRY.getType(), BaseTranslationFieldEnum.NAME.getFieldName(),
                        Collections.singleton(country.getId()), langCode);
                vo.setCountryName(countryNameMap.getOrDefault(country.getId(), country.getNameEn()));
            }
        }
        if (StrUtil.isNotBlank(row.getStateCode()) && StrUtil.isNotBlank(row.getCountryCode())) {
            StateProvinceDO state = stateProvinceMapper.selectByUnique(row.getCountryCode(), row.getStateCode());
            if (state != null) {
                Map<Long, String> stateNameMap = entityTranslationService.getDisplayNameMap(
                        BaseEntityTypeEnum.STATE_PROVINCE.getType(), BaseTranslationFieldEnum.NAME.getFieldName(),
                        Collections.singleton(state.getId()), langCode);
                vo.setStateName(stateNameMap.getOrDefault(state.getId(), state.getNameEn()));
            }
        }
        Map<Long, String> nameDisplayMap = entityTranslationService.getDisplayNameMap(
                BaseEntityTypeEnum.PLATFORM_ADDRESS.getType(), BaseTranslationFieldEnum.NAME.getFieldName(),
                Collections.singleton(row.getId()), langCode);
        vo.setNameDisplay(nameDisplayMap.getOrDefault(row.getId(), row.getNameEn()));
        return vo;
    }

    private Long insertAddress(PlatformAddressSaveReqVO reqVO) {
        normalizeFields(reqVO);
        validatePlatformExists(reqVO.getPlatformId());
        validateWeighStation(reqVO);
        validateUnique(null, reqVO.getPlatformId(), reqVO.getAddressCode());
        PlatformAddressDO row = BeanUtils.toBean(reqVO, PlatformAddressDO.class);
        row.setStatus(CommonStatusEnum.ENABLE.getStatus());
        row.setLastVerifiedAt(LocalDateTime.now());
        if (row.getIsWeighStation() == null) {
            row.setIsWeighStation(0);
        }
        platformAddressMapper.insert(row);
        saveTranslations(row.getId(), reqVO.getTranslations());
        return row.getId();
    }

    private void updateAddress(PlatformAddressSaveReqVO updateReqVO, PlatformAddressDO existing) {
        normalizeFields(updateReqVO);
        validateWeighStation(updateReqVO);
        if (!Objects.equals(existing.getPlatformId(), updateReqVO.getPlatformId())
                || !Objects.equals(existing.getAddressCode(), updateReqVO.getAddressCode())) {
            throw exception(PLATFORM_ADDRESS_KEY_NOT_MODIFIABLE);
        }
        updateReqVO.setPlatformId(existing.getPlatformId());
        updateReqVO.setAddressCode(existing.getAddressCode());
        PlatformAddressDO updateObj = BeanUtils.toBean(updateReqVO, PlatformAddressDO.class);
        updateObj.setId(existing.getId());
        updateObj.setStatus(existing.getStatus());
        updateObj.setLastVerifiedAt(LocalDateTime.now());
        platformAddressMapper.updateById(updateObj);
        saveTranslations(updateReqVO.getId(), updateReqVO.getTranslations());
    }

    private void insertChangeLog(Long platformAddressId, String changeType,
                                 String beforeValue, String afterValue, String changeReason) {
        PlatformAddressChangeLogDO log = PlatformAddressChangeLogDO.builder()
                .platformAddressId(platformAddressId)
                .changeType(changeType)
                .beforeValue(beforeValue)
                .afterValue(afterValue)
                .changeReason(changeReason)
                .operatorName(SecurityFrameworkUtils.getLoginUserNickname())
                .build();
        changeLogMapper.insert(log);
    }

    private String toSnapshotJson(PlatformAddressDO row) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("addressCode", row.getAddressCode());
        map.put("nameEn", row.getNameEn());
        map.put("addressType", row.getAddressType());
        map.put("countryCode", row.getCountryCode());
        map.put("stateCode", row.getStateCode());
        map.put("city", row.getCity());
        map.put("zipCode", row.getZipCode());
        map.put("whProperty", row.getWhProperty());
        map.put("palletCbm", row.getPalletCbm());
        map.put("isWeighStation", row.getIsWeighStation());
        map.put("maxWeightTon", row.getMaxWeightTon());
        map.put("status", row.getStatus());
        return JSONUtil.toJsonStr(map);
    }

    private void saveTranslations(Long addressId, List<BaseTranslationItemVO> translations) {
        if (translations == null) {
            return;
        }
        List<EntityTranslationService.CountryTranslationItem> items = translations.stream()
                .filter(t -> StrUtil.isNotBlank(t.getLangCode()) && StrUtil.isNotBlank(t.getValue()))
                .map(t -> new EntityTranslationService.CountryTranslationItem(t.getLangCode(), t.getValue()))
                .collect(Collectors.toList());
        entityTranslationService.saveTranslations(
                BaseEntityTypeEnum.PLATFORM_ADDRESS.getType(), addressId,
                BaseTranslationFieldEnum.NAME.getFieldName(), items);
    }

    private void validateWeighStation(PlatformAddressSaveReqVO reqVO) {
        int weigh = reqVO.getIsWeighStation() != null ? reqVO.getIsWeighStation() : 0;
        if (Objects.equals(weigh, WEIGH_STATION_YES) && reqVO.getMaxWeightTon() == null) {
            throw exception(PLATFORM_ADDRESS_MAX_WEIGHT_REQUIRED);
        }
    }

    private void validatePlatformExists(Long platformId) {
        if (platformMapper.selectById(platformId) == null) {
            throw exception(PLATFORM_NOT_EXISTS_FOR_ADDRESS);
        }
    }

    private void normalizeFields(PlatformAddressSaveReqVO reqVO) {
        if (reqVO.getAddressCode() != null) {
            reqVO.setAddressCode(reqVO.getAddressCode().trim().toUpperCase());
        }
        if (reqVO.getCountryCode() != null) {
            reqVO.setCountryCode(reqVO.getCountryCode().trim().toUpperCase());
        }
        if (reqVO.getStateCode() != null) {
            reqVO.setStateCode(reqVO.getStateCode().trim().toUpperCase());
        }
        if (reqVO.getNameEn() != null) {
            reqVO.setNameEn(reqVO.getNameEn().trim());
        }
    }

    private PlatformAddressDO validateExists(Long id) {
        PlatformAddressDO row = platformAddressMapper.selectById(id);
        if (row == null) {
            throw exception(PLATFORM_ADDRESS_NOT_EXISTS);
        }
        return row;
    }

    private void validateUnique(Long id, Long platformId, String addressCode) {
        PlatformAddressDO exist = platformAddressMapper.selectByUnique(platformId, addressCode);
        if (exist != null && (id == null || !exist.getId().equals(id))) {
            throw exception(PLATFORM_ADDRESS_DUPLICATE);
        }
    }

}
