from pydantic import BaseModel

class PlaylistModel(BaseModel):
    id: str | None
    emailUser : str | None
    idUser: str | None
    namePlaylist: str   
    description: str | None
    audioTracks: list[dict] | None
