part of 'repository.dart';

class UserRepository {
  Future<String> login(String email, String password) async {
    User user = User(email: email, password: password);
    try {
      PostResponse response = await apiServices.getPostApiResponse('/login', user.toJson());

      String result = '';

      if (response.body['success']) {
        Const.userId = response.body['payload']['userId']!;
        Const.auth = response.headers['authorization']!;

        await Const.signIn(response.body['payload']['userId']!, response.headers['authorization']!);

        result = response.body['messages'][0].toString();
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> register(String email, String password) async {
    User user = User(email: email, password: password);
    try {
      PostResponse response = await apiServices.getPostApiResponse('/register', user.toJson());

      String result = '';

      if (response.body['success']) {
        Const.userId = response.body['payload']['userId']!;
        Const.auth = response.headers['authorization']!;

        await Const.signIn(response.body['payload']['userId']!, response.headers['authorization']!);

        result = response.body['messages'][0].toString();
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updateUserData({String? newPassword, String? oldPassword, bool? isPremium}) async {
    User user = User(password: newPassword, oldPassword: oldPassword, premium: isPremium);
    try {
      dynamic response = await apiServices.getPutApiResponse('/user/${Const.userId}', user.toJson());

      String result = '';

      if (response['success']) {
        result = response['messages'][0].toString();
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }
}
