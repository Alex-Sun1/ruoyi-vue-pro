package cn.iocoder.yudao.module.oms.dal.dataobject.biz;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import cn.iocoder.yudao.module.oms.controller.admin.bizattachment.vo.BizAttachmentRespVO;

import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = true)
@TableName("biz_attachment")
public class BizAttachmentDO extends TenantBaseDO {

    @TableId
    private Long id;

    private Long bizRootId;
    private String targetType;
    private Long targetId;
    private String targetNo;
    private String attachmentType;
    private String fileName;
    private String fileUrl;
    private Long fileSize;
    private String fileExt;
    private String mimeType;
    private Integer customerVisibleFlag;
    private Integer internalVisibleFlag;
    private Long uploadUserId;
    private String uploadUserName;
    private Date uploadTime;
    private String remark;}
