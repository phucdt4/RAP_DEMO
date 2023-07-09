@AbapCatalog.sqlViewAppendName: 'ZXAPRODUCTPREM'
@EndUserText.label: 'CDS View Erweiterung A_Product'
extend view A_Product with ZX_A_Product_Premium {
    _ProductExt.ZZPremium as ZZPremium
}
