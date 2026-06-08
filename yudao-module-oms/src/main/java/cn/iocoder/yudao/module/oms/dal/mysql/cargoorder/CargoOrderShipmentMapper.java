package cn.iocoder.yudao.module.oms.dal.mysql.cargoorder;
import org.apache.ibatis.annotations.Mapper;

import org.apache.ibatis.annotations.Param;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderShipmentDO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderShipmentRespVO;

import java.util.Date;
import java.util.List;

@Mapper
public interface CargoOrderShipmentMapper extends BaseMapperX<CargoOrderShipmentDO> {

    Date selectMinDwTime(@Param("cargoOrderId") Long cargoOrderId);

    List<CargoOrderShipmentRespVO> selectByCargoOrderId(@Param("cargoOrderId") Long cargoOrderId);

    /** 根据海柜订单ID查询所有货件（通过 cargo_order 关联） */
    List<CargoOrderShipmentDO> selectShipmentsByContainerOrderId(@Param("containerOrderId") Long containerOrderId);
}
