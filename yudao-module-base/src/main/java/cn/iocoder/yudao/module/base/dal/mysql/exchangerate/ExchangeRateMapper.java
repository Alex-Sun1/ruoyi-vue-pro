package cn.iocoder.yudao.module.base.dal.mysql.exchangerate;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.exchangerate.vo.ExchangeRatePageReqVO;
import cn.iocoder.yudao.module.base.dal.dataobject.exchangerate.ExchangeRateDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ExchangeRateMapper extends BaseMapperX<ExchangeRateDO> {

    default PageResult<ExchangeRateDO> selectPage(ExchangeRatePageReqVO reqVO) {
        LambdaQueryWrapperX<ExchangeRateDO> wrapper = new LambdaQueryWrapperX<>();
        wrapper.eqIfPresent(ExchangeRateDO::getFromCurrency, reqVO.getFromCurrency());
        wrapper.eqIfPresent(ExchangeRateDO::getToCurrency, reqVO.getToCurrency());
        wrapper.eqIfPresent(ExchangeRateDO::getIsCurrent, reqVO.getIsCurrent());
        wrapper.geIfPresent(ExchangeRateDO::getEffectiveDate, reqVO.getEffectiveDateStart());
        wrapper.leIfPresent(ExchangeRateDO::getEffectiveDate, reqVO.getEffectiveDateEnd());
        wrapper.orderByDesc(ExchangeRateDO::getEffectiveDate).orderByDesc(ExchangeRateDO::getId);
        return selectPage(reqVO, wrapper);
    }

    default ExchangeRateDO selectByUnique(String fromCurrency, String toCurrency,
                                          java.time.LocalDate effectiveDate) {
        return selectOne(new LambdaQueryWrapperX<ExchangeRateDO>()
                .eq(ExchangeRateDO::getFromCurrency, fromCurrency)
                .eq(ExchangeRateDO::getToCurrency, toCurrency)
                .eq(ExchangeRateDO::getEffectiveDate, effectiveDate));
    }

    default ExchangeRateDO selectCurrent(String fromCurrency, String toCurrency) {
        return selectOne(new LambdaQueryWrapperX<ExchangeRateDO>()
                .eq(ExchangeRateDO::getFromCurrency, fromCurrency)
                .eq(ExchangeRateDO::getToCurrency, toCurrency)
                .eq(ExchangeRateDO::getIsCurrent, 1));
    }

    default List<ExchangeRateDO> selectHistoryList(String fromCurrency, String toCurrency) {
        return selectList(new LambdaQueryWrapperX<ExchangeRateDO>()
                .eq(ExchangeRateDO::getFromCurrency, fromCurrency)
                .eq(ExchangeRateDO::getToCurrency, toCurrency)
                .orderByDesc(ExchangeRateDO::getEffectiveDate)
                .orderByDesc(ExchangeRateDO::getId));
    }

    default Long selectCountByCurrencyCode(String currencyCode) {
        return selectCount(new LambdaQueryWrapperX<ExchangeRateDO>()
                .and(w -> w.eq(ExchangeRateDO::getFromCurrency, currencyCode)
                        .or()
                        .eq(ExchangeRateDO::getToCurrency, currencyCode)));
    }

}
