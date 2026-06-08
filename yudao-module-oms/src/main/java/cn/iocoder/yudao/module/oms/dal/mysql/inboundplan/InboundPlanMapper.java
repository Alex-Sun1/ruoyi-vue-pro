package cn.iocoder.yudao.module.oms.dal.mysql.inboundplan;
import org.apache.ibatis.annotations.Mapper;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.module.oms.dal.dataobject.inboundplan.InboundPlanDO;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanPageReqVO;
import cn.iocoder.yudao.module.oms.controller.admin.inboundplan.vo.InboundPlanRespVO;

/**
 * 入库计划 Mapper
 */
@Mapper
public interface InboundPlanMapper extends BaseMapperX<InboundPlanDO> {

    Page<InboundPlanRespVO> selectPageList(@Param("page") Page<InboundPlanDO> page,
                                        @Param("bo") InboundPlanPageReqVO bo);
}
