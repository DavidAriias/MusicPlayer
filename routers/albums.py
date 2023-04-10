from FastAPI.lib.libSpotifyAPI import getSpotifyToken
from fastapi import APIRouter
from FastAPI.routers.models.album_contain import AlbumContain

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
            url= item["preview_url"],
            uri= item["uri"]
        ))

    return items

    