
def userSchema(user) -> dict:
    return {
        'id': str(user['_id']),
        'email': user['email'],
        'password': user['password'],
    }