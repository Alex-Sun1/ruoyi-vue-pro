package cn.iocoder.yudao.module.base.dal.mysql.feeitem;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.feeitem.vo.FeeItemPageReqVO;
import cn.iocoder.yudao.module.base.dal.dataobject.feeitem.FeeItemDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface FeeItemMapper extends BaseMapperX<FeeItemDO> {

    default PageResult<FeeItemDO> selectPage(FeeItemPageReqVO reqVO) {
        LambdaQueryWrapperX<FeeItemDO> wrapper = new LambdaQueryWrapperX<>();
        wrapper.and(StrUtil.isNotBlank(reqVO.getKeyword()), w -> w
                .like(FeeItemDO::getFeeCode, reqVO.getKeyword())
                .or()
                .like(FeeItemDO::getFeeName, reqVO.getKeyword()));
        wrapper.eqIfPresent(FeeItemDO::getFeeCategory, reqVO.getFeeCategory());
        wrapper.eqIfPresent(FeeItemDO::getBusinessStage, reqVO.getBusinessStage());
        if (reqVO.getBusinessType() != null) {
            if (StrUtil.isBlank(reqVO.getBusinessType())) {
                wrapper.and(w -> w.isNull(FeeItemDO::getBusinessType)
                        .or().eq(FeeItemDO::getBusinessType, ""));
            } else {
                wrapper.eq(FeeItemDO::getBusinessType, reqVO.getBusinessType());
            }
        }
        wrapper.eqIfPresent(FeeItemDO::getStatus, reqVO.getStatus());
        wrapper.orderByAsc(FeeItemDO::getSortOrder).orderByDesc(FeeItemDO::getId);
        return selectPage(reqVO, wrapper);
    }

    default FeeItemDO selectByUnique(String feeCode) {
        return selectOne(new LambdaQueryWrapperX<FeeItemDO>()
                .eq(FeeItemDO::getFeeCode, feeCode));
    }

    default List<FeeItemDO> selectSimpleList(Integer status) {
        return selectSimpleList(status, null);
    }

    default List<FeeItemDO> selectSimpleList(Integer status, String feeCategory) {
        LambdaQueryWrapperX<FeeItemDO> wrapper = new LambdaQueryWrapperX<>();
        if (status != null) {
            wrapper.eq(FeeItemDO::getStatus, status);
        }
        wrapper.eqIfPresent(FeeItemDO::getFeeCategory, feeCategory);
        return selectList(wrapper.orderByAsc(FeeItemDO::getSortOrder).orderByAsc(FeeItemDO::getFeeCode));
    }

}
