from pydantic import BaseModel

class VideoContain(BaseModel):
    url : str
    title : str
    year: str
    thumbnail_url : str