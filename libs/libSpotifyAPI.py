from spotipy.oauth2 import SpotifyClientCredentials
import spotipy

#Credenciales para SPOTIFY API
CLIENT_ID = "51f0e6b2845c46c993e4fa27def68d04"
CLIENT_SECRET = "0e475ffc03224621b6c91efee39620f3"

def getSpotifyToken():

    '''
    Obtiene el token para poder accesar al API de Spotify
    '''
    auth_manager = SpotifyClientCredentials(client_id = CLIENT_ID, client_secret = CLIENT_SECRET)
    sp = spotipy.Spotify(auth_manager=auth_manager)

    return sp 