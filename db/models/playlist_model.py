from pydantic import BaseModel

class PlaylistModel(BaseModel):
    id: str | None
    emailUser : str | None
    idUser: str | None
    namePlaylist: str   
    songs: list[dict] | None
    musicVideos: list[dict] | None