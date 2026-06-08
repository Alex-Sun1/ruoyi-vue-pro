package cn.iocoder.yudao.module.oms.controller.admin.bizattachment.vo;

import cn.iocoder.yudao.module.oms.controller.admin.bizattachment.vo.BizAttachmentRespVO;

import lombok.Data;
import cn.iocoder.yudao.module.oms.dal.dataobject.biz.BizAttachmentDO;

import java.io.Serializable;
import java.util.Date;

@Data
public class BizAttachmentRespVO implements Serializable {

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
    private String remark;
    private Date createTime;
}
