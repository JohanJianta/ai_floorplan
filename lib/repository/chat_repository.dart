part of 'repository.dart';

class ChatRepository {
  Future<List<Chat>> fetchChatList(int chatgroupId) async {
    try {
      final response = await apiServices.getGetApiResponse('/chat/$chatgroupId');

      List<Chat> result = [];

      if (response['success']) {
        result = (response['payload']['chatlist'] as List).map((e) => Chat.fromJson(e)).toList();
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Chat> sendChat(String prompt, int chatgroupId) async {
    Chat chat = Chat(chat: prompt, chatgroupId: chatgroupId, userId: Const.userId);
    try {
      final response = await apiServices.getPostApiResponse('/chat', chat.toJson());

      Chat result = const Chat();

      if (response.body['success']) {
        result = Chat.fromJson(response.body['payload']);
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> saveFloorplan(int floorplanId) async {
    Map<String, dynamic> data = {"floorplanId": floorplanId, "userId": Const.userId};
    try {
      final response = await apiServices.getPostApiResponse('/gallery', data);

      String result = '';

      if (response.body['success']) {
        result = response.body['messages'][0].toString();
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }
}
