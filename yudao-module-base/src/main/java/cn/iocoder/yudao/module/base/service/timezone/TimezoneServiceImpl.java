package cn.iocoder.yudao.module.base.service.timezone;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.timezone.vo.*;
import cn.iocoder.yudao.module.base.dal.dataobject.country.CountryDO;
import cn.iocoder.yudao.module.base.dal.dataobject.timezone.TimezoneDO;
import cn.iocoder.yudao.module.base.dal.mysql.country.CountryMapper;
import cn.iocoder.yudao.module.base.dal.mysql.port.PortMapper;
import cn.iocoder.yudao.module.base.dal.mysql.timezone.TimezoneMapper;
import cn.iocoder.yudao.module.base.dal.mysql.warehouse.BaseWarehouseMapper;
import cn.iocoder.yudao.module.base.enums.BaseEntityTypeEnum;
import cn.iocoder.yudao.module.base.enums.BaseTranslationFieldEnum;
import cn.iocoder.yudao.module.base.framework.web.BaseLocaleUtils;
import cn.iocoder.yudao.module.base.service.i18n.EntityTranslationService;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.util.*;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.base.enums.ErrorCodeConstants.*;

@Service
@Validated
public class TimezoneServiceImpl implements TimezoneService {

    private static final int COUNTRY_ACTIVE = 1;
    private static final Pattern UTC_OFFSET_PATTERN = Pattern.compile("^UTC[+-]\\d{1,2}(:\\d{2})?$");

    @Resource
    private TimezoneMapper timezoneMapper;
    @Resource
    private CountryMapper countryMapper;
    @Resource
    private PortMapper portMapper;
    @Resource
    private BaseWarehouseMapper baseWarehouseMapper;
    @Resource
    private EntityTranslationService entityTranslationService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createTimezone(TimezoneSaveReqVO createReqVO) {
        normalizeFields(createReqVO);
        validateUtcOffset(createReqVO.getUtcOffset());
        validateCountryIfPresent(createReqVO.getCountryCode());
        validateUnique(null, createReqVO.getTzCode());
        if (createReqVO.getStatus() == null) {
            createReqVO.setStatus(CommonStatusEnum.ENABLE.getStatus());
        }
        if (createReqVO.getSortOrder() == null) {
            createReqVO.setSortOrder(0);
        }
        TimezoneDO row = BeanUtils.toBean(createReqVO, TimezoneDO.class);
        timezoneMapper.insert(row);
        return row.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateTimezone(TimezoneSaveReqVO updateReqVO) {
        TimezoneDO existing = validateExists(updateReqVO.getId());
        normalizeFields(updateReqVO);
        validateUtcOffset(updateReqVO.getUtcOffset());
        validateCountryIfPresent(updateReqVO.getCountryCode());
        if (!Objects.equals(existing.getTzCode(), updateReqVO.getTzCode())) {
            throw exception(TIMEZONE_TZ_CODE_NOT_MODIFIABLE);
        }
        updateReqVO.setTzCode(existing.getTzCode());
        validateUnique(updateReqVO.getId(), updateReqVO.getTzCode());
        TimezoneDO updateObj = BeanUtils.toBean(updateReqVO, TimezoneDO.class);
        updateObj.setStatus(existing.getStatus());
        if (updateReqVO.getSortOrder() == null) {
            updateObj.setSortOrder(existing.getSortOrder());
        }
        timezoneMapper.updateById(updateObj);
    }

    @Override
    public void updateTimezoneStatus(TimezoneUpdateStatusReqVO reqVO) {
        TimezoneDO existing = validateExists(reqVO.getId());
        if (Objects.equals(reqVO.getStatus(), CommonStatusEnum.DISABLE.getStatus())) {
            validateNoReference(existing.getTzCode());
        }
        TimezoneDO update = new TimezoneDO();
        update.setId(reqVO.getId());
        update.setStatus(reqVO.getStatus());
        timezoneMapper.updateById(update);
    }

    @Override
    public TimezoneRespVO getTimezone(Long id) {
        TimezoneDO row = validateExists(id);
        String langCode = BaseLocaleUtils.getLangCode();
        Map<String, String> countryNameMap = buildCountryNameMap(
                StrUtil.isNotBlank(row.getCountryCode())
                        ? Collections.singleton(row.getCountryCode()) : Collections.emptySet(),
                langCode);
        return buildRespVO(row, countryNameMap);
    }

    @Override
    public PageResult<TimezoneRespVO> getTimezonePage(TimezonePageReqVO pageReqVO) {
        if (StrUtil.isNotBlank(pageReqVO.getCountryCode())) {
            pageReqVO.setCountryCode(pageReqVO.getCountryCode().trim().toUpperCase());
        }
        PageResult<TimezoneDO> pageResult = timezoneMapper.selectPage(pageReqVO);
        String langCode = BaseLocaleUtils.getLangCode();
        Set<String> countryCodes = pageResult.getList().stream()
                .map(TimezoneDO::getCountryCode)
                .filter(StrUtil::isNotBlank)
                .collect(Collectors.toSet());
        Map<String, String> countryNameMap = buildCountryNameMap(countryCodes, langCode);
        List<TimezoneRespVO> list = pageResult.getList().stream()
                .map(row -> buildRespVO(row, countryNameMap))
                .collect(Collectors.toList());
        return new PageResult<>(list, pageResult.getTotal());
    }

    @Override
    public List<TimezoneRespVO> getTimezoneSimpleList(Integer status) {
        List<TimezoneDO> list = timezoneMapper.selectSimpleList(status);
        String langCode = BaseLocaleUtils.getLangCode();
        Set<String> countryCodes = list.stream()
                .map(TimezoneDO::getCountryCode)
                .filter(StrUtil::isNotBlank)
                .collect(Collectors.toSet());
        Map<String, String> countryNameMap = buildCountryNameMap(countryCodes, langCode);
        return list.stream().map(row -> buildRespVO(row, countryNameMap)).collect(Collectors.toList());
    }

    private TimezoneRespVO buildRespVO(TimezoneDO row, Map<String, String> countryNameMap) {
        TimezoneRespVO vo = BeanUtils.toBean(row, TimezoneRespVO.class);
        if (StrUtil.isNotBlank(row.getCountryCode())) {
            vo.setCountryName(countryNameMap.getOrDefault(row.getCountryCode(), row.getCountryCode()));
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

    private void validateUtcOffset(String utcOffset) {
        if (StrUtil.isBlank(utcOffset) || !UTC_OFFSET_PATTERN.matcher(utcOffset.trim()).matches()) {
            throw exception(TIMEZONE_UTC_OFFSET_INVALID);
        }
    }

    private void validateCountryIfPresent(String countryCode) {
        if (StrUtil.isBlank(countryCode)) {
            return;
        }
        CountryDO country = countryMapper.selectByUnique(countryCode);
        if (country == null || !Objects.equals(country.getIsActive(), COUNTRY_ACTIVE)) {
            throw exception(TIMEZONE_COUNTRY_NOT_ACTIVE);
        }
    }

    private void validateNoReference(String tzCode) {
        if (countryMapper.selectCountByTimezoneDefault(tzCode) > 0
                || portMapper.selectCountByTimezone(tzCode) > 0
                || baseWarehouseMapper.selectCountByTimezoneCode(tzCode) > 0) {
            throw exception(TIMEZONE_DISABLE_HAS_REFERENCE);
        }
    }

    private void normalizeFields(TimezoneSaveReqVO reqVO) {
        if (reqVO.getTzCode() != null) {
            reqVO.setTzCode(reqVO.getTzCode().trim());
        }
        if (reqVO.getNameEn() != null) {
            reqVO.setNameEn(reqVO.getNameEn().trim());
        }
        if (reqVO.getUtcOffset() != null) {
            reqVO.setUtcOffset(reqVO.getUtcOffset().trim());
        }
        if (reqVO.getCountryCode() != null) {
            String cc = reqVO.getCountryCode().trim();
            reqVO.setCountryCode(StrUtil.isBlank(cc) ? null : cc.toUpperCase());
        }
    }

    private TimezoneDO validateExists(Long id) {
        TimezoneDO row = timezoneMapper.selectById(id);
        if (row == null) {
            throw exception(TIMEZONE_NOT_EXISTS);
        }
        return row;
    }

    private void validateUnique(Long id, String tzCode) {
        TimezoneDO exist = timezoneMapper.selectByUnique(tzCode);
        if (exist != null && (id == null || !exist.getId().equals(id))) {
            throw exception(TIMEZONE_DUPLICATE);
        }
    }

}
