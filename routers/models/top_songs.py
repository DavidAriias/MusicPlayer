from pydantic import BaseModel

class TopSongs(BaseModel):
    name: str
    image: str
    album: str
    release: str
    url: str