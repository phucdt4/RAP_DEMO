@AbapCatalog.sqlViewAppendName: 'ZXIPRODUCTPREM'
@EndUserText.label: 'CDS View Erweiterung I_Produkt'
extend view I_Product with ZX_I_Product_Premium {
    mara.zzpremium as ZZPremium
}

