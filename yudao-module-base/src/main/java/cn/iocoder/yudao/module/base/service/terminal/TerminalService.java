package cn.iocoder.yudao.module.base.service.terminal;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.base.controller.admin.terminal.vo.*;

import java.util.List;

public interface TerminalService {

    Long createTerminal(TerminalSaveReqVO createReqVO);

    void updateTerminal(TerminalSaveReqVO updateReqVO);

    void deleteTerminal(Long id);

    TerminalRespVO getTerminal(Long id);

    PageResult<TerminalRespVO> getTerminalPage(TerminalPageReqVO pageReqVO);

    List<TerminalRespVO> getTerminalExportList(TerminalPageReqVO pageReqVO);

    /** 下拉精简列表（默认仅启用） */
    List<TerminalRespVO> getTerminalSimpleList(Integer status);

}
