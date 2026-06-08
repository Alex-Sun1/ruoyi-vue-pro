package cn.iocoder.yudao.module.oms.service.omsbizlifecycle;

import java.util.Date;

public interface OmsBizLifecycleService {

    Boolean transitionCargo(Long cargoOrderId, String nextNode, String action, String remark);

    Boolean transitionCargo(Long cargoOrderId, String nextNode, String action, String remark, Date nodeTime);
}
