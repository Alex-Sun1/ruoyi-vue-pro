package cn.iocoder.yudao.module.base.service.currency;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.common.vo.BaseTranslationItemVO;
import cn.iocoder.yudao.module.base.controller.admin.currency.vo.*;
import cn.iocoder.yudao.module.base.dal.dataobject.currency.CurrencyDO;
import cn.iocoder.yudao.module.base.dal.mysql.country.CountryMapper;
import cn.iocoder.yudao.module.base.dal.mysql.currency.CurrencyMapper;
import cn.iocoder.yudao.module.base.dal.mysql.exchangerate.ExchangeRateMapper;
import cn.iocoder.yudao.module.base.enums.BaseEntityTypeEnum;
import cn.iocoder.yudao.module.base.enums.BaseTranslationFieldEnum;
import cn.iocoder.yudao.module.base.framework.web.BaseLocaleUtils;
import cn.iocoder.yudao.module.base.service.i18n.EntityTranslationService;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.base.enums.ErrorCodeConstants.*;

@Service
@Validated
public class CurrencyServiceImpl implements CurrencyService {

    private static final int IS_BASE = 1;

    @Resource
    private CurrencyMapper currencyMapper;
    @Resource
    private CountryMapper countryMapper;
    @Resource
    private ExchangeRateMapper exchangeRateMapper;
    @Resource
    private EntityTranslationService entityTranslationService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createCurrency(CurrencySaveReqVO createReqVO) {
        normalizeFields(createReqVO);
        validateCode(createReqVO.getCode());
        validateDecimalPlaces(createReqVO.getDecimalPlaces());
        validateUnique(null, createReqVO.getCode());
        if (createReqVO.getStatus() == null) {
            createReqVO.setStatus(CommonStatusEnum.ENABLE.getStatus());
        }
        if (createReqVO.getSortOrder() == null) {
            createReqVO.setSortOrder(0);
        }
        clearOtherBaseCurrency(null, createReqVO.getIsBase());
        CurrencyDO row = BeanUtils.toBean(createReqVO, CurrencyDO.class);
        currencyMapper.insert(row);
        saveTranslations(row.getId(), createReqVO.getTranslations());
        return row.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateCurrency(CurrencySaveReqVO updateReqVO) {
        CurrencyDO existing = validateExists(updateReqVO.getId());
        normalizeFields(updateReqVO);
        validateCode(updateReqVO.getCode());
        validateDecimalPlaces(updateReqVO.getDecimalPlaces());
        if (!Objects.equals(existing.getCode(), updateReqVO.getCode())) {
            throw exception(CURRENCY_CODE_NOT_MODIFIABLE);
        }
        updateReqVO.setCode(existing.getCode());
        validateUnique(updateReqVO.getId(), updateReqVO.getCode());
        clearOtherBaseCurrency(updateReqVO.getId(), updateReqVO.getIsBase());
        CurrencyDO updateObj = BeanUtils.toBean(updateReqVO, CurrencyDO.class);
        updateObj.setStatus(existing.getStatus());
        if (updateReqVO.getSortOrder() == null) {
            updateObj.setSortOrder(existing.getSortOrder());
        }
        currencyMapper.updateById(updateObj);
        saveTranslations(updateReqVO.getId(), updateReqVO.getTranslations());
    }

    @Override
    public void updateCurrencyStatus(CurrencyUpdateStatusReqVO reqVO) {
        CurrencyDO existing = validateExists(reqVO.getId());
        if (Objects.equals(reqVO.getStatus(), CommonStatusEnum.DISABLE.getStatus())) {
            if (Objects.equals(existing.getIsBase(), IS_BASE)) {
                throw exception(CURRENCY_BASE_CANNOT_DISABLE);
            }
            validateNoReference(existing.getCode());
        }
        CurrencyDO update = new CurrencyDO();
        update.setId(reqVO.getId());
        update.setStatus(reqVO.getStatus());
        currencyMapper.updateById(update);
    }

    @Override
    public CurrencyRespVO getCurrency(Long id) {
        CurrencyDO row = validateExists(id);
        String langCode = BaseLocaleUtils.getLangCode();
        CurrencyRespVO resp = buildRespVO(row, langCode);
        List<BaseTranslationItemVO> items = entityTranslationService.getTranslationList(
                        BaseEntityTypeEnum.CURRENCY.getType(), id, BaseTranslationFieldEnum.NAME.getFieldName())
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
    public PageResult<CurrencyRespVO> getCurrencyPage(CurrencyPageReqVO pageReqVO) {
        PageResult<CurrencyDO> pageResult = currencyMapper.selectPage(pageReqVO);
        String langCode = BaseLocaleUtils.getLangCode();
        List<Long> ids = pageResult.getList().stream().map(CurrencyDO::getId).collect(Collectors.toList());
        Map<Long, String> displayMap = entityTranslationService.getDisplayNameMap(
                BaseEntityTypeEnum.CURRENCY.getType(), BaseTranslationFieldEnum.NAME.getFieldName(),
                ids, langCode);
        List<CurrencyRespVO> list = pageResult.getList().stream()
                .map(row -> {
                    CurrencyRespVO vo = BeanUtils.toBean(row, CurrencyRespVO.class);
                    vo.setNameDisplay(displayMap.getOrDefault(row.getId(), row.getNameEn()));
                    return vo;
                })
                .collect(Collectors.toList());
        return new PageResult<>(list, pageResult.getTotal());
    }

    @Override
    public List<CurrencyRespVO> getCurrencySimpleList(Integer status) {
        List<CurrencyDO> list = currencyMapper.selectSimpleList(status);
        String langCode = BaseLocaleUtils.getLangCode();
        List<Long> ids = list.stream().map(CurrencyDO::getId).collect(Collectors.toList());
        Map<Long, String> displayMap = entityTranslationService.getDisplayNameMap(
                BaseEntityTypeEnum.CURRENCY.getType(), BaseTranslationFieldEnum.NAME.getFieldName(),
                ids, langCode);
        return list.stream().map(row -> {
            CurrencyRespVO vo = BeanUtils.toBean(row, CurrencyRespVO.class);
            vo.setNameDisplay(displayMap.getOrDefault(row.getId(), row.getNameEn()));
            return vo;
        }).collect(Collectors.toList());
    }

    private CurrencyRespVO buildRespVO(CurrencyDO row, String langCode) {
        CurrencyRespVO vo = BeanUtils.toBean(row, CurrencyRespVO.class);
        Map<Long, String> displayMap = entityTranslationService.getDisplayNameMap(
                BaseEntityTypeEnum.CURRENCY.getType(), BaseTranslationFieldEnum.NAME.getFieldName(),
                Collections.singleton(row.getId()), langCode);
        vo.setNameDisplay(displayMap.getOrDefault(row.getId(), row.getNameEn()));
        return vo;
    }

    private void saveTranslations(Long currencyId, List<BaseTranslationItemVO> translations) {
        if (translations == null) {
            return;
        }
        List<EntityTranslationService.CountryTranslationItem> items = translations.stream()
                .filter(t -> StrUtil.isNotBlank(t.getLangCode()) && StrUtil.isNotBlank(t.getValue()))
                .map(t -> new EntityTranslationService.CountryTranslationItem(t.getLangCode(), t.getValue()))
                .collect(Collectors.toList());
        entityTranslationService.saveTranslations(
                BaseEntityTypeEnum.CURRENCY.getType(), currencyId,
                BaseTranslationFieldEnum.NAME.getFieldName(), items);
    }

    private void clearOtherBaseCurrency(Long id, Integer isBase) {
        if (!Objects.equals(isBase, IS_BASE)) {
            return;
        }
        List<CurrencyDO> baseList = currencyMapper.selectList(new LambdaQueryWrapperX<CurrencyDO>()
                .eq(CurrencyDO::getIsBase, IS_BASE));
        for (CurrencyDO item : baseList) {
            if (id == null || !item.getId().equals(id)) {
                CurrencyDO update = new CurrencyDO();
                update.setId(item.getId());
                update.setIsBase(0);
                currencyMapper.updateById(update);
            }
        }
    }

    private void validateNoReference(String currencyCode) {
        if (countryMapper.selectCountByCurrencyCode(currencyCode) > 0
                || exchangeRateMapper.selectCountByCurrencyCode(currencyCode) > 0) {
            throw exception(CURRENCY_DISABLE_HAS_REFERENCE);
        }
    }

    private void validateCode(String code) {
        if (StrUtil.isBlank(code) || !code.matches("^[A-Z]{3}$")) {
            throw exception(CURRENCY_CODE_INVALID);
        }
    }

    private void validateDecimalPlaces(Integer decimalPlaces) {
        if (decimalPlaces == null || decimalPlaces < 0 || decimalPlaces > 4) {
            throw exception(CURRENCY_DECIMAL_PLACES_INVALID);
        }
    }

    private void normalizeFields(CurrencySaveReqVO reqVO) {
        if (reqVO.getCode() != null) {
            reqVO.setCode(reqVO.getCode().trim().toUpperCase());
        }
        if (reqVO.getNameEn() != null) {
            reqVO.setNameEn(reqVO.getNameEn().trim());
        }
        if (reqVO.getSymbol() != null) {
            reqVO.setSymbol(reqVO.getSymbol().trim());
        }
    }

    private CurrencyDO validateExists(Long id) {
        CurrencyDO row = currencyMapper.selectById(id);
        if (row == null) {
            throw exception(CURRENCY_NOT_EXISTS);
        }
        return row;
    }

    private void validateUnique(Long id, String code) {
        CurrencyDO exist = currencyMapper.selectByUnique(code);
        if (exist != null && (id == null || !exist.getId().equals(id))) {
            throw exception(CURRENCY_DUPLICATE);
        }
    }

}
