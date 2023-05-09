from fastapi import APIRouter , HTTPException
from db.client import db_client
from db.models.user_model import UserModel
from werkzeug.security import generate_password_hash, check_password_hash
from db.schemas.user_schema import userSchema
from db.schemas.playlist_schema import playlistsSchema

users_db = APIRouter()


@users_db.get('/users/{email}/{password}')
async def get_user_data(email : str , password : str):
    error = None
    user = None

    try:
        user = userSchema(db_client.users.find_one({'email': email}))
    except:
        print("Could not find user")

    if user is None:
       error =  HTTPException(403, "Could not find user")
    elif not check_password_hash(user['password'], password):
       error =  HTTPException(403, "Could not find user")
    
    if error is None:
       return playlistsSchema(db_client.playlists.find({'idUser' : user['id']}))
    else:
        raise error

    
@users_db.post('/users')
async def create_user(data_user: UserModel):
    
    if(searchEmail(data_user.email) != True):
        data_user.password = generate_password_hash(data_user.password, "pbkdf2:sha256:30", 50)
        user_dict = dict(data_user)

        del user_dict['id']

        id = db_client.users.insert_one(user_dict).inserted_id

        new_user = userSchema(db_client.users.find_one({'_id': id}))

        return UserModel(**new_user)
    else:
        return HTTPException(403, "User registrated")

@users_db.put('/users/{email}/{password}')
async def modify_user(data_user: UserModel):

    data_user.password = generate_password_hash(data_user.password, "pbkdf2:sha256:30", 50)
    user_dict = dict(data_user)
    del user_dict['id']
    
    user = userSchema(db_client.users.find_one_and_update({'email': data_user.email}, {'$set': user_dict }))

    return UserModel(**user)



def searchEmail(email: str):
    
    response : bool = False

    try:
        
        user = userSchema(db_client.users.find_one({'email': email}))
        if user is not None:
            response = True
    except:
        response = False

   
    return response












    




