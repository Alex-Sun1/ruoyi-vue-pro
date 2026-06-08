package cn.iocoder.yudao.module.org.dal.mysql.permission;

import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.org.dal.dataobject.permission.OrgRoleCompanyScopeDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.Collection;
import java.util.List;

@Mapper
public interface OrgRoleCompanyScopeMapper extends BaseMapperX<OrgRoleCompanyScopeDO> {

    default List<OrgRoleCompanyScopeDO> selectListByRoleId(Long roleId) {
        return selectList(new LambdaQueryWrapperX<OrgRoleCompanyScopeDO>().eq(OrgRoleCompanyScopeDO::getRoleId, roleId));
    }

    default List<OrgRoleCompanyScopeDO> selectListByRoleIds(Collection<Long> roleIds) {
        return selectList(new LambdaQueryWrapperX<OrgRoleCompanyScopeDO>().in(OrgRoleCompanyScopeDO::getRoleId, roleIds));
    }

    default int deleteByRoleId(Long roleId) {
        return delete(new LambdaQueryWrapperX<OrgRoleCompanyScopeDO>().eq(OrgRoleCompanyScopeDO::getRoleId, roleId));
    }

}
