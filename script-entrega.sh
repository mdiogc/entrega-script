###########################################
#
# Autor: Kai Rodríguez García
#
# Nombre: EjercicioSoftware1.sh
#
# Objetivo: Debe recibir un argumento (nombre del paquete), si el usuario no lo indica, se le pedirá luego por teclado hasta que especifique un nombre.
#
# Si el paquete indicado NO ESTÁ INSTALADO en el sistema, se comprobará si existe en los repositorios del sistema:
# Si el paquete SÍ EXISTE en los repositorios: se le mostrará la información del paquete y se le dará la opción de instalarlo.
# Si el paquete NO EXISTE en los repositorios: se le indicará al usuario que no hay ningún paquete que se llame como ha indicado,
# y se le mostrará el resultado de la búsqueda que se obtiene con el argumento que ha dado el usuario
# (puede que la búsqueda no dé ningún paquete, o puede que la búsqueda muestre paquetes que se llaman de forma similar. En cualquier caso, se mostrará el resultado).
#
# Si el paquete indicado SÍ ESTÁ INSTALADO: se le dará la opción de:
# Mostrar su versión
# Reinstalarlo
# Actualizarlo (solo este paquete, si fuera actualizable)
# Eliminarlo (guardando la configuración)
# Eliminarlo totalmente
#
# Entradas: nombre de un paquete
# Salidas: mostrar info del paquete, reinstalarlo, actualizarlo, eliminarlo
#
# Historial: 7/02/2024 #Primer esqueleto del ejercicio
#
###########################################

paquete=$1

while [ -z "$paquete" ]; do
    echo "ERROR: No ha escrito un argumento. Debes escribir el nombre de un paquete de software. "
    read -p "Escribe el nombre del paquete: " paquete
done

sudo apt update

dpkg -s $paquete
if [ "$?" -eq 1 ]; then
    apt-cache search $paquete > /dev/null
    if [ $? -eq 0 ]; then
        apt-cache policy $paquete
        read -p "¿Quiere instalar este programa? (S/N)" preguntainstalar
        case $preguntainstalar in
        "S") sudo apt-get install $paquete ;;
        "N") ;;
        esac
    else
        echo "No está disponible o no existe ese paquete"
        echo "El resultado de la búsqueda es el siguiente: "
        apt search $paquete
    fi
elif [ "$?" -eq 0 ]; then
    echo "                *********************"
    echo "                *******Menú**********"
    echo "                *********************"
    echo ""
    echo "┌───────────────────────────────────────────────────────────┐"
    echo ""
    echo "1) Mostrar Versión"
    echo "2) Reinstalar"
    echo "3) Actualizarlo"
    echo "4) Eliminarlo (guardando la configuración)"
    echo "5) Eliminarlo totalmente"
    echo ""
    echo "└───────────────────────────────────────────────────────────┘"
    read -p "Elija la opción que desee: " opcion

    case "$opcion" in
    1) dpkg -s $paquete | grep 'Version:' | cut -d ' ' -f 2 ;;
    2) sudo apt-get reinstall $paquete ;;
    3) sudo apt-get upgrade $paquete ;;
    4) sudo apt-get remove $paquete ;;
    5) sudo apt-get purge $paquete ;;
    *) echo "Error: '$opcion' no es una opción correcta" ;;
    esac
fi


























#!/bin/bash
###########################################
#
#Autores:
# Kai Rodríguez García <kai97rg@gmail.com>
# Marina Giacomaniello Castro <mdiogcasko@gmail.com> 
#
#Nombre: script-entrega.sh
#
#Objetivo: facilitar la gestión de paquetes de software en un sistema GNU Linux, 
# ofreciendo opciones interactivas para mostrar información, instalar, actualizar 
# y eliminar paquetes.
# Entradas: nombre del paquete de software que el usuario desea administrar 
# Salidas: mensajes de información
#
# Historial:
#   2024-08-02: versión 1
#
############################################

# Sincronizar el listado de software local
sudo apt update

# Verificar si se ha proporcionado un argumento (nombre del paquete)
if [ -z "$1" ]; then
    # Si no se proporciona, solicitar al usuario que ingrese el nombre del paquete
    read -p "Por favor, ingrese el nombre del paquete: " nombre_paquete
else
    nombre_paquete=$1
fi

# Verificar si el paquete está instalado en el sistema
if dpkg -l | grep -q "^ii  $nombre_paquete "; then
    # El paquete está instalado
    echo "El paquete '$nombre_paquete' está instalado."
    echo "¿Qué acción desea realizar?"
    echo "1. Mostrar información del paquete"
    echo "2. Reinstalar el paquete"
    echo "3. Actualizar el paquete"
    echo "4. Eliminar el paquete (manteniendo la configuración)"
    echo "5. Eliminar el paquete totalmente"
    read -p "Seleccione una opción (1-5): " option
    case $option in
        1)
            apt-cache show $nombre_paquete
            ;;
        2)
            sudo apt reinstall $nombre_paquete
            ;;
        3)
            sudo apt install --only-upgrade $nombre_paquete
            ;;
        4)
            sudo apt remove $nombre_paquete
            ;;
        5)
            sudo apt purge $nombre_paquete
            ;;
        *)
            echo "Opción no válida."
            ;;
    esac
else
    # El paquete no está instalado, verificar si existe en los repositorios del sistema
    if apt-cache show $nombre_paquete &> /dev/null; then
        # El paquete existe en los repositorios del sistema
        echo "El paquete '$nombre_paquete' existe en los repositorios del sistema."
        read -p "¿Desea instalar el paquete '$nombre_paquete'? (S/N): " install_choice
        if [ "$install_choice" == "s" ]; then
            sudo apt install $nombre_paquete
        fi
    else
        # El paquete no existe en los repositorios del sistema
        echo "El paquete '$nombre_paquete' no existe en los repositorios del sistema."
        echo "Aquí está el resultado de la búsqueda:"
        apt-cache search $nombre_paquete
    fi
fi
