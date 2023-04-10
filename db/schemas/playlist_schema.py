def playlistSchema(playlist) -> dict:
    return {
        'id': str(playlist['_id']),
        'idUser': playlist['idUser'],
        'namePlaylist': playlist['namePlaylist'],
        'songs': playlist['songs'],
        'musicVideos': playlist['musicVideos']
    }

def playlistsSchema(playlists) -> list:
    return [playlistSchema(playlist) for playlist in playlists]