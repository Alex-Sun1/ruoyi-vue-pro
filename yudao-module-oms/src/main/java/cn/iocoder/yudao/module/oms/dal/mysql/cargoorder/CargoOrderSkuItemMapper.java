package cn.iocoder.yudao.module.oms.dal.mysql.cargoorder;
import org.apache.ibatis.annotations.Mapper;

import org.apache.ibatis.annotations.Param;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderSkuItemDO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderSkuItemRespVO;

import java.util.List;

@Mapper
public interface CargoOrderSkuItemMapper extends BaseMapperX<CargoOrderSkuItemDO> {

    List<CargoOrderSkuItemRespVO> selectByCargoOrderId(@Param("cargoOrderId") Long cargoOrderId);

    List<CargoOrderSkuItemRespVO> selectByShipmentId(@Param("shipmentId") Long shipmentId);
}
