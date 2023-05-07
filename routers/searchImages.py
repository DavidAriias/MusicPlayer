from fastapi import APIRouter

search_image = APIRouter()

@search_image.get('/searchImages')
async def search_images():
    data : list = [
        {
        "genre": 'Musica Mexicana',
        "image": 'https://th.bing.com/th/id/R.8b6829bfb5775f6fcae7dc7459eaf89b?rik=pXxBm7gmoEH3CQ&riu=http%3a%2f%2fofficialpsds.com%2fimageview%2fr1%2f43%2fr1433y_large.png%3f1521316540&ehk=8hAkrNSlKCcutgSmz0PY7LuMP01ldfwB%2fvIgt4rjewY%3d&risl=&pid=ImgRaw&r=0',
        },
        {
        "genre": 'Hits',
        "image": 'https://www.mdzol.com/u/fotografias/m/2021/3/17/f1280x720-1031801_1163476_4237.jpg',
        },
        {
        
        "genre": 'Hip - Hop/Rap',
        "image": 'https://th.bing.com/th/id/R.957610715ca5687e01b58eb013b95b5c?rik=ODyWMg1qp4d9oQ&pid=ImgRaw&r=0',
        },
        {
        "genre": 'Urbano latino',
        "image": 'https://www.pngarts.com/files/5/J-Balvin-Transparent-Image.png',
        },
        {
        "genre": 'Alternativo español',
        "image": 'https://1.bp.blogspot.com/-Uq1vYEU8miQ/XcfW4YnlE4I/AAAAAAACdrg/gcXaORgB47QtmEFzs9ooyI4rHJiCCRX0gCLcBGAsYHQ/w1200-h630-p-k-no-nu/Silvana-Estrada.jpg',
        },
        {
        "genre": 'Pop in spanish',
        "image": 'https://www.freepngimg.com/thumb/enrique_iglesias/35636-5-enrique-iglesias-transparent-background.png',
        },
        {
        "genre": 'Rock in spanish',
        "image": 'https://2.bp.blogspot.com/-40PufrCubK8/XOB4D3DNcWI/AAAAAAAABaw/JVWIAHLimesnu-sJTke-nWjc8_AXOwkpgCEwYBhgL/s1600/BUNBURY_PORTADA-min.png',
        },
        {
        "genre": 'Dance',
        "image": 'https://th.bing.com/th/id/OIP.5a61y1XWk9iEBZ_1v9WslQHaHa?pid=ImgDet&rs=1',
        },
        {
        "genre": 'Rock',
        "image": 'https://th.bing.com/th/id/R.bed09382a99a1f556485c12a16c0f39e?rik=V8NuH99vTHHm7A&riu=http%3a%2f%2fimg01.deviantart.net%2f246c%2fi%2f2013%2f192%2f2%2fd%2flinkin_park_transparent_by_darksoulforver9-d6czlu3.png&ehk=p7PQ2fiqR8tRtd1%2fLfiAel0QH4HeRbObR4Ft5yhyv2M%3d&risl=&pid=ImgRaw&r=0',
        },
        {
        'genre': 'Alternative',
        "image": 'https://th.bing.com/th/id/R.7a770e092ef4de6a5a6be1fbcf723c69?rik=7XAqUkgfI2F8Vw&pid=ImgRaw&r=0',
        },
        {
        "genre": 'Pop',
        "image": 'https://th.bing.com/th/id/R.2178ad183f083162708b364ba125f570?rik=nImMcpSwrNf4JA&riu=http%3a%2f%2fpre05.deviantart.net%2f3237%2fth%2fpre%2ff%2f2016%2f165%2f1%2f4%2fariana_grande_png_by_maarcopngs-da69k9m.png&ehk=GTAEVWT%2fnkpQXv6JAb7r4Q1zaPceXaXMeaerx1xK%2fdo%3d&risl=&pid=ImgRaw&r=0',
        },
        {
        "genre": 'Electronic',
        "image": 'https://orig00.deviantart.net/66e0/f/2015/190/c/d/avicii_png_by_bellathornee-d90jzfd.png',
        },
        {
        "genre": 'Country',
        "image": 'https://www.baptistpress.com/wp-content/uploads/images/IMG20035306978HI.jpg',
        },
        {
        "genre": 'Classical',
        "image": 'https://th.bing.com/th/id/R.44a4ca299b48d2998f319a18078f44a6?rik=gXJS%2fMSR0n5VzA&riu=http%3a%2f%2fpngimg.com%2fuploads%2fviolin%2fviolin_PNG12842.png&ehk=xm%2b%2bvBGBJJkLNfta8jz%2bnTfJG%2fQ3EY6Nfxr2SSFd6Nc%3d&risl=&pid=ImgRaw&r=0',
        },
        {
        "genre": 'Jazz',
        "image": 'https://th.bing.com/th/id/OIP.1JACqF6FhNadniBDiU33CwHaE5?pid=ImgDet&rs=1',
        },
        {
        "genre": 'Classic Rock',
        "image": 'https://th.bing.com/th/id/R.acc60d3cc20cac6460cc05ed91c20544?rik=dMY5jeQAJkqQ5Q&pid=ImgRaw&r=0',
        },
        {
        "genre": 'R&B',
        "image": 'https://www.iceposter.com/thumbs/G557492_b.jpg',
        },
        {
        "genre": 'Indie',
        "image": 'https://th.bing.com/th/id/R.755ed306bf46c8edee14ce47841348ec?rik=7OA7S8yEBw2Xew&pid=ImgRaw&r=0',
        },
        {
        "genre": 'K-Pop',
        "image": 'https://www.pngall.com/wp-content/uploads/10/Blackpink-PNG-HD-Image.png',
        },
        {
        "genre": 'Christian',
        "image": 'https://images.genius.com/c33e7fdea309d2c77eda86d637400aa0.1000x1000x1.png',
        },
        {
        "genre": 'J-Pop',
        "image": 'https://item-shopping.c.yimg.jp/i/n/jeugiabasic_basic-4988031433461',
        },
        {
        "genre": 'Oldies',
        "image": 'https://th.bing.com/th/id/R.cb1815716ddae28c096c0f220d05eefc?rik=V5VOhhsDjkRxfg&riu=http%3a%2f%2floveferrari.l.o.pic.centerblog.net%2fo%2f74089d7a.png&ehk=N2FXed6iP7QEZZJ0K06lzmsgp%2fFrXqPdP%2bbjXU1Uy5Y%3d&risl=&pid=ImgRaw&r=0'
        }
    ]
    return data
    