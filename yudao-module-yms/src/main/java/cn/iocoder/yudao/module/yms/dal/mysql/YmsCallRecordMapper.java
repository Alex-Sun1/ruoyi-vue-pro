package cn.iocoder.yudao.module.yms.dal.mysql;

import org.apache.ibatis.annotations.Mapper;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;

import org.apache.ibatis.annotations.Param;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsCallRecordDO;

@Mapper
public interface YmsCallRecordMapper extends BaseMapperX<YmsCallRecordDO> {

    int countByYardTaskId(@Param("yardTaskId") Long yardTaskId);
}

