package cn.iocoder.yudao.module.base.service.city;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.city.vo.*;
import cn.iocoder.yudao.module.base.controller.admin.common.vo.BaseTranslationItemVO;
import cn.iocoder.yudao.module.base.dal.dataobject.city.CityDO;
import cn.iocoder.yudao.module.base.dal.dataobject.country.CountryDO;
import cn.iocoder.yudao.module.base.dal.dataobject.state.StateProvinceDO;
import cn.iocoder.yudao.module.base.dal.mysql.city.CityMapper;
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
public class CityServiceImpl implements CityService {

    private static final int COUNTRY_ACTIVE = 1;

    @Resource
    private CityMapper cityMapper;
    @Resource
    private CountryMapper countryMapper;
    @Resource
    private StateProvinceMapper stateProvinceMapper;
    @Resource
    private ZipCodeMapper zipCodeMapper;
    @Resource
    private PlatformAddressMapper platformAddressMapper;
    @Resource
    private EntityTranslationService entityTranslationService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createCity(CitySaveReqVO createReqVO) {
        normalizeCodes(createReqVO);
        validateCountryActive(createReqVO.getCountryCode());
        validateStateActive(createReqVO.getCountryCode(), createReqVO.getStateCode());
        validateUnique(null, createReqVO.getCountryCode(), createReqVO.getStateCode(), createReqVO.getNameEn());
        CityDO row = BeanUtils.toBean(createReqVO, CityDO.class);
        cityMapper.insert(row);
        saveTranslations(row.getId(), createReqVO.getTranslations());
        return row.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateCity(CitySaveReqVO updateReqVO) {
        CityDO existing = validateExists(updateReqVO.getId());
        normalizeCodes(updateReqVO);
        validateCountryActive(updateReqVO.getCountryCode());
        validateStateActive(updateReqVO.getCountryCode(), updateReqVO.getStateCode());
        if (!Objects.equals(existing.getCountryCode(), updateReqVO.getCountryCode())
                || !Objects.equals(existing.getStateCode(), updateReqVO.getStateCode())) {
            throw exception(CITY_REGION_NOT_MODIFIABLE);
        }
        updateReqVO.setCountryCode(existing.getCountryCode());
        updateReqVO.setStateCode(existing.getStateCode());
        validateUnique(updateReqVO.getId(), updateReqVO.getCountryCode(),
                updateReqVO.getStateCode(), updateReqVO.getNameEn());
        CityDO updateObj = BeanUtils.toBean(updateReqVO, CityDO.class);
        cityMapper.updateById(updateObj);
        saveTranslations(updateReqVO.getId(), updateReqVO.getTranslations());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteCity(Long id) {
        CityDO row = validateExists(id);
        if (zipCodeMapper.selectCountByCountryStateAndCityName(
                row.getCountryCode(), row.getStateCode(), row.getNameEn()) > 0) {
            throw exception(CITY_DELETE_HAS_ZIP);
        }
        if (platformAddressMapper.selectCountByCountryStateAndCity(
                row.getCountryCode(), row.getStateCode(), row.getNameEn()) > 0) {
            throw exception(CITY_DELETE_HAS_ADDRESS);
        }
        cityMapper.deleteById(id);
        entityTranslationService.saveTranslations(
                BaseEntityTypeEnum.CITY.getType(), id,
                BaseTranslationFieldEnum.NAME.getFieldName(), null);
    }

    @Override
    public void updateCityStatus(CityUpdateStatusReqVO reqVO) {
        validateExists(reqVO.getId());
        CityDO update = new CityDO();
        update.setId(reqVO.getId());
        update.setStatus(reqVO.getStatus());
        cityMapper.updateById(update);
    }

    @Override
    public CityRespVO getCity(Long id) {
        CityDO row = validateExists(id);
        String langCode = BaseLocaleUtils.getLangCode();
        CityRespVO resp = buildRespVO(row, langCode,
                buildCountryNameMap(Collections.singleton(row.getCountryCode()), langCode),
                buildStateNameMap(Collections.singletonList(row), langCode));
        List<BaseTranslationItemVO> items = entityTranslationService.getTranslationList(
                        BaseEntityTypeEnum.CITY.getType(), id, BaseTranslationFieldEnum.NAME.getFieldName())
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
    public PageResult<CityRespVO> getCityPage(CityPageReqVO pageReqVO) {
        if (StrUtil.isNotBlank(pageReqVO.getCountryCode())) {
            String countryCode = pageReqVO.getCountryCode().trim().toUpperCase();
            pageReqVO.setCountryCode(countryCode);
        }
        if (StrUtil.isNotBlank(pageReqVO.getStateCode())) {
            pageReqVO.setStateCode(pageReqVO.getStateCode().trim().toUpperCase());
        }
        PageResult<CityDO> pageResult = cityMapper.selectPage(pageReqVO);
        String langCode = BaseLocaleUtils.getLangCode();
        Set<String> countryCodes = pageResult.getList().stream()
                .map(CityDO::getCountryCode).collect(Collectors.toSet());
        Map<String, String> countryNameMap = buildCountryNameMap(countryCodes, langCode);
        Map<String, String> stateNameMap = buildStateNameMap(pageResult.getList(), langCode);
        List<CityRespVO> list = pageResult.getList().stream()
                .map(row -> buildRespVO(row, langCode, countryNameMap, stateNameMap))
                .collect(Collectors.toList());
        return new PageResult<>(list, pageResult.getTotal());
    }

    @Override
    public List<CityRespVO> getCitySimpleList(String countryCode, String stateCode, Integer status) {
        if (StrUtil.isNotBlank(countryCode)) {
            countryCode = countryCode.trim().toUpperCase();
        }
        if (StrUtil.isNotBlank(stateCode)) {
            stateCode = stateCode.trim().toUpperCase();
        }
        List<CityDO> list = cityMapper.selectSimpleList(countryCode, stateCode, status);
        String langCode = BaseLocaleUtils.getLangCode();
        Set<String> countryCodes = list.stream().map(CityDO::getCountryCode).collect(Collectors.toSet());
        Map<String, String> countryNameMap = buildCountryNameMap(countryCodes, langCode);
        Map<String, String> stateNameMap = buildStateNameMap(list, langCode);
        return list.stream()
                .map(row -> buildRespVO(row, langCode, countryNameMap, stateNameMap))
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public CityImportRespVO importCityList(List<CityImportExcelVO> importList, boolean updateSupport) {
        if (CollUtil.isEmpty(importList)) {
            throw exception(CITY_IMPORT_LIST_IS_EMPTY);
        }
        CityImportRespVO resp = CityImportRespVO.builder()
                .createKeys(new ArrayList<>())
                .updateKeys(new ArrayList<>())
                .failureKeys(new LinkedHashMap<>())
                .build();
        AtomicInteger index = new AtomicInteger(1);
        for (CityImportExcelVO row : importList) {
            int line = index.getAndIncrement();
            String key = StrUtil.format("{}:{}:{}",
                    StrUtil.blankToDefault(row.getCountryCode(), "?"),
                    StrUtil.blankToDefault(row.getStateCode(), "?"),
                    StrUtil.blankToDefault(row.getNameEn(), "第" + line + "行"));
            try {
                CitySaveReqVO saveReq = new CitySaveReqVO();
                saveReq.setCountryCode(row.getCountryCode());
                saveReq.setStateCode(row.getStateCode());
                saveReq.setNameEn(row.getNameEn());
                saveReq.setStatus(CommonStatusEnum.ENABLE.getStatus());
                normalizeCodes(saveReq);
                validateCountryActive(saveReq.getCountryCode());
                validateStateActive(saveReq.getCountryCode(), saveReq.getStateCode());
                if (StrUtil.isBlank(saveReq.getNameEn())) {
                    throw exception(CITY_IMPORT_ROW_INVALID, "城市英文名称不能为空");
                }
                CityDO exist = cityMapper.selectByUnique(
                        saveReq.getCountryCode(), saveReq.getStateCode(), saveReq.getNameEn());
                String successKey = saveReq.getCountryCode() + ":" + saveReq.getStateCode() + ":" + saveReq.getNameEn();
                if (exist == null) {
                    CityDO insert = BeanUtils.toBean(saveReq, CityDO.class);
                    cityMapper.insert(insert);
                    resp.getCreateKeys().add(successKey);
                } else if (!updateSupport) {
                    resp.getFailureKeys().put(key, CITY_DUPLICATE.getMsg());
                } else {
                    CityDO update = BeanUtils.toBean(saveReq, CityDO.class);
                    update.setId(exist.getId());
                    update.setCountryCode(exist.getCountryCode());
                    update.setStateCode(exist.getStateCode());
                    cityMapper.updateById(update);
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

    private CityRespVO buildRespVO(CityDO row, String langCode,
                                   Map<String, String> countryNameMap,
                                   Map<String, String> stateNameMap) {
        CityRespVO vo = BeanUtils.toBean(row, CityRespVO.class);
        vo.setCountryName(countryNameMap.getOrDefault(row.getCountryCode(), row.getCountryCode()));
        vo.setStateName(stateNameMap.getOrDefault(regionKey(row.getCountryCode(), row.getStateCode()),
                row.getStateCode()));
        Map<Long, String> displayMap = entityTranslationService.getDisplayNameMap(
                BaseEntityTypeEnum.CITY.getType(), BaseTranslationFieldEnum.NAME.getFieldName(),
                Collections.singleton(row.getId()), langCode);
        vo.setNameDisplay(displayMap.getOrDefault(row.getId(), row.getNameEn()));
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

    private Map<String, String> buildStateNameMap(List<CityDO> cities, String langCode) {
        if (CollUtil.isEmpty(cities)) {
            return Collections.emptyMap();
        }
        Set<String> countryCodes = cities.stream().map(CityDO::getCountryCode).collect(Collectors.toSet());
        List<StateProvinceDO> states = stateProvinceMapper.selectList(new LambdaQueryWrapperX<StateProvinceDO>()
                .in(StateProvinceDO::getCountryCode, countryCodes));
        if (CollUtil.isEmpty(states)) {
            return Collections.emptyMap();
        }
        Set<String> neededKeys = cities.stream()
                .map(c -> regionKey(c.getCountryCode(), c.getStateCode()))
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

    private void saveTranslations(Long cityId, List<BaseTranslationItemVO> translations) {
        if (translations == null) {
            return;
        }
        List<EntityTranslationService.CountryTranslationItem> items = translations.stream()
                .filter(t -> StrUtil.isNotBlank(t.getLangCode()) && StrUtil.isNotBlank(t.getValue()))
                .map(t -> new EntityTranslationService.CountryTranslationItem(t.getLangCode(), t.getValue()))
                .collect(Collectors.toList());
        entityTranslationService.saveTranslations(
                BaseEntityTypeEnum.CITY.getType(), cityId,
                BaseTranslationFieldEnum.NAME.getFieldName(), items);
    }

    private void validateCountryActive(String countryCode) {
        CountryDO country = countryMapper.selectByUnique(countryCode);
        if (country == null || !Objects.equals(country.getIsActive(), COUNTRY_ACTIVE)) {
            throw exception(CITY_COUNTRY_NOT_ACTIVE);
        }
    }

    private void validateStateActive(String countryCode, String stateCode) {
        StateProvinceDO state = stateProvinceMapper.selectByUnique(countryCode, stateCode);
        if (state == null
                || !Objects.equals(state.getStatus(), CommonStatusEnum.ENABLE.getStatus())) {
            throw exception(CITY_STATE_INVALID);
        }
    }

    private void normalizeCodes(CitySaveReqVO reqVO) {
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

    private CityDO validateExists(Long id) {
        CityDO row = cityMapper.selectById(id);
        if (row == null) {
            throw exception(CITY_NOT_EXISTS);
        }
        return row;
    }

    private void validateUnique(Long id, String countryCode, String stateCode, String nameEn) {
        CityDO exist = cityMapper.selectByUnique(countryCode, stateCode, nameEn);
        if (exist != null && (id == null || !exist.getId().equals(id))) {
            throw exception(CITY_DUPLICATE);
        }
    }

}
