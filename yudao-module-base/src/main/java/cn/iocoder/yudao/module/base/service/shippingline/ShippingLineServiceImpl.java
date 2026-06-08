package cn.iocoder.yudao.module.base.service.shippingline;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.common.vo.BaseTranslationItemVO;
import cn.iocoder.yudao.module.base.controller.admin.shippingline.vo.*;
import cn.iocoder.yudao.module.base.dal.dataobject.country.CountryDO;
import cn.iocoder.yudao.module.base.dal.dataobject.shippingline.ShippingLineDO;
import cn.iocoder.yudao.module.base.dal.mysql.country.CountryMapper;
import cn.iocoder.yudao.module.base.dal.mysql.shippingline.ShippingLineMapper;
import cn.iocoder.yudao.module.base.enums.BaseEntityTypeEnum;
import cn.iocoder.yudao.module.base.enums.BaseTranslationFieldEnum;
import cn.iocoder.yudao.module.base.framework.web.BaseLocaleUtils;
import cn.iocoder.yudao.module.base.service.i18n.EntityTranslationService;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.util.*;
import java.util.stream.Collectors;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.base.enums.ErrorCodeConstants.*;

@Service
@Validated
public class ShippingLineServiceImpl implements ShippingLineService {

    private static final int COUNTRY_ACTIVE = 1;
    private static final String CONTAINER_NO_PLACEHOLDER = "{container_no}";

    @Resource
    private ShippingLineMapper shippingLineMapper;
    @Resource
    private CountryMapper countryMapper;
    @Resource
    private EntityTranslationService entityTranslationService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createShippingLine(ShippingLineSaveReqVO createReqVO) {
        normalizeFields(createReqVO);
        validateCountryIfPresent(createReqVO.getCountryCode());
        validateTrackingUrl(createReqVO.getTrackingUrl());
        validateUnique(null, createReqVO.getCode());
        if (createReqVO.getStatus() == null) {
            createReqVO.setStatus(CommonStatusEnum.ENABLE.getStatus());
        }
        ShippingLineDO row = BeanUtils.toBean(createReqVO, ShippingLineDO.class);
        shippingLineMapper.insert(row);
        saveTranslations(row.getId(), createReqVO.getTranslations());
        return row.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateShippingLine(ShippingLineSaveReqVO updateReqVO) {
        ShippingLineDO existing = validateExists(updateReqVO.getId());
        normalizeFields(updateReqVO);
        validateCountryIfPresent(updateReqVO.getCountryCode());
        validateTrackingUrl(updateReqVO.getTrackingUrl());
        if (!Objects.equals(existing.getCode(), updateReqVO.getCode())) {
            throw exception(SHIPPING_LINE_CODE_NOT_MODIFIABLE);
        }
        updateReqVO.setCode(existing.getCode());
        ShippingLineDO updateObj = BeanUtils.toBean(updateReqVO, ShippingLineDO.class);
        updateObj.setStatus(existing.getStatus());
        shippingLineMapper.updateById(updateObj);
        saveTranslations(updateReqVO.getId(), updateReqVO.getTranslations());
    }

    @Override
    public void updateShippingLineStatus(ShippingLineUpdateStatusReqVO reqVO) {
        validateExists(reqVO.getId());
        ShippingLineDO update = new ShippingLineDO();
        update.setId(reqVO.getId());
        update.setStatus(reqVO.getStatus());
        shippingLineMapper.updateById(update);
    }

    @Override
    public ShippingLineRespVO getShippingLine(Long id) {
        ShippingLineDO row = validateExists(id);
        String langCode = BaseLocaleUtils.getLangCode();
        ShippingLineRespVO resp = buildRespVO(row, langCode,
                buildCountryNameMap(collectCountryCodes(Collections.singletonList(row)), langCode));
        List<BaseTranslationItemVO> items = entityTranslationService.getTranslationList(
                        BaseEntityTypeEnum.SHIPPING_LINE.getType(), id,
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
    public PageResult<ShippingLineRespVO> getShippingLinePage(ShippingLinePageReqVO pageReqVO) {
        if (StrUtil.isNotBlank(pageReqVO.getCountryCode())) {
            pageReqVO.setCountryCode(pageReqVO.getCountryCode().trim().toUpperCase());
        }
        PageResult<ShippingLineDO> pageResult = shippingLineMapper.selectPage(pageReqVO);
        String langCode = BaseLocaleUtils.getLangCode();
        Map<String, String> countryNameMap = buildCountryNameMap(
                collectCountryCodes(pageResult.getList()), langCode);
        List<ShippingLineRespVO> list = pageResult.getList().stream()
                .map(row -> buildRespVO(row, langCode, countryNameMap))
                .collect(Collectors.toList());
        return new PageResult<>(list, pageResult.getTotal());
    }

    @Override
    public List<ShippingLineRespVO> getShippingLineSimpleList(Integer status) {
        List<ShippingLineDO> list = shippingLineMapper.selectSimpleList(status);
        String langCode = BaseLocaleUtils.getLangCode();
        Map<String, String> countryNameMap = buildCountryNameMap(collectCountryCodes(list), langCode);
        return list.stream()
                .map(row -> buildRespVO(row, langCode, countryNameMap))
                .collect(Collectors.toList());
    }

    private ShippingLineRespVO buildRespVO(ShippingLineDO row, String langCode,
                                         Map<String, String> countryNameMap) {
        ShippingLineRespVO vo = BeanUtils.toBean(row, ShippingLineRespVO.class);
        if (StrUtil.isNotBlank(row.getCountryCode())) {
            vo.setCountryName(countryNameMap.getOrDefault(row.getCountryCode(), row.getCountryCode()));
        }
        Map<Long, String> displayMap = entityTranslationService.getDisplayNameMap(
                BaseEntityTypeEnum.SHIPPING_LINE.getType(), BaseTranslationFieldEnum.NAME.getFieldName(),
                Collections.singleton(row.getId()), langCode);
        vo.setNameDisplay(displayMap.getOrDefault(row.getId(), row.getNameEn()));
        return vo;
    }

    private Set<String> collectCountryCodes(List<ShippingLineDO> rows) {
        return rows.stream()
                .map(ShippingLineDO::getCountryCode)
                .filter(StrUtil::isNotBlank)
                .collect(Collectors.toSet());
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

    private void saveTranslations(Long shippingLineId, List<BaseTranslationItemVO> translations) {
        if (translations == null) {
            return;
        }
        List<EntityTranslationService.CountryTranslationItem> items = translations.stream()
                .filter(t -> StrUtil.isNotBlank(t.getLangCode()) && StrUtil.isNotBlank(t.getValue()))
                .map(t -> new EntityTranslationService.CountryTranslationItem(t.getLangCode(), t.getValue()))
                .collect(Collectors.toList());
        entityTranslationService.saveTranslations(
                BaseEntityTypeEnum.SHIPPING_LINE.getType(), shippingLineId,
                BaseTranslationFieldEnum.NAME.getFieldName(), items);
    }

    private void validateCountryIfPresent(String countryCode) {
        if (StrUtil.isBlank(countryCode)) {
            return;
        }
        CountryDO country = countryMapper.selectByUnique(countryCode);
        if (country == null || !Objects.equals(country.getIsActive(), COUNTRY_ACTIVE)) {
            throw exception(SHIPPING_LINE_COUNTRY_NOT_ACTIVE);
        }
    }

    private void validateTrackingUrl(String trackingUrl) {
        if (StrUtil.isBlank(trackingUrl)) {
            return;
        }
        if (!trackingUrl.contains(CONTAINER_NO_PLACEHOLDER)) {
            throw exception(SHIPPING_LINE_TRACKING_URL_INVALID);
        }
    }

    private void normalizeFields(ShippingLineSaveReqVO reqVO) {
        if (reqVO.getCode() != null) {
            reqVO.setCode(reqVO.getCode().trim().toUpperCase());
        }
        if (reqVO.getCountryCode() != null) {
            reqVO.setCountryCode(reqVO.getCountryCode().trim().toUpperCase());
        }
        if (reqVO.getNameEn() != null) {
            reqVO.setNameEn(reqVO.getNameEn().trim());
        }
        if (reqVO.getNameAbbr() != null) {
            reqVO.setNameAbbr(reqVO.getNameAbbr().trim());
        }
        if (reqVO.getContactEmail() != null) {
            reqVO.setContactEmail(reqVO.getContactEmail().trim());
        }
        if (reqVO.getContactPhone() != null) {
            reqVO.setContactPhone(reqVO.getContactPhone().trim());
        }
        if (reqVO.getWebsite() != null) {
            reqVO.setWebsite(reqVO.getWebsite().trim());
        }
        if (reqVO.getTrackingUrl() != null) {
            reqVO.setTrackingUrl(reqVO.getTrackingUrl().trim());
        }
        if (reqVO.getRemark() != null) {
            reqVO.setRemark(reqVO.getRemark().trim());
        }
    }

    private ShippingLineDO validateExists(Long id) {
        ShippingLineDO row = shippingLineMapper.selectById(id);
        if (row == null) {
            throw exception(SHIPPING_LINE_NOT_EXISTS);
        }
        return row;
    }

    private void validateUnique(Long id, String code) {
        ShippingLineDO exist = shippingLineMapper.selectByUnique(code);
        if (exist != null && (id == null || !exist.getId().equals(id))) {
            throw exception(SHIPPING_LINE_DUPLICATE);
        }
    }

}
