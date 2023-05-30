import 'dart:convert';

UserError userErrorFromJson(String str) => UserError.fromJson(json.decode(str));

String userErrorToJson(UserError data) => json.encode(data.toJson());

class UserError {
    String detail;

    UserError({
        required this.detail,
    });

    factory UserError.fromJson(Map<String, dynamic> json) => UserError(
        detail: json["detail"],
    );

    Map<String, dynamic> toJson() => {
        "detail": detail,
    };
}

ModifyUser modifyUserFromJson(String str) => ModifyUser.fromJson(json.decode(str));

String modifyUserToJson(ModifyUser data) => json.encode(data.toJson());

class ModifyUser {
    String email;
    String password;

    ModifyUser({
        required this.email,
        required this.password,
    });

    factory ModifyUser.fromJson(Map<String, dynamic> json) => ModifyUser(
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
    };
}

CreateUser createUserFromJson(String str) => CreateUser.fromJson(json.decode(str));

String createUserToJson(CreateUser data) => json.encode(data.toJson());

class CreateUser {
    String email;
    String password;

    CreateUser({
        required this.email,
        required this.password,
    });

    factory CreateUser.fromJson(Map<String, dynamic> json) => CreateUser(
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
    };
}