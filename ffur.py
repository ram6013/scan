import requests
import sys
diccionario = "diccionario.txt"

def ffuf(url, diccionario, cookies = None):
    if "Ramon" not in url:
        print("Error 001: No se encuentra la palabra Ramon.")
        sys.exit(1)
    url = url.split("Ramon")[0]
    print(url)
    with open(diccionario, "r") as archivo:
        for linea in archivo: 
            palabra = linea.strip()
            objetivo = url + palabra 
            try:    
                respuesta = requests.get(objetivo, cookies=cookies)
            except requests.exceptions.RequestException as e:
                print(f"Error al hacer la solicitud a {objetivo}: {e}")
                continue
            if respuesta.status_code == 200:
                print("(+)Ruta abierta encontrada: " + objetivo)
            elif respuesta.status_code == 301 or respuesta.status_code == 302:
                print("(--)Se ha encontrado una ruta de redirección: " + objetivo)
            elif respuesta.status_code == 403:
                print("(-)Se ha encontrado una ruta protegida: " + objetivo)

    


if len(sys.argv) < 2:
    print("Necesito que me des una url que contenga Ramon, un diccionario con las palabras a probar y ls coockies(opcional)")
    sys.exit(1)
url = sys.argv[1]

cookies = None
if len(sys.argv) == 3:
    cookies = {'session': sys.argv[3]}

ffuf(url, diccionario, cookies)
