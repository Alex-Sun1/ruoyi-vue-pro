package cn.iocoder.yudao.module.oms.dal.mysql.cargoorder;
import org.apache.ibatis.annotations.Mapper;

import org.apache.ibatis.annotations.Param;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderNodeTraceDO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderNodeTraceRespVO;

import java.util.List;

@Mapper
public interface CargoOrderNodeTraceMapper extends BaseMapperX<CargoOrderNodeTraceDO> {

    List<CargoOrderNodeTraceRespVO> selectByCargoOrderId(@Param("cargoOrderId") Long cargoOrderId);
}
