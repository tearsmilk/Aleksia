# Дополнительные item definitions

`<item>.json` здесь — определения предметов формата 1.21.4+ (`range_dispatch` по `custom_model_data`).
`tools/patch_pack.py` вливает их записи во все копии `assets/minecraft/items/<item>.json` внутри пака
(корень и overlays ItemsAdder), не трогая записи самого IA. Нужно для паков с «сырыми» моделями
(LostAssets Swordmaster: paper 551001..551024, stone_sword 551901), которые ItemsAdder сливать отказывается.
