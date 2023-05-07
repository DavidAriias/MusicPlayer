from pydantic import BaseModel

class AlbumData(BaseModel):
    name: str
    uri: str
    image: str
    release: str