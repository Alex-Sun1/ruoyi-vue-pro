package cn.iocoder.yudao.module.base.service.language;

import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.base.controller.admin.language.vo.LanguageSimpleRespVO;
import cn.iocoder.yudao.module.base.dal.dataobject.i18n.LanguageDO;
import cn.iocoder.yudao.module.base.dal.mysql.i18n.LanguageMapper;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LanguageServiceImpl implements LanguageService {

    @Resource
    private LanguageMapper languageMapper;

    @Override
    public List<LanguageSimpleRespVO> getLanguageSimpleList(Integer status) {
        List<LanguageDO> list = languageMapper.selectSimpleList(status);
        return BeanUtils.toBean(list, LanguageSimpleRespVO.class);
    }

}
