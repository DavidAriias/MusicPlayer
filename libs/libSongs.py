import re
import requests
from libs.libVideos import deleteSpaces , getURLForConsult

def getSongID(artist: str, song: str):

    newArtist = deleteSpaces(transformToUnitCode(artist))
    newSong = deleteSpaces(transformToUnitCode(song))
    
    artistSong = deleteSpaces(newSong +' '+ newArtist)

    url = getURLForConsult(artistSong, "official audio")
    response = requests.get(url)
    html = response.content.decode(encoding="utf-8")
 

    songID = re.findall(r"watch\?v=(\S{11})",html) [0]

    return songID

def transformToUnitCode(string):
    newString = ""
    for c in string:
        characterUnitCode  = ord(c)
        newString += chr(characterUnitCode)


    return newString
