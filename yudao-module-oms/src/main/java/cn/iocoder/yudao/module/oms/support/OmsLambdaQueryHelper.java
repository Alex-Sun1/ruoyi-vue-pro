package cn.iocoder.yudao.module.oms.support;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.support.SFunction;

import java.util.List;

/**
 * MyBatis-Plus 高级筛选逗号分隔多选条件。
 */
public final class OmsLambdaQueryHelper {

    private OmsLambdaQueryHelper() {
    }

    public static <T> void inStringCsv(LambdaQueryWrapper<T> lqw, SFunction<T, ?> column, String csv) {
        List<String> values = OmsQueryCsvUtils.toStringList(csv);
        if (values == null) {
            return;
        }
        if (values.size() == 1) {
            lqw.eq(column, values.get(0));
        } else {
            lqw.in(column, values);
        }
    }

    public static <T> void inLongCsv(LambdaQueryWrapper<T> lqw, SFunction<T, ?> column, String csv) {
        List<Long> values = OmsQueryCsvUtils.toLongList(csv);
        if (values == null) {
            return;
        }
        if (values.size() == 1) {
            lqw.eq(column, values.get(0));
        } else {
            lqw.in(column, values);
        }
    }

    public static <T> void inIntegerCsv(LambdaQueryWrapper<T> lqw, SFunction<T, ?> column, String csv) {
        List<String> parts = OmsQueryCsvUtils.toStringList(csv);
        if (parts == null) {
            return;
        }
        List<Integer> values = parts.stream().map(Integer::valueOf).toList();
        if (values.size() == 1) {
            lqw.eq(column, values.get(0));
        } else {
            lqw.in(column, values);
        }
    }

    public static <T> void likeAnyStringCsv(LambdaQueryWrapper<T> lqw, SFunction<T, ?> column, String csv) {
        List<String> values = OmsQueryCsvUtils.toStringList(csv);
        if (values == null) {
            return;
        }
        if (values.size() == 1) {
            lqw.like(column, values.get(0));
            return;
        }
        lqw.and(wrapper -> {
            for (String value : values) {
                wrapper.or().like(column, value);
            }
        });
    }
}
