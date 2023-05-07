from fastapi import APIRouter
from libs.libSpotifyAPI import getSpotifyToken
from routers.models.artists import Artists

results = APIRouter()


@results.get('/search/{artist}')
async def search(artist: str):
    token = getSpotifyToken()
    results = token.search(q=artist, type='artist', limit= 10)
    artists = []

    for result in results['artists']['items']:
        if len(result['images']) > 0  and len(result['genres']) > 0:
            artists.append(Artists(
                name=result['name'], 
                images=result['images'], 
                genre=result['genres'],
                type= result['type'] ,
                uri=result['uri']
            ))
    return  artists


