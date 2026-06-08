package cn.iocoder.yudao.module.org.dal.mysql.permission;

import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.org.dal.dataobject.permission.OrgRoleWarehouseScopeDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.Collection;
import java.util.List;

@Mapper
public interface OrgRoleWarehouseScopeMapper extends BaseMapperX<OrgRoleWarehouseScopeDO> {

    default List<OrgRoleWarehouseScopeDO> selectListByRoleId(Long roleId) {
        return selectList(new LambdaQueryWrapperX<OrgRoleWarehouseScopeDO>().eq(OrgRoleWarehouseScopeDO::getRoleId, roleId));
    }

    default List<OrgRoleWarehouseScopeDO> selectListByRoleIds(Collection<Long> roleIds) {
        return selectList(new LambdaQueryWrapperX<OrgRoleWarehouseScopeDO>().in(OrgRoleWarehouseScopeDO::getRoleId, roleIds));
    }

    default int deleteByRoleId(Long roleId) {
        return delete(new LambdaQueryWrapperX<OrgRoleWarehouseScopeDO>().eq(OrgRoleWarehouseScopeDO::getRoleId, roleId));
    }

}
