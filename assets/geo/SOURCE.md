# Cambodian administrative hierarchy (2025)

Source: Ministry of Economy and Finance open data portal,
`CambodiaProvinceList2025.csv`, `CambodiaDistrictList2025.csv`,
`CambodiaCommuneList2025.csv`, and `CambodiaVillagesList2025.csv`
(General Department of Digital Economy), mirrored by the MIT-licensed
`bsthen/CambodiaGeoAPI` dataset.

Format: `provinces.json` lists the 25 first-level units; `provinces/<code>.json`
contains nested districts, communes, and villages with official codes and
Khmer/English names. Used only for address pickers and reverse-geocode
matching; the app does not modify this reference data.
