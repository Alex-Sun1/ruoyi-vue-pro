package cn.iocoder.yudao.module.system.service.permission;

import cn.iocoder.yudao.framework.redis.config.YudaoRedisAutoConfiguration;
import org.junit.jupiter.api.Test;
import org.springframework.data.redis.serializer.RedisSerializer;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import java.nio.charset.StandardCharsets;

import static cn.iocoder.yudao.framework.common.util.collection.CollectionUtils.convertList;
import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertNotNull;

/**
 * 复现 @PreAuthorize → permission_menu_ids 缓存的 Redis JSON 反序列化问题。
 */
class PermissionMenuRedisSerializerTest {

    private final RedisSerializer<Object> serializer = (RedisSerializer<Object>) YudaoRedisAutoConfiguration.buildRedisSerializer();

    @Test
    void roundTrip_hashSet_shouldDeserializeAsObject() {
        Set<Long> original = new HashSet<>(Arrays.asList(6901L));
        assertRoundTrip(original);
    }

    @Test
    void roundTrip_arrayListFromConvertList_shouldDeserializeAsObject() {
        List<Long> original = new ArrayList<>(Arrays.asList(6901L));
        assertRoundTrip(original);
    }

    @Test
    void roundTrip_convertListOutput_shouldDeserializeAsObject() {
        // 权限缓存实际走 convertList → @Cacheable 写入 Redis
        assertRoundTrip(convertList(Arrays.asList(6901L), id -> id));
    }

    @Test
    void legacyBadPermissionMenuRedisJson_shouldFailDeserialize() {
        // 修复前 Redis 里实际存在的坏数据格式（用户报错 START_ARRAY 即此）
        byte[] bad = "[[\"java.lang.Long\",6901]]".getBytes(StandardCharsets.UTF_8);
        org.junit.jupiter.api.Assertions.assertThrows(
                org.springframework.data.redis.serializer.SerializationException.class,
                () -> serializer.deserialize(bad));
    }

    @Test
    void roundTrip_emptyHashSet_shouldDeserializeAsObject() {
        assertRoundTrip(new HashSet<Long>());
    }

    @Test
    void roundTrip_emptyArrayList_shouldDeserializeAsObject() {
        assertRoundTrip(new ArrayList<Long>());
    }

    private void assertRoundTrip(Object original) {
        byte[] bytes = serializer.serialize(original);
        assertNotNull(bytes, "serialize bytes");
        assertDoesNotThrow(() -> serializer.deserialize(bytes), () -> "deserialize failed for "
                + original.getClass().getName() + ", json=" + new String(bytes));
    }
}
