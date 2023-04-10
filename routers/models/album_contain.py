from pydantic import BaseModel

class AlbumContain(BaseModel):
    trackNumber: int
    url: str
    name: str
    uri: str
    