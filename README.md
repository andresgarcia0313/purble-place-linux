<div align="center">

<img src="purbleplace.png" alt="Purble Place" width="128">

# Purble Place en Linux

**Los 3 minijuegos clásicos de Windows Vista/7, funcionando en Linux con Wine.**

[![Platform](https://img.shields.io/badge/Kubuntu-24.04_Noble-0078D4?style=flat-square&logo=ubuntu&logoColor=white)](https://kubuntu.org/)
[![Wine](https://img.shields.io/badge/Wine-11.0_stable-722F37?style=flat-square&logo=wine&logoColor=white)](https://www.winehq.org/)
[![Desktop](https://img.shields.io/badge/KDE_Plasma-6-1D99F3?style=flat-square&logo=kde&logoColor=white)](https://kde.org/)
[![Lang](https://img.shields.io/badge/Idioma-Español-E4002B?style=flat-square)](INSTALACION.md#5-parchear-español-embeber-mui-en-el-exe)

</div>

<br>

## Contenido

- [Minijuegos](#minijuegos)
- [Inicio rápido](#inicio-rápido)
- [Descargas](#descargas)
- [Troubleshooting](#troubleshooting)
- [Entorno probado](#entorno-probado)
- [Estructura del repositorio](#estructura-del-repositorio)

<br>

## Minijuegos

| | Juego | Descripción |
|---|---|---|
| 🧠 | **Purble Pairs** | Juego de memoria — encuentra las parejas |
| 🎂 | **Comfy Cakes** | Pastelería — reproduce el patrón indicado |
| 🎭 | **Purble Shop** | Adivinanza — deduce la combinación correcta |

<br>

## Inicio rápido

### 1 &nbsp; Instalar Wine 11

```bash
sudo dpkg --add-architecture i386
wget -qO /tmp/winehq.key https://dl.winehq.org/wine-builds/winehq.key
gpg --dearmor < /tmp/winehq.key > /tmp/winehq-archive.key 2>/dev/null
sudo cp /tmp/winehq-archive.key /etc/apt/keyrings/winehq-archive.key
sudo wget -NP /etc/apt/sources.list.d/ \
  https://dl.winehq.org/wine-builds/ubuntu/dists/noble/winehq-noble.sources
sudo apt update && sudo apt install --install-recommends winehq-stable
```

### 2 &nbsp; Instalar dependencias

```bash
sudo apt install -y \
  libgl1-mesa-dri:i386 libgl1:i386 libegl1:i386 \
  libvulkan1:i386 mesa-vulkan-drivers:i386 \
  winetricks icoutils unrar
```

### 3 &nbsp; Descargar el juego

<details>
<summary><b>Español</b> (requiere parcheo con Resource Hacker)</summary>

```bash
wget "https://archive.org/download/purble-place_202106/Purble%20Place.rar" \
  -O /tmp/PurblePlace_ES.rar
```

</details>

<details>
<summary><b>English</b> (funciona directo, sin parches)</summary>

```bash
wget "https://archive.org/download/purble-place-0.4-modern-windows-compatible/Purble%20Place.zip" \
  -O /tmp/PurblePlace_EN.zip
```

</details>

### 4 &nbsp; Configurar y jugar

> Consulta **[INSTALACION.md](INSTALACION.md)** para la guía completa:
> prefijo Wine, dependencias, parcheo de idioma, fix de crashes,
> extracción de icono y lanzador KDE.

<br>

## Descargas

| Recurso | Enlace |
|---|---|
| Purble Place v0.4 (inglés) | [Internet Archive](https://archive.org/details/purble-place-0.4-modern-windows-compatible) |
| Purble Place español | [Internet Archive](https://archive.org/details/purble-place_202106) |
| Resource Hacker | [angusj.com](https://www.angusj.com/resourcehacker/) |
| Wine HQ | [winehq.org](https://dl.winehq.org/wine-builds/ubuntu/) |

<br>

## Troubleshooting

| Problema | Solución |
|---|---|
| Crash *divide by zero* | Fix `HIGHDPIAWARE` + DPI 96 via registro |
| Textos con IDs internos | Embeber MUI con Resource Hacker |
| *Failed to load libGL* | `apt install libgl1:i386 mesa-vulkan-drivers:i386` |

<details>
<summary><b>Ver todos los problemas y soluciones</b></summary>

| Problema | Causa | Solución |
|---|---|---|
| Crash *divide by zero* al cambiar modo | Cálculo de escala con divisor 0 | Fix `HIGHDPIAWARE` + DPI 96 ([paso 4](INSTALACION.md#4-aplicar-fix-highdpiaware-previene-crash-divide-by-zero)) |
| Crash *page fault 0x00000028* | D3D9 sin DLLs nativas | `winetricks d3dx9 gdiplus vcrun2005` |
| *Failed to load libGL.so.1* | Faltan libs Mesa 32-bit | `apt install libgl1:i386 libegl1:i386` |
| Textos con IDs en vez de texto | Wine no lee archivos `.mui` | Embeber MUI con Resource Hacker ([paso 5](INSTALACION.md#5-parchear-español-embeber-mui-en-el-exe)) |
| *Setting line patterns…* | Mensaje informativo de Wine | Ignorar — no afecta funcionalidad |

</details>

<br>

## Entorno probado

| | Componente | Versión |
|---|---|---|
| 💻 | Sistema operativo | Kubuntu 24.04 Noble — Kernel 6.17 |
| 🖥️ | Escritorio | KDE Plasma 6 |
| 🎮 | Wine | 11.0 estable (WineHQ) |
| 🔲 | GPU | Intel Iris Xe (Alder Lake) |

<br>

## Estructura del repositorio

```
├── INSTALACION.md     Guía completa paso a paso
├── README.md          Este archivo
├── jugar.sh           Lanzador autocontenido
├── purbleplace.png    Icono original 256×256
└── .gitignore         Excluye binarios y wineprefix
```

> Los binarios del juego (`.exe`, `.dll`) no se incluyen por copyright.
> Descárgalos desde los enlaces de [Internet Archive](#descargas).

<br>

---

<div align="center">

Desarrollado originalmente por **Oberon Games** para Microsoft (2005)

Esta guía documenta cómo ejecutarlo en Linux — no distribuye software propietario.

</div>
