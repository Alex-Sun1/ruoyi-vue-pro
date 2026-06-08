package cn.iocoder.yudao.module.base.dal.mysql.sku;

import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.dal.dataobject.sku.SkuDefaultFeeDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.Collection;
import java.util.List;

@Mapper
public interface SkuDefaultFeeMapper extends BaseMapperX<SkuDefaultFeeDO> {

    default List<SkuDefaultFeeDO> selectListBySkuId(Long skuId) {
        return selectList(new LambdaQueryWrapperX<SkuDefaultFeeDO>()
                .eq(SkuDefaultFeeDO::getSkuId, skuId));
    }

    default List<SkuDefaultFeeDO> selectListBySkuIds(Collection<Long> skuIds) {
        return selectList(new LambdaQueryWrapperX<SkuDefaultFeeDO>()
                .in(SkuDefaultFeeDO::getSkuId, skuIds));
    }

    default void deleteBySkuId(Long skuId) {
        delete(new LambdaQueryWrapperX<SkuDefaultFeeDO>()
                .eq(SkuDefaultFeeDO::getSkuId, skuId));
    }

}
