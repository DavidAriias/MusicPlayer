from pydantic import BaseModel
from typing import Optional


class UserModel(BaseModel):
    id: Optional[str]
    email: str
    password: str