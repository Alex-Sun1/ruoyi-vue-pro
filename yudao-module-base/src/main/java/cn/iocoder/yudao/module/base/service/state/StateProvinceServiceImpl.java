package cn.iocoder.yudao.module.base.service.state;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.common.vo.BaseTranslationItemVO;
import cn.iocoder.yudao.module.base.controller.admin.state.vo.*;
import cn.iocoder.yudao.module.base.dal.dataobject.country.CountryDO;
import cn.iocoder.yudao.module.base.dal.dataobject.state.StateProvinceDO;
import cn.iocoder.yudao.module.base.dal.mysql.city.CityMapper;
import cn.iocoder.yudao.module.base.dal.mysql.country.CountryMapper;
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
public class StateProvinceServiceImpl implements StateProvinceService {

    private static final int COUNTRY_ACTIVE = 1;

    @Resource
    private StateProvinceMapper stateProvinceMapper;
    @Resource
    private CountryMapper countryMapper;
    @Resource
    private CityMapper cityMapper;
    @Resource
    private ZipCodeMapper zipCodeMapper;
    @Resource
    private EntityTranslationService entityTranslationService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createStateProvince(StateProvinceSaveReqVO createReqVO) {
        normalizeCodes(createReqVO);
        validateCountryActive(createReqVO.getCountryCode());
        validateUnique(null, createReqVO.getCountryCode(), createReqVO.getCode());
        StateProvinceDO row = BeanUtils.toBean(createReqVO, StateProvinceDO.class);
        stateProvinceMapper.insert(row);
        saveTranslations(row.getId(), createReqVO.getTranslations());
        return row.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateStateProvince(StateProvinceSaveReqVO updateReqVO) {
        StateProvinceDO existing = validateExists(updateReqVO.getId());
        normalizeCodes(updateReqVO);
        validateCountryActive(updateReqVO.getCountryCode());
        if (!Objects.equals(existing.getCode(), updateReqVO.getCode())
                || !Objects.equals(existing.getCountryCode(), updateReqVO.getCountryCode())) {
            throw exception(STATE_PROVINCE_CODE_NOT_MODIFIABLE);
        }
        updateReqVO.setCode(existing.getCode());
        updateReqVO.setCountryCode(existing.getCountryCode());
        StateProvinceDO updateObj = BeanUtils.toBean(updateReqVO, StateProvinceDO.class);
        stateProvinceMapper.updateById(updateObj);
        saveTranslations(updateReqVO.getId(), updateReqVO.getTranslations());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteStateProvince(Long id) {
        StateProvinceDO row = validateExists(id);
        if (cityMapper.selectCountByCountryAndState(row.getCountryCode(), row.getCode()) > 0) {
            throw exception(STATE_PROVINCE_DELETE_HAS_CITY);
        }
        if (zipCodeMapper.selectCountByCountryAndState(row.getCountryCode(), row.getCode()) > 0) {
            throw exception(STATE_PROVINCE_DELETE_HAS_ZIP);
        }
        stateProvinceMapper.deleteById(id);
        entityTranslationService.saveTranslations(
                BaseEntityTypeEnum.STATE_PROVINCE.getType(), id,
                BaseTranslationFieldEnum.NAME.getFieldName(), null);
    }

    @Override
    public void updateStateProvinceStatus(StateProvinceUpdateStatusReqVO reqVO) {
        validateExists(reqVO.getId());
        StateProvinceDO update = new StateProvinceDO();
        update.setId(reqVO.getId());
        update.setStatus(reqVO.getStatus());
        stateProvinceMapper.updateById(update);
    }

    @Override
    public StateProvinceRespVO getStateProvince(Long id) {
        StateProvinceDO row = validateExists(id);
        String langCode = BaseLocaleUtils.getLangCode();
        StateProvinceRespVO resp = buildRespVO(row, langCode, buildCountryNameMap(
                Collections.singleton(row.getCountryCode()), langCode));
        List<BaseTranslationItemVO> items = entityTranslationService.getTranslationList(
                        BaseEntityTypeEnum.STATE_PROVINCE.getType(), id, BaseTranslationFieldEnum.NAME.getFieldName())
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
    public PageResult<StateProvinceRespVO> getStateProvincePage(StateProvincePageReqVO pageReqVO) {
        if (StrUtil.isNotBlank(pageReqVO.getCountryCode())) {
            String countryCode = pageReqVO.getCountryCode().trim().toUpperCase();
            pageReqVO.setCountryCode(countryCode);
            validateCountryActive(countryCode);
        }
        PageResult<StateProvinceDO> pageResult = stateProvinceMapper.selectPage(pageReqVO);
        String langCode = BaseLocaleUtils.getLangCode();
        Set<String> countryCodes = pageResult.getList().stream()
                .map(StateProvinceDO::getCountryCode).collect(Collectors.toSet());
        Map<String, String> countryNameMap = buildCountryNameMap(countryCodes, langCode);
        List<StateProvinceRespVO> list = pageResult.getList().stream()
                .map(row -> buildRespVO(row, langCode, countryNameMap))
                .collect(Collectors.toList());
        return new PageResult<>(list, pageResult.getTotal());
    }

    @Override
    public List<StateProvinceRespVO> getStateProvinceSimpleList(String countryCode, Integer status) {
        if (StrUtil.isNotBlank(countryCode)) {
            validateCountryActive(countryCode.trim().toUpperCase());
            countryCode = countryCode.trim().toUpperCase();
        }
        List<StateProvinceDO> list = stateProvinceMapper.selectSimpleList(countryCode, status);
        String langCode = BaseLocaleUtils.getLangCode();
        Map<String, String> countryNameMap = buildCountryNameMap(
                list.stream().map(StateProvinceDO::getCountryCode).collect(Collectors.toSet()), langCode);
        return list.stream().map(row -> buildRespVO(row, langCode, countryNameMap)).collect(Collectors.toList());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public StateProvinceImportRespVO importStateProvinceList(List<StateProvinceImportExcelVO> importList,
                                                               boolean updateSupport) {
        if (CollUtil.isEmpty(importList)) {
            throw exception(STATE_PROVINCE_IMPORT_LIST_IS_EMPTY);
        }
        StateProvinceImportRespVO resp = StateProvinceImportRespVO.builder()
                .createKeys(new ArrayList<>())
                .updateKeys(new ArrayList<>())
                .failureKeys(new LinkedHashMap<>())
                .build();
        AtomicInteger index = new AtomicInteger(1);
        for (StateProvinceImportExcelVO row : importList) {
            int line = index.getAndIncrement();
            String key = StrUtil.format("{}:{}",
                    StrUtil.blankToDefault(row.getCountryCode(), "?"),
                    StrUtil.blankToDefault(row.getCode(), "第" + line + "行"));
            try {
                StateProvinceSaveReqVO saveReq = new StateProvinceSaveReqVO();
                saveReq.setCountryCode(row.getCountryCode());
                saveReq.setCode(row.getCode());
                saveReq.setNameEn(row.getNameEn());
                saveReq.setSortOrder(0);
                saveReq.setStatus(0);
                normalizeCodes(saveReq);
                validateCountryActive(saveReq.getCountryCode());
                if (StrUtil.isBlank(saveReq.getNameEn())) {
                    throw exception(STATE_PROVINCE_IMPORT_ROW_INVALID, "英文名称不能为空");
                }
                StateProvinceDO exist = stateProvinceMapper.selectByUnique(
                        saveReq.getCountryCode(), saveReq.getCode());
                String successKey = saveReq.getCountryCode() + ":" + saveReq.getCode();
                if (exist == null) {
                    StateProvinceDO insert = BeanUtils.toBean(saveReq, StateProvinceDO.class);
                    stateProvinceMapper.insert(insert);
                    resp.getCreateKeys().add(successKey);
                } else if (!updateSupport) {
                    resp.getFailureKeys().put(key, STATE_PROVINCE_DUPLICATE.getMsg());
                } else {
                    saveReq.setId(exist.getId());
                    StateProvinceDO update = BeanUtils.toBean(saveReq, StateProvinceDO.class);
                    update.setId(exist.getId());
                    update.setCode(exist.getCode());
                    update.setCountryCode(exist.getCountryCode());
                    stateProvinceMapper.updateById(update);
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

    private StateProvinceRespVO buildRespVO(StateProvinceDO row, String langCode,
                                              Map<String, String> countryNameMap) {
        StateProvinceRespVO vo = BeanUtils.toBean(row, StateProvinceRespVO.class);
        vo.setCountryName(countryNameMap.getOrDefault(row.getCountryCode(), row.getCountryCode()));
        Map<Long, String> displayMap = entityTranslationService.getDisplayNameMap(
                BaseEntityTypeEnum.STATE_PROVINCE.getType(), BaseTranslationFieldEnum.NAME.getFieldName(),
                Collections.singleton(row.getId()), langCode);
        vo.setNameDisplay(displayMap.getOrDefault(row.getId(), row.getNameEn()));
        vo.setCityCount(cityMapper.selectCountByCountryAndState(row.getCountryCode(), row.getCode()));
        vo.setZipCodeCount(zipCodeMapper.selectCountByCountryAndState(row.getCountryCode(), row.getCode()));
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

    private void saveTranslations(Long stateId, List<BaseTranslationItemVO> translations) {
        if (translations == null) {
            return;
        }
        List<EntityTranslationService.CountryTranslationItem> items = translations.stream()
                .filter(t -> StrUtil.isNotBlank(t.getLangCode()) && StrUtil.isNotBlank(t.getValue()))
                .map(t -> new EntityTranslationService.CountryTranslationItem(t.getLangCode(), t.getValue()))
                .collect(Collectors.toList());
        entityTranslationService.saveTranslations(
                BaseEntityTypeEnum.STATE_PROVINCE.getType(), stateId,
                BaseTranslationFieldEnum.NAME.getFieldName(), items);
    }

    private void validateCountryActive(String countryCode) {
        CountryDO country = countryMapper.selectByUnique(countryCode);
        if (country == null || !Objects.equals(country.getIsActive(), COUNTRY_ACTIVE)) {
            throw exception(STATE_PROVINCE_COUNTRY_NOT_ACTIVE);
        }
    }

    private void normalizeCodes(StateProvinceSaveReqVO reqVO) {
        if (reqVO.getCountryCode() != null) {
            reqVO.setCountryCode(reqVO.getCountryCode().trim().toUpperCase());
        }
        if (reqVO.getCode() != null) {
            reqVO.setCode(reqVO.getCode().trim().toUpperCase());
        }
    }

    private StateProvinceDO validateExists(Long id) {
        StateProvinceDO row = stateProvinceMapper.selectById(id);
        if (row == null) {
            throw exception(STATE_PROVINCE_NOT_EXISTS);
        }
        return row;
    }

    private void validateUnique(Long id, String countryCode, String code) {
        StateProvinceDO exist = stateProvinceMapper.selectByUnique(countryCode, code);
        if (exist != null && (id == null || !exist.getId().equals(id))) {
            throw exception(STATE_PROVINCE_DUPLICATE);
        }
    }

}
