package cn.iocoder.yudao.module.oms.dal.mysql.biz;
import org.apache.ibatis.annotations.Mapper;

import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.module.oms.dal.dataobject.biz.BizAttachmentDO;
import cn.iocoder.yudao.module.oms.controller.admin.bizattachment.vo.BizAttachmentRespVO;

@Mapper
public interface BizAttachmentMapper extends BaseMapperX<BizAttachmentDO> {
}
