import pyapplemusicapi
import re
from googleapiclient.discovery import build
import urllib.request
import requests
from routers.models.video_data import VideoContain 


API_KEY = "AIzaSyCV1KcPcDlCG5YrhQjVRN7W-ijzFqE1Y7g"
API_SERVICE_NAME = "youtube"
API_VERSION = 'v3'


def generateToken():
    '''
    Genera el token para el servicio de Youtube API
    '''
    return build(API_SERVICE_NAME,API_VERSION,developerKey=API_KEY)


def deleteSpaces(string: str):
    '''
    Elimina los espacios de un string, para prepararlo una busqueda para la web, cuando el string
    contiene espacios.

    Ejemplo:
    Ariana Grande = Ariana+Grande

    Keywords arguments:
    string - recibe el string para agregar suma en vez de espacios
    '''
    if string.find(" "):
        string = re.sub(" ","+", string)

    return string

def getURLForConsult(artistInput: str,query: str):
    '''
    Genera la URL para realizar una busqueda en Youtube

    Keywords arguments:
    artistInput - es el nombre del artista a buscar
    query - es lo que se va a realizar con el artista

    Ejemplo:

    "https://www.youtube.com/results?search_query=Ariana+Grande+channel "
    (Buscara el canal de Ariana Grande)
    '''
       
    return "https://www.youtube.com/results?search_query=%s+%s" % (deleteSpaces(artistInput),deleteSpaces(query))

def getChannelID(artist: str):
    '''
    Se obtiene el id del canal a buscar, como parametro busca la pagina de canal de YT del artista
    '''

    url = getURLForConsult(artist , "official channel")
   
    #Busca el nombre del artista con su nombre personalizado
    html = urllib.request.urlopen(url)
    resultsChannels_ids = re.findall(r"/@(\S{23})",html.read().decode()) [0]
    personalizeID = resultsChannels_ids
    personalizeID = personalizeID.split('"')[0]

    #Busca el canal del artista
    consult = "https://www.youtube.com/@%s" % (personalizeID)
    htmlProfile = urllib.request.urlopen(consult)
    #Trae el id del canal de artista que servira despues para traer info de su canal de YT
    channel_id = re.findall(r"channel_id=(\S{24})",htmlProfile.read().decode())
   
    return  channel_id[0]

def getPlaylistID(artist: str):

    '''
    Obtiene el id del playlist de los videos musicales del artista de su canal de youtube en caso de existir

    Arguments keyword:
    artist - Es el nombre del artista a buscar
    '''

    #Genera token para el servicio de YOUTUBE API
    token = generateToken()

    #Obtiene el id del canal del artista
    channelID = getChannelID(artist)

    #Realiza la peticion de buscar todas las playlist que hay en el canal del artista
    request =  token.playlists().list(
        part="snippet",
        channelId= channelID,
        maxResults="50"
    )

    results = request.execute()

    #Obtiene todas las playlist
    items_in_playlists = results["items"]

    #Opciones para encontrar la playlist de los videos musicales
    options = ["music video","music videos","mv","mv's","m/v"]
    aux = "%s music video" % (artist.lower())
    aux2 = "%s music videos" % (artist.lower())
    options.append(aux)
    options.append(aux2)

    #Definiremos que el id de la playlist no contiene nada
    idPlaylist = None
    
    #Itera todas las playlist
    for item in items_in_playlists:
        playlistTitle = item["snippet"]["title"]

        #Itera el nombre de cada playlist encontrada y compara si es igual a alguna opcion
        for option in options:
            if option == playlistTitle.lower():
                idPlaylist = item["id"]
                break
        #Si encontro el id de la playlist de los videos musiciales antes de buscar entre todas saldra del ciclo
        if idPlaylist != None:
            break
    
    #Retorna el id de la playlist en caso de haberlo encontrado, si no retorna None
    return idPlaylist

def getIDMusicVideos(artist: str):

    '''
    Obtiene las urls de los videos musciales del artista

    Keyword arguments:
    artist - Es el nombre del artista a buscar
    '''
    listIDVideos = []
    #Obtiene el id de la playlist en caso de haberla
    idPlaylist = getPlaylistID(artist)

    #Si no encontro los videos musiciales en YT, entonces los buscara en la API de itunes
    if idPlaylist == None:
         videos = pyapplemusicapi.search(query=artist ,media='musicVideo', limit=20)
         for video in videos:
            IDs = getIDVideosForItunes(video.name, artist)
            if IDs != None:
                listIDVideos.append(IDs)
    else:
        listIDVideos = getIDVideosForPlaylistYT(idPlaylist, artist)


    if len(listIDVideos) == 0:
        videos = pyapplemusicapi.search(query=artist ,media='musicVideo', limit=20)
        for video in videos:
            IDs = getIDVideosForItunes(video.name, artist)
            if IDs != None:
                listIDVideos.append(IDs)
    
    #Retorna las urls de los videos musicales
    return listIDVideos

def getIDVideosForItunes(videoName: str, artist: str):
    '''
    Busca las urls de los videos para los videos obtenidos de la API de itunes

    Keyword arguments:
    videoName = nombre del video a buscar
    artist = nombre del artista del video
    '''

    videos_ids : str =  None
    #Obtiene url del video a buscar
    url = getURLForConsult(deleteSpaces(artist),deleteSpaces(videoName))
    try:
        #Obtiene el html de las busqueadas del video
        response = requests.get(url)
        html = response.content.decode(encoding="utf-8")
        #Obtiene el id del primer video encontrado
        videos_ids = re.findall(r"watch\?v=(\S{11})",html)[0]
        
    except:
        print("No se ha podido buscar el video " + videoName )
    
    return videos_ids
    
    
def getIDVideosForPlaylistYT(idPlaylist: str, artist: str):
    '''
    Obtiene las url de los videos de la playlist del artista encontrado en su canal de YT

    Keyword arguments:

    idPlaylist: Es el id de la playlist encontrado antes en su canal de yt
    '''
    #Genera token para la API de YT
    token = generateToken()

    #Realiza la peticion de cada video de la playlist encontrada
    request =  token.playlistItems().list(
        part="snippet",
        playlistId = idPlaylist,
        maxResults = "30"
    )

    results = request.execute()

    #Obtiene todos los videos
    items_in_playlist = results['items']
  
    videosID = []
    #Itera todos los videos
    for item in items_in_playlist:
        title = item["snippet"]["title"]
        aux : str = title.lower()

        if aux.find("teaser") != -1 or re.search(artist.lower(), aux) is None:
            continue
        else:
            videoID = item["snippet"]["resourceId"]["videoId"]
            videosID.append(videoID)
    return videosID

def getMusicVideos(artist: str):
    
    token = generateToken()
    listVideoIDs = getIDMusicVideos(artist)

    request = token.videos().list(
        part="snippet",
        id= listVideoIDs
    )
    response = request.execute()

    items_in_playlist = response['items']
    listMusicVideos = []

    for item in items_in_playlist:
        release_date = item['snippet']['publishedAt']
        releaseYear = release_date.split('-')
        releaseYear = releaseYear[0]
        listMusicVideos.append(
            VideoContain(
            title= item['snippet']['title'],
            url= item['id'],
            year=releaseYear,
            thumbnail_url= item['snippet']['thumbnails']['medium']['url']
            )
        )

    return listMusicVideos


