-- 回填 biz_root.current_node，修复货物订单状态 Tab 统计为 0
-- 原因：统计 SQL 依赖 biz_root.current_node，历史/演示数据仅有 oms_cargo_order.fulfillment_status

SET SQL_SAFE_UPDATES = 0;

UPDATE `biz_root` br
INNER JOIN `oms_cargo_order` co
        ON co.`biz_root_id` = br.`id`
       AND co.`deleted` = 0
SET br.`current_node` = COALESCE(NULLIF(br.`current_node`, ''), NULLIF(co.`fulfillment_status`, '')),
    br.`current_node_name` = CASE COALESCE(NULLIF(br.`current_node`, ''), NULLIF(co.`fulfillment_status`, ''))
        WHEN 'PENDING_ACCEPT' THEN '待受理'
        WHEN 'ACCEPTED' THEN '已受理'
        WHEN 'IN_TRANSIT' THEN '在途'
        WHEN 'ARRIVED_PORT' THEN '已到港'
        WHEN 'PICKED_UP' THEN '已提柜'
        WHEN 'ARRIVED_WAREHOUSE' THEN '已到仓'
        WHEN 'DEVANNING' THEN '拆柜中'
        WHEN 'DEVANNED' THEN '拆柜完成'
        WHEN 'INBOUNDED' THEN '已入库'
        WHEN 'OUTBOUND_ORDERED' THEN '已出单'
        WHEN 'DELIVERY_APPOINTED' THEN '已预约派送'
        WHEN 'OUTBOUNDED' THEN '已出库'
        WHEN 'DELIVERING' THEN '派送中'
        WHEN 'DELIVERED' THEN '已签收'
        WHEN 'POD_UPLOADED' THEN 'POD已上传'
        WHEN 'BILLED' THEN '已出账'
        WHEN 'COMPLETED' THEN '已完成'
        WHEN 'CANCELLED' THEN '已取消'
        ELSE br.`current_node_name`
    END,
    br.`update_time` = NOW()
WHERE br.`deleted` = 0
  AND (br.`current_node` IS NULL OR br.`current_node` = '')
  AND co.`fulfillment_status` IS NOT NULL
  AND co.`fulfillment_status` != '';

SET SQL_SAFE_UPDATES = 1;
