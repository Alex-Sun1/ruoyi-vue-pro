package cn.iocoder.yudao.module.oms.service.cargogroupingfieldmeta;

import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingfieldmeta.vo.CargoGroupingFieldMetaSaveReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingfieldmeta.vo.CargoGroupingFieldMetaPageReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargogroupingfieldmeta.vo.CargoGroupingFieldMetaRespVO;

import java.util.List;

public interface CargoGroupingFieldMetaService {

    List<CargoGroupingFieldMetaRespVO> queryList(CargoGroupingFieldMetaPageReqVO bo);

    CargoGroupingFieldMetaRespVO queryById(Long id);

    Boolean insertByBo(CargoGroupingFieldMetaSaveReqVO bo);

    Boolean updateByBo(CargoGroupingFieldMetaSaveReqVO bo);

    Boolean enable(Long id);

    Boolean disable(Long id);
}
