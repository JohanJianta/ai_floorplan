part of 'view_model.dart';

class ChatViewModel with ChangeNotifier {
  final ChatRepository _chatRepo = ChatRepository();
  ApiResponse<List<Chat>> response = ApiResponse.notStarted();

  int chatgroupId = 0;

  void setApiResponse(ApiResponse<List<Chat>> result) {
    response = result;
    notifyListeners();
  }

  Future<void> fetchChatData() async {
    setApiResponse(ApiResponse.loading());

    if (chatgroupId == 0) {
      setApiResponse(ApiResponse.completed([]));
      return;
    }

    try {
      List<Chat> result = await _chatRepo.fetchChatList(chatgroupId);
      setApiResponse(ApiResponse.completed(result));
    } catch (error) {
      setApiResponse(ApiResponse.error(error.toString()));
    }
  }

  Future<void> postChat(String prompt) async {
    response.message = '';

    List<Chat> previousChat = [];
    if (chatgroupId != 0 && response.data != null) {
      previousChat = response.data!;
    }

    response.status = Status.loading;
    notifyListeners();

    try {
      Chat result = await _chatRepo.sendChat(prompt, chatgroupId);

      setApiResponse(ApiResponse.completed([...previousChat, result]));

      // Perbarui chatgroupId apabila nilainya berbeda dengan yang sekarang
      if (result.chatgroupId != null && chatgroupId != result.chatgroupId) {
        chatgroupId = result.chatgroupId!;
      }
    } catch (error) {
      response.status = Status.error;
      response.message = error.toString();
      notifyListeners();
    }
  }

  Future<String> saveToGallery(int floorplanId) async {
    try {
      String result = await _chatRepo.saveFloorplan(floorplanId);
      return result;
    } catch (e) {
      return e.toString();
    }
  }

  void updateChatgroupId(int newChatgroupId) {
    if (chatgroupId != newChatgroupId || chatgroupId == 0) {
      chatgroupId = newChatgroupId;
      fetchChatData();
    }
  }
}
