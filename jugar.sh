#!/bin/bash
# Purble Place — Lanzador autocontenido
# El prefijo Wine está dentro de esta misma carpeta
DIR="$(cd "$(dirname "$0")" && pwd)"
LANG=es_ES.UTF-8 WINEPREFIX="$DIR/wineprefix" wine "$DIR/PurblePlace.exe" "$@"
