import wikipedia
from bs4 import BeautifulSoup
import re
import requests

def deleteSquareParentheses(string: str):
    '''
    Borrar el contenido que hay entre parentesis cuadrados

    Keyword arguments:
    string - Recibe el string para realizar el borrado
    '''
    newString = ""
        
    for i in range(0,len(string)):
        if string[i] == '[' or string[i] == ']' or (string[ i - 1]  == '['and string[i].isdigit()):
            continue

        else:
            newString += string[i]
            
        
           
    return newString

            

def deleteContentInParentheses(string):
    '''
    Borrar el contenido que hay entre parentensis y los parentesis

    Keyword arguments:
    string - Recibe el string para realizar el borrado
    '''

    #En cuentra la posicion de los parentesis
    first = string.find("(")
    second = string.find(")") + 1

    #Encuentra el cotenido de los parentesis
    content = string[first:second]

    #Borra el contenido de los paretensis
    newString = re.sub(content,"",string)
    map = {
        ord("(") : None,
        ord(")"): None
    }
    #Primero borra los parentesis y devuelve el string sin los paretensis
    return  newString.translate(map)


def getSmallSummary(summary):
    '''
    Obtiene el resumen mas pequeño del artista ingresado
    
    Keyword arguments:
    
    summary - es el resumen del artista

    '''
    #Donde encuentre el salto de linea se realizara el fin del resumen
    findEnd = summary.find("\n")
    shortSummary = ""
    for i in range(0,findEnd):
        shortSummary += summary[i]
    
    #Se borran los parentesis que se puedan encontrar
     
    return deleteContentInParentheses(shortSummary)



def getSummary(artist, isSinger, html):
    '''
    Obtiene la descripcion de artista o grupo en cuestion

    Keyword arguments:

    artist - es el nombre del artista o grupo a buscar

    Retorna el resumen completo del artista ingresado
    '''
    about = ""
    wikipedia.set_lang("es")

    if isSinger:
       
        try:
            for label in html.find_all('p'):
                if label.find('b') is not None:
                    about = label.get_text()
                    about = deleteContentInParentheses(about)
                    about = deleteSquareParentheses(about)
                    break
        except:
           pass           
                
    else:
        about = wikipedia.page("%s(grupo)" % (artist)).content
        about = getSmallSummary(about)
         
    
    return about

def getHomeTownArtist(html):
    '''
    La siguiente funcion retorna la ciudad natal de cada artista, 
    solamente se puede usar si es cantante, si es un grupo no funcionara

    Argument keywords:
    html: Recibe el html del artista a buscar
    '''
    #Extrayendo el html de la pagina del artista

    origin = ""
    try:
        for tr in html.find_all('tr'):
            #Busca todos los td del html y th
            label = tr.find('td')
            th = tr.find('th')

            if th is not None and th.get_text() == 'Nacimiento':
                #Obtiene el texto del td de nacimiento donde contiene la fecha de nacimiento
                tr = label.get_text()
                
                start = tr.find(')') + 1
                end =  len(tr)
                
                origin = tr[start : end]
                break
    except:
        pass
       
    return origin

def getOriginGroup(group):
    '''
    La siguiente funcion retorna donde se origino el grupo,
    solamente funciona correctamente para grupos

    Arguments keywords:
    group - Recibe el nombre del grupo
    '''
    try:
        wikipedia.set_lang("en")
        about = wikipedia.page("%s(group)" % (group)).html()
        soup = BeautifulSoup(about,"html.parser")

        origin = ""
        #Itera todos los tr del html
        for tr in soup.find_all('tr'):
        #Busca el infobox-label de cada tr
            label = tr.find(class_="infobox-label")
            if label != None:
                if label.get_text() == "Origin":
                    labelOrigin = tr.find(class_="infobox-data")
                    origin = labelOrigin.get_text()
                    break
        
        return origin
    except:
        print('No se pudo hallar el origen del grupo')

def getBirthdayFromArtist(html):

    '''
    La siguiente funcion retorna la fecha de nacimiento del artista

    Keywords arguments:
    html - es el html del artista

    '''


    date = ""

    try:
        #Itera todos los tr del html
        for tr in html.find_all('tr'):
            #Busca todos los td del html y th
            label = tr.find('td')
            th = tr.find('th')

            if th is not None and th.get_text() == 'Nacimiento':
                #Obtiene el texto del td de nacimiento donde contiene la fecha de nacimiento
                text = label.get_text()

                #Encuentra la posicion del año de nacimiento 
                positionYear = re.search('[1-2][0-9][0-9][0-9]', text)
                positionYear = positionYear.span()[1]

                #Obtiene solamente la fecha de nacimiento
                date = text[0: positionYear]
                date = re.sub('\n',"",date)
                break
    except:
        print('No se pudo hallar la fecha de nacimiento')
    
    return date


def getDebutedDateFromGroup(group):
    '''
    Obtiene la fecha de debut de un grupo, solamente funciona para grupos, de lo contrario
    saldra una excepcion

    Keyword arguments:
    group - es el nombre del grupo
    
    '''

    wikipedia.set_lang("en")
    dates = []
    
    try:
        about = wikipedia.page("%s"'(group)' % (group)).html()

        soup = BeautifulSoup(about,"html.parser")
        
        for tr in soup.find_all('tr'):
            label = tr.find('td')

            if label is not None:
                try:
                    positionYear = re.search('[1-2][0-9][0-9][0-9]',label.get_text())
                    date = label.get_text()[ positionYear.span()[0] :  positionYear.span()[1]]
                    dates.append(date)
                except:
                    pass
    except:
       print('No se pudo obtener la fecha debut del grupo')

    return dates[1]

def findTypeArtist(artist : str):
    '''
    La siguiente funcion retorna el tipo de artista
    
    Argument keywords:
    artista - recibe el nombre del artista
    '''  

    isSinger : bool = None
    
    #Url para los cantantes que tiene ambiguedad
    urlSinger = "https://es.wikipedia.org/wiki/%s_(cantante)" % artist

    try:
        #Obtiene el html para la primera url
        response = requests.get(urlSinger)
        soup = BeautifulSoup(response.content,"html.parser")
 
        for tr in soup.find_all('tr'):
            #Busca todos los td del html y th
            th = tr.find('th')

            if th is not None and th.get_text() == 'Nacimiento':
                
                isSinger = True
                break
        
    except:
        pass
    
    #Si no obtuvo algun valor booleano anteriormente intentara con la segunda url
    #En caso de volver a fallar, entonces se deducira que es un grupo
    
    if isSinger is None:
        result = getHTMLArtistV2(artist)
        isSinger = result[0]
       
        if isSinger is True:
         soup = result[1]
        
        
    
    if isSinger is None:
        isSinger = False


    return isSinger , soup

def getHTMLArtistV2(artist: str):
    
    options = ["_",""]
    optionsArtist = [artist,artist.lower()]
    isSinger : bool = False
    soup = ""
    html = ""
    for optionArtist in optionsArtist:
        for option in options:
            try:
                #Url para los cantantes sin ambiguedad
                urlV2 = "https://es.wikipedia.org/wiki/%s" % deleteSpaces(optionArtist,option)
    
                response = requests.get(urlV2)
                soup = BeautifulSoup(response.content,"html.parser")

                for tr in soup.find_all('tr'):
                    #Busca todos los td del html y th
                    th = tr.find('th')

                    if th is not None and th.get_text() == 'Nacimiento':
                        html = soup
                        isSinger = True
                        break
            
            except:
                pass
    
    return isSinger,html

def deleteSpaces(string: str, symbol: str):
    '''
    Elimina los espacios de un string, para prepararlo una busqueda para la web, cuando el string
    contiene espacios.

    Ejemplo:
    Ariana Grande = Ariana_Grande / ArianaGrande

    Keywords arguments:
    string - recibe el string para eliminar espacios
    symbol - simbolo a reemplazar por espacios
    '''
    if string.find(" "):
        string = re.sub(" ",symbol, string)

    return string

    



    