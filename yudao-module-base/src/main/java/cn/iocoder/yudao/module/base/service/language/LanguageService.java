package cn.iocoder.yudao.module.base.service.language;

import cn.iocoder.yudao.module.base.controller.admin.language.vo.LanguageSimpleRespVO;

import java.util.List;

public interface LanguageService {

    List<LanguageSimpleRespVO> getLanguageSimpleList(Integer status);

}
