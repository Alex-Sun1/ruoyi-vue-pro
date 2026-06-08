package cn.iocoder.yudao.module.base.dal.mysql.i18n;

import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.base.dal.dataobject.i18n.LanguageDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface LanguageMapper extends BaseMapperX<LanguageDO> {

    default List<LanguageDO> selectSimpleList(Integer status) {
        LambdaQueryWrapperX<LanguageDO> wrapper = new LambdaQueryWrapperX<>();
        if (status != null) {
            wrapper.eq(LanguageDO::getStatus, status);
        }
        return selectList(wrapper.orderByAsc(LanguageDO::getSortOrder).orderByAsc(LanguageDO::getId));
    }

    default List<LanguageDO> selectEnabledList() {
        return selectSimpleList(CommonStatusEnum.ENABLE.getStatus());
    }

}
