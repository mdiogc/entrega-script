###########################################
#
# Autores: 
# Kai Rodríguez García <kai97rg@gmail.com>
# Marina Giacomaniello Castro <mdiogcasko@gmail.com> 
#
# Nombre: script-entrega.sh
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
    echo "ERROR: No ha escrito un argumento"
    read -p "Escribe el nombre del paquete: " paquete
done

echo "Espera un momento mientras se actualizan los repositorios... "

sudo apt-get update > /dev/null 2>&1

echo "Los repositorios se han actualizado."
echo ""

dpkg -s "$paquete" > /dev/null 2>&1

if [ "$?" -eq 0 ]; then
    echo "Tiene ese paquete instalado. Elija una opción que se muestra a continuación: "
    echo ""
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
        1) dpkg -s "$paquete" | grep 'Version:' | cut -d ' ' -f 2 ;;
        2) sudo apt-get reinstall "$paquete" ;;
        3) sudo apt-get install "$paquete" ;;
        4) sudo apt-get remove "$paquete" ;;
        5) sudo apt-get purge "$paquete" ;;
        *) echo "Error: '$opcion' no es una opción correcta" ;;
    esac

else
    apt-cache show "$paquete" > /dev/null 2>&1

    if [ "$?" -eq 0 ]; then
        echo "No tiene ese paquete instalado."
        echo "La información sobre ese paquete es la siguiente: "
        apt-cache policy "$paquete"
        read -p "¿Quiere instalar este programa? (S/N)" preguntainstalar
        case "$preguntainstalar" in
            "S"|"s") sudo apt-get install "$paquete" ;;
            "N"|"n") echo "De acuerdo"
                exit 0
                ;;
        esac

    else
        echo "No está disponible o no existe ese paquete"
        echo "El resultado de la búsqueda es el siguiente: "
        echo ""
        apt-cache search "$paquete"
        echo ""
        echo ""
        echo "Este es el final del resultado de la búsqueda, porque no se ha encontrado $paquete pero puede volver a intentarlo con algún paquete existente."
    fi
fi



