package cn.iocoder.yudao.module.oms.dal.mysql.cargogroupingfieldmeta;
import org.apache.ibatis.annotations.Mapper;

import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargogroupingfieldmeta.CargoGroupingFieldMetaDO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingfieldmeta.vo.CargoGroupingFieldMetaRespVO;

@Mapper
public interface CargoGroupingFieldMetaMapper extends BaseMapperX<CargoGroupingFieldMetaDO> {
}
