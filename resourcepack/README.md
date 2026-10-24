# Ресурспак сервера lobby (ItemsAdder)

`generated.zip` — пак, собранный ItemsAdder командой `/iazip` на сервере (`plugins/ItemsAdder/output/generated.zip`).
ItemsAdder настроен на `pack_hosting.method: external_host` и раздаёт клиентам ссылку:

https://github.com/tearsmilk/Aleksia/raw/refs/heads/claude/serene-pasteur-cvs6ts/resourcepack/lobby-pack-31915241.zip

После каждого `/iazip` нужно обновить этот файл в репозитории и выполнить `/iareload` на сервере,
иначе игроки получат старый пак (хэш берётся из локального generated.zip, а скачивается файл с GitHub).
