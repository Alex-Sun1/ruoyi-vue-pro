package cn.iocoder.yudao.module.yms.dal.mysql;

import org.apache.ibatis.annotations.Mapper;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import cn.iocoder.yudao.module.yms.dal.dataobject.YmsBlacklistDO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsBlacklistQueryReqVO;
import cn.iocoder.yudao.module.yms.controller.admin.vo.YmsBlacklistRespVO;

@Mapper
public interface YmsBlacklistMapper extends BaseMapperX<YmsBlacklistDO> {

    Page<YmsBlacklistRespVO> selectPageList(@Param("page") Page<YmsBlacklistDO> page,
                                        @Param("bo") YmsBlacklistQueryReqVO bo);
}

