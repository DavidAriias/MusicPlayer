from fastapi import APIRouter
from libs.libAbout import *
from libs.libSpotifyAPI import getSpotifyToken
from libs.libVideos import getMusicVideos
from routers.models import about_artist , album_data ,similar_artist , top_songs
from libs.libSongs import getSongID

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
            url= getSongID(track["artists"][0]["name"],track["name"]),
            albumUri = track["album"]["uri"]

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
    
    result = findTypeArtist(artist)
    isSinger : bool = result[0]
    htmlSinger = result[1]
    
    try:
        if isSinger == True:
            artist =  about_artist.AboutArtist(summary = getSummary(artist,isSinger,htmlSinger ), origin= getHomeTownArtist(htmlSinger) ,date= getBirthdayFromArtist(htmlSinger), isSinger = True) 
        else:
            artist = about_artist.AboutArtist(summary = getSummary(artist,isSinger, None), origin= getOriginGroup(artist),date= getDebutedDateFromGroup(artist) , isSinger = False) 
    except:
        artist = about_artist.AboutArtist(summary = "", origin= "",date= "" , isSinger = False) 
        
    return artist

@artistInfo.get("/artist/similar/{uri}")
async def get_similar_artist(uri: str):
    token = getSpotifyToken()
    data = token.artist_related_artists(uri)
    listSimilarArtist = []
    
    for i in data["artists"]:
        if len(i["genres"]) > 0:
         listSimilarArtist.append(similar_artist.SimilarArtist(
            name=i["name"],
            uri=i["uri"],
            image=i["images"][0]["url"],
            genre = i["genres"][0]
        ))
    
    return listSimilarArtist

@artistInfo.get("/artist/musicVideos/{artist}")
async def get_music_videos_data(artist: str):

    return getMusicVideos(artist)
    
    


    





