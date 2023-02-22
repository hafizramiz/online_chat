import '../model/m_user.dart';

class CreateMUser {
  static MUser createMUserObject(AuthState authState, String? userId,
      [String? email, String? displayName, String? photoUrl]) {
    MUser mUser = MUser(
        userId: userId,
        email: email,
        displayName: displayName,
        photoUrl: photoUrl != null
            ? photoUrl
            : "https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png",
        authState: authState);
    return mUser;
  }
}
