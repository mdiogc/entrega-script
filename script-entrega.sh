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
    read -p "Por favor, ingrese el nombre del paquete: " package_name
else
    package_name=$1
fi

# Verificar si el paquete está instalado en el sistema
if dpkg -l | grep -q "^ii  $package_name "; then
    # El paquete está instalado
    echo "El paquete '$package_name' está instalado."
    echo "¿Qué acción desea realizar?"
    echo "1. Mostrar información del paquete"
    echo "2. Reinstalar el paquete"
    echo "3. Actualizar el paquete"
    echo "4. Eliminar el paquete (manteniendo la configuración)"
    echo "5. Eliminar el paquete totalmente"
    read -p "Seleccione una opción (1-5): " option
    case $option in
        1)
            apt-cache show $package_name
            ;;
        2)
            sudo apt reinstall $package_name
            ;;
        3)
            sudo apt install --only-upgrade $package_name
            ;;
        4)
            sudo apt remove $package_name
            ;;
        5)
            sudo apt purge $package_name
            ;;
        *)
            echo "Opción no válida."
            ;;
    esac
else
    # El paquete no está instalado, verificar si existe en los repositorios del sistema
    if apt-cache show $package_name &> /dev/null; then
        # El paquete existe en los repositorios del sistema
        echo "El paquete '$package_name' existe en los repositorios del sistema."
        read -p "¿Desea instalar el paquete '$package_name'? (s/n): " install_choice
        if [ "$install_choice" == "s" ]; then
            sudo apt install $package_name
        fi
    else
        # El paquete no existe en los repositorios del sistema
        echo "El paquete '$package_name' no existe en los repositorios del sistema."
        echo "Aquí está el resultado de la búsqueda:"
        apt-cache search $package_name
    fi
fi
