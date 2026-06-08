/**
 * 根据前端 backend-integration 约定生成 yudao-module-base 骨架
 * 运行: node scripts/generate-yudao-module-base.mjs
 */
import fs from 'node:fs';
import path from 'node:path';

const root = path.resolve(import.meta.dirname, '..');
const moduleRoot = path.join(root, 'yudao-module-base/src/main/java/cn/iocoder/yudao/module/base');
const pkg = 'cn.iocoder.yudao.module.base';

const entities = [
  {
    className: 'Country',
    pkg: 'country',
    table: 'base_country',
    apiPath: 'country',
    comment: '国家',
    perm: 'standard',
    unique: ['code'],
    simpleActiveField: 'isActive',
    simpleActiveValue: 1,
    fields: [
      { j: 'code', c: 'code', t: 'String', sql: 'varchar(2) NOT NULL' },
      { j: 'nameEn', c: 'name_en', t: 'String', sql: 'varchar(128) NOT NULL' },
      { j: 'phoneCode', c: 'phone_code', t: 'String', sql: 'varchar(16) DEFAULT NULL' },
      { j: 'currencyCode', c: 'currency_code', t: 'String', sql: 'varchar(3) DEFAULT NULL' },
      { j: 'timezoneDefault', c: 'timezone_default', t: 'String', sql: 'varchar(64) DEFAULT NULL' },
      { j: 'isActive', c: 'is_active', t: 'Integer', sql: 'tinyint NOT NULL DEFAULT 1' },
      { j: 'sortOrder', c: 'sort_order', t: 'Integer', sql: 'int NOT NULL DEFAULT 0' },
    ],
    pageLikes: ['code', 'nameEn'],
    pageEq: ['isActive'],
  },
  {
    className: 'StateProvince',
    pkg: 'state',
    table: 'base_state_province',
    apiPath: 'state-province',
    comment: '州/省',
    perm: 'standard',
    unique: ['countryCode', 'code'],
    fields: [
      { j: 'countryCode', c: 'country_code', t: 'String', sql: 'varchar(2) NOT NULL' },
      { j: 'code', c: 'code', t: 'String', sql: 'varchar(32) NOT NULL' },
      { j: 'nameEn', c: 'name_en', t: 'String', sql: 'varchar(128) NOT NULL' },
      { j: 'sortOrder', c: 'sort_order', t: 'Integer', sql: 'int NOT NULL DEFAULT 0' },
      { j: 'status', c: 'status', t: 'Integer', sql: 'tinyint NOT NULL DEFAULT 0' },
    ],
    pageLikes: ['code', 'nameEn'],
    pageEq: ['countryCode', 'status'],
    simpleStatus: true,
  },
  {
    className: 'City',
    pkg: 'city',
    table: 'base_city',
    apiPath: 'city',
    comment: '城市',
    perm: 'standard',
    unique: ['countryCode', 'stateCode', 'nameEn'],
    fields: [
      { j: 'countryCode', c: 'country_code', t: 'String', sql: 'varchar(2) NOT NULL' },
      { j: 'stateCode', c: 'state_code', t: 'String', sql: 'varchar(32) NOT NULL' },
      { j: 'nameEn', c: 'name_en', t: 'String', sql: 'varchar(128) NOT NULL' },
      { j: 'status', c: 'status', t: 'Integer', sql: 'tinyint NOT NULL DEFAULT 0' },
    ],
    pageLikes: ['nameEn'],
    pageEq: ['countryCode', 'stateCode', 'status'],
    simpleStatus: true,
  },
  {
    className: 'ZipCode',
    pkg: 'zipcode',
    table: 'base_zip_code',
    apiPath: 'zip-code',
    comment: '邮编',
    perm: 'standard',
    unique: ['countryCode', 'zip'],
    fields: [
      { j: 'countryCode', c: 'country_code', t: 'String', sql: 'varchar(2) NOT NULL' },
      { j: 'stateCode', c: 'state_code', t: 'String', sql: 'varchar(32) DEFAULT NULL' },
      { j: 'cityName', c: 'city_name', t: 'String', sql: 'varchar(128) NOT NULL' },
      { j: 'zip', c: 'zip', t: 'String', sql: 'varchar(32) NOT NULL' },
    ],
    pageLikes: ['zip'],
    pageEq: ['countryCode', 'stateCode'],
  },
  {
    className: 'Timezone',
    pkg: 'timezone',
    table: 'base_timezone',
    apiPath: 'timezone',
    comment: '时区',
    perm: 'standard',
    unique: ['tzCode'],
    fields: [
      { j: 'tzCode', c: 'tz_code', t: 'String', sql: 'varchar(64) NOT NULL' },
      { j: 'nameEn', c: 'name_en', t: 'String', sql: 'varchar(128) NOT NULL' },
      { j: 'utcOffset', c: 'utc_offset', t: 'String', sql: 'varchar(16) NOT NULL' },
      { j: 'countryCode', c: 'country_code', t: 'String', sql: 'varchar(2) DEFAULT NULL' },
      { j: 'isDst', c: 'is_dst', t: 'Integer', sql: 'tinyint NOT NULL DEFAULT 0' },
      { j: 'status', c: 'status', t: 'Integer', sql: 'tinyint NOT NULL DEFAULT 0' },
      { j: 'sortOrder', c: 'sort_order', t: 'Integer', sql: 'int NOT NULL DEFAULT 0' },
    ],
    pageLikes: ['tzCode', 'nameEn'],
    pageEq: ['countryCode', 'status'],
    simpleStatus: true,
  },
  {
    className: 'Currency',
    pkg: 'currency',
    table: 'base_currency',
    apiPath: 'currency',
    comment: '币种',
    perm: 'standard',
    unique: ['code'],
    fields: [
      { j: 'code', c: 'code', t: 'String', sql: 'varchar(3) NOT NULL' },
      { j: 'nameEn', c: 'name_en', t: 'String', sql: 'varchar(128) NOT NULL' },
      { j: 'symbol', c: 'symbol', t: 'String', sql: 'varchar(16) NOT NULL' },
      { j: 'decimalPlaces', c: 'decimal_places', t: 'Integer', sql: 'tinyint NOT NULL DEFAULT 2' },
      { j: 'isBase', c: 'is_base', t: 'Integer', sql: 'tinyint NOT NULL DEFAULT 0' },
      { j: 'status', c: 'status', t: 'Integer', sql: 'tinyint NOT NULL DEFAULT 0' },
      { j: 'sortOrder', c: 'sort_order', t: 'Integer', sql: 'int NOT NULL DEFAULT 0' },
    ],
    pageLikes: ['code'],
    pageEq: ['status'],
    simpleStatus: true,
  },
  {
    className: 'ExchangeRate',
    pkg: 'exchangerate',
    table: 'base_exchange_rate',
    apiPath: 'exchange-rate',
    comment: '汇率',
    perm: 'exchange-rate',
    unique: ['fromCurrency', 'toCurrency', 'effectiveDate'],
    fields: [
      { j: 'fromCurrency', c: 'from_currency', t: 'String', sql: 'varchar(3) NOT NULL' },
      { j: 'toCurrency', c: 'to_currency', t: 'String', sql: 'varchar(3) NOT NULL' },
      { j: 'rate', c: 'rate', t: 'BigDecimal', sql: 'decimal(18,6) NOT NULL' },
      { j: 'effectiveDate', c: 'effective_date', t: 'LocalDate', sql: 'date NOT NULL' },
      { j: 'expiredDate', c: 'expired_date', t: 'LocalDate', sql: 'date DEFAULT NULL' },
      { j: 'isCurrent', c: 'is_current', t: 'Integer', sql: 'tinyint NOT NULL DEFAULT 1' },
      { j: 'remark', c: 'remark', t: 'String', sql: 'varchar(512) DEFAULT NULL' },
    ],
    pageEq: ['fromCurrency', 'toCurrency', 'isCurrent'],
  },
  {
    className: 'Platform',
    pkg: 'platform',
    table: 'base_platform',
    apiPath: 'platform',
    comment: '平台',
    perm: 'standard',
    unique: ['code'],
    fields: [
      { j: 'code', c: 'code', t: 'String', sql: 'varchar(32) NOT NULL' },
      { j: 'nameEn', c: 'name_en', t: 'String', sql: 'varchar(128) NOT NULL' },
      { j: 'typeCode', c: 'type_code', t: 'String', sql: 'varchar(32) NOT NULL' },
      { j: 'logoOssId', c: 'logo_oss_id', t: 'Long', sql: 'bigint DEFAULT NULL' },
      { j: 'logoUrl', c: 'logo_url', t: 'String', sql: 'varchar(512) DEFAULT NULL' },
      { j: 'status', c: 'status', t: 'Integer', sql: 'tinyint NOT NULL DEFAULT 0' },
      { j: 'sortOrder', c: 'sort_order', t: 'Integer', sql: 'int NOT NULL DEFAULT 0' },
    ],
    pageLikes: ['code'],
    pageEq: ['typeCode', 'status'],
    simpleStatus: true,
  },
  {
    className: 'PlatformAddress',
    pkg: 'platformaddress',
    table: 'base_platform_address',
    apiPath: 'platform-address',
    comment: '平台地址',
    perm: 'standard',
    unique: ['platformId', 'addressCode'],
    fields: [
      { j: 'platformId', c: 'platform_id', t: 'Long', sql: 'bigint NOT NULL' },
      { j: 'addressCode', c: 'address_code', t: 'String', sql: 'varchar(64) NOT NULL' },
      { j: 'addressType', c: 'address_type', t: 'Integer', sql: 'tinyint NOT NULL' },
      { j: 'nameEn', c: 'name_en', t: 'String', sql: 'varchar(128) NOT NULL' },
      { j: 'countryCode', c: 'country_code', t: 'String', sql: 'varchar(2) NOT NULL' },
      { j: 'stateCode', c: 'state_code', t: 'String', sql: 'varchar(32) DEFAULT NULL' },
      { j: 'city', c: 'city', t: 'String', sql: 'varchar(128) DEFAULT NULL' },
      { j: 'addressLine1', c: 'address_line1', t: 'String', sql: 'varchar(256) NOT NULL' },
      { j: 'addressLine2', c: 'address_line2', t: 'String', sql: 'varchar(256) DEFAULT NULL' },
      { j: 'zipCode', c: 'zip_code', t: 'String', sql: 'varchar(32) DEFAULT NULL' },
      { j: 'contactName', c: 'contact_name', t: 'String', sql: 'varchar(64) DEFAULT NULL' },
      { j: 'contactPhone', c: 'contact_phone', t: 'String', sql: 'varchar(32) DEFAULT NULL' },
      { j: 'lastVerifiedAt', c: 'last_verified_at', t: 'LocalDateTime', sql: 'datetime DEFAULT NULL' },
      { j: 'status', c: 'status', t: 'Integer', sql: 'tinyint NOT NULL DEFAULT 0' },
      { j: 'remark', c: 'remark', t: 'String', sql: 'varchar(512) DEFAULT NULL' },
    ],
    pageLikes: ['addressCode'],
    pageEq: ['platformId', 'countryCode', 'addressType', 'status'],
    simpleStatus: true,
  },
  {
    className: 'Port',
    pkg: 'port',
    table: 'base_port',
    apiPath: 'port',
    comment: '港口',
    perm: 'standard',
    unique: ['portCode'],
    fields: [
      { j: 'portCode', c: 'port_code', t: 'String', sql: 'varchar(16) NOT NULL' },
      { j: 'nameEn', c: 'name_en', t: 'String', sql: 'varchar(128) NOT NULL' },
      { j: 'countryCode', c: 'country_code', t: 'String', sql: 'varchar(2) NOT NULL' },
      { j: 'stateCode', c: 'state_code', t: 'String', sql: 'varchar(32) DEFAULT NULL' },
      { j: 'city', c: 'city', t: 'String', sql: 'varchar(128) DEFAULT NULL' },
      { j: 'portType', c: 'port_type', t: 'Integer', sql: 'tinyint NOT NULL' },
      { j: 'timezone', c: 'timezone', t: 'String', sql: 'varchar(64) DEFAULT NULL' },
      { j: 'containerQueryUrl', c: 'container_query_url', t: 'String', sql: 'varchar(512) DEFAULT NULL' },
      { j: 'status', c: 'status', t: 'Integer', sql: 'tinyint NOT NULL DEFAULT 0' },
      { j: 'remark', c: 'remark', t: 'String', sql: 'varchar(512) DEFAULT NULL' },
    ],
    pageLikes: ['portCode', 'nameEn'],
    pageEq: ['countryCode', 'portType', 'status'],
    simpleStatus: true,
  },
  {
    className: 'ShippingLine',
    pkg: 'shippingline',
    table: 'base_shipping_line',
    apiPath: 'shipping-line',
    comment: '船司',
    perm: 'standard',
    unique: ['code'],
    fields: [
      { j: 'code', c: 'code', t: 'String', sql: 'varchar(16) NOT NULL' },
      { j: 'nameEn', c: 'name_en', t: 'String', sql: 'varchar(128) NOT NULL' },
      { j: 'nameAbbr', c: 'name_abbr', t: 'String', sql: 'varchar(32) DEFAULT NULL' },
      { j: 'countryCode', c: 'country_code', t: 'String', sql: 'varchar(2) DEFAULT NULL' },
      { j: 'contactEmail', c: 'contact_email', t: 'String', sql: 'varchar(128) DEFAULT NULL' },
      { j: 'contactPhone', c: 'contact_phone', t: 'String', sql: 'varchar(32) DEFAULT NULL' },
      { j: 'website', c: 'website', t: 'String', sql: 'varchar(256) DEFAULT NULL' },
      { j: 'trackingUrl', c: 'tracking_url', t: 'String', sql: 'varchar(512) DEFAULT NULL' },
      { j: 'status', c: 'status', t: 'Integer', sql: 'tinyint NOT NULL DEFAULT 0' },
      { j: 'remark', c: 'remark', t: 'String', sql: 'varchar(512) DEFAULT NULL' },
    ],
    pageLikes: ['code', 'nameEn', 'nameAbbr'],
    pageEq: ['countryCode', 'status'],
    simpleStatus: true,
  },
  {
    className: 'FeeItem',
    pkg: 'feeitem',
    table: 'mdm_fee_item',
    apiPath: 'fee-item',
    comment: '费项',
    perm: 'standard',
    unique: ['feeCode'],
    fields: [
      { j: 'feeCode', c: 'fee_code', t: 'String', sql: 'varchar(32) NOT NULL' },
      { j: 'feeName', c: 'fee_name', t: 'String', sql: 'varchar(128) NOT NULL' },
      { j: 'feeCategory', c: 'fee_category', t: 'String', sql: 'varchar(32) NOT NULL' },
      { j: 'businessStage', c: 'business_stage', t: 'String', sql: 'varchar(32) NOT NULL' },
      { j: 'businessType', c: 'business_type', t: 'String', sql: 'varchar(32) DEFAULT NULL' },
      { j: 'isSystem', c: 'is_system', t: 'Integer', sql: 'tinyint NOT NULL DEFAULT 0' },
      { j: 'isBillable', c: 'is_billable', t: 'Integer', sql: 'tinyint NOT NULL DEFAULT 1' },
      { j: 'description', c: 'description', t: 'String', sql: 'varchar(512) DEFAULT NULL' },
      { j: 'status', c: 'status', t: 'Integer', sql: 'tinyint NOT NULL DEFAULT 0' },
      { j: 'sortOrder', c: 'sort_order', t: 'Integer', sql: 'int NOT NULL DEFAULT 0' },
      { j: 'remark', c: 'remark', t: 'String', sql: 'varchar(512) DEFAULT NULL' },
    ],
    pageLikes: ['feeCode'],
    pageEq: ['feeCategory', 'businessStage', 'businessType', 'status'],
    simpleStatus: true,
  },
  {
    className: 'Sku',
    pkg: 'sku',
    table: 'mdm_sku',
    apiPath: 'sku',
    comment: 'SKU',
    perm: 'standard',
    unique: ['clientId', 'skuCode'],
    fields: [
      { j: 'clientId', c: 'client_id', t: 'Long', sql: 'bigint NOT NULL' },
      { j: 'skuCode', c: 'sku_code', t: 'String', sql: 'varchar(64) NOT NULL' },
      { j: 'skuName', c: 'sku_name', t: 'String', sql: 'varchar(256) NOT NULL' },
      { j: 'skuNameEn', c: 'sku_name_en', t: 'String', sql: 'varchar(256) DEFAULT NULL' },
      { j: 'barcode', c: 'barcode', t: 'String', sql: 'varchar(64) DEFAULT NULL' },
      { j: 'unit', c: 'unit', t: 'String', sql: 'varchar(16) NOT NULL DEFAULT \'pcs\'' },
      { j: 'status', c: 'status', t: 'Integer', sql: 'tinyint NOT NULL DEFAULT 0' },
      { j: 'remark', c: 'remark', t: 'String', sql: 'varchar(512) DEFAULT NULL' },
    ],
    pageLikes: ['skuCode', 'skuName', 'barcode'],
    pageEq: ['clientId', 'status'],
    simpleStatus: true,
  },
  {
    className: 'Company',
    pkg: 'company',
    table: 'mdm_company',
    apiPath: 'company',
    comment: '主体',
    perm: 'company',
    unique: ['companyCode'],
    fields: [
      { j: 'companyCode', c: 'company_code', t: 'String', sql: 'varchar(32) NOT NULL' },
      { j: 'companyName', c: 'company_name', t: 'String', sql: 'varchar(128) NOT NULL' },
      { j: 'companyNameEn', c: 'company_name_en', t: 'String', sql: 'varchar(128) DEFAULT NULL' },
      { j: 'taxNo', c: 'tax_no', t: 'String', sql: 'varchar(64) DEFAULT NULL' },
      { j: 'status', c: 'status', t: 'Integer', sql: 'tinyint NOT NULL DEFAULT 0' },
      { j: 'sort', c: 'sort', t: 'Integer', sql: 'int NOT NULL DEFAULT 0' },
      { j: 'remark', c: 'remark', t: 'String', sql: 'varchar(512) DEFAULT NULL' },
    ],
    pageLikes: ['companyCode', 'companyName'],
    simpleStatus: true,
  },
  {
    className: 'Warehouse',
    mapperClassName: 'BaseWarehouse', // 避免 Bean 名 warehouseMapper 与 MES MesWmWarehouseMapper 冲突
    pkg: 'warehouse',
    table: 'mdm_warehouse',
    apiPath: 'warehouse',
    comment: '仓库',
    perm: 'warehouse',
    unique: ['warehouseCode'],
    fields: [
      { j: 'warehouseCode', c: 'warehouse_code', t: 'String', sql: 'varchar(32) NOT NULL' },
      { j: 'warehouseName', c: 'warehouse_name', t: 'String', sql: 'varchar(128) NOT NULL' },
      { j: 'companyId', c: 'company_id', t: 'Long', sql: 'bigint DEFAULT NULL' },
      { j: 'timezoneCode', c: 'timezone_code', t: 'String', sql: 'varchar(64) NOT NULL' },
      { j: 'countryCode', c: 'country_code', t: 'String', sql: 'varchar(2) DEFAULT NULL' },
      { j: 'address', c: 'address', t: 'String', sql: 'varchar(512) DEFAULT NULL' },
      { j: 'status', c: 'status', t: 'Integer', sql: 'tinyint NOT NULL DEFAULT 0' },
      { j: 'sort', c: 'sort', t: 'Integer', sql: 'int NOT NULL DEFAULT 0' },
      { j: 'remark', c: 'remark', t: 'String', sql: 'varchar(512) DEFAULT NULL' },
    ],
    pageLikes: ['warehouseCode', 'warehouseName'],
    simpleStatus: true,
  },
];

function w(file, content) {
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, content, 'utf8');
}

function permExprs(perm) {
  if (perm === 'exchange-rate') {
    return { q: "base:exchange-rate:manage", c: "base:exchange-rate:manage", u: "base:exchange-rate:manage", d: "base:exchange-rate:manage" };
  }
  if (perm === 'company') {
    return { q: "base:company:query", c: "base:company:create", u: "base:company:update", d: "base:company:delete" };
  }
  if (perm === 'warehouse') {
    return { q: "base:warehouse:query", c: "base:warehouse:create", u: "base:warehouse:update", d: "base:warehouse:delete" };
  }
  return { q: "base:data:view", c: "base:data:edit", u: "base:data:edit", d: "base:data:delete" };
}

function importsForFields(fields) {
  const set = new Set();
  for (const f of fields) {
    if (f.t === 'BigDecimal') set.add('java.math.BigDecimal');
    if (f.t === 'LocalDate') set.add('java.time.LocalDate');
    if (f.t === 'LocalDateTime') set.add('java.time.LocalDateTime');
  }
  return [...set].map((i) => `import ${i};`).join('\n');
}

function genDO(e) {
  const imp = importsForFields(e.fields);
  return `package ${pkg}.dal.dataobject.${e.pkg};

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.KeySequence;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

${imp}

@TableName("${e.table}")
@KeySequence("${e.table}_seq")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ${e.className}DO extends TenantBaseDO {

    @TableId
    private Long id;

${e.fields.map((f) => `    private ${f.t} ${f.j};`).join('\n\n')}

}
`;
}

function genMapper(e) {
  const likes = (e.pageLikes || []).map((f) => {
    return `                .likeIfPresent(${e.className}DO::get${cap(f)}, reqVO.get${cap(f)}())`;
  });
  const eqs = (e.pageEq || []).map((f) => `                .eqIfPresent(${e.className}DO::get${cap(f)}, reqVO.get${cap(f)}())`);
  const mapperImports = importsForFields(e.fields);
  return `package ${pkg}.dal.mysql.${e.pkg};

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import ${pkg}.controller.admin.${e.pkg}.vo.${e.className}PageReqVO;
import ${pkg}.dal.dataobject.${e.pkg}.${e.className}DO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
${mapperImports ? '\n' + mapperImports : ''}

@Mapper
public interface ${mapperClass(e)} extends BaseMapperX<${e.className}DO> {

    default PageResult<${e.className}DO> selectPage(${e.className}PageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<${e.className}DO>()
${likes.join('\n')}
${eqs.join('\n')}
                .orderByDesc(${e.className}DO::getId));
    }

    default ${e.className}DO selectByUnique(${uniqueParams(e)}) {
        return selectOne(new LambdaQueryWrapperX<${e.className}DO>()
${e.unique.map((u) => `                .eq(${e.className}DO::get${cap(u)}, ${u})`).join('\n')});
    }

    default List<${e.className}DO> selectSimpleList() {
        LambdaQueryWrapperX<${e.className}DO> w = new LambdaQueryWrapperX<>();
${simpleFilter(e)}
        return selectList(w.orderByAsc(${e.className}DO::getId));
    }

}
`;
}

function uniqueParams(e) {
  return e.unique.map((u) => `${e.fields.find((f) => f.j === u)?.t || 'String'} ${u}`).join(', ');
}

function simpleFilter(e) {
  if (e.simpleActiveField) {
    return `        w.eq(${e.className}DO::get${cap(e.simpleActiveField)}, ${e.simpleActiveValue});`;
  }
  if (e.simpleStatus) {
    return `        w.eq(${e.className}DO::getStatus, cn.iocoder.yudao.framework.common.enums.CommonStatusEnum.ENABLE.getStatus());`;
  }
  return '';
}

function cap(s) {
  return s.charAt(0).toUpperCase() + s.slice(1);
}

function mapperClass(e) {
  return `${e.mapperClassName || e.className}Mapper`;
}

function mapperField(e) {
  return lc(e.mapperClassName || e.className) + 'Mapper';
}

function toErrPrefix(className) {
  return className.replace(/([a-z])([A-Z])/g, '$1_$2').toUpperCase();
}

function genServiceImpl(e) {
  const err = toErrPrefix(e.className);
  return `package ${pkg}.service.${e.pkg};

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import ${pkg}.controller.admin.${e.pkg}.vo.${e.className}PageReqVO;
import ${pkg}.controller.admin.${e.pkg}.vo.${e.className}SaveReqVO;
import ${pkg}.dal.dataobject.${e.pkg}.${e.className}DO;
import ${pkg}.dal.mysql.${e.pkg}.${mapperClass(e)};
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;

import java.util.List;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static ${pkg}.enums.ErrorCodeConstants.*;

@Service
@Validated
public class ${e.className}ServiceImpl implements ${e.className}Service {

    @Resource
    private ${mapperClass(e)} ${mapperField(e)};

    @Override
    public Long create${e.className}(${e.className}SaveReqVO createReqVO) {
        validateUnique(null, createReqVO);
        ${e.className}DO row = BeanUtils.toBean(createReqVO, ${e.className}DO.class);
        ${mapperField(e)}.insert(row);
        return row.getId();
    }

    @Override
    public void update${e.className}(${e.className}SaveReqVO updateReqVO) {
        validateExists(updateReqVO.getId());
        validateUnique(updateReqVO.getId(), updateReqVO);
        ${e.className}DO updateObj = BeanUtils.toBean(updateReqVO, ${e.className}DO.class);
        ${mapperField(e)}.updateById(updateObj);
    }

    @Override
    public void delete${e.className}(Long id) {
        validateExists(id);
        ${mapperField(e)}.deleteById(id);
    }

    private void validateExists(Long id) {
        if (${mapperField(e)}.selectById(id) == null) {
            throw exception(${err}_NOT_EXISTS);
        }
    }

    private void validateUnique(Long id, ${e.className}SaveReqVO reqVO) {
        ${e.className}DO exist = ${mapperField(e)}.selectByUnique(${e.unique.map((u) => `reqVO.get${cap(u)}()`).join(', ')});
        if (exist != null && (id == null || !exist.getId().equals(id))) {
            throw exception(${err}_DUPLICATE);
        }
    }

    @Override
    public ${e.className}DO get${e.className}(Long id) {
        return ${mapperField(e)}.selectById(id);
    }

    @Override
    public PageResult<${e.className}DO> get${e.className}Page(${e.className}PageReqVO pageReqVO) {
        return ${mapperField(e)}.selectPage(pageReqVO);
    }

    @Override
    public List<${e.className}DO> get${e.className}SimpleList() {
        return ${mapperField(e)}.selectSimpleList();
    }

}
`;
}

function lc(s) {
  return s.charAt(0).toLowerCase() + s.slice(1);
}

function genService(e) {
  return `package ${pkg}.service.${e.pkg};

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import ${pkg}.controller.admin.${e.pkg}.vo.${e.className}PageReqVO;
import ${pkg}.controller.admin.${e.pkg}.vo.${e.className}SaveReqVO;
import ${pkg}.dal.dataobject.${e.pkg}.${e.className}DO;

import java.util.List;

public interface ${e.className}Service {

    Long create${e.className}(${e.className}SaveReqVO createReqVO);

    void update${e.className}(${e.className}SaveReqVO updateReqVO);

    void delete${e.className}(Long id);

    ${e.className}DO get${e.className}(Long id);

    PageResult<${e.className}DO> get${e.className}Page(${e.className}PageReqVO pageReqVO);

    List<${e.className}DO> get${e.className}SimpleList();

}
`;
}

function genVOs(e) {
  const imp = importsForFields(e.fields);
  const pageFields = [...(e.pageLikes || []), ...(e.pageEq || [])];
  const page = `package ${pkg}.controller.admin.${e.pkg}.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Schema(description = "管理后台 - ${e.comment}分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class ${e.className}PageReqVO extends PageParam {

${pageFields.map((f) => `    @Schema(description = "${f}")\n    private ${e.fields.find((x) => x.j === f)?.t || 'String'} ${f};`).join('\n\n')}

}
`;
  const save = `package ${pkg}.controller.admin.${e.pkg}.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
${imp}

@Schema(description = "管理后台 - ${e.comment}新增/修改 Request VO")
@Data
public class ${e.className}SaveReqVO {

    @Schema(description = "编号", example = "1")
    private Long id;

${e.fields.filter((f) => f.j !== 'remark' && !f.j.includes('Url') && f.t !== 'LocalDateTime' && !f.sql.includes('DEFAULT NULL') && !f.sql.includes('DEFAULT \'pcs\'')).map((f) => `    @Schema(description = "${f.c}")\n    @NotNull(message = "${f.c}不能为空")\n    private ${f.t} ${f.j};`).join('\n\n')}
${e.fields.filter((f) => f.j === 'remark' || f.j.includes('Url') || f.t === 'LocalDateTime' || f.sql.includes('DEFAULT NULL') || f.sql.includes('DEFAULT \'pcs\'')).map((f) => `    @Schema(description = "${f.c}")\n    private ${f.t} ${f.j};`).join('\n\n')}

}
`;
  const resp = `package ${pkg}.controller.admin.${e.pkg}.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import java.time.LocalDateTime;
${imp}

@Schema(description = "管理后台 - ${e.comment} Response VO")
@Data
public class ${e.className}RespVO {

    @Schema(description = "编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    private Long id;

${e.fields.map((f) => `    @Schema(description = "${f.c}")\n    private ${f.t} ${f.j};`).join('\n\n')}

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

}
`;
  return { page, save, resp };
}

function genController(e) {
  const p = permExprs(e.perm);
  const simpleLabel = e.simpleActiveField ? 'isActive=1' : (e.simpleStatus ? 'status=启用' : '全部');
  return `package ${pkg}.controller.admin.${e.pkg};

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.common.util.object.BeanUtils;
import ${pkg}.controller.admin.${e.pkg}.vo.*;
import ${pkg}.dal.dataobject.${e.pkg}.${e.className}DO;
import ${pkg}.service.${e.pkg}.${e.className}Service;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - ${e.comment}")
@RestController
@RequestMapping("/base/${e.apiPath}")
@Validated
public class ${e.className}Controller {

    @Resource
    private ${e.className}Service ${lc(e.className)}Service;

    @PostMapping("/create")
    @Operation(summary = "创建${e.comment}")
    @PreAuthorize("@ss.hasPermission('${p.c}')")
    public CommonResult<Long> create(@Valid @RequestBody ${e.className}SaveReqVO createReqVO) {
        return success(${lc(e.className)}Service.create${e.className}(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新${e.comment}")
    @PreAuthorize("@ss.hasPermission('${p.u}')")
    public CommonResult<Boolean> update(@Valid @RequestBody ${e.className}SaveReqVO updateReqVO) {
        ${lc(e.className)}Service.update${e.className}(updateReqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除${e.comment}")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('${p.d}')")
    public CommonResult<Boolean> delete(@RequestParam("id") Long id) {
        ${lc(e.className)}Service.delete${e.className}(id);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得${e.comment}")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('${p.q}')")
    public CommonResult<${e.className}RespVO> get(@RequestParam("id") Long id) {
        ${e.className}DO row = ${lc(e.className)}Service.get${e.className}(id);
        return success(BeanUtils.toBean(row, ${e.className}RespVO.class));
    }

    @GetMapping("/page")
    @Operation(summary = "获得${e.comment}分页")
    @PreAuthorize("@ss.hasPermission('${p.q}')")
    public CommonResult<PageResult<${e.className}RespVO>> getPage(@Valid ${e.className}PageReqVO pageReqVO) {
        PageResult<${e.className}DO> pageResult = ${lc(e.className)}Service.get${e.className}Page(pageReqVO);
        return success(BeanUtils.toBean(pageResult, ${e.className}RespVO.class));
    }

    @GetMapping("/simple-list")
    @Operation(summary = "获得${e.comment}精简列表", description = "默认 ${simpleLabel}")
    public CommonResult<List<${e.className}RespVO>> getSimpleList() {
        List<${e.className}DO> list = ${lc(e.className)}Service.get${e.className}SimpleList();
        return success(BeanUtils.toBean(list, ${e.className}RespVO.class));
    }

}
`;
}

function genSql(entities) {
  const parts = entities.map((e) => {
    const cols = e.fields.map((f) => `  \`${f.c}\` ${f.sql} COMMENT '${f.c}',`).join('\n');
    const uk = e.unique.map((u) => e.fields.find((f) => f.j === u).c).join('`, `');
    return `-- ${e.comment}
DROP TABLE IF EXISTS \`${e.table}\`;
CREATE TABLE \`${e.table}\` (
  \`id\` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
${cols}
  \`creator\` varchar(64) DEFAULT '' COMMENT '创建者',
  \`create_time\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  \`updater\` varchar(64) DEFAULT '' COMMENT '更新者',
  \`update_time\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  \`deleted\` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
  \`tenant_id\` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
  PRIMARY KEY (\`id\`),
  UNIQUE KEY \`uk_tenant_unique\` (\`tenant_id\`, \`${uk}\`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='${e.comment}';
`;
  });
  return `-- 基础资料模块表结构\nSET NAMES utf8mb4;\n\n${parts.join('\n')}`;
}

function genErrorCodes(entities) {
  let code = 1_050_001_000;
  const lines = entities.flatMap((e) => {
    const err = toErrPrefix(e.className);
    const c1 = code++;
    const c2 = code++;
    return [
      `    // ========== ${e.comment} ${e.className} ==========`,
      `    ErrorCode ${err}_NOT_EXISTS = new ErrorCode(${c1}, "${e.comment}不存在");`,
      `    ErrorCode ${err}_DUPLICATE = new ErrorCode(${c2}, "${e.comment}已存在");`,
    ];
  });
  return `package ${pkg}.enums;

import cn.iocoder.yudao.framework.common.exception.ErrorCode;

/**
 * Base 基础资料模块，使用 1-050-xxx-xxx 段
 */
public interface ErrorCodeConstants {

${lines.join('\n')}

}
`;
}

for (const e of entities) {
  w(path.join(moduleRoot, 'dal/dataobject', e.pkg, `${e.className}DO.java`), genDO(e));
  w(path.join(moduleRoot, 'dal/mysql', e.pkg, `${mapperClass(e)}.java`), genMapper(e));
  w(path.join(moduleRoot, 'service', e.pkg, `${e.className}Service.java`), genService(e));
  w(path.join(moduleRoot, 'service', e.pkg, `${e.className}ServiceImpl.java`), genServiceImpl(e));
  const vos = genVOs(e);
  w(path.join(moduleRoot, 'controller/admin', e.pkg, 'vo', `${e.className}PageReqVO.java`), vos.page);
  w(path.join(moduleRoot, 'controller/admin', e.pkg, 'vo', `${e.className}SaveReqVO.java`), vos.save);
  w(path.join(moduleRoot, 'controller/admin', e.pkg, 'vo', `${e.className}RespVO.java`), vos.resp);
  w(path.join(moduleRoot, 'controller/admin', e.pkg, `${e.className}Controller.java`), genController(e));
}

w(path.join(root, 'yudao-module-base/src/main/java/cn/iocoder/yudao/module/base/enums/ErrorCodeConstants.java'), genErrorCodes(entities));
w(path.join(root, 'sql/mysql/base-tables.sql'), genSql(entities));

// 以下文件含手工业务逻辑，重新生成后需合并：
// - service/country/CountryServiceImpl.java
// - service/currency/CurrencyServiceImpl.java
// - service/zipcode/ZipCodeService*.java + ZipCodeController lookup
// - controller/admin/client/BaseClientController.java

console.log(`Generated ${entities.length} entities under yudao-module-base`);
