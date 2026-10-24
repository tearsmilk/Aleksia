#!/usr/bin/env python3
"""Пересобирает generated.zip ItemsAdder в чистый zip и добавляет overlay с шейдером вспышки.

usage: patch_pack.py <in generated.zip> <out zip> <shader dir with rendertype_text.vsh/.fsh>
Overlay flash_1_21_6_plus применяется к клиентам с pack_format 63..83 (1.21.6 - 1.21.11)
и ставится последним в списке overlays, то есть имеет наивысший приоритет.
"""
import sys, struct, zlib, json, zipfile, os

def read_entries(path):
    """Читает записи по центральному каталогу: IA подменяет имена и размеры в локальных заголовках."""
    data = open(path, 'rb').read()
    eocd = data.rfind(b'PK\x05\x06')
    count, cd_off = struct.unpack('<H', data[eocd+10:eocd+12])[0], struct.unpack('<I', data[eocd+16:eocd+20])[0]
    entries = {}; p = cd_off
    for _ in range(count):
        assert data[p:p+4] == b'PK\x01\x02', 'bad central directory'
        (method, csize, nlen, elen, clen, loff) = (struct.unpack('<H', data[p+10:p+12])[0], struct.unpack('<I', data[p+20:p+24])[0],
            struct.unpack('<H', data[p+28:p+30])[0], struct.unpack('<H', data[p+30:p+32])[0], struct.unpack('<H', data[p+32:p+34])[0],
            struct.unpack('<I', data[p+42:p+46])[0])
        name = data[p+46:p+46+nlen].decode('utf-8'); p += 46 + nlen + elen + clen
        assert data[loff:loff+4] == b'PK\x03\x04', 'bad local header for ' + name
        lnlen, lelen = struct.unpack('<HH', data[loff+26:loff+30]); off = loff + 30 + lnlen + lelen
        if method == 8:
            d = zlib.decompressobj(-15); out = d.decompress(data[off:off+32_000_000])
            if not d.eof: raise SystemExit('truncated deflate stream: ' + name)
        elif method == 0:
            out = data[off:off+csize]
        else:
            raise SystemExit('unsupported method ' + str(method) + ' for ' + name)
        if not name.endswith('/'): entries[name] = out
    return entries

def main():
    src, dst, shdir = sys.argv[1:4]
    e = read_entries(src)
    print('entries:', len(e))
    mcmeta_name = next((n for n in e if n.endswith('pack.mcmeta') and '/' not in n), None)
    if mcmeta_name is None: raise SystemExit('pack.mcmeta not found')
    meta = json.loads(e[mcmeta_name].decode('utf-8'))
    ov = meta.setdefault('overlays', {}).setdefault('entries', [])
    ov = [o for o in ov if o.get('directory') != 'flash_1_21_6_plus']
    # Та же форма записи, что у overlays ItemsAdder: клиент 1.21.9+ читает min_format/max_format
    ov.append({'directory': 'flash_1_21_6_plus', 'formats': [63, 64], 'min_format': 63, 'max_format': 83})
    meta['overlays']['entries'] = ov
    e[mcmeta_name] = json.dumps(meta, ensure_ascii=False).encode('utf-8')
    for f in ('rendertype_text.vsh', 'rendertype_text.fsh'):
        e['flash_1_21_6_plus/assets/minecraft/shaders/core/' + f] = open(os.path.join(shdir, f), 'rb').read()
    # Дополнительные item definitions (extra_items/<item>.json): вливаем записи во все копии items/<item>.json
    extra_dir = os.path.join(os.path.dirname(shdir), 'extra_items')
    if os.path.isdir(extra_dir):
        for fn in os.listdir(extra_dir):
            if not fn.endswith('.json'): continue
            extra = json.load(open(os.path.join(extra_dir, fn), encoding='utf-8'))['model']
            targets = [n for n in e if n.endswith('assets/minecraft/items/' + fn)]
            if not targets:
                e['assets/minecraft/items/' + fn] = json.dumps({'model': extra}, ensure_ascii=False).encode('utf-8'); print('added', fn); continue
            for n in targets:
                d = json.loads(e[n].decode('utf-8')); m = d.get('model', {})
                if m.get('type') != 'minecraft:range_dispatch' or m.get('property') != extra.get('property'):
                    print('skip (not a cmd range_dispatch):', n); continue
                have = {x['threshold'] for x in m['entries']}
                added = [x for x in extra['entries'] if x['threshold'] not in have]
                m['entries'] = sorted(m['entries'] + added, key=lambda x: x['threshold'])
                e[n] = json.dumps(d, ensure_ascii=False).encode('utf-8'); print('merged', len(added), 'entries into', n)
    with zipfile.ZipFile(dst, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for n in sorted(e): z.writestr(n, e[n])
    print('written', dst, os.path.getsize(dst), 'bytes; overlays:', [o['directory'] for o in ov])

if __name__ == '__main__': main()
