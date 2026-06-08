package cn.iocoder.yudao.module.yms.dal.mysql;

import org.apache.ibatis.annotations.Mapper;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsAppointmentDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsAppointmentRespVO;

@Mapper
public interface YmsAppointmentMapper extends BaseMapperX<YmsAppointmentDO> {

    Page<YmsAppointmentRespVO> selectPageList(@Param("page") Page<YmsAppointmentDO> page,
                                          @Param("bo") YmsAppointmentQueryReqVO bo);

    /** 统计某日期+时段已用预约数 */
    int countBySlot(@Param("warehouseId") Long warehouseId,
                    @Param("aptDate") String aptDate,
                    @Param("aptSlot") String aptSlot);

    /** 某日预约列表（看板用） */
    java.util.List<YmsAppointmentRespVO> selectListByDate(@Param("warehouseId") Long warehouseId,
                                                      @Param("aptDate") String aptDate);
}

