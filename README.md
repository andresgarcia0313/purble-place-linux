# Purble Place en Linux

Guía para instalar y ejecutar **Purble Place** (Windows Vista/7) en **Kubuntu 24.04** con Wine 11, en español y con icono original en el menú KDE.

![Purble Place](purbleplace.png)

## Qué es Purble Place

Colección de 3 minijuegos clásicos desarrollados por Oberon Games para Microsoft:

- **Purble Pairs** — Juego de memoria
- **Comfy Cakes** — Pastelería (seguir patrones)
- **Purble Shop** — Adivinanza por deducción

## Instalación rápida

### 1. Instalar Wine 11 estable

```bash
sudo dpkg --add-architecture i386
wget -qO /tmp/winehq.key https://dl.winehq.org/wine-builds/winehq.key
gpg --dearmor < /tmp/winehq.key > /tmp/winehq-archive.key 2>/dev/null
sudo cp /tmp/winehq-archive.key /etc/apt/keyrings/winehq-archive.key
sudo wget -NP /etc/apt/sources.list.d/ \
  https://dl.winehq.org/wine-builds/ubuntu/dists/noble/winehq-noble.sources
sudo apt update && sudo apt install --install-recommends winehq-stable
```

### 2. Instalar dependencias

```bash
sudo apt install -y \
  libgl1-mesa-dri:i386 libgl1:i386 libegl1:i386 \
  libvulkan1:i386 mesa-vulkan-drivers:i386 \
  winetricks icoutils unrar
```

### 3. Descargar el juego

**Versión español:**
```bash
wget "https://archive.org/download/purble-place_202106/Purble%20Place.rar" -O /tmp/PurblePlace_ES.rar
```

**Versión inglés (alternativa, sin necesidad de parchear):**
```bash
wget "https://archive.org/download/purble-place-0.4-modern-windows-compatible/Purble%20Place.zip" -O /tmp/PurblePlace_EN.zip
```

### 4. Seguir la guía completa

Ver **[INSTALACION.md](INSTALACION.md)** para los pasos detallados de configuración de Wine, parcheo de idioma español, extracción de iconos y creación del lanzador KDE.

## Descargas

| Recurso | Enlace |
|---|---|
| Purble Place v0.4 (inglés) | [Internet Archive](https://archive.org/details/purble-place-0.4-modern-windows-compatible) |
| Purble Place español | [Internet Archive](https://archive.org/details/purble-place_202106) |
| Resource Hacker | [angusj.com](https://www.angusj.com/resourcehacker/) |
| Wine HQ | [winehq.org](https://dl.winehq.org/wine-builds/ubuntu/) |

## Problemas conocidos

| Problema | Solución |
|---|---|
| Crash "divide by zero" | Fix HIGHDPIAWARE + DPI 96 via registro |
| Textos con IDs internos | Embeber MUI con Resource Hacker |
| "Failed to load libGL" | Instalar `libgl1:i386 mesa-vulkan-drivers:i386` |

Ver la sección completa de troubleshooting en [INSTALACION.md](INSTALACION.md).

## Probado en

- Kubuntu 24.04 (Noble) — Kernel 6.17
- Intel Iris Xe (Alder Lake)
- Wine 11.0 estable
- KDE Plasma 6

## Archivos del repositorio

```
├── INSTALACION.md   # Guía completa paso a paso
├── README.md        # Este archivo
├── jugar.sh         # Lanzador autocontenido
├── purbleplace.png  # Icono original 256x256
└── .gitignore       # Excluye binarios y wineprefix
```

> Los binarios del juego (`.exe`, `.dll`) no se incluyen en el repositorio por copyright.
> Descárgalos desde los enlaces de Internet Archive indicados arriba.
