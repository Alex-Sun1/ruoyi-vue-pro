package cn.iocoder.yudao.module.base.service.exchangerate;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.NumberUtil;
import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.base.controller.admin.exchangerate.vo.ExchangeRatePageReqVO;
import cn.iocoder.yudao.module.base.controller.admin.exchangerate.vo.ExchangeRateRespVO;
import cn.iocoder.yudao.module.base.controller.admin.exchangerate.vo.ExchangeRateSaveReqVO;
import cn.iocoder.yudao.module.base.dal.dataobject.currency.CurrencyDO;
import cn.iocoder.yudao.module.base.dal.dataobject.exchangerate.ExchangeRateDO;
import cn.iocoder.yudao.module.base.dal.mysql.currency.CurrencyMapper;
import cn.iocoder.yudao.module.base.dal.mysql.exchangerate.ExchangeRateMapper;
import cn.iocoder.yudao.module.system.api.user.AdminUserApi;
import cn.iocoder.yudao.module.system.api.user.dto.AdminUserRespDTO;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.base.enums.ErrorCodeConstants.*;

@Service
@Validated
public class ExchangeRateServiceImpl implements ExchangeRateService {

    private static final int IS_CURRENT = 1;
    private static final int RATE_SCALE = 6;

    @Resource
    private ExchangeRateMapper exchangeRateMapper;
    @Resource
    private CurrencyMapper currencyMapper;
    @Resource
    private AdminUserApi adminUserApi;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createExchangeRate(ExchangeRateSaveReqVO createReqVO) {
        normalizeCurrencies(createReqVO);
        validateCurrencies(createReqVO.getFromCurrency(), createReqVO.getToCurrency());
        validateRate(createReqVO.getRate());
        ExchangeRateDO duplicate = exchangeRateMapper.selectByUnique(
                createReqVO.getFromCurrency(), createReqVO.getToCurrency(), createReqVO.getEffectiveDate());
        if (duplicate != null) {
            throw exception(EXCHANGE_RATE_DUPLICATE);
        }
        expireCurrentIfPresent(createReqVO.getFromCurrency(), createReqVO.getToCurrency(),
                createReqVO.getEffectiveDate());
        ExchangeRateDO row = BeanUtils.toBean(createReqVO, ExchangeRateDO.class);
        row.setRate(scaleRate(createReqVO.getRate()));
        row.setIsCurrent(IS_CURRENT);
        row.setExpiredDate(null);
        exchangeRateMapper.insert(row);
        return row.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateExchangeRate(ExchangeRateSaveReqVO updateReqVO) {
        ExchangeRateDO existing = validateExists(updateReqVO.getId());
        validateCurrent(existing);
        normalizeCurrencies(updateReqVO);
        validateCurrencies(updateReqVO.getFromCurrency(), updateReqVO.getToCurrency());
        validateRate(updateReqVO.getRate());
        if (!Objects.equals(existing.getFromCurrency(), updateReqVO.getFromCurrency())
                || !Objects.equals(existing.getToCurrency(), updateReqVO.getToCurrency())
                || !Objects.equals(existing.getEffectiveDate(), updateReqVO.getEffectiveDate())) {
            throw exception(EXCHANGE_RATE_KEY_NOT_MODIFIABLE);
        }
        ExchangeRateDO update = new ExchangeRateDO();
        update.setId(existing.getId());
        update.setRate(scaleRate(updateReqVO.getRate()));
        update.setRemark(updateReqVO.getRemark());
        exchangeRateMapper.updateById(update);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void invalidateExchangeRate(Long id) {
        ExchangeRateDO existing = validateExists(id);
        validateCurrent(existing);
        ExchangeRateDO update = new ExchangeRateDO();
        update.setId(id);
        update.setIsCurrent(0);
        update.setExpiredDate(LocalDate.now());
        exchangeRateMapper.updateById(update);
    }

    @Override
    public ExchangeRateRespVO getExchangeRate(Long id) {
        ExchangeRateDO row = validateExists(id);
        return buildRespList(Collections.singletonList(row)).get(0);
    }

    @Override
    public PageResult<ExchangeRateRespVO> getExchangeRatePage(ExchangeRatePageReqVO pageReqVO) {
        normalizePageQuery(pageReqVO);
        PageResult<ExchangeRateDO> pageResult = exchangeRateMapper.selectPage(pageReqVO);
        List<ExchangeRateRespVO> list = buildRespList(pageResult.getList());
        return new PageResult<>(list, pageResult.getTotal());
    }

    @Override
    public List<ExchangeRateRespVO> getExchangeRateHistory(String fromCurrency, String toCurrency) {
        if (StrUtil.hasBlank(fromCurrency, toCurrency)) {
            return Collections.emptyList();
        }
        fromCurrency = fromCurrency.trim().toUpperCase();
        toCurrency = toCurrency.trim().toUpperCase();
        return buildRespList(exchangeRateMapper.selectHistoryList(fromCurrency, toCurrency));
    }

    private void expireCurrentIfPresent(String fromCurrency, String toCurrency, LocalDate newEffectiveDate) {
        ExchangeRateDO current = exchangeRateMapper.selectCurrent(fromCurrency, toCurrency);
        if (current == null) {
            return;
        }
        ExchangeRateDO update = new ExchangeRateDO();
        update.setId(current.getId());
        update.setIsCurrent(0);
        update.setExpiredDate(newEffectiveDate.minusDays(1));
        exchangeRateMapper.updateById(update);
    }

    private List<ExchangeRateRespVO> buildRespList(List<ExchangeRateDO> rows) {
        if (CollUtil.isEmpty(rows)) {
            return Collections.emptyList();
        }
        Set<Long> userIds = rows.stream()
                .map(ExchangeRateDO::getCreator)
                .filter(StrUtil::isNotBlank)
                .filter(NumberUtil::isLong)
                .map(Long::valueOf)
                .collect(Collectors.toSet());
        Map<Long, AdminUserRespDTO> userMap = CollUtil.isEmpty(userIds)
                ? Collections.emptyMap() : adminUserApi.getUserMap(userIds);
        return rows.stream().map(row -> {
            ExchangeRateRespVO vo = BeanUtils.toBean(row, ExchangeRateRespVO.class);
            vo.setRate(scaleRate(row.getRate()));
            if (StrUtil.isNotBlank(row.getCreator()) && NumberUtil.isLong(row.getCreator())) {
                AdminUserRespDTO user = userMap.get(Long.valueOf(row.getCreator()));
                if (user != null) {
                    vo.setCreatorName(user.getNickname());
                }
            }
            if (vo.getCreatorName() == null) {
                vo.setCreatorName(row.getCreator());
            }
            return vo;
        }).collect(Collectors.toList());
    }

    private void normalizePageQuery(ExchangeRatePageReqVO pageReqVO) {
        if (StrUtil.isNotBlank(pageReqVO.getFromCurrency())) {
            pageReqVO.setFromCurrency(pageReqVO.getFromCurrency().trim().toUpperCase());
        }
        if (StrUtil.isNotBlank(pageReqVO.getToCurrency())) {
            pageReqVO.setToCurrency(pageReqVO.getToCurrency().trim().toUpperCase());
        }
    }

    private void normalizeCurrencies(ExchangeRateSaveReqVO reqVO) {
        if (reqVO.getFromCurrency() != null) {
            reqVO.setFromCurrency(reqVO.getFromCurrency().trim().toUpperCase());
        }
        if (reqVO.getToCurrency() != null) {
            reqVO.setToCurrency(reqVO.getToCurrency().trim().toUpperCase());
        }
    }

    private void validateCurrencies(String fromCurrency, String toCurrency) {
        if (Objects.equals(fromCurrency, toCurrency)) {
            throw exception(EXCHANGE_RATE_CURRENCY_SAME);
        }
        validateCurrencyEnabled(fromCurrency);
        validateCurrencyEnabled(toCurrency);
    }

    private void validateCurrencyEnabled(String code) {
        CurrencyDO currency = currencyMapper.selectByUnique(code);
        if (currency == null || !Objects.equals(currency.getStatus(), CommonStatusEnum.ENABLE.getStatus())) {
            throw exception(EXCHANGE_RATE_CURRENCY_INVALID);
        }
    }

    private void validateRate(BigDecimal rate) {
        if (rate == null || rate.compareTo(BigDecimal.ZERO) <= 0) {
            throw exception(EXCHANGE_RATE_RATE_INVALID);
        }
    }

    private void validateCurrent(ExchangeRateDO row) {
        if (!Objects.equals(row.getIsCurrent(), IS_CURRENT)) {
            throw exception(EXCHANGE_RATE_NOT_CURRENT);
        }
    }

    private BigDecimal scaleRate(BigDecimal rate) {
        return rate == null ? null : rate.setScale(RATE_SCALE, RoundingMode.HALF_UP);
    }

    private ExchangeRateDO validateExists(Long id) {
        ExchangeRateDO row = exchangeRateMapper.selectById(id);
        if (row == null) {
            throw exception(EXCHANGE_RATE_NOT_EXISTS);
        }
        return row;
    }

}
