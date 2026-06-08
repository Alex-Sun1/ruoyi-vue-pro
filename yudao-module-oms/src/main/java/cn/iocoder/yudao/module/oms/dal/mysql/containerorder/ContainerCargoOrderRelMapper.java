package cn.iocoder.yudao.module.oms.dal.mysql.containerorder;
import org.apache.ibatis.annotations.Mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import cn.iocoder.yudao.module.oms.dal.dataobject.containerorder.ContainerCargoOrderRelDO;

/**
 * 海柜-货物订单关系Mapper
 */
@Mapper
public interface ContainerCargoOrderRelMapper extends BaseMapper<ContainerCargoOrderRelDO> {
}
