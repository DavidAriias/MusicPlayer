from libs.libSpotifyAPI import getSpotifyToken
from fastapi import APIRouter
from routers.models.album_contain import AlbumContain
from libs.libSongs import getSongID

albums = APIRouter()


@albums.get('/data/albums/{uri}')
async def get_albums_contain(uri: str):
    token = getSpotifyToken()
    data = token.album_tracks(uri, limit=None, market=None)
    items = data["items"]
    listTracks = []

    for item in items:
        listTracks.append(AlbumContain(
            trackNumber= item["track_number"],
            name=item["name"],
            url= getSongID(item["artists"][0]["name"],item["name"]),
        ))

    return {
        "artist": items[0]["artists"][0]["name"],
        "data": listTracks
    }

    
