part of 'view_model.dart';

class ChatViewModel with ChangeNotifier {
  ChatViewModel({this.currentChatgroupId = 0});

  int currentChatgroupId;

  final ChatRepository _chatRepo = ChatRepository();
  ApiResponse<List<Chat>> response = ApiResponse.notStarted();

  void setApiResponse(ApiResponse<List<Chat>> result) {
    response = result;
    notifyListeners();
  }

  Future<void> fetchChatData() async {
    setApiResponse(ApiResponse.loading());

    if (currentChatgroupId == 0) {
      setApiResponse(ApiResponse.completed([]));
      return;
    }

    try {
      List<Chat> result = await _chatRepo.fetchChatList(currentChatgroupId);
      setApiResponse(ApiResponse.completed(result));
    } catch (error) {
      setApiResponse(ApiResponse.error(error.toString()));
    }
  }

  Future<void> postChat(String prompt) async {
    response.message = '';

    List<Chat> previousChat = [];
    if (currentChatgroupId != 0 && response.data != null) {
      previousChat = response.data!;
    }

    response.status = Status.loading;
    notifyListeners();

    try {
      Chat result = await _chatRepo.sendChat(prompt, currentChatgroupId);

      setApiResponse(ApiResponse.completed([...previousChat, result]));

      // Perbarui chatgroupId apabila nilainya berbeda dengan yang sekarang
      if (result.chatgroupId != null && currentChatgroupId != result.chatgroupId) {
        currentChatgroupId = result.chatgroupId!;
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
    if (currentChatgroupId != newChatgroupId || currentChatgroupId == 0) {
      currentChatgroupId = newChatgroupId;
      fetchChatData();
    }
  }
}
