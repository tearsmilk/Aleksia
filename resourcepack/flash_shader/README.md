# Шейдер вспышки FlashCreeper

`rendertype_text.vsh/.fsh` — текстовый шейдер BetterHud (его оригинал лежит в `betterhud_original/`,
взят из `plugins/BetterHud/build.zip`, overlay `betterhud_1_21_6`) плюс ветка вспышки:
title с цветом `#FEFEFD` растягивается на весь экран и заливается белым.

Наш пак стоит первым в PaperResources, поэтому его `rendertype_text` перекрывает BetterHud.
Чтобы HUD не ломался, шейдер BetterHud включён сюда целиком. Если BetterHud пересоберёт пак
с другим шейдером, нужно повторить слияние: взять новый `betterhud_1_21_6/.../rendertype_text.*`
и вставить ветку вспышки (см. tools/patch_pack.py и эти файлы как образец).
