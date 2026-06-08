package cn.iocoder.yudao.module.base.service.shippingroute;

import cn.hutool.core.util.StrUtil;
import cn.iocoder.yudao.framework.common.enums.CommonStatusEnum;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import cn.iocoder.yudao.module.base.controller.admin.shippingroute.vo.*;
import cn.iocoder.yudao.module.base.dal.dataobject.port.PortDO;
import cn.iocoder.yudao.module.base.dal.dataobject.shippingline.ShippingLineDO;
import cn.iocoder.yudao.module.base.dal.dataobject.shippingroute.ShippingRouteDO;
import cn.iocoder.yudao.module.base.dal.mysql.port.PortMapper;
import cn.iocoder.yudao.module.base.dal.mysql.shippingline.ShippingLineMapper;
import cn.iocoder.yudao.module.base.dal.mysql.shippingroute.ShippingRouteMapper;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;

import java.util.List;
import java.util.Objects;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.base.enums.ErrorCodeConstants.*;

@Service
@Validated
public class ShippingRouteServiceImpl implements ShippingRouteService {

    private static final String DEFAULT_ROUTE_TYPE = "DIRECT";

    @Resource
    private ShippingRouteMapper shippingRouteMapper;
    @Resource
    private ShippingLineMapper shippingLineMapper;
    @Resource
    private PortMapper portMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createShippingRoute(ShippingRouteSaveReqVO createReqVO) {
        normalize(createReqVO);
        validateUnique(null, createReqVO.getRouteCode());
        if (createReqVO.getStatus() == null) {
            createReqVO.setStatus(CommonStatusEnum.ENABLE.getStatus());
        }
        if (StrUtil.isBlank(createReqVO.getRouteType())) {
            createReqVO.setRouteType(DEFAULT_ROUTE_TYPE);
        }
        ShippingRouteDO row = BeanUtils.toBean(createReqVO, ShippingRouteDO.class);
        fillSnapshots(row);
        shippingRouteMapper.insert(row);
        return row.getId();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateShippingRoute(ShippingRouteSaveReqVO updateReqVO) {
        ShippingRouteDO existing = validateExists(updateReqVO.getId());
        normalize(updateReqVO);
        if (!Objects.equals(existing.getRouteCode(), updateReqVO.getRouteCode())) {
            throw exception(SHIPPING_ROUTE_CODE_NOT_MODIFIABLE);
        }
        updateReqVO.setRouteCode(existing.getRouteCode());
        ShippingRouteDO update = BeanUtils.toBean(updateReqVO, ShippingRouteDO.class);
        fillSnapshots(update);
        update.setStatus(existing.getStatus());
        shippingRouteMapper.updateById(update);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteShippingRoute(Long id) {
        ShippingRouteDO row = validateExists(id);
        if (CommonStatusEnum.ENABLE.getStatus().equals(row.getStatus())) {
            throw exception(SHIPPING_ROUTE_DELETE_ENABLED);
        }
        shippingRouteMapper.deleteById(id);
    }

    @Override
    public ShippingRouteRespVO getShippingRoute(Long id) {
        return BeanUtils.toBean(validateExists(id), ShippingRouteRespVO.class);
    }

    @Override
    public PageResult<ShippingRouteRespVO> getShippingRoutePage(ShippingRoutePageReqVO pageReqVO) {
        return BeanUtils.toBean(shippingRouteMapper.selectPage(pageReqVO), ShippingRouteRespVO.class);
    }

    @Override
    public List<ShippingRouteRespVO> getShippingRouteExportList(ShippingRoutePageReqVO pageReqVO) {
        pageReqVO.setPageSize(-1);
        return getShippingRoutePage(pageReqVO).getList();
    }

    @Override
    public List<ShippingRouteRespVO> getShippingRouteSimpleList(Integer status) {
        ShippingRoutePageReqVO pageReqVO = new ShippingRoutePageReqVO();
        pageReqVO.setPageNo(1);
        pageReqVO.setPageSize(500);
        pageReqVO.setStatus(status != null ? status : CommonStatusEnum.ENABLE.getStatus());
        return getShippingRoutePage(pageReqVO).getList();
    }

    private void fillSnapshots(ShippingRouteDO route) {
        if (route.getShippingLineId() != null) {
            ShippingLineDO line = shippingLineMapper.selectById(route.getShippingLineId());
            if (line == null) {
                throw exception(SHIPPING_ROUTE_SHIPPING_LINE_NOT_EXISTS);
            }
            route.setShippingLineCode(line.getCode());
            route.setShippingLineName(StrUtil.isNotBlank(line.getNameAbbr()) ? line.getNameAbbr() : line.getNameEn());
        }
        if (route.getOriginPortId() != null) {
            PortDO port = portMapper.selectById(route.getOriginPortId());
            if (port == null) {
                throw exception(SHIPPING_ROUTE_ORIGIN_PORT_NOT_EXISTS);
            }
            route.setOriginPortCode(port.getPortCode());
            route.setOriginPortName(port.getNameEn());
        }
        if (route.getDestinationPortId() != null) {
            PortDO port = portMapper.selectById(route.getDestinationPortId());
            if (port == null) {
                throw exception(SHIPPING_ROUTE_DESTINATION_PORT_NOT_EXISTS);
            }
            route.setDestinationPortCode(port.getPortCode());
            route.setDestinationPortName(port.getNameEn());
        }
    }

    private ShippingRouteDO validateExists(Long id) {
        ShippingRouteDO row = shippingRouteMapper.selectById(id);
        if (row == null) {
            throw exception(SHIPPING_ROUTE_NOT_EXISTS);
        }
        return row;
    }

    private void validateUnique(Long id, String routeCode) {
        ShippingRouteDO exist = shippingRouteMapper.selectByUnique(routeCode);
        if (exist != null && (id == null || !exist.getId().equals(id))) {
            throw exception(SHIPPING_ROUTE_DUPLICATE);
        }
    }

    private void normalize(ShippingRouteSaveReqVO reqVO) {
        if (reqVO.getRouteCode() != null) {
            reqVO.setRouteCode(reqVO.getRouteCode().trim().toUpperCase());
        }
        if (reqVO.getRouteName() != null) {
            reqVO.setRouteName(reqVO.getRouteName().trim());
        }
        if (reqVO.getRouteNameEn() != null) {
            reqVO.setRouteNameEn(reqVO.getRouteNameEn().trim());
        }
        if (reqVO.getRouteType() != null) {
            reqVO.setRouteType(reqVO.getRouteType().trim().toUpperCase());
        }
    }

}
