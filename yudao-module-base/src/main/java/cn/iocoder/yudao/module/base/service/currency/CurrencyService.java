package cn.iocoder.yudao.module.base.service.currency;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.currency.vo.*;

import java.util.List;

public interface CurrencyService {

    Long createCurrency(CurrencySaveReqVO createReqVO);

    void updateCurrency(CurrencySaveReqVO updateReqVO);

    void updateCurrencyStatus(CurrencyUpdateStatusReqVO reqVO);

    CurrencyRespVO getCurrency(Long id);

    PageResult<CurrencyRespVO> getCurrencyPage(CurrencyPageReqVO pageReqVO);

    List<CurrencyRespVO> getCurrencySimpleList(Integer status);

}
