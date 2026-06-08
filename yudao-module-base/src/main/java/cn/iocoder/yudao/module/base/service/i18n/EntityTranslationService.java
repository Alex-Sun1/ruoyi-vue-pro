package cn.iocoder.yudao.module.base.service.i18n;

import cn.iocoder.yudao.module.base.controller.admin.i18n.vo.EntityTranslationRespVO;
import cn.iocoder.yudao.module.base.controller.admin.i18n.vo.EntityTranslationSaveBatchReqVO;

import java.util.Collection;
import java.util.List;
import java.util.Map;

public interface EntityTranslationService {

    List<EntityTranslationRespVO> getTranslationList(String entityType, Long entityId, String fieldName);

    void saveTranslationBatch(EntityTranslationSaveBatchReqVO reqVO);

    void saveTranslations(String entityType, Long entityId, String fieldName,
                          List<CountryTranslationItem> items);

    Map<Long, String> getDisplayNameMap(String entityType, String fieldName,
                                        Collection<Long> entityIds, String langCode);

    /**
     * 国家保存 VO 中的翻译项（langCode + value）
     */
    record CountryTranslationItem(String langCode, String value) {
    }

}
