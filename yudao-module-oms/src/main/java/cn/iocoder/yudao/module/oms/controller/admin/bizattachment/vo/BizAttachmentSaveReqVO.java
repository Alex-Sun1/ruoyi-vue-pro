package cn.iocoder.yudao.module.oms.controller.admin.bizattachment.vo;

import cn.iocoder.yudao.module.oms.controller.admin.bizattachment.vo.BizAttachmentSaveReqVO;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import cn.iocoder.yudao.module.oms.dal.dataobject.biz.BizAttachmentDO;

@Data
public class BizAttachmentSaveReqVO {

    private Long id;
    private Long bizRootId;
    private String targetType;
    private Long targetId;
    private String targetNo;

    @NotBlank(message = "附件类型不能为空")
    private String attachmentType;

    @NotBlank(message = "文件名不能为空")
    private String fileName;

    @NotBlank(message = "文件地址不能为空")
    private String fileUrl;

    private Long fileSize;
    private String fileExt;
    private String mimeType;
    private Integer customerVisibleFlag;
    private Integer internalVisibleFlag;
    private String remark;
}
