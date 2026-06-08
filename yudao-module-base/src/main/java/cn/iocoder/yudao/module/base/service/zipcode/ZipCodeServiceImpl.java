package cn.iocoder.yudao.module.base.service.zipcode;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.zipcode.vo.*;
import cn.iocoder.yudao.module.base.dal.dataobject.country.CountryDO;
import cn.iocoder.yudao.module.base.dal.dataobject.state.StateProvinceDO;
import cn.iocoder.yudao.module.base.dal.dataobject.zipcode.ZipCodeDO;
import cn.iocoder.yudao.module.base.dal.mysql.country.CountryMapper;
import cn.iocoder.yudao.module.base.dal.mysql.platformaddress.PlatformAddressMapper;
import cn.iocoder.yudao.module.base.dal.mysql.state.StateProvinceMapper;
import cn.iocoder.yudao.module.base.dal.mysql.zipcode.ZipCodeMapper;
import cn.iocoder.yudao.module.base.enums.BaseEntityTypeEnum;
import cn.iocoder.yudao.module.base.enums.BaseTranslationFieldEnum;
import cn.iocoder.yudao.module.base.framework.web.BaseLocaleUtils;
import cn.iocoder.yudao.module.base.service.i18n.EntityTranslationService;
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
public class ZipCodeServiceImpl implements ZipCodeService {

    private static final int COUNTRY_ACTIVE = 1;

    @Resource
    private ZipCodeMapper zipCodeMapper;
    @Resource
    private CountryMapper countryMapper;
    @Resource
    private StateProvinceMapper stateProvinceMapper;
    @Resource
    private PlatformAddressMapper platformAddressMapper;
    @Resource
    private EntityTranslationService entityTranslationService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createZipCode(ZipCodeSaveReqVO createReqVO) {
        normalizeFields(createReqVO);
        validateCountryActive(createReqVO.getCountryCode());
        validateStateIfPresent(createReqVO.getCountryCode(), createReqVO.getStateCode());
        validateUnique(null, createReqVO.getCountryCode(), createReqVO.getZip());
        ZipCodeDO row = BeanUtils.toBean(createReqVO, ZipCodeDO.class);
        zipCodeMapper.insert(row);
        return row.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateZipCode(ZipCodeSaveReqVO updateReqVO) {
        ZipCodeDO existing = validateExists(updateReqVO.getId());
        normalizeFields(updateReqVO);
        validateCountryActive(updateReqVO.getCountryCode());
        validateStateIfPresent(updateReqVO.getCountryCode(), updateReqVO.getStateCode());
        if (!Objects.equals(existing.getCountryCode(), updateReqVO.getCountryCode())
                || !Objects.equals(existing.getZip(), updateReqVO.getZip())) {
            throw exception(ZIP_CODE_KEY_NOT_MODIFIABLE);
        }
        updateReqVO.setCountryCode(existing.getCountryCode());
        updateReqVO.setZip(existing.getZip());
        ZipCodeDO updateObj = BeanUtils.toBean(updateReqVO, ZipCodeDO.class);
        zipCodeMapper.updateById(updateObj);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteZipCode(Long id) {
        ZipCodeDO row = validateExists(id);
        if (platformAddressMapper.selectCountByCountryAndZipCode(row.getCountryCode(), row.getZip()) > 0) {
            throw exception(ZIP_CODE_DELETE_HAS_ADDRESS);
        }
        zipCodeMapper.deleteById(id);
    }

    @Override
    public ZipCodeRespVO getZipCode(Long id) {
        ZipCodeDO row = validateExists(id);
        String langCode = BaseLocaleUtils.getLangCode();
        return buildRespVO(row, langCode,
                buildCountryNameMap(Collections.singleton(row.getCountryCode()), langCode),
                buildStateNameMap(Collections.singletonList(row), langCode));
    }

    @Override
    public PageResult<ZipCodeRespVO> getZipCodePage(ZipCodePageReqVO pageReqVO) {
        if (StrUtil.isNotBlank(pageReqVO.getCountryCode())) {
            pageReqVO.setCountryCode(pageReqVO.getCountryCode().trim().toUpperCase());
        }
        if (StrUtil.isNotBlank(pageReqVO.getStateCode())) {
            pageReqVO.setStateCode(pageReqVO.getStateCode().trim().toUpperCase());
        }
        PageResult<ZipCodeDO> pageResult = zipCodeMapper.selectPage(pageReqVO);
        String langCode = BaseLocaleUtils.getLangCode();
        Set<String> countryCodes = pageResult.getList().stream()
                .map(ZipCodeDO::getCountryCode).collect(Collectors.toSet());
        Map<String, String> countryNameMap = buildCountryNameMap(countryCodes, langCode);
        Map<String, String> stateNameMap = buildStateNameMap(pageResult.getList(), langCode);
        List<ZipCodeRespVO> list = pageResult.getList().stream()
                .map(row -> buildRespVO(row, langCode, countryNameMap, stateNameMap))
                .collect(Collectors.toList());
        return new PageResult<>(list, pageResult.getTotal());
    }

    @Override
    public List<ZipCodeRespVO> getZipCodeSimpleList(String countryCode, String zip) {
        if (StrUtil.isNotBlank(countryCode)) {
            countryCode = countryCode.trim().toUpperCase();
        }
        if (StrUtil.isNotBlank(zip)) {
            zip = zip.trim();
        }
        List<ZipCodeDO> list = zipCodeMapper.selectSimpleList(countryCode, zip);
        String langCode = BaseLocaleUtils.getLangCode();
        Set<String> countryCodes = list.stream().map(ZipCodeDO::getCountryCode).collect(Collectors.toSet());
        Map<String, String> countryNameMap = buildCountryNameMap(countryCodes, langCode);
        Map<String, String> stateNameMap = buildStateNameMap(list, langCode);
        return list.stream()
                .map(row -> buildRespVO(row, langCode, countryNameMap, stateNameMap))
                .collect(Collectors.toList());
    }

    @Override
    public ZipCodeLookupRespVO lookupZipCode(String countryCode, String zip) {
        if (StrUtil.hasBlank(countryCode, zip)) {
            return new ZipCodeLookupRespVO();
        }
        countryCode = countryCode.trim().toUpperCase();
        zip = zip.trim();
        ZipCodeDO row = zipCodeMapper.selectByCountryAndZip(countryCode, zip);
        if (row == null) {
            return new ZipCodeLookupRespVO();
        }
        ZipCodeLookupRespVO resp = new ZipCodeLookupRespVO();
        resp.setStateCode(row.getStateCode());
        resp.setCityName(row.getCityName());
        if (StrUtil.isNotBlank(row.getStateCode())) {
            StateProvinceDO state = stateProvinceMapper.selectByUnique(countryCode, row.getStateCode());
            if (state != null) {
                String langCode = BaseLocaleUtils.getLangCode();
                Map<Long, String> displayMap = entityTranslationService.getDisplayNameMap(
                        BaseEntityTypeEnum.STATE_PROVINCE.getType(),
                        BaseTranslationFieldEnum.NAME.getFieldName(),
                        Collections.singleton(state.getId()), langCode);
                resp.setStateName(displayMap.getOrDefault(state.getId(), state.getNameEn()));
            }
        }
        return resp;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public ZipCodeImportRespVO importZipCodeList(List<ZipCodeImportExcelVO> importList, boolean updateSupport) {
        if (CollUtil.isEmpty(importList)) {
            throw exception(ZIP_CODE_IMPORT_LIST_IS_EMPTY);
        }
        ZipCodeImportRespVO resp = ZipCodeImportRespVO.builder()
                .createKeys(new ArrayList<>())
                .updateKeys(new ArrayList<>())
                .failureKeys(new LinkedHashMap<>())
                .build();
        AtomicInteger index = new AtomicInteger(1);
        for (ZipCodeImportExcelVO row : importList) {
            int line = index.getAndIncrement();
            String key = StrUtil.format("{}:{}",
                    StrUtil.blankToDefault(row.getCountryCode(), "?"),
                    StrUtil.blankToDefault(row.getZip(), "第" + line + "行"));
            try {
                ZipCodeSaveReqVO saveReq = new ZipCodeSaveReqVO();
                saveReq.setCountryCode(row.getCountryCode());
                saveReq.setStateCode(row.getStateCode());
                saveReq.setCityName(row.getCityName());
                saveReq.setZip(row.getZip());
                normalizeFields(saveReq);
                validateCountryActive(saveReq.getCountryCode());
                validateStateIfPresent(saveReq.getCountryCode(), saveReq.getStateCode());
                if (StrUtil.isBlank(saveReq.getZip()) || StrUtil.isBlank(saveReq.getCityName())) {
                    throw exception(ZIP_CODE_IMPORT_ROW_INVALID, "邮编与城市名称不能为空");
                }
                ZipCodeDO exist = zipCodeMapper.selectByUnique(saveReq.getCountryCode(), saveReq.getZip());
                String successKey = saveReq.getCountryCode() + ":" + saveReq.getZip();
                if (exist == null) {
                    ZipCodeDO insert = BeanUtils.toBean(saveReq, ZipCodeDO.class);
                    zipCodeMapper.insert(insert);
                    resp.getCreateKeys().add(successKey);
                } else if (!updateSupport) {
                    resp.getFailureKeys().put(key, ZIP_CODE_DUPLICATE.getMsg());
                } else {
                    ZipCodeDO update = BeanUtils.toBean(saveReq, ZipCodeDO.class);
                    update.setId(exist.getId());
                    update.setCountryCode(exist.getCountryCode());
                    update.setZip(exist.getZip());
                    zipCodeMapper.updateById(update);
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

    private ZipCodeRespVO buildRespVO(ZipCodeDO row, String langCode,
                                      Map<String, String> countryNameMap,
                                      Map<String, String> stateNameMap) {
        ZipCodeRespVO vo = BeanUtils.toBean(row, ZipCodeRespVO.class);
        vo.setCountryName(countryNameMap.getOrDefault(row.getCountryCode(), row.getCountryCode()));
        if (StrUtil.isNotBlank(row.getStateCode())) {
            vo.setStateName(stateNameMap.getOrDefault(
                    regionKey(row.getCountryCode(), row.getStateCode()), row.getStateCode()));
        }
        return vo;
    }

    private Map<String, String> buildCountryNameMap(Set<String> countryCodes, String langCode) {
        if (CollUtil.isEmpty(countryCodes)) {
            return Collections.emptyMap();
        }
        List<CountryDO> countries = countryMapper.selectList(new LambdaQueryWrapperX<CountryDO>()
                .in(CountryDO::getCode, countryCodes));
        if (CollUtil.isEmpty(countries)) {
            return Collections.emptyMap();
        }
        List<Long> countryIds = countries.stream().map(CountryDO::getId).collect(Collectors.toList());
        Map<Long, String> displayById = entityTranslationService.getDisplayNameMap(
                BaseEntityTypeEnum.COUNTRY.getType(), BaseTranslationFieldEnum.NAME.getFieldName(),
                countryIds, langCode);
        Map<String, String> result = new HashMap<>();
        for (CountryDO country : countries) {
            result.put(country.getCode(),
                    displayById.getOrDefault(country.getId(), country.getNameEn()));
        }
        return result;
    }

    private Map<String, String> buildStateNameMap(List<ZipCodeDO> rows, String langCode) {
        if (CollUtil.isEmpty(rows)) {
            return Collections.emptyMap();
        }
        Set<String> countryCodes = rows.stream()
                .map(ZipCodeDO::getCountryCode)
                .filter(StrUtil::isNotBlank)
                .collect(Collectors.toSet());
        List<StateProvinceDO> states = stateProvinceMapper.selectList(new LambdaQueryWrapperX<StateProvinceDO>()
                .in(StateProvinceDO::getCountryCode, countryCodes));
        if (CollUtil.isEmpty(states)) {
            return Collections.emptyMap();
        }
        Set<String> neededKeys = rows.stream()
                .filter(r -> StrUtil.isNotBlank(r.getStateCode()))
                .map(r -> regionKey(r.getCountryCode(), r.getStateCode()))
                .collect(Collectors.toSet());
        Map<String, StateProvinceDO> stateByKey = new HashMap<>();
        for (StateProvinceDO state : states) {
            String key = regionKey(state.getCountryCode(), state.getCode());
            if (neededKeys.contains(key)) {
                stateByKey.put(key, state);
            }
        }
        if (stateByKey.isEmpty()) {
            return Collections.emptyMap();
        }
        List<Long> stateIds = stateByKey.values().stream().map(StateProvinceDO::getId).collect(Collectors.toList());
        Map<Long, String> displayById = entityTranslationService.getDisplayNameMap(
                BaseEntityTypeEnum.STATE_PROVINCE.getType(), BaseTranslationFieldEnum.NAME.getFieldName(),
                stateIds, langCode);
        Map<String, String> result = new HashMap<>();
        for (Map.Entry<String, StateProvinceDO> entry : stateByKey.entrySet()) {
            StateProvinceDO state = entry.getValue();
            result.put(entry.getKey(), displayById.getOrDefault(state.getId(), state.getNameEn()));
        }
        return result;
    }

    private static String regionKey(String countryCode, String stateCode) {
        return countryCode + ":" + stateCode;
    }

    private void validateCountryActive(String countryCode) {
        CountryDO country = countryMapper.selectByUnique(countryCode);
        if (country == null || !Objects.equals(country.getIsActive(), COUNTRY_ACTIVE)) {
            throw exception(ZIP_CODE_COUNTRY_NOT_ACTIVE);
        }
    }

    private void validateStateIfPresent(String countryCode, String stateCode) {
        if (StrUtil.isBlank(stateCode)) {
            return;
        }
        StateProvinceDO state = stateProvinceMapper.selectByUnique(countryCode, stateCode);
        if (state == null
                || !Objects.equals(state.getStatus(), CommonStatusEnum.ENABLE.getStatus())) {
            throw exception(ZIP_CODE_STATE_INVALID);
        }
    }

    private void normalizeFields(ZipCodeSaveReqVO reqVO) {
        if (reqVO.getCountryCode() != null) {
            reqVO.setCountryCode(reqVO.getCountryCode().trim().toUpperCase());
        }
        if (reqVO.getStateCode() != null) {
            reqVO.setStateCode(reqVO.getStateCode().trim().toUpperCase());
        }
        if (reqVO.getZip() != null) {
            reqVO.setZip(reqVO.getZip().trim());
        }
        if (reqVO.getCityName() != null) {
            reqVO.setCityName(reqVO.getCityName().trim());
        }
    }

    private ZipCodeDO validateExists(Long id) {
        ZipCodeDO row = zipCodeMapper.selectById(id);
        if (row == null) {
            throw exception(ZIP_CODE_NOT_EXISTS);
        }
        return row;
    }

    private void validateUnique(Long id, String countryCode, String zip) {
        ZipCodeDO exist = zipCodeMapper.selectByUnique(countryCode, zip);
        if (exist != null && (id == null || !exist.getId().equals(id))) {
            throw exception(ZIP_CODE_DUPLICATE);
        }
    }

}
