from fastapi import FastAPI
from routers import artistProfile , results, users_db,albums  , playlist_user_db, searchImages

app = FastAPI(title= "Backend", 
            description="Se encuentra toda la informacion de la app, tanto del consumo de API'S como de la base de datos",
            version="0.0.4")

app.include_router(artistProfile.artistInfo)
app.include_router(results.results)
app.include_router(users_db.users_db)
app.include_router(albums.albums)
app.include_router(playlist_user_db.playlist_user_db)
app.include_router(searchImages.search_image)

@app.get("/")
async def read_root():
    return "Backend"