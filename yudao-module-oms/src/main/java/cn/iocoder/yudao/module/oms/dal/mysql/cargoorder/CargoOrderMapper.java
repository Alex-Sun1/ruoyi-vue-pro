package cn.iocoder.yudao.module.oms.dal.mysql.cargoorder;
import org.apache.ibatis.annotations.Mapper;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.module.oms.dal.dataobject.cargoorder.CargoOrderDO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderPageReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.cargoorder.vo.CargoOrderRespVO;

import java.util.List;
import java.util.Map;

@Mapper
public interface CargoOrderMapper extends BaseMapperX<CargoOrderDO> {

        IPage<CargoOrderRespVO> selectPageList(@Param("page") Page<CargoOrderDO> page,
                                       @Param("bo") CargoOrderPageReqVO bo);

    List<Map<String, Object>> selectStatusCount(@Param("bo") CargoOrderPageReqVO bo);
}
