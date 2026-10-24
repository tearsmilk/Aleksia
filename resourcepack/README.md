# Ресурспак сервера lobby (ItemsAdder)

`generated.zip` — пак, собранный ItemsAdder командой `/iazip` на сервере (`plugins/ItemsAdder/output/generated.zip`).
ItemsAdder настроен на `pack_hosting.method: external_host` и раздаёт клиентам ссылку:

https://raw.githubusercontent.com/tearsmilk/Aleksia/claude/serene-pasteur-cvs6ts/resourcepack/generated.zip

После каждого `/iazip` нужно обновить этот файл в репозитории и выполнить `/iareload` на сервере,
иначе игроки получат старый пак (хэш берётся из локального generated.zip, а скачивается файл с GitHub).
