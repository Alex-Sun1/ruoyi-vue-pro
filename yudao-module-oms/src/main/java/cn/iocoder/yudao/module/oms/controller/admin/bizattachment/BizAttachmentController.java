package cn.iocoder.yudao.module.oms.controller.admin.bizattachment;

import jakarta.validation.Valid;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

import org.springframework.security.access.prepost.PreAuthorize;
import jakarta.annotation.Resource;
import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.module.oms.dal.dataobject.biz.BizAttachmentDO;
import cn.iocoder.yudao.module.oms.dal.mysql.biz.BizAttachmentMapper;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Validated
@RestController
@RequestMapping("/biz/attachment")
public class BizAttachmentController  {

    @Resource
    private BizAttachmentMapper attachmentMapper;

    @PreAuthorize("@ss.hasPermission('biz:attachment:preview')")
    @GetMapping("/{id}/preview")
    public CommonResult<String> preview(@PathVariable Long id) {
        BizAttachmentDO attachment = attachmentMapper.selectById(id);
        return success(attachment == null ? null : attachment.getFileUrl());
    }

    @PreAuthorize("@ss.hasPermission('biz:attachment:download')")
    @GetMapping("/{id}/download")
    public CommonResult<String> download(@PathVariable Long id) {
        BizAttachmentDO attachment = attachmentMapper.selectById(id);
        return success(attachment == null ? null : attachment.getFileUrl());
    }
}
