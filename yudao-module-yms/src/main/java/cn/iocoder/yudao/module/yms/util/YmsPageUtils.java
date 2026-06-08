package cn.iocoder.yudao.module.yms.util;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;

public final class YmsPageUtils {

    private YmsPageUtils() {
    }

    public static <T> Page<T> toPage(PageParam pageParam) {
        return new Page<>(pageParam.getPageNo(), pageParam.getPageSize());
    }

    public static <T> PageResult<T> toPageResult(Page<T> page) {
        if (page == null) {
            return PageResult.empty();
        }
        return new PageResult<>(page.getRecords(), page.getTotal());
    }

}
