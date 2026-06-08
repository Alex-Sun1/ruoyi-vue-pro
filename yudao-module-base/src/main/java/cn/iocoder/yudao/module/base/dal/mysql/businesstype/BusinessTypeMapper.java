package cn.iocoder.yudao.module.base.dal.mysql.businesstype;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.businesstype.vo.BusinessTypePageReqVO;
import cn.iocoder.yudao.module.base.dal.dataobject.businesstype.BusinessTypeDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface BusinessTypeMapper extends BaseMapperX<BusinessTypeDO> {

    default PageResult<BusinessTypeDO> selectPage(BusinessTypePageReqVO reqVO) {
        LambdaQueryWrapperX<BusinessTypeDO> wrapper = new LambdaQueryWrapperX<>();
        wrapper.and(StrUtil.isNotBlank(reqVO.getKeyword()), w -> w
                .like(BusinessTypeDO::getBusinessTypeCode, reqVO.getKeyword())
                .or()
                .like(BusinessTypeDO::getBusinessTypeName, reqVO.getKeyword()));
        wrapper.eqIfPresent(BusinessTypeDO::getBusinessCategory, reqVO.getBusinessCategory());
        wrapper.eqIfPresent(BusinessTypeDO::getOperationFlowType, reqVO.getOperationFlowType());
        wrapper.eqIfPresent(BusinessTypeDO::getStatus, reqVO.getStatus());
        wrapper.orderByAsc(BusinessTypeDO::getSortOrder).orderByAsc(BusinessTypeDO::getBusinessTypeCode);
        return selectPage(reqVO, wrapper);
    }

    default BusinessTypeDO selectByUnique(String businessTypeCode) {
        return selectOne(new LambdaQueryWrapperX<BusinessTypeDO>()
                .eq(BusinessTypeDO::getBusinessTypeCode, businessTypeCode));
    }

    default List<BusinessTypeDO> selectSimpleList(Integer status, String businessCategory, String operationFlowType) {
        LambdaQueryWrapperX<BusinessTypeDO> wrapper = new LambdaQueryWrapperX<>();
        wrapper.eqIfPresent(BusinessTypeDO::getStatus, status);
        wrapper.eqIfPresent(BusinessTypeDO::getBusinessCategory, businessCategory);
        wrapper.eqIfPresent(BusinessTypeDO::getOperationFlowType, operationFlowType);
        return selectList(wrapper.orderByAsc(BusinessTypeDO::getSortOrder)
                .orderByAsc(BusinessTypeDO::getBusinessTypeCode));
    }

}
