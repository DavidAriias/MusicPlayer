from pydantic import BaseModel

class AboutArtist(BaseModel):
    summary: str
    origin: str
    date: str
    isSinger : bool