package cn.iocoder.yudao.module.org.service.permission.dto;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.Set;

@Data
public class OrgUserOrgPermissionDTO {

    private Set<Long> visibleWarehouseIds = Collections.emptySet();

    private Set<Long> visibleCompanyIds = Collections.emptySet();

    private String orgScopeSummary;

    private LocalDateTime builtAt;

}
