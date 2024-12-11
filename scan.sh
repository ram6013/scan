verificacion(){
    # Limpiar el archivo de resultados por si hay alguno creado
    if [ -f "resultado.txt" ]; then
        > "resultado.txt"
    fi
        if [ "$#" -lt 2 ] || [ "$#" -gt 4 ]; then
        echo "Error: Necesitas proporcionar una URL y cookies (opcionales)." 
        echo "Uso: scan web <url> <cookies>" 
        return 1
    fi
}
web(){
    url="$1"

    if [ ! -z "$3" ]; then
        cookies="$3"
    else
        cookies=""
    fi

    # Realizar la búsqueda de endpoints
    echo "============Busqueda de endpoints============" >> "resultado.txt"
    python3 ffur.py "$url/Ramon" >> "resultado.txt"

    # Obtención del dominio y IP
    echo "============Dominio============" >> "resultado.txt"
    domain=$(echo "$url" | sed -E 's#^https?://(www\.)?([^/]+).*#\2#')
    echo "Dominio: $domain" >> "resultado.txt"

    echo "============IP============" >> "resultado.txt"
    ip=$(dig +short "$domain")
    if [ -z "$ip" ]; then
        echo "Error: No se pudo obtener la IP para el dominio $domain" >> "resultado.txt"
        return 1
    fi
    echo "IP: $ip" >> "resultado.txt"

    # Escaneo de puertos con nmap (simplificado)
    echo "============Escaneo de puertos============" >> "resultado.txt"
    nmap -T4 -Pn "$ip" | grep "open" >> "resultado.txt"

    # Escaneo de vulnerabilidades
    echo "============Escaneo de vulnerabilidades============" >> "resultado.txt"
    nmap --script=vuln "$ip" >> "resultado.txt"

    # Identificación de CMS
    echo "============Identificación de CMS============" >> "resultado.txt"
    whatweb "$url" >> "resultado.txt"

    # Escaneo de SSL
    echo "============Escaneo SSL/TLS============" >> "resultado.txt"
    slyze --certinfo --heartbleed --robot --http_headers --tlsv1 --tlsv1_1 --tlsv1_2 --tlsv1_3 --sslv2 --sslv3 --elliptic_curves "$domain" >> "resultado.txt"

    # Escaneo de encabezados HTTP
    echo "============Escaneo de encabezados HTTP============" >> "resultado.txt"
    curl -I "$url" >> "resultado.txt"
    #tls check
    # testssl
    # csrt.shortniktohttpx
}



infraestructura(){
    return 1
}


redes(){
    return 1    
}



case "$1" in 

    web)
    verificacion "$@"
    web "$2" "$3"
    ;;
    infraestructura)
    infraestructura
    ;;
    redes)
    redes
    ;;

esac
