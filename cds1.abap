@AbapCatalog.sqlViewName: 'ZSDPRACTICE1SQL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'practice cds view'
@Metadata.ignorePropagatedAnnotations: true
define view zcds_practice1 as select from vbak
{
    key vbeln as SALESRDER,
    erdat as CREATEDON,
    erzet as CREATEDAT,
    ernam as CREATEDBY,
    auart as TYPE,
    case auart
    when 'YTA' then 'PAID'
    when 'YDP' then 'PENDING'
    else 'NOT PAID'
    end as REFERENCE
}
