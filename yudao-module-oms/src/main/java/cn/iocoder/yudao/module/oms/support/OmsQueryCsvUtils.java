package cn.iocoder.yudao.module.oms.support;

import cn.hutool.core.util.StrUtil;

import java.util.Arrays;
import java.util.List;

/**
 * 高级筛选逗号分隔多选值解析。
 */
public final class OmsQueryCsvUtils {

    private OmsQueryCsvUtils() {
    }

    public static List<String> toStringList(String csv) {
        if (StrUtil.isBlank(csv)) {
            return null;
        }
        List<String> list = Arrays.stream(csv.split(","))
            .map(String::trim)
            .filter(StrUtil::isNotBlank)
            .distinct()
            .toList();
        return list.isEmpty() ? null : list;
    }

    public static List<Long> toLongList(String csv) {
        List<String> parts = toStringList(csv);
        if (parts == null) {
            return null;
        }
        return parts.stream().map(Long::valueOf).toList();
    }
}
