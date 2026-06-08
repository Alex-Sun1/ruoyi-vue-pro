package cn.iocoder.yudao.module.base.dal.mysql.vessel;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.controller.admin.vessel.vo.VesselPageReqVO;
import cn.iocoder.yudao.module.base.dal.dataobject.vessel.VesselDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface VesselMapper extends BaseMapperX<VesselDO> {

    default PageResult<VesselDO> selectPage(VesselPageReqVO reqVO) {
        return selectPage(reqVO, buildQueryWrapper(reqVO));
    }

    default List<VesselDO> selectOptionList(VesselPageReqVO reqVO) {
        return selectList(buildQueryWrapper(reqVO));
    }

    default LambdaQueryWrapperX<VesselDO> buildQueryWrapper(VesselPageReqVO reqVO) {
        LambdaQueryWrapperX<VesselDO> wrapper = new LambdaQueryWrapperX<>();
        wrapper.likeIfPresent(VesselDO::getVesselCode, reqVO.getVesselCode());
        wrapper.likeIfPresent(VesselDO::getVesselName, reqVO.getVesselName());
        wrapper.likeIfPresent(VesselDO::getVesselNameEn, reqVO.getVesselNameEn());
        wrapper.likeIfPresent(VesselDO::getImoNo, reqVO.getImoNo());
        wrapper.eqIfPresent(VesselDO::getShippingLineId, reqVO.getShippingLineId());
        wrapper.eqIfPresent(VesselDO::getVesselType, reqVO.getVesselType());
        wrapper.eqIfPresent(VesselDO::getStatus, reqVO.getStatus());
        if (StrUtil.isNotBlank(reqVO.getKeyword())) {
            wrapper.and(w -> w.like(VesselDO::getVesselCode, reqVO.getKeyword())
                    .or().like(VesselDO::getVesselName, reqVO.getKeyword())
                    .or().like(VesselDO::getVesselNameEn, reqVO.getKeyword())
                    .or().like(VesselDO::getImoNo, reqVO.getKeyword()));
        }
        wrapper.orderByAsc(VesselDO::getShippingLineCode, VesselDO::getVesselCode);
        return wrapper;
    }

    default VesselDO selectByUnique(String vesselCode) {
        return selectOne(VesselDO::getVesselCode, vesselCode);
    }

}
