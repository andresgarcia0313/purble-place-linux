<div align="center">

<img src="purbleplace.png" alt="Purble Place" width="96">

# Guía de Instalación

**Purble Place clásico de Windows Vista/7 funcionando en Kubuntu 24.04 via Wine.**
Versión en español, sin virtual desktop, con icono original en el menú KDE.

</div>

<br>

## Contenido

- [Sobre el juego](#sobre-el-juego)
- [Descargas necesarias](#descargas-necesarias)
- [Prerequisitos del sistema](#prerequisitos-del-sistema)
- [Instalación paso a paso](#instalación-paso-a-paso)
- [Cambiar idioma](#cambiar-idioma)
- [Troubleshooting](#troubleshooting)
- [Perfil técnico](#perfil-técnico)
- [Estructura final](#estructura-final)
- [Entorno probado](#entorno-probado)

<br>

---

## Sobre el juego

| | | |
|---|---|---|
| **Desarrollador** | Oberon Games | Contratado por Microsoft, 2005 |
| **Motor** | Flat Engine | Engine propietario custom |
| **Plataforma** | Windows Vista / 7 | PE32+ (64-bit x86-64) |

### Minijuegos incluidos

| | Juego | Mecánica |
|---|---|---|
| 🧠 | **Purble Pairs** | Memoria — encuentra las parejas ocultas |
| 🎂 | **Comfy Cakes** | Pastelería — reproduce el patrón indicado |
| 🎭 | **Purble Shop** | Deducción — adivina la combinación correcta |

<br>

---

## Descargas necesarias

| Recurso | Tamaño | Enlace |
|---|---|---|
| Purble Place v0.4 (inglés, sin MUI) | 56 MB | [Internet Archive](https://archive.org/details/purble-place-0.4-modern-windows-compatible) |
| Purble Place español (con MUI) | 30 MB | [Internet Archive](https://archive.org/details/purble-place_202106) |
| Resource Hacker (solo para español) | 4 MB | [angusj.com](https://www.angusj.com/resourcehacker/) |

### Cuál descargar

> **Inglés** — Solo la v0.4. Funciona directo sin parches.
>
> **Español** — Versión española + Resource Hacker para embeber los recursos `.mui`
> dentro del `.exe`. Wine no soporta archivos `.mui`
> (bug [#43670](https://bugs.winehq.org/show_bug.cgi?id=43670)).

<br>

---

## Prerequisitos del sistema

### 1 &nbsp; Wine 11.0 estable

Desde el repositorio oficial de WineHQ (no el de Ubuntu, que trae una versión antigua):

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

### 2 &nbsp; Librerías gráficas Mesa 32-bit

Necesarias para OpenGL y Vulkan en arquitectura i386:

```bash
sudo apt install -y \
  libgl1-mesa-dri:i386 libgl1:i386 libegl1:i386 \
  libvulkan1:i386 mesa-vulkan-drivers:i386
```

### 3 &nbsp; Herramientas auxiliares

```bash
sudo apt install -y winetricks icoutils unrar
```

| Paquete | Uso |
|---|---|
| `winetricks` | Instalar dependencias Windows dentro de Wine |
| `icoutils` | Extraer iconos del `.exe` (`wrestool`, `icotool`) |
| `unrar` | Descomprimir el `.rar` de la versión española |

<br>

---

## Instalación paso a paso

### Paso 1 &nbsp; Descargar archivos

```bash
mkdir -p ~/Juegos/Instalados/PurblePlace

# Versión española
wget "https://archive.org/download/purble-place_202106/Purble%20Place.rar" \
  -O /tmp/PurblePlace_ES.rar
unrar x -o+ /tmp/PurblePlace_ES.rar /tmp/purble_es/

cp /tmp/purble_es/Purble\ Place/PurblePlace.exe  ~/Juegos/Instalados/PurblePlace/
cp /tmp/purble_es/Purble\ Place/PurblePlace.dll  ~/Juegos/Instalados/PurblePlace/
cp /tmp/purble_es/Purble\ Place/PurblePlace2.dll ~/Juegos/Instalados/PurblePlace/
cp /tmp/purble_es/Purble\ Place/slc.dll          ~/Juegos/Instalados/PurblePlace/

mkdir -p ~/Juegos/Instalados/PurblePlace/es-ES
cp /tmp/purble_es/Purble\ Place/es-ES/PurblePlace.exe.mui \
  ~/Juegos/Instalados/PurblePlace/es-ES/
```

<br>

### Paso 2 &nbsp; Crear prefijo Wine

Prefijo autocontenido dentro de la carpeta del juego (64-bit):

```bash
WINEARCH=win64 \
WINEPREFIX=~/Juegos/Instalados/PurblePlace/wineprefix \
  wineboot --init
```

<br>

### Paso 3 &nbsp; Configurar dependencias Wine

```bash
export WINEPREFIX=~/Juegos/Instalados/PurblePlace/wineprefix

winetricks win7
winetricks -q d3dx9
winetricks -q gdiplus
winetricks -q vcrun2005
```

<details>
<summary><b>Por qué cada dependencia</b></summary>

| Dependencia | Razón |
|---|---|
| `win7` | El juego fue diseñado para Vista/7 |
| `d3dx9` | D3DX9 nativo de Microsoft para texturas DXT |
| `gdiplus` | GDI+ nativo para renderizado 2D de sprites y UI |
| `vcrun2005` | Runtime Visual C++ 2005 (compilador original del juego) |

</details>

<br>

### Paso 4 &nbsp; Fix HIGHDPIAWARE

> Previene el crash **"divide by zero"** que ocurre al cambiar entre minijuegos.
> El juego calcula una escala de resolución que resulta en divisor 0 sin este fix.

```bash
cat > /tmp/purble_fix.reg << 'EOF'
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers]
@="~ HIGHDPIAWARE"

[HKEY_CURRENT_USER\Control Panel\Desktop]
"LogPixels"=dword:00000060
EOF

WINEPREFIX=~/Juegos/Instalados/PurblePlace/wineprefix \
  wine regedit /S /tmp/purble_fix.reg
```

<details>
<summary><b>Qué hace este fix</b></summary>

- `HIGHDPIAWARE` — Le indica a Windows que la app maneja su propio DPI, evitando el escalado automático
- `LogPixels=0x60` (96 DPI) — Fuerza DPI estándar, asegurando que el divisor en el cálculo de escala nunca sea 0

</details>

<br>

### Paso 5 &nbsp; Parchear español

Wine no soporta archivos `.mui` ([bug #43670](https://bugs.winehq.org/show_bug.cgi?id=43670)).
El workaround es embeber los recursos de idioma directamente dentro del `.exe` usando Resource Hacker.

> **Si solo quieres inglés**, salta este paso.

```bash
export WINEPREFIX=~/Juegos/Instalados/PurblePlace/wineprefix

# 1. Instalar Resource Hacker via Wine
wget -q "https://www.angusj.com/resourcehacker/reshacker_setup.exe" \
  -O /tmp/reshacker_setup.exe
wine /tmp/reshacker_setup.exe /SILENT /DIR="C:\reshacker"

# 2. Copiar archivos al directorio de Resource Hacker
RHDIR="$WINEPREFIX/drive_c/reshacker"
cp ~/Juegos/Instalados/PurblePlace/PurblePlace.exe \
  "$RHDIR/PurblePlace_original.exe"
cp ~/Juegos/Instalados/PurblePlace/es-ES/PurblePlace.exe.mui \
  "$RHDIR/PurblePlace.exe.mui"

# 3. Extraer recursos del MUI
wine "C:\reshacker\ResourceHacker.exe" \
  -open "C:\reshacker\PurblePlace.exe.mui" \
  -save "C:\reshacker\mui_resources.res" \
  -action extract \
  -mask ",,"

# 4. Embeber recursos en el exe
wine "C:\reshacker\ResourceHacker.exe" \
  -open "C:\reshacker\PurblePlace_original.exe" \
  -save "C:\reshacker\PurblePlace_ES.exe" \
  -action addoverwrite \
  -resource "C:\reshacker\mui_resources.res"

# 5. Reemplazar exe con versión parcheada
cp "$RHDIR/PurblePlace_ES.exe" \
  ~/Juegos/Instalados/PurblePlace/PurblePlace.exe
```

<details>
<summary><b>Cómo funciona el parcheo</b></summary>

```
PurblePlace.exe.mui ──► Resource Hacker (extract) ──► mui_resources.res
                                                              │
PurblePlace.exe ─────► Resource Hacker (addoverwrite) ◄──────┘
                                │
                        PurblePlace_ES.exe
                    (exe con español embebido)
```

Los archivos `.mui` son satélites de recursos que Windows carga según el idioma del sistema.
Wine no implementa esta carga, así que embebemos los recursos directamente en el ejecutable.

</details>

<br>

### Paso 6 &nbsp; Extraer icono original

```bash
wrestool -x --type=group_icon \
  ~/Juegos/Instalados/PurblePlace/PurblePlace.exe \
  -o /tmp/purble_icon.ico

# Instalar en hicolor para KDE
for size in 256 48 32 16; do
    mkdir -p ~/.local/share/icons/hicolor/${size}x${size}/apps
    icotool -x -w $size /tmp/purble_icon.ico \
      -o ~/.local/share/icons/hicolor/${size}x${size}/apps/purbleplace.png \
      2>/dev/null
done

# Copia local junto al juego
icotool -x -w 256 /tmp/purble_icon.ico \
  -o ~/Juegos/Instalados/PurblePlace/purbleplace.png
```

<br>

### Paso 7 &nbsp; Crear lanzador

```bash
cat > ~/Juegos/Instalados/PurblePlace/jugar.sh << 'SCRIPT'
#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
LANG=es_ES.UTF-8 WINEPREFIX="$DIR/wineprefix" wine "$DIR/PurblePlace.exe" "$@"
SCRIPT

chmod +x ~/Juegos/Instalados/PurblePlace/jugar.sh
```

<br>

### Paso 8 &nbsp; Crear entrada en el menú KDE

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

<br>

---

## Cambiar idioma

### Español → Inglés

Reemplazar el exe parcheado con la versión inglesa v0.4:

```bash
wget "https://archive.org/download/purble-place-0.4-modern-windows-compatible/Purble%20Place.zip" \
  -O /tmp/PurblePlace_EN.zip
unzip -o /tmp/PurblePlace_EN.zip PurblePlace.exe \
  -d ~/Juegos/Instalados/PurblePlace/
```

Cambiar `LANG=es_ES.UTF-8` por `LANG=en_US.UTF-8` en `jugar.sh`.

### Inglés → Español

Seguir el [paso 5](#paso-5--parchear-español) y asegurarse de que `jugar.sh` usa `LANG=es_ES.UTF-8`.

<br>

---

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Crash *divide by zero* al cambiar modo | Cálculo de escala con divisor 0 | Fix HIGHDPIAWARE + DPI 96 → [paso 4](#paso-4--fix-highdpiaware) |
| Crash *page fault 0x00000028* | D3D9 sin DLLs nativas | `winetricks d3dx9 gdiplus vcrun2005` |
| *Failed to load libGL.so.1* | Faltan libs Mesa 32-bit | `apt install libgl1:i386 libegl1:i386` |
| Textos con IDs en vez de texto | Wine no lee archivos `.mui` | Embeber MUI con Resource Hacker → [paso 5](#paso-5--parchear-español) |
| *Setting line patterns…* | Mensaje informativo de Wine | Ignorar — no afecta funcionalidad |

<br>

---

## Perfil técnico

<details>
<summary><b>Stack tecnológico del juego</b></summary>

| Capa | Librería | Función |
|---|---|---|
| 3D | `d3d9.dll` (Direct3D 9) | Renderizado 3D |
| 2D | `gdiplus.dll` (GDI+) | Sprites y UI |
| Audio | `dsound.dll` (DirectSound) | Efectos de sonido |
| Video | `WMVCore.DLL` | Multimedia |
| Input | `xinput.dll` | Controles |
| Runtime | `msvcrt.dll` | Visual C++ |
| Texturas | DXT1, DXT3, DXT5 | Compresión GPU |
| Arquitectura | PE32+ (64-bit x86-64) | Ejecutable Windows |

</details>

<br>

---

## Estructura final

```
~/Juegos/Instalados/PurblePlace/
│
├── es-ES/
│   └── PurblePlace.exe.mui     Recursos de idioma español (original)
│
├── wineprefix/                  Prefijo Wine autocontenido
│
├── PurblePlace.exe              Ejecutable parcheado con español
├── PurblePlace.dll              Assets y motor principal (28 MB)
├── PurblePlace2.dll             Assets adicionales (8 MB)
├── slc.dll                      Software Licensing Client
│
├── purbleplace.png              Icono 256×256
├── jugar.sh                     Lanzador autocontenido
├── INSTALACION.md               Este archivo
└── README.md                    Presentación del repositorio
```

<br>

---

## Entorno probado

| | Componente | Detalle |
|---|---|---|
| 💻 | Sistema operativo | Kubuntu 24.04 (Noble) — Kernel 6.17.0-14-generic |
| 🖥️ | Escritorio | KDE Plasma 6 |
| 🎮 | Wine | 11.0 estable (WineHQ) |
| 🔲 | GPU | Intel Iris Xe (Alder Lake) |
| 📅 | Fecha | 2026-02-28 |

<br>

---

<div align="center">

Desarrollado originalmente por **Oberon Games** para Microsoft (2005)

Esta guía documenta cómo ejecutarlo en Linux — no distribuye software propietario.

</div>
