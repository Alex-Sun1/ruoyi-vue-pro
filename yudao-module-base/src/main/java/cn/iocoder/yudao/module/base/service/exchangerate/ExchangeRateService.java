package cn.iocoder.yudao.module.base.service.exchangerate;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.exchangerate.vo.ExchangeRatePageReqVO;
import cn.iocoder.yudao.module.base.controller.admin.exchangerate.vo.ExchangeRateRespVO;
import cn.iocoder.yudao.module.base.controller.admin.exchangerate.vo.ExchangeRateSaveReqVO;

import java.util.List;

public interface ExchangeRateService {

    Long createExchangeRate(ExchangeRateSaveReqVO createReqVO);

    void updateExchangeRate(ExchangeRateSaveReqVO updateReqVO);

    void invalidateExchangeRate(Long id);

    ExchangeRateRespVO getExchangeRate(Long id);

    PageResult<ExchangeRateRespVO> getExchangeRatePage(ExchangeRatePageReqVO pageReqVO);

    List<ExchangeRateRespVO> getExchangeRateHistory(String fromCurrency, String toCurrency);

}
