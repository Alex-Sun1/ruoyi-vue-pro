package cn.iocoder.yudao.module.base.service.i18n;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.base.controller.admin.i18n.vo.EntityTranslationRespVO;
import cn.iocoder.yudao.module.base.controller.admin.i18n.vo.EntityTranslationSaveBatchReqVO;
import cn.iocoder.yudao.module.base.dal.dataobject.i18n.EntityTranslationDO;
import cn.iocoder.yudao.module.base.dal.mysql.i18n.EntityTranslationMapper;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.util.*;
import java.util.stream.Collectors;

@Service
@Validated
public class EntityTranslationServiceImpl implements EntityTranslationService {

    @Resource
    private EntityTranslationMapper entityTranslationMapper;

    @Override
    public List<EntityTranslationRespVO> getTranslationList(String entityType, Long entityId, String fieldName) {
        List<EntityTranslationDO> list = entityTranslationMapper.selectList(entityType, entityId, fieldName);
        return BeanUtils.toBean(list, EntityTranslationRespVO.class);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveTranslationBatch(EntityTranslationSaveBatchReqVO reqVO) {
        if (CollUtil.isEmpty(reqVO.getItems())) {
            return;
        }
        String fieldName = reqVO.getItems().get(0).getFieldName();
        entityTranslationMapper.deleteByEntity(reqVO.getEntityType(), reqVO.getEntityId(), fieldName);
        for (EntityTranslationSaveBatchReqVO.Item item : reqVO.getItems()) {
            if (StrUtil.isBlank(item.getValue())) {
                continue;
            }
            EntityTranslationDO row = EntityTranslationDO.builder()
                    .entityType(reqVO.getEntityType())
                    .entityId(reqVO.getEntityId())
                    .fieldName(item.getFieldName())
                    .langCode(item.getLangCode())
                    .value(item.getValue().trim())
                    .build();
            entityTranslationMapper.insert(row);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveTranslations(String entityType, Long entityId, String fieldName,
                                 List<CountryTranslationItem> items) {
        entityTranslationMapper.deleteByEntity(entityType, entityId, fieldName);
        if (CollUtil.isEmpty(items)) {
            return;
        }
        for (CountryTranslationItem item : items) {
            if (StrUtil.isBlank(item.langCode()) || StrUtil.isBlank(item.value())) {
                continue;
            }
            EntityTranslationDO row = EntityTranslationDO.builder()
                    .entityType(entityType)
                    .entityId(entityId)
                    .fieldName(fieldName)
                    .langCode(item.langCode().trim())
                    .value(item.value().trim())
                    .build();
            entityTranslationMapper.insert(row);
        }
    }

    @Override
    public Map<Long, String> getDisplayNameMap(String entityType, String fieldName,
                                               Collection<Long> entityIds, String langCode) {
        if (CollUtil.isEmpty(entityIds) || StrUtil.isBlank(langCode)) {
            return Collections.emptyMap();
        }
        List<EntityTranslationDO> list = entityTranslationMapper.selectListByEntityIds(
                entityType, fieldName, entityIds, langCode);
        return list.stream().collect(Collectors.toMap(EntityTranslationDO::getEntityId,
                EntityTranslationDO::getValue, (a, b) -> a));
    }

}
