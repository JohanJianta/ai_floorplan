part of 'repository.dart';

class UserRepository {
  Future<String> login(User user) async {
    try {
      PostResponse response = await apiServices.getPostApiResponse('/login', user.toJson());

      String result = '';

      if (response.body['success']) {
        Const.userId = response.body['payload']['userId']!;
        Const.auth = response.headers['authorization']!;

        result = response.body['messages'][0].toString();
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> register(User user) async {
    try {
      PostResponse response = await apiServices.getPostApiResponse('/register', user.toJson());

      String result = '';

      if (response.body['success']) {
        Const.userId = response.body['payload']['userId']!;
        Const.auth = response.headers['authorization']!;

        result = response.body['messages'][0].toString();
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }
}
