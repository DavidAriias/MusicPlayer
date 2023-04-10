from pydantic import BaseModel

class SimilarArtist(BaseModel):
    name: str
    uri: str
    image: str
