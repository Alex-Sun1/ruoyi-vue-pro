package cn.iocoder.yudao.module.base.dal.mysql.i18n;

import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.dal.dataobject.i18n.EntityTranslationDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.Collection;
import java.util.List;

@Mapper
public interface EntityTranslationMapper extends BaseMapperX<EntityTranslationDO> {

    default List<EntityTranslationDO> selectList(String entityType, Long entityId, String fieldName) {
        return selectList(new LambdaQueryWrapperX<EntityTranslationDO>()
                .eq(EntityTranslationDO::getEntityType, entityType)
                .eq(EntityTranslationDO::getEntityId, entityId)
                .eqIfPresent(EntityTranslationDO::getFieldName, fieldName)
                .orderByAsc(EntityTranslationDO::getLangCode));
    }

    default List<EntityTranslationDO> selectListByEntityIds(String entityType, String fieldName,
                                                            Collection<Long> entityIds, String langCode) {
        return selectList(new LambdaQueryWrapperX<EntityTranslationDO>()
                .eq(EntityTranslationDO::getEntityType, entityType)
                .eq(EntityTranslationDO::getFieldName, fieldName)
                .in(EntityTranslationDO::getEntityId, entityIds)
                .eq(EntityTranslationDO::getLangCode, langCode));
    }

    default void deleteByEntity(String entityType, Long entityId, String fieldName) {
        delete(new LambdaQueryWrapperX<EntityTranslationDO>()
                .eq(EntityTranslationDO::getEntityType, entityType)
                .eq(EntityTranslationDO::getEntityId, entityId)
                .eq(EntityTranslationDO::getFieldName, fieldName));
    }

}
