package cn.iocoder.yudao.module.base.service.port;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.exception.ServiceException;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.common.vo.BaseTranslationItemVO;
import cn.iocoder.yudao.module.base.controller.admin.port.vo.*;
import cn.iocoder.yudao.module.base.dal.dataobject.country.CountryDO;
import cn.iocoder.yudao.module.base.dal.dataobject.port.PortDO;
import cn.iocoder.yudao.module.base.dal.dataobject.state.StateProvinceDO;
import cn.iocoder.yudao.module.base.dal.dataobject.timezone.TimezoneDO;
import cn.iocoder.yudao.module.base.dal.mysql.country.CountryMapper;
import cn.iocoder.yudao.module.base.dal.mysql.port.PortMapper;
import cn.iocoder.yudao.module.base.dal.mysql.state.StateProvinceMapper;
import cn.iocoder.yudao.module.base.dal.mysql.timezone.TimezoneMapper;
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
public class PortServiceImpl implements PortService {

    private static final int COUNTRY_ACTIVE = 1;
    private static final String CONTAINER_NO_PLACEHOLDER = "{container_no}";
    private static final Set<Integer> VALID_PORT_TYPES = Set.of(1, 2, 3);

    @Resource
    private PortMapper portMapper;
    @Resource
    private CountryMapper countryMapper;
    @Resource
    private StateProvinceMapper stateProvinceMapper;
    @Resource
    private TimezoneMapper timezoneMapper;
    @Resource
    private EntityTranslationService entityTranslationService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createPort(PortSaveReqVO createReqVO) {
        normalizeFields(createReqVO);
        validatePortType(createReqVO.getPortType());
        validateCountryActive(createReqVO.getCountryCode());
        validateStateIfPresent(createReqVO.getCountryCode(), createReqVO.getStateCode());
        validateTimezoneIfPresent(createReqVO.getTimezone());
        validateContainerQueryUrl(createReqVO.getContainerQueryUrl());
        validateUnique(null, createReqVO.getPortCode());
        if (createReqVO.getStatus() == null) {
            createReqVO.setStatus(CommonStatusEnum.ENABLE.getStatus());
        }
        PortDO row = BeanUtils.toBean(createReqVO, PortDO.class);
        portMapper.insert(row);
        saveTranslations(row.getId(), createReqVO.getTranslations());
        return row.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updatePort(PortSaveReqVO updateReqVO) {
        PortDO existing = validateExists(updateReqVO.getId());
        normalizeFields(updateReqVO);
        validatePortType(updateReqVO.getPortType());
        validateCountryActive(updateReqVO.getCountryCode());
        validateStateIfPresent(updateReqVO.getCountryCode(), updateReqVO.getStateCode());
        validateTimezoneIfPresent(updateReqVO.getTimezone());
        validateContainerQueryUrl(updateReqVO.getContainerQueryUrl());
        if (!Objects.equals(existing.getPortCode(), updateReqVO.getPortCode())
                || !Objects.equals(existing.getCountryCode(), updateReqVO.getCountryCode())
                || !Objects.equals(normalizeStateCode(existing.getStateCode()),
                normalizeStateCode(updateReqVO.getStateCode()))) {
            throw exception(PORT_KEY_NOT_MODIFIABLE);
        }
        updateReqVO.setPortCode(existing.getPortCode());
        updateReqVO.setCountryCode(existing.getCountryCode());
        updateReqVO.setStateCode(existing.getStateCode());
        PortDO updateObj = BeanUtils.toBean(updateReqVO, PortDO.class);
        updateObj.setStatus(existing.getStatus());
        portMapper.updateById(updateObj);
        saveTranslations(updateReqVO.getId(), updateReqVO.getTranslations());
    }

    @Override
    public void updatePortStatus(PortUpdateStatusReqVO reqVO) {
        validateExists(reqVO.getId());
        PortDO update = new PortDO();
        update.setId(reqVO.getId());
        update.setStatus(reqVO.getStatus());
        portMapper.updateById(update);
    }

    @Override
    public PortRespVO getPort(Long id) {
        PortDO row = validateExists(id);
        String langCode = BaseLocaleUtils.getLangCode();
        PortRespVO resp = buildRespVO(row, langCode,
                buildCountryNameMap(Collections.singleton(row.getCountryCode()), langCode),
                buildStateNameMap(Collections.singletonList(row), langCode));
        List<BaseTranslationItemVO> items = entityTranslationService.getTranslationList(
                        BaseEntityTypeEnum.PORT.getType(), id, BaseTranslationFieldEnum.NAME.getFieldName())
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
    public PageResult<PortRespVO> getPortPage(PortPageReqVO pageReqVO) {
        if (StrUtil.isNotBlank(pageReqVO.getCountryCode())) {
            pageReqVO.setCountryCode(pageReqVO.getCountryCode().trim().toUpperCase());
        }
        PageResult<PortDO> pageResult = portMapper.selectPage(pageReqVO);
        String langCode = BaseLocaleUtils.getLangCode();
        Set<String> countryCodes = pageResult.getList().stream()
                .map(PortDO::getCountryCode).collect(Collectors.toSet());
        Map<String, String> countryNameMap = buildCountryNameMap(countryCodes, langCode);
        Map<String, String> stateNameMap = buildStateNameMap(pageResult.getList(), langCode);
        List<PortRespVO> list = pageResult.getList().stream()
                .map(row -> buildRespVO(row, langCode, countryNameMap, stateNameMap))
                .collect(Collectors.toList());
        return new PageResult<>(list, pageResult.getTotal());
    }

    @Override
    public List<PortRespVO> getPortSimpleList(Integer status) {
        List<PortDO> list = portMapper.selectSimpleList(status);
        String langCode = BaseLocaleUtils.getLangCode();
        Set<String> countryCodes = list.stream().map(PortDO::getCountryCode).collect(Collectors.toSet());
        Map<String, String> countryNameMap = buildCountryNameMap(countryCodes, langCode);
        Map<String, String> stateNameMap = buildStateNameMap(list, langCode);
        return list.stream()
                .map(row -> buildRespVO(row, langCode, countryNameMap, stateNameMap))
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public PortImportRespVO importPortList(List<PortImportExcelVO> importList, boolean updateSupport) {
        if (CollUtil.isEmpty(importList)) {
            throw exception(PORT_IMPORT_LIST_IS_EMPTY);
        }
        PortImportRespVO resp = PortImportRespVO.builder()
                .createKeys(new ArrayList<>())
                .updateKeys(new ArrayList<>())
                .failureKeys(new LinkedHashMap<>())
                .build();
        AtomicInteger index = new AtomicInteger(1);
        for (PortImportExcelVO row : importList) {
            int line = index.getAndIncrement();
            String key = StrUtil.blankToDefault(row.getPortCode(), "第" + line + "行");
            try {
                PortSaveReqVO saveReq = new PortSaveReqVO();
                saveReq.setPortCode(row.getPortCode());
                saveReq.setNameEn(row.getNameEn());
                saveReq.setCountryCode(row.getCountryCode());
                saveReq.setStateCode(row.getStateCode());
                saveReq.setCity(row.getCity());
                saveReq.setPortType(row.getPortType());
                saveReq.setTimezone(row.getTimezone());
                saveReq.setContainerQueryUrl(row.getContainerQueryUrl());
                saveReq.setRemark(row.getRemark());
                saveReq.setStatus(CommonStatusEnum.ENABLE.getStatus());
                normalizeFields(saveReq);
                if (StrUtil.isBlank(saveReq.getPortCode())) {
                    throw exception(PORT_IMPORT_ROW_INVALID, "港口代码不能为空");
                }
                if (StrUtil.isBlank(saveReq.getNameEn())) {
                    throw exception(PORT_IMPORT_ROW_INVALID, "英文名称不能为空");
                }
                if (saveReq.getPortType() == null) {
                    throw exception(PORT_IMPORT_ROW_INVALID, "港口类型不能为空");
                }
                validatePortType(saveReq.getPortType());
                validateCountryActive(saveReq.getCountryCode());
                validateStateIfPresent(saveReq.getCountryCode(), saveReq.getStateCode());
                validateTimezoneIfPresent(saveReq.getTimezone());
                validateContainerQueryUrl(saveReq.getContainerQueryUrl());
                PortDO exist = portMapper.selectByUnique(saveReq.getPortCode());
                if (exist == null) {
                    PortDO insert = BeanUtils.toBean(saveReq, PortDO.class);
                    portMapper.insert(insert);
                    resp.getCreateKeys().add(saveReq.getPortCode());
                } else if (!updateSupport) {
                    resp.getFailureKeys().put(key, PORT_DUPLICATE.getMsg());
                } else {
                    PortDO update = BeanUtils.toBean(saveReq, PortDO.class);
                    update.setId(exist.getId());
                    update.setPortCode(exist.getPortCode());
                    update.setCountryCode(exist.getCountryCode());
                    update.setStateCode(exist.getStateCode());
                    update.setStatus(exist.getStatus());
                    portMapper.updateById(update);
                    resp.getUpdateKeys().add(saveReq.getPortCode());
                }
            } catch (ServiceException ex) {
                resp.getFailureKeys().put(key, ex.getMessage());
            } catch (Exception ex) {
                resp.getFailureKeys().put(key, StrUtil.blankToDefault(ex.getMessage(), "导入失败"));
            }
        }
        return resp;
    }

    private PortRespVO buildRespVO(PortDO row, String langCode,
                                   Map<String, String> countryNameMap,
                                   Map<String, String> stateNameMap) {
        PortRespVO vo = BeanUtils.toBean(row, PortRespVO.class);
        vo.setCountryName(countryNameMap.getOrDefault(row.getCountryCode(), row.getCountryCode()));
        if (StrUtil.isNotBlank(row.getStateCode())) {
            vo.setStateName(stateNameMap.getOrDefault(regionKey(row.getCountryCode(), row.getStateCode()),
                    row.getStateCode()));
        }
        Map<Long, String> displayMap = entityTranslationService.getDisplayNameMap(
                BaseEntityTypeEnum.PORT.getType(), BaseTranslationFieldEnum.NAME.getFieldName(),
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

    private Map<String, String> buildStateNameMap(List<PortDO> ports, String langCode) {
        if (CollUtil.isEmpty(ports)) {
            return Collections.emptyMap();
        }
        Set<String> countryCodes = ports.stream().map(PortDO::getCountryCode).collect(Collectors.toSet());
        List<StateProvinceDO> states = stateProvinceMapper.selectList(new LambdaQueryWrapperX<StateProvinceDO>()
                .in(StateProvinceDO::getCountryCode, countryCodes));
        if (CollUtil.isEmpty(states)) {
            return Collections.emptyMap();
        }
        Set<String> neededKeys = ports.stream()
                .filter(p -> StrUtil.isNotBlank(p.getStateCode()))
                .map(p -> regionKey(p.getCountryCode(), p.getStateCode()))
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

    private void saveTranslations(Long portId, List<BaseTranslationItemVO> translations) {
        if (translations == null) {
            return;
        }
        List<EntityTranslationService.CountryTranslationItem> items = translations.stream()
                .filter(t -> StrUtil.isNotBlank(t.getLangCode()) && StrUtil.isNotBlank(t.getValue()))
                .map(t -> new EntityTranslationService.CountryTranslationItem(t.getLangCode(), t.getValue()))
                .collect(Collectors.toList());
        entityTranslationService.saveTranslations(
                BaseEntityTypeEnum.PORT.getType(), portId,
                BaseTranslationFieldEnum.NAME.getFieldName(), items);
    }

    private void validateCountryActive(String countryCode) {
        CountryDO country = countryMapper.selectByUnique(countryCode);
        if (country == null || !Objects.equals(country.getIsActive(), COUNTRY_ACTIVE)) {
            throw exception(PORT_COUNTRY_NOT_ACTIVE);
        }
    }

    private void validateStateIfPresent(String countryCode, String stateCode) {
        if (StrUtil.isBlank(stateCode)) {
            return;
        }
        StateProvinceDO state = stateProvinceMapper.selectByUnique(countryCode, stateCode);
        if (state == null
                || !Objects.equals(state.getStatus(), CommonStatusEnum.ENABLE.getStatus())) {
            throw exception(PORT_STATE_INVALID);
        }
    }

    private void validateTimezoneIfPresent(String timezone) {
        if (StrUtil.isBlank(timezone)) {
            return;
        }
        TimezoneDO tz = timezoneMapper.selectByUnique(timezone.trim());
        if (tz == null || !Objects.equals(tz.getStatus(), CommonStatusEnum.ENABLE.getStatus())) {
            throw exception(PORT_TIMEZONE_INVALID);
        }
    }

    private void validateContainerQueryUrl(String containerQueryUrl) {
        if (StrUtil.isBlank(containerQueryUrl)) {
            return;
        }
        if (!containerQueryUrl.contains(CONTAINER_NO_PLACEHOLDER)) {
            throw exception(PORT_CONTAINER_URL_INVALID);
        }
    }

    private void validatePortType(Integer portType) {
        if (portType == null || !VALID_PORT_TYPES.contains(portType)) {
            throw exception(PORT_PORT_TYPE_INVALID);
        }
    }

    private void normalizeFields(PortSaveReqVO reqVO) {
        if (reqVO.getPortCode() != null) {
            reqVO.setPortCode(reqVO.getPortCode().trim().toUpperCase());
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
        if (reqVO.getCity() != null) {
            reqVO.setCity(reqVO.getCity().trim());
        }
        if (reqVO.getTimezone() != null) {
            reqVO.setTimezone(reqVO.getTimezone().trim());
        }
        if (reqVO.getContainerQueryUrl() != null) {
            reqVO.setContainerQueryUrl(reqVO.getContainerQueryUrl().trim());
        }
        if (reqVO.getRemark() != null) {
            reqVO.setRemark(reqVO.getRemark().trim());
        }
    }

    private static String normalizeStateCode(String stateCode) {
        return StrUtil.isBlank(stateCode) ? "" : stateCode.trim().toUpperCase();
    }

    private PortDO validateExists(Long id) {
        PortDO row = portMapper.selectById(id);
        if (row == null) {
            throw exception(PORT_NOT_EXISTS);
        }
        return row;
    }

    private void validateUnique(Long id, String portCode) {
        PortDO exist = portMapper.selectByUnique(portCode);
        if (exist != null && (id == null || !exist.getId().equals(id))) {
            throw exception(PORT_DUPLICATE);
        }
    }

}
