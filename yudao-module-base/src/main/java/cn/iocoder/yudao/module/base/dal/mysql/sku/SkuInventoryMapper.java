package cn.iocoder.yudao.module.base.dal.mysql.sku;

import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.dal.dataobject.sku.SkuInventoryDO;
import org.apache.ibatis.annotations.Mapper;

import java.math.BigDecimal;
import java.util.Collection;
import java.util.List;

@Mapper
public interface SkuInventoryMapper extends BaseMapperX<SkuInventoryDO> {

    default SkuInventoryDO selectBySkuId(Long skuId) {
        return selectOne(new LambdaQueryWrapperX<SkuInventoryDO>()
                .eq(SkuInventoryDO::getSkuId, skuId));
    }

    default List<SkuInventoryDO> selectListBySkuIds(Collection<Long> skuIds) {
        return selectList(new LambdaQueryWrapperX<SkuInventoryDO>()
                .in(SkuInventoryDO::getSkuId, skuIds));
    }

    default boolean hasStock(Long skuId) {
        SkuInventoryDO inv = selectBySkuId(skuId);
        return inv != null && inv.getQtyOnHand() != null
                && inv.getQtyOnHand().compareTo(BigDecimal.ZERO) > 0;
    }

}
