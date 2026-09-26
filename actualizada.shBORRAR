#!/bin/bash

# Directorio del repositorio
REPO_DIR="/home/pi/ACTUALIZACIONES_FINAL_NEW2"
STATUS_FILE="/home/pi/status.ini"
ACTUALIZACIONES_TXT="$REPO_DIR/actualizaciones.txt"
FORM_SCRIPT="/home/pi/A108/qt/./qt_actualizada"  # Ruta al script que abre tu formulario Qt

# Cambiar al directorio
cd "$REPO_DIR" || {
    echo "Error: No se pudo acceder al directorio $REPO_DIR"
    exit 1
}

# Hacer git pull
git pull

# Leer la primera línea del archivo actualizaciones.txt
actualizacion=$(head -n 1 "$ACTUALIZACIONES_TXT" 2>/dev/null | tr -d '\r\n')

# Verificar si se pudo leer el archivo
if [ -z "$actualizacion" ]; then
    echo "Error: No se pudo leer la versión en $ACTUALIZACIONES_TXT"
    exit 1
fi

# Leer la línea 130 del archivo status.ini
mi_actualizacion=$(sed -n '130p' "$STATUS_FILE" 2>/dev/null | tr -d '\r\n')

# Verificar si se pudo leer la línea 130
if [ -z "$mi_actualizacion" ]; then
    echo "Advertencia: No se pudo leer la línea 130 de $STATUS_FILE"
    exit 1
fi
# Comparar ambas variables
if [ "$actualizacion" != "$mi_actualizacion" ]; then
    # Mostrar formulario Qt con mensaje de actualización disponible
    # Puedes usar un script externo que lance tu aplicación Qt (PyQt, Qt con C++, etc.)
    if [ -f "$FORM_SCRIPT" ]; then
        "$FORM_SCRIPT" &
    else
        echo "Formulario Qt no encontrado en $FORM_SCRIPT"
        # Alternativa: usar un mensaje básico con zenity si Qt no está disponible
        # zenity --info --text="Tienes una actualización disponible."
    fi
else
    # Son iguales, no hacer nada
    #echo "No hay nuevas actualizaciones."
    "$FORM_SCRIPT" &
fi