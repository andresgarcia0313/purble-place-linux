# Purble Place en Linux — Guía de Instalación

> Purble Place clásico de Windows Vista/7 funcionando en Kubuntu 24.04 via Wine.
> Versión en **español**, sin virtual desktop, con icono original en el menú KDE.

---

## Sobre el juego

- **Desarrollador:** Oberon Games (contratado por Microsoft, 2005)
- **Motor:** "Flat Engine" (engine propietario custom)
- **Plataforma original:** Windows Vista / Windows 7
- **Contenido:** 3 minijuegos — Purble Pairs (memoria), Comfy Cakes (pastelería), Purble Shop (adivinanza)

---

## Descargas necesarias

| Recurso | URL | Tamaño |
|---|---|---|
| Purble Place v0.4 (inglés, sin MUI) | https://archive.org/details/purble-place-0.4-modern-windows-compatible | 56 MB |
| Purble Place español (con MUI) | https://archive.org/details/purble-place_202106 | 30 MB |
| Resource Hacker (para parchear español) | https://www.angusj.com/resourcehacker/ | 4 MB |

### Cuál descargar según idioma

- **Inglés:** Solo necesitas la v0.4. Funciona directo sin parches.
- **Español:** Necesitas la versión española + Resource Hacker para embeber los recursos `.mui` dentro del `.exe` (Wine no soporta archivos `.mui`, bug [#43670](https://bugs.winehq.org/show_bug.cgi?id=43670)).

---

## Perfil técnico

| Tecnología | Librería | Función |
|---|---|---|
| 3D | `d3d9.dll` (Direct3D 9) | Renderizado 3D |
| 2D | `gdiplus.dll` (GDI+) | Sprites y UI |
| Audio | `dsound.dll` (DirectSound) | Efectos de sonido |
| Video | `WMVCore.DLL` | Multimedia |
| Input | `xinput.dll` | Controles |
| Runtime | `msvcrt.dll` | Visual C++ |
| Texturas | DXT1, DXT3, DXT5 | Compresión GPU |
| Arquitectura | PE32+ (64-bit x86-64) | Ejecutable Windows |

---

## Prerequisitos del sistema

### 1. Wine 11.0 estable (repo WineHQ)

```bash
sudo dpkg --add-architecture i386

wget -qO /tmp/winehq.key https://dl.winehq.org/wine-builds/winehq.key
gpg --dearmor < /tmp/winehq.key > /tmp/winehq-archive.key 2>/dev/null
sudo cp /tmp/winehq-archive.key /etc/apt/keyrings/winehq-archive.key

sudo wget -NP /etc/apt/sources.list.d/ \
  https://dl.winehq.org/wine-builds/ubuntu/dists/noble/winehq-noble.sources

sudo apt update
sudo apt install --install-recommends winehq-stable
```

### 2. Librerías gráficas Mesa 32-bit

```bash
sudo apt install -y \
  libgl1-mesa-dri:i386 libgl1:i386 libegl1:i386 \
  libvulkan1:i386 mesa-vulkan-drivers:i386
```

### 3. Winetricks e icoutils

```bash
sudo apt install -y winetricks icoutils unrar
```

---

## Instalación paso a paso

### 1. Descargar archivos

```bash
mkdir -p ~/Juegos/Instalados/PurblePlace

# Versión española
wget "https://archive.org/download/purble-place_202106/Purble%20Place.rar" \
  -O /tmp/PurblePlace_ES.rar
unrar x -o+ /tmp/PurblePlace_ES.rar /tmp/purble_es/
cp /tmp/purble_es/Purble\ Place/PurblePlace.exe ~/Juegos/Instalados/PurblePlace/
cp /tmp/purble_es/Purble\ Place/PurblePlace.dll ~/Juegos/Instalados/PurblePlace/
cp /tmp/purble_es/Purble\ Place/PurblePlace2.dll ~/Juegos/Instalados/PurblePlace/
cp /tmp/purble_es/Purble\ Place/slc.dll ~/Juegos/Instalados/PurblePlace/
mkdir -p ~/Juegos/Instalados/PurblePlace/es-ES
cp /tmp/purble_es/Purble\ Place/es-ES/PurblePlace.exe.mui ~/Juegos/Instalados/PurblePlace/es-ES/
```

### 2. Crear prefijo Wine (64-bit)

```bash
WINEARCH=win64 WINEPREFIX=~/Juegos/Instalados/PurblePlace/wineprefix wineboot --init
```

### 3. Configurar dependencias

```bash
export WINEPREFIX=~/Juegos/Instalados/PurblePlace/wineprefix

winetricks win7
winetricks -q d3dx9
winetricks -q gdiplus
winetricks -q vcrun2005
```

| Fix | Razón |
|---|---|
| `win7` | El juego fue hecho para Vista/7 |
| `d3dx9` | D3DX9 nativo de Microsoft para texturas DXT |
| `gdiplus` | GDI+ nativo para renderizado 2D |
| `vcrun2005` | Runtime Visual C++ 2005 (compilador original) |

### 4. Aplicar fix HIGHDPIAWARE (previene crash "divide by zero")

```bash
cat > /tmp/purble_fix.reg << 'EOF'
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers]
@="~ HIGHDPIAWARE"

[HKEY_CURRENT_USER\Control Panel\Desktop]
"LogPixels"=dword:00000060
EOF

WINEPREFIX=~/Juegos/Instalados/PurblePlace/wineprefix wine regedit /S /tmp/purble_fix.reg
```

### 5. Parchear español (embeber MUI en el exe)

Wine no soporta archivos `.mui` (bug #43670). El workaround es embeber los recursos de idioma directamente dentro del `.exe` usando Resource Hacker.

```bash
export WINEPREFIX=~/Juegos/Instalados/PurblePlace/wineprefix

# Instalar Resource Hacker via Wine
wget -q "https://www.angusj.com/resourcehacker/reshacker_setup.exe" -O /tmp/reshacker_setup.exe
wine /tmp/reshacker_setup.exe /SILENT /DIR="C:\reshacker"

# Copiar archivos al directorio de ResHacker
RHDIR="$WINEPREFIX/drive_c/reshacker"
cp ~/Juegos/Instalados/PurblePlace/PurblePlace.exe "$RHDIR/PurblePlace_original.exe"
cp ~/Juegos/Instalados/PurblePlace/es-ES/PurblePlace.exe.mui "$RHDIR/PurblePlace.exe.mui"

# Extraer recursos del MUI
wine "C:\reshacker\ResourceHacker.exe" \
  -open "C:\reshacker\PurblePlace.exe.mui" \
  -save "C:\reshacker\mui_resources.res" \
  -action extract \
  -mask ",,"

# Embeber recursos en el exe
wine "C:\reshacker\ResourceHacker.exe" \
  -open "C:\reshacker\PurblePlace_original.exe" \
  -save "C:\reshacker\PurblePlace_ES.exe" \
  -action addoverwrite \
  -resource "C:\reshacker\mui_resources.res"

# Reemplazar exe con versión parcheada
cp "$RHDIR/PurblePlace_ES.exe" ~/Juegos/Instalados/PurblePlace/PurblePlace.exe
```

### 6. Extraer icono original

```bash
wrestool -x --type=group_icon ~/Juegos/Instalados/PurblePlace/PurblePlace.exe \
  -o /tmp/purble_icon.ico

# Instalar en hicolor para KDE
for size in 256 48 32 16; do
    mkdir -p ~/.local/share/icons/hicolor/${size}x${size}/apps
    icotool -x -w $size /tmp/purble_icon.ico \
      -o ~/.local/share/icons/hicolor/${size}x${size}/apps/purbleplace.png 2>/dev/null
done

# Copia local junto al juego
icotool -x -w 256 /tmp/purble_icon.ico -o ~/Juegos/Instalados/PurblePlace/purbleplace.png
```

### 7. Crear lanzador

```bash
cat > ~/Juegos/Instalados/PurblePlace/jugar.sh << 'SCRIPT'
#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
LANG=es_ES.UTF-8 WINEPREFIX="$DIR/wineprefix" wine "$DIR/PurblePlace.exe" "$@"
SCRIPT
chmod +x ~/Juegos/Instalados/PurblePlace/jugar.sh
```

### 8. Crear entrada en el menú KDE

```bash
cat > ~/.local/share/applications/purbleplace.desktop << 'EOF'
[Desktop Entry]
Name=Purble Place
Name[es]=Purble Place
Comment=Colección de 3 minijuegos clásicos de Windows Vista/7
Comment[en]=Classic Windows Vista/7 mini-games collection
GenericName=Minijuegos
GenericName[en]=Mini-games
Exec=/home/$USER/Juegos/Instalados/PurblePlace/jugar.sh
Type=Application
Categories=Game;KidsGame;LogicGame;
Keywords=purble;comfy;cakes;pairs;shop;memoria;pasteles;
Icon=purbleplace
Terminal=false
StartupNotify=true
StartupWMClass=purbleplace.exe
EOF

update-desktop-database ~/.local/share/applications/
```

---

## Cambiar idioma

### De español a inglés

Reemplazar el exe parcheado con la versión inglesa v0.4:

```bash
wget "https://archive.org/download/purble-place-0.4-modern-windows-compatible/Purble%20Place.zip" \
  -O /tmp/PurblePlace_EN.zip
unzip -o /tmp/PurblePlace_EN.zip PurblePlace.exe -d ~/Juegos/Instalados/PurblePlace/
```

Y cambiar `LANG=es_ES.UTF-8` por `LANG=en_US.UTF-8` en `jugar.sh`.

### De inglés a español

Seguir el paso 5 (parchear con Resource Hacker) y asegurarse de que `jugar.sh` usa `LANG=es_ES.UTF-8`.

---

## Problemas conocidos y soluciones

| Problema | Causa | Solución |
|---|---|---|
| Crash "divide by zero" al cambiar modo | Cálculo de escala con divisor 0 | Fix HIGHDPIAWARE + DPI 96 (paso 4) |
| Crash "page fault 0x00000028" | D3D9 sin DLLs nativas | `winetricks d3dx9 gdiplus vcrun2005` |
| "Failed to load libGL.so.1" | Faltan libs 32-bit | `apt install libgl1:i386 libegl1:i386` |
| Textos con IDs en vez de texto | Wine no lee archivos `.mui` | Embeber MUI con Resource Hacker (paso 5) |
| "Setting line patterns..." | Mensaje informativo de Wine | Ignorar, no afecta funcionalidad |

---

## Estructura final

```
~/Juegos/Instalados/PurblePlace/
├── es-ES/
│   └── PurblePlace.exe.mui   # Recursos de idioma español (original)
├── wineprefix/                # Prefijo Wine autocontenido
├── PurblePlace.exe            # Ejecutable parcheado con español embebido
├── PurblePlace.dll            # Assets y motor principal (28 MB)
├── PurblePlace2.dll           # Assets adicionales (8 MB)
├── slc.dll                    # Software Licensing Client
├── purbleplace.png            # Icono 256x256
├── jugar.sh                   # Lanzador autocontenido
└── INSTALACION.md             # Este archivo
```

---

## Probado en

- **OS:** Kubuntu 24.04 (Noble) — Kernel 6.17.0-14-generic
- **GPU:** Intel Iris Xe (Alder Lake)
- **Wine:** 11.0 estable (WineHQ)
- **Fecha:** 2026-02-28
