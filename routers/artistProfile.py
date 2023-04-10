from fastapi import APIRouter
from FastAPI.lib.libAbout import *
from FastAPI.lib.libSpotifyAPI import getSpotifyToken
from FastAPI.lib.libVideos import getMusicVideos
from FastAPI.routers.models import about_artist , album_data ,similar_artist , top_songs

artistInfo = APIRouter()

@artistInfo.get("/artist/topSongs/{uri}")
async def get_top_songs(uri: str):
    token = getSpotifyToken()
    data = token.artist_top_tracks(uri,country="MX")
    tracks = data["tracks"]
    listSongs = []

    for track in tracks:
        release_date = track["album"]["release_date"]
        releaseYear = release_date.split('-')
        releaseYear = releaseYear[0]

        listSongs.append(top_songs.TopSongs(
            name=track["name"],
            image=track["album"]["images"][0]['url'],
            album=track["album"]["name"],
            release=releaseYear,
            url=track["preview_url"],

        ))

    return listSongs
    
@artistInfo.get("/artist/albumData/{uri}/{type}")
async def get_album_data(uri: str, type: str):
    token = getSpotifyToken()
    data = token.artist_albums(uri, album_type= type, limit=None)
    listAlbums = []

    for i in data["items"]:
        release_date = i["release_date"]
        releaseYear = release_date.split('-')
        releaseYear = releaseYear[0]
        listAlbums.append(album_data.AlbumData(
            name=i["name"],
            uri=i["uri"],
            image=i["images"][0]["url"],
            release= releaseYear
        ))
        
    return listAlbums


@artistInfo.get("/artist/about/{artist}")
async def get_about_artist(artist: str):
    
    summary = getSummary(artist= artist)
    isSinger: bool = findTypeArtist(summary)
    
    if isSinger == True:
        artist =  about_artist.AboutArtist(summary = summary, origin= getHomeTownArtist(artist),date= getBirthdayFromArtist(artist), isSinger = True) 
    else:
        artist = about_artist.AboutArtist(summary = summary, origin= getOriginGroup(artist),date= getDebutedDateFromGroup(artist) , isSinger = False) 
    

    return artist

@artistInfo.get("/artist/similar/{uri}")
async def get_similar_artist(uri: str):
    token = getSpotifyToken()
    data = token.artist_related_artists(uri)
    listSimilarArtist = []

    for i in data["artists"]:
        listSimilarArtist.append(similar_artist.SimilarArtist(
            name=i["name"],
            uri=i["uri"],
            image=i["images"][0]["url"]
        ))

    return listSimilarArtist

@artistInfo.get("/artist/musicVideos/{artist}")
async def get_music_videos_data(artist: str):

    return getMusicVideos(artist)


    
    


    





