enum AuthState {
  SUCCESFULL,
  ERROR,
  WEAKPASSWORD,
  EMAILINUSE,
  IDLE,
  USERNOTFOUND,
  WRONGPASSWORD,
  }

class MUser {
  final String? userId;
  final String? email;
   String? displayName;
   String? photoUrl;
  final AuthState authState;

  MUser(
      {required this.userId,
       required this.email,
       required this.displayName,
       required this.photoUrl,
      this.authState = AuthState.IDLE});

  MUser.fromJson(Map<String, dynamic> json)
      : this.userId = json["userId"],
        this.email = json["email"],
        this.displayName = json["displayName"],
        this.photoUrl = json["photoUrl"],
        this.authState = AuthState.IDLE;

  Map<String, dynamic> toJson() {
    return {
      "userId": this.userId,
      "email": this.email,
      "displayName": this.displayName,
      "photoUrl": this.photoUrl
    };
  }
}
