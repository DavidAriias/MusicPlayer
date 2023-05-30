from fastapi import APIRouter , HTTPException , status
from db.client import db_client
from db.models.playlist_model import PlaylistModel
from db.schemas.playlist_schema import playlistSchema, playlistsSchema
from db.schemas.user_schema import userSchema
from bson import ObjectId

playlist_user_db = APIRouter()

@playlist_user_db.post('/playlists')
async def create_playlsit(data_playlist: PlaylistModel):

    user = userSchema(db_client.users.find_one({'email': data_playlist.emailUser}))


    data_playlist.idUser = user['id']

    playlist_dict = dict(data_playlist)

    del playlist_dict['id']
    del playlist_dict['emailUser']
    
    id = db_client.playlists.insert_one(playlist_dict).inserted_id

    new_playlist = playlistsSchema(db_client.playlists.find({'idUser': data_playlist.idUser}))

    return new_playlist
    

@playlist_user_db.put('/playlists')
async def modify_playlist(data_playlist: PlaylistModel):  
 
    playlist = playlistSchema(db_client.playlists.find_one({'_id': ObjectId(data_playlist.id)}))

    data_playlist.idUser = playlist['idUser']
    playlist_dic = dict(data_playlist)
    del playlist_dic['emailUser']
   
    del playlist_dic['id']
  
    db_client.playlists.find_one_and_update({'_id': ObjectId(data_playlist.id)} , {'$set': playlist_dic })

    return playlistsSchema(db_client.playlists.find({'idUser' : data_playlist.idUser}))
    

@playlist_user_db.delete('/playlists/{playlist_id}')
async def delete_playlist(playlist_id : str):

    playlist = playlistSchema(db_client.playlists.find_one({'_id': ObjectId(playlist_id)}))

    id_user = playlist['idUser']

    response = db_client.playlists.delete_one({'_id': ObjectId(playlist_id)})

    if response.raw_result['n'] == 1:
        return playlistsSchema(db_client.playlists.find({'idUser': id_user}))
    else:
        return status.HTTP_404_NOT_FOUND
    



    
