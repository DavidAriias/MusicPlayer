from pydantic import BaseModel

class Artists(BaseModel):
    name: str
    images: list
    type : str
    uri : str
    genre: list
