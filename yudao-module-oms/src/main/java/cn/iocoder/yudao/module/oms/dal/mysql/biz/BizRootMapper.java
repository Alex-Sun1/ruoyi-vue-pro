package cn.iocoder.yudao.module.oms.dal.mysql.biz;
import org.apache.ibatis.annotations.Mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Param;
import cn.iocoder.yudao.module.oms.dal.dataobject.biz.BizRootDO;

import java.util.List;

/**
 * 业务主线根 Mapper
 */
@Mapper
public interface BizRootMapper extends BaseMapper<BizRootDO> {

    /**
     * 物理删除（绕过 @TableLogic），用于海柜订单编辑时重建子记录。
     * biz_root 有 uk_root_no_tenant 唯一键，逻辑删除后再插入同编号会冲突。
     */
    @Delete("<script>DELETE FROM biz_root WHERE id IN " +
            "<foreach collection='ids' item='id' open='(' separator=',' close=')'>#{id}</foreach>" +
            "</script>")
    void physicalDeleteByIds(@Param("ids") List<Long> ids);
}
