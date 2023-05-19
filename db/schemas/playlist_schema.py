def playlistSchema(playlist) -> dict:
    return {
        'id': str(playlist['_id']),
        'idUser': playlist['idUser'],
        'namePlaylist': playlist['namePlaylist'],
        'description': playlist['description'],
        'audioTracks': playlist['audioTracks'],
    }

def playlistsSchema(playlists) -> list:
    return [playlistSchema(playlist) for playlist in playlists]
