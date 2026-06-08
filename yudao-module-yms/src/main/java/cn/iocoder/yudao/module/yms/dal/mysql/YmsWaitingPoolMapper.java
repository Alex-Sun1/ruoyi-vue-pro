package cn.iocoder.yudao.module.yms.dal.mysql;

import org.apache.ibatis.annotations.Mapper;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;

import org.apache.ibatis.annotations.Param;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsWaitingPoolQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsWaitingPoolRespVO;

import java.util.List;

@Mapper
public interface YmsWaitingPoolMapper {

    List<YmsWaitingPoolRespVO> selectWaitingList(@Param("bo") YmsWaitingPoolQueryReqVO bo);
}

