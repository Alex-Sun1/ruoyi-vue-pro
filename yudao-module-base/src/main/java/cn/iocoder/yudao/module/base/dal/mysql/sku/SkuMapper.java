package cn.iocoder.yudao.module.base.dal.mysql.sku;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.sku.vo.SkuPageReqVO;
import cn.iocoder.yudao.module.base.dal.dataobject.sku.SkuDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface SkuMapper extends BaseMapperX<SkuDO> {

    default PageResult<SkuDO> selectPage(SkuPageReqVO reqVO) {
        LambdaQueryWrapperX<SkuDO> wrapper = new LambdaQueryWrapperX<>();
        wrapper.and(StrUtil.isNotBlank(reqVO.getKeyword()), w -> w
                .like(SkuDO::getSkuCode, reqVO.getKeyword())
                .or()
                .like(SkuDO::getSkuName, reqVO.getKeyword())
                .or()
                .like(SkuDO::getBarcode, reqVO.getKeyword()));
        wrapper.eqIfPresent(SkuDO::getClientId, reqVO.getClientId());
        wrapper.eqIfPresent(SkuDO::getStatus, reqVO.getStatus());
        wrapper.eqIfPresent(SkuDO::getIsFragile, reqVO.getIsFragile());
        wrapper.eqIfPresent(SkuDO::getIsLiquid, reqVO.getIsLiquid());
        wrapper.eqIfPresent(SkuDO::getIsBattery, reqVO.getIsBattery());
        wrapper.eqIfPresent(SkuDO::getIsMagnetic, reqVO.getIsMagnetic());
        wrapper.eqIfPresent(SkuDO::getIsDangerous, reqVO.getIsDangerous());
        wrapper.eqIfPresent(SkuDO::getIsOversize, reqVO.getIsOversize());
        wrapper.orderByDesc(SkuDO::getId);
        return selectPage(reqVO, wrapper);
    }

    default SkuDO selectByUnique(Long clientId, String skuCode) {
        return selectOne(new LambdaQueryWrapperX<SkuDO>()
                .eq(SkuDO::getClientId, clientId)
                .eq(SkuDO::getSkuCode, skuCode));
    }

    default Long selectCountByDefaultPkgId(Long defaultPkgId) {
        return selectCount(new LambdaQueryWrapperX<SkuDO>()
                .eq(SkuDO::getDefaultPkgId, defaultPkgId));
    }

    default List<SkuDO> selectSimpleList(Long clientId, Integer status) {
        LambdaQueryWrapperX<SkuDO> wrapper = new LambdaQueryWrapperX<>();
        wrapper.eqIfPresent(SkuDO::getClientId, clientId);
        if (status != null) {
            wrapper.eq(SkuDO::getStatus, status);
        }
        return selectList(wrapper.orderByAsc(SkuDO::getSkuCode));
    }

}
