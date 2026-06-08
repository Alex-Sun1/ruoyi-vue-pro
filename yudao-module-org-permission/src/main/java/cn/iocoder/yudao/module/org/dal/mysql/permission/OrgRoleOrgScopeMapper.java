package cn.iocoder.yudao.module.org.dal.mysql.permission;

import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.org.dal.dataobject.permission.OrgRoleOrgScopeDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.Collection;
import java.util.List;

@Mapper
public interface OrgRoleOrgScopeMapper extends BaseMapperX<OrgRoleOrgScopeDO> {

    default OrgRoleOrgScopeDO selectByRoleId(Long roleId) {
        return selectOne(new LambdaQueryWrapperX<OrgRoleOrgScopeDO>().eq(OrgRoleOrgScopeDO::getRoleId, roleId));
    }

    default List<OrgRoleOrgScopeDO> selectListByRoleIds(Collection<Long> roleIds) {
        return selectList(new LambdaQueryWrapperX<OrgRoleOrgScopeDO>().in(OrgRoleOrgScopeDO::getRoleId, roleIds));
    }

    default int deleteByRoleId(Long roleId) {
        return delete(new LambdaQueryWrapperX<OrgRoleOrgScopeDO>().eq(OrgRoleOrgScopeDO::getRoleId, roleId));
    }

}
