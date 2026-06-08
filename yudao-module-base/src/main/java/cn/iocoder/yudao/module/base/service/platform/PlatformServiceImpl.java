package cn.iocoder.yudao.module.base.service.platform;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.base.controller.admin.common.vo.BaseTranslationItemVO;
import cn.iocoder.yudao.module.base.controller.admin.platform.vo.*;
import cn.iocoder.yudao.module.base.dal.dataobject.platform.PlatformDO;
import cn.iocoder.yudao.module.base.dal.mysql.platform.PlatformMapper;
import cn.iocoder.yudao.module.base.dal.mysql.platformaddress.PlatformAddressMapper;
import cn.iocoder.yudao.module.base.enums.BaseEntityTypeEnum;
import cn.iocoder.yudao.module.base.enums.BaseTranslationFieldEnum;
import cn.iocoder.yudao.module.base.framework.web.BaseLocaleUtils;
import cn.iocoder.yudao.module.base.service.i18n.EntityTranslationService;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.util.*;
import java.util.stream.Collectors;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.base.enums.ErrorCodeConstants.*;

@Service
@Validated
public class PlatformServiceImpl implements PlatformService {

    @Resource
    private PlatformMapper platformMapper;
    @Resource
    private PlatformAddressMapper platformAddressMapper;
    @Resource
    private EntityTranslationService entityTranslationService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createPlatform(PlatformSaveReqVO createReqVO) {
        normalizeFields(createReqVO);
        validateUnique(null, createReqVO.getCode());
        if (createReqVO.getStatus() == null) {
            createReqVO.setStatus(CommonStatusEnum.ENABLE.getStatus());
        }
        if (createReqVO.getSortOrder() == null) {
            createReqVO.setSortOrder(0);
        }
        PlatformDO row = BeanUtils.toBean(createReqVO, PlatformDO.class);
        platformMapper.insert(row);
        saveTranslations(row.getId(), createReqVO.getTranslations());
        return row.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updatePlatform(PlatformSaveReqVO updateReqVO) {
        PlatformDO existing = validateExists(updateReqVO.getId());
        normalizeFields(updateReqVO);
        if (!Objects.equals(existing.getCode(), updateReqVO.getCode())) {
            throw exception(PLATFORM_CODE_NOT_MODIFIABLE);
        }
        updateReqVO.setCode(existing.getCode());
        validateUnique(updateReqVO.getId(), updateReqVO.getCode());
        PlatformDO updateObj = BeanUtils.toBean(updateReqVO, PlatformDO.class);
        updateObj.setStatus(existing.getStatus());
        if (updateReqVO.getLogoOssId() == null) {
            updateObj.setLogoOssId(existing.getLogoOssId());
        }
        if (updateReqVO.getSortOrder() == null) {
            updateObj.setSortOrder(existing.getSortOrder());
        }
        platformMapper.updateById(updateObj);
        saveTranslations(updateReqVO.getId(), updateReqVO.getTranslations());
    }

    @Override
    public void updatePlatformStatus(PlatformUpdateStatusReqVO reqVO) {
        validateExists(reqVO.getId());
        PlatformDO update = new PlatformDO();
        update.setId(reqVO.getId());
        update.setStatus(reqVO.getStatus());
        platformMapper.updateById(update);
    }

    @Override
    public PlatformRespVO getPlatform(Long id) {
        PlatformDO row = validateExists(id);
        String langCode = BaseLocaleUtils.getLangCode();
        PlatformRespVO resp = buildRespVO(row, langCode, buildAddressCountMap(Collections.singletonList(row.getId())));
        List<BaseTranslationItemVO> items = entityTranslationService.getTranslationList(
                        BaseEntityTypeEnum.PLATFORM.getType(), id, BaseTranslationFieldEnum.NAME.getFieldName())
                .stream()
                .map(t -> {
                    BaseTranslationItemVO vo = new BaseTranslationItemVO();
                    vo.setLangCode(t.getLangCode());
                    vo.setValue(t.getValue());
                    return vo;
                })
                .collect(Collectors.toList());
        resp.setTranslations(items);
        return resp;
    }

    @Override
    public PageResult<PlatformRespVO> getPlatformPage(PlatformPageReqVO pageReqVO) {
        PageResult<PlatformDO> pageResult = platformMapper.selectPage(pageReqVO);
        String langCode = BaseLocaleUtils.getLangCode();
        List<Long> ids = pageResult.getList().stream().map(PlatformDO::getId).collect(Collectors.toList());
        Map<Long, String> displayMap = entityTranslationService.getDisplayNameMap(
                BaseEntityTypeEnum.PLATFORM.getType(), BaseTranslationFieldEnum.NAME.getFieldName(),
                ids, langCode);
        Map<Long, Long> addressCountMap = buildAddressCountMap(ids);
        List<PlatformRespVO> list = pageResult.getList().stream().map(row -> {
            PlatformRespVO vo = BeanUtils.toBean(row, PlatformRespVO.class);
            vo.setNameDisplay(displayMap.getOrDefault(row.getId(), row.getNameEn()));
            vo.setAddressCount(addressCountMap.getOrDefault(row.getId(), 0L));
            return vo;
        }).collect(Collectors.toList());
        return new PageResult<>(list, pageResult.getTotal());
    }

    @Override
    public List<PlatformRespVO> getPlatformSimpleList(Integer status) {
        List<PlatformDO> list = platformMapper.selectSimpleList(status);
        String langCode = BaseLocaleUtils.getLangCode();
        List<Long> ids = list.stream().map(PlatformDO::getId).collect(Collectors.toList());
        Map<Long, String> displayMap = entityTranslationService.getDisplayNameMap(
                BaseEntityTypeEnum.PLATFORM.getType(), BaseTranslationFieldEnum.NAME.getFieldName(),
                ids, langCode);
        return list.stream().map(row -> {
            PlatformRespVO vo = BeanUtils.toBean(row, PlatformRespVO.class);
            vo.setNameDisplay(displayMap.getOrDefault(row.getId(), row.getNameEn()));
            return vo;
        }).collect(Collectors.toList());
    }

    private PlatformRespVO buildRespVO(PlatformDO row, String langCode, Map<Long, Long> addressCountMap) {
        PlatformRespVO vo = BeanUtils.toBean(row, PlatformRespVO.class);
        Map<Long, String> displayMap = entityTranslationService.getDisplayNameMap(
                BaseEntityTypeEnum.PLATFORM.getType(), BaseTranslationFieldEnum.NAME.getFieldName(),
                Collections.singleton(row.getId()), langCode);
        vo.setNameDisplay(displayMap.getOrDefault(row.getId(), row.getNameEn()));
        vo.setAddressCount(addressCountMap.getOrDefault(row.getId(), 0L));
        return vo;
    }

    private Map<Long, Long> buildAddressCountMap(List<Long> platformIds) {
        if (platformIds == null || platformIds.isEmpty()) {
            return Collections.emptyMap();
        }
        Map<Long, Long> result = new HashMap<>();
        for (Long platformId : platformIds) {
            result.put(platformId, platformAddressMapper.selectCountByPlatformId(platformId));
        }
        return result;
    }

    private void saveTranslations(Long platformId, List<BaseTranslationItemVO> translations) {
        if (translations == null) {
            return;
        }
        List<EntityTranslationService.CountryTranslationItem> items = translations.stream()
                .filter(t -> StrUtil.isNotBlank(t.getLangCode()) && StrUtil.isNotBlank(t.getValue()))
                .map(t -> new EntityTranslationService.CountryTranslationItem(t.getLangCode(), t.getValue()))
                .collect(Collectors.toList());
        entityTranslationService.saveTranslations(
                BaseEntityTypeEnum.PLATFORM.getType(), platformId,
                BaseTranslationFieldEnum.NAME.getFieldName(), items);
    }

    private void normalizeFields(PlatformSaveReqVO reqVO) {
        if (reqVO.getCode() != null) {
            reqVO.setCode(reqVO.getCode().trim().toUpperCase());
        }
        if (reqVO.getNameEn() != null) {
            reqVO.setNameEn(reqVO.getNameEn().trim());
        }
        if (reqVO.getTypeCode() != null) {
            reqVO.setTypeCode(reqVO.getTypeCode().trim());
        }
    }

    private PlatformDO validateExists(Long id) {
        PlatformDO row = platformMapper.selectById(id);
        if (row == null) {
            throw exception(PLATFORM_NOT_EXISTS);
        }
        return row;
    }

    private void validateUnique(Long id, String code) {
        PlatformDO exist = platformMapper.selectByUnique(code);
        if (exist != null && (id == null || !exist.getId().equals(id))) {
            throw exception(PLATFORM_DUPLICATE);
        }
    }

}
