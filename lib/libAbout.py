import wikipedia
from bs4 import BeautifulSoup
import re


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



def getSummary(artist):
    '''
    Obtiene la descripcion de artista o grupo en cuestion

    Keyword arguments:

    artist - es el nombre del artista o grupo a buscar

    Retorna el resumen completo del artista ingresado
    '''
    about = ""
    wikipedia.set_lang("en")
    try:
        about = wikipedia.page("%s(group)" % (artist)).content
        
    except:
        about = wikipedia.summary("%s(singer)" % (artist))
       
    
    return getSmallSummary(about)

def getHomeTownArtist(singer):
    '''
    La siguiente funcion retorna la ciudad natal de cada artista, 
    solamente se puede usar si es cantante, si es un grupo no funcionara

    Argument keywords:
    singer: Recibe el nombre del artista a buscar
    '''
    #Extrayendo el html de la pagina del artista
    wikipedia.set_lang("en")
    about = wikipedia.page("%s(singer)" % (singer)).html()
   
    soup = BeautifulSoup(about, "html.parser")
       
    return soup.find(class_="birthplace").get_text()

def getOriginGroup(group):
    '''
    La siguiente funcion retorna donde se origino el grupo,
    solamente funciona correctamente para grupos

    Arguments keywords:
    group - Recibe el nombre del grupo
    '''
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

def dateAndOrigin(artist):
    '''
    funcion secundaria para que realize la tarea de la funcion
    gettingBirthDayFromArtist y gettingOriginArtist
    '''
    wikipedia.set_lang("es")

    summary = ""
    try:
        summary = wikipedia.summary(artist)
    except:
        print("No se encontro info del artista")

   
    return summary
def getBirthdayFromArtist(artist):

    '''
    La siguiente funcion retorna la fecha de nacimiento del artista

    Keywords arguments:
    artista - es el nombre del artista

    '''
    #Lista de los meses del año 
    months = ["enero","febrero","marzo","abril","mayo","junio","julio","agosto","septiembre","octubre","noviembre","diciembre"]

    dateIncomplete = dateAndOrigin(artist)
    dateOneDigit = []
    dateTwoDigits = []

    for month in months:
        try:
            #Busca las combinaciones posibles de la fecha de nacimiento del artista
            dateTwoDigits = re.findall('[1-3][0-9] de %s de [1-2][0-9][0-9][0-9]' % (month),dateIncomplete)
            dateOneDigit = re.findall('[1-9] de %s de [1-2][0-9][0-9][0-9]' % (month),dateIncomplete)
            if len(dateTwoDigits) > 0 or len(dateOneDigit) > 0:
                break
        except:
            pass

    finalDate = ""
    if len(dateTwoDigits) > 0:
        finalDate = dateTwoDigits[0]
    elif len(dateOneDigit) >  0:
        finalDate = dateOneDigit[0]

    return finalDate

def gettingAllString(date, positionYear):

    '''
    En la siguiente funcion se obtendra solamente la fecha de debut quitando palabras inecesarias que 
    se encuentren
    '''
    finalDate = ""
    x = date.find("n") + 2
    for i in range(x, positionYear):
        finalDate += date[i]
    return finalDate

def eliminateTrashFromDate(date):

    '''
    La siguiente funcion es la prefuncion para eliminar la basura que pueda contener la fecha

    Keywords arguments:
    date - es la fecha con datos del debut
    '''
    finalDate = ""

    try:
        #El siguiente bloque de codigo es para la fecha en formato mes,año
        dateIncomplete = re.search('[1-9], [1-2][0-9][0-9][0-9]',date)
        positionYear = dateIncomplete.span()[1]
        finalDate =  gettingAllString(date, positionYear)
    except:
        #El siguiente bloque de codigo es para la fecha con formato que solamente contiene año 
        dateIncomplete = re.search('[1-2][0-9][0-9][0-9]',date)
        positionYear = dateIncomplete.span()[1]
        finalDate = gettingAllString(date,positionYear)
       

    
    return finalDate

def getDebutedDateFromGroup(summary):
    '''
    Obtiene la fecha de debut de un grupo, solamente funciona para grupos, de lo contrario
    saldra una excepcion, para utilizar la funcion se necesita haber obtenido previamente
    el resumen

    Keyword arguments:
    summary - es el resumen completo
    '''
    
    #Son palabras que pueden ayudar a encontrar la fecha de debut del grupo en cuestion
    options = ["debut","debuted","released"]
    subString = ""

    try:
        #Obtiene todas los años encontrados en el resumen
        years = re.findall('[1-2][0-9][0-9][0-9]',summary)


        for option in options:
            #Busca la palabra del array opciones en el resumen
            foundWord = re.search(option,summary)
            #Obteniendo la posicion de donde empieza la palabra dentro del resumen
            foundWord = foundWord.span()[0]

            for year in years:
                #Del array de los años encontrados en el resumen, los buscara en el resuemn
                foundYear = re.search(year,summary)
                #Obtiene la posicion del ultimo digito del año encontrado
                foundYear = foundYear.span()[1]
                
                 #Se descartara los años que esten antes de la palabra que haya encontrado dentro del array options
                if foundYear > foundWord:
                    #Obtendra la cadena que estre entre la palabra debut/debuted/released y el año de encontro
                    subString = summary[foundWord:foundYear]
                    #En la siguiente funcion solamente dejara la fecha de debut
                    subString = eliminateTrashFromDate(subString)
                    break
            if len(subString) > 0:
                break


    except:
        pass

    return subString

def findTypeArtist(summary : str):
    '''
    La siguiente funcion retorna el tipo de artista
    
    Argument keywords:
    summary - recibe el resumen del artista
    '''

    
    isSinger : bool 

    positionWordSinger = re.search('singer', summary)
    positionWordGroup = re.search('group',summary)
    
    if positionWordSinger is None:
        isSinger = False
    else:
        if positionWordGroup is None:
            isSinger = True
        else:
            positionWordGroup = positionWordGroup.span()[0]
            positionWordSinger = positionWordSinger.span()[0]

            if positionWordSinger < positionWordGroup:
                isSinger = True
            elif positionWordGroup > positionWordSinger:
                isSinger = False

    return isSinger
    

    



    