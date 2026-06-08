package cn.iocoder.yudao.module.base.service.country;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.base.controller.admin.country.vo.*;
import cn.iocoder.yudao.module.base.dal.dataobject.country.CountryDO;
import cn.iocoder.yudao.module.base.dal.mysql.country.CountryMapper;
import cn.iocoder.yudao.module.base.dal.mysql.state.StateProvinceMapper;
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
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.base.enums.ErrorCodeConstants.*;

@Service
@Validated
public class CountryServiceImpl implements CountryService {

    private static final Pattern COUNTRY_CODE_PATTERN = Pattern.compile("^[A-Z]{2}$");
    private static final Pattern PHONE_CODE_PATTERN = Pattern.compile("^\\+?\\d+$");

    @Resource
    private CountryMapper countryMapper;
    @Resource
    private StateProvinceMapper stateProvinceMapper;
    @Resource
    private EntityTranslationService entityTranslationService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createCountry(CountrySaveReqVO createReqVO) {
        normalizeAndValidateCode(createReqVO);
        validatePhoneCode(createReqVO.getPhoneCode());
        validateUnique(null, createReqVO.getCode());
        CountryDO row = BeanUtils.toBean(createReqVO, CountryDO.class);
        countryMapper.insert(row);
        saveCountryTranslations(row.getId(), createReqVO.getTranslations());
        return row.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateCountry(CountrySaveReqVO updateReqVO) {
        CountryDO existing = validateExists(updateReqVO.getId());
        validatePhoneCode(updateReqVO.getPhoneCode());
        String normalizedCode = normalizeCode(updateReqVO.getCode());
        if (!Objects.equals(existing.getCode(), normalizedCode)) {
            throw exception(COUNTRY_CODE_NOT_MODIFIABLE);
        }
        updateReqVO.setCode(existing.getCode());
        CountryDO updateObj = BeanUtils.toBean(updateReqVO, CountryDO.class);
        countryMapper.updateById(updateObj);
        saveCountryTranslations(updateReqVO.getId(), updateReqVO.getTranslations());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteCountry(Long id) {
        CountryDO country = validateExists(id);
        if (stateProvinceMapper.selectCountByCountryCode(country.getCode()) > 0) {
            throw exception(COUNTRY_DELETE_HAS_STATE);
        }
        countryMapper.deleteById(id);
        entityTranslationService.saveTranslations(
                BaseEntityTypeEnum.COUNTRY.getType(), id, BaseTranslationFieldEnum.NAME.getFieldName(), null);
    }

    @Override
    public void updateCountryActive(CountryUpdateActiveReqVO reqVO) {
        validateExists(reqVO.getId());
        CountryDO update = new CountryDO();
        update.setId(reqVO.getId());
        update.setIsActive(reqVO.getIsActive());
        countryMapper.updateById(update);
    }

    @Override
    public CountryRespVO getCountry(Long id) {
        CountryDO row = validateExists(id);
        CountryRespVO resp = buildCountryRespVO(row, BaseLocaleUtils.getLangCode());
        List<CountryTranslationItemVO> items = entityTranslationService.getTranslationList(
                        BaseEntityTypeEnum.COUNTRY.getType(), id, BaseTranslationFieldEnum.NAME.getFieldName())
                .stream()
                .map(t -> {
                    CountryTranslationItemVO vo = new CountryTranslationItemVO();
                    vo.setLangCode(t.getLangCode());
                    vo.setValue(t.getValue());
                    return vo;
                })
                .collect(Collectors.toList());
        resp.setTranslations(items);
        return resp;
    }

    @Override
    public PageResult<CountryRespVO> getCountryPage(CountryPageReqVO pageReqVO) {
        PageResult<CountryDO> pageResult = countryMapper.selectPage(pageReqVO);
        String langCode = BaseLocaleUtils.getLangCode();
        List<CountryRespVO> list = buildCountryRespVOList(pageResult.getList(), langCode);
        return new PageResult<>(list, pageResult.getTotal());
    }

    @Override
    public List<CountryRespVO> getCountrySimpleList(Integer isActive) {
        List<CountryDO> list = countryMapper.selectSimpleList(isActive);
        return buildCountryRespVOList(list, BaseLocaleUtils.getLangCode());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public CountryImportRespVO importCountryList(List<CountryImportExcelVO> importList, boolean updateSupport) {
        if (CollUtil.isEmpty(importList)) {
            throw exception(COUNTRY_IMPORT_LIST_IS_EMPTY);
        }
        CountryImportRespVO resp = CountryImportRespVO.builder()
                .createCodes(new ArrayList<>())
                .updateCodes(new ArrayList<>())
                .failureCodes(new LinkedHashMap<>())
                .build();
        AtomicInteger index = new AtomicInteger(1);
        for (CountryImportExcelVO row : importList) {
            int line = index.getAndIncrement();
            String key = StrUtil.blankToDefault(row.getCode(), "第 " + line + " 行");
            try {
                CountrySaveReqVO saveReq = new CountrySaveReqVO();
                saveReq.setCode(row.getCode());
                saveReq.setNameEn(row.getNameEn());
                saveReq.setPhoneCode(row.getPhoneCode());
                saveReq.setCurrencyCode(row.getCurrencyCode());
                saveReq.setTimezoneDefault(row.getTimezoneDefault());
                saveReq.setIsActive(row.getIsActive() != null ? row.getIsActive() : 1);
                saveReq.setSortOrder(0);
                normalizeAndValidateCode(saveReq);
                validatePhoneCode(saveReq.getPhoneCode());
                if (StrUtil.isBlank(saveReq.getNameEn())) {
                    throw exception(COUNTRY_IMPORT_ROW_INVALID, "英文名称不能为空");
                }
                CountryDO exist = countryMapper.selectByUnique(saveReq.getCode());
                if (exist == null) {
                    CountryDO insert = BeanUtils.toBean(saveReq, CountryDO.class);
                    countryMapper.insert(insert);
                    resp.getCreateCodes().add(saveReq.getCode());
                } else if (!updateSupport) {
                    resp.getFailureCodes().put(key, COUNTRY_DUPLICATE.getMsg());
                } else {
                    saveReq.setId(exist.getId());
                    CountryDO update = BeanUtils.toBean(saveReq, CountryDO.class);
                    update.setId(exist.getId());
                    update.setCode(exist.getCode());
                    countryMapper.updateById(update);
                    resp.getUpdateCodes().add(saveReq.getCode());
                }
            } catch (ServiceException ex) {
                resp.getFailureCodes().put(key, ex.getMessage());
            } catch (Exception ex) {
                resp.getFailureCodes().put(key, StrUtil.blankToDefault(ex.getMessage(), "导入失败"));
            }
        }
        return resp;
    }

    private void saveCountryTranslations(Long countryId, List<CountryTranslationItemVO> translations) {
        if (translations == null) {
            return;
        }
        List<EntityTranslationService.CountryTranslationItem> items = translations.stream()
                .filter(t -> StrUtil.isNotBlank(t.getLangCode()) && StrUtil.isNotBlank(t.getValue()))
                .map(t -> new EntityTranslationService.CountryTranslationItem(t.getLangCode(), t.getValue()))
                .collect(Collectors.toList());
        entityTranslationService.saveTranslations(
                BaseEntityTypeEnum.COUNTRY.getType(), countryId,
                BaseTranslationFieldEnum.NAME.getFieldName(), items);
    }

    private List<CountryRespVO> buildCountryRespVOList(List<CountryDO> rows, String langCode) {
        if (CollUtil.isEmpty(rows)) {
            return Collections.emptyList();
        }
        List<Long> ids = rows.stream().map(CountryDO::getId).collect(Collectors.toList());
        Map<Long, String> displayMap = entityTranslationService.getDisplayNameMap(
                BaseEntityTypeEnum.COUNTRY.getType(), BaseTranslationFieldEnum.NAME.getFieldName(), ids, langCode);
        return rows.stream().map(row -> {
            CountryRespVO vo = BeanUtils.toBean(row, CountryRespVO.class);
            vo.setNameDisplay(displayMap.getOrDefault(row.getId(), row.getNameEn()));
            vo.setStateProvinceCount(stateProvinceMapper.selectCountByCountryCode(row.getCode()));
            return vo;
        }).collect(Collectors.toList());
    }

    private CountryRespVO buildCountryRespVO(CountryDO row, String langCode) {
        CountryRespVO vo = BeanUtils.toBean(row, CountryRespVO.class);
        Map<Long, String> displayMap = entityTranslationService.getDisplayNameMap(
                BaseEntityTypeEnum.COUNTRY.getType(), BaseTranslationFieldEnum.NAME.getFieldName(),
                Collections.singleton(row.getId()), langCode);
        vo.setNameDisplay(displayMap.getOrDefault(row.getId(), row.getNameEn()));
        vo.setStateProvinceCount(stateProvinceMapper.selectCountByCountryCode(row.getCode()));
        return vo;
    }

    private CountryDO validateExists(Long id) {
        CountryDO country = countryMapper.selectById(id);
        if (country == null) {
            throw exception(COUNTRY_NOT_EXISTS);
        }
        return country;
    }

    private void normalizeAndValidateCode(CountrySaveReqVO reqVO) {
        reqVO.setCode(normalizeCode(reqVO.getCode()));
        if (StrUtil.isBlank(reqVO.getCode()) || !COUNTRY_CODE_PATTERN.matcher(reqVO.getCode()).matches()) {
            throw exception(COUNTRY_CODE_INVALID);
        }
    }

    private String normalizeCode(String code) {
        return code == null ? null : code.trim().toUpperCase();
    }

    private void validatePhoneCode(String phoneCode) {
        if (StrUtil.isBlank(phoneCode)) {
            return;
        }
        if (!PHONE_CODE_PATTERN.matcher(phoneCode.trim()).matches()) {
            throw exception(COUNTRY_PHONE_CODE_INVALID);
        }
    }

    private void validateUnique(Long id, String code) {
        CountryDO exist = countryMapper.selectByUnique(code);
        if (exist != null && (id == null || !exist.getId().equals(id))) {
            throw exception(COUNTRY_DUPLICATE);
        }
    }

}
