@AbapCatalog.sqlViewAppendName: 'ZXEPRODUCTPREM'
@EndUserText.label: 'CDS View Erweiterung E_Product (Extension Include View)'
extend view E_Product with ZX_E_Product_Premium {
    Persistence.zzpremium as ZZPremium
}

