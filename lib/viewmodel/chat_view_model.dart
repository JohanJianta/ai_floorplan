part of 'view_model.dart';

class ChatViewModel with ChangeNotifier {
  ChatViewModel({this.chatgroupId = 0});

  int chatgroupId;

  final ChatRepository _chatRepo = ChatRepository();
  ApiResponse<List<Chat>> response = ApiResponse.notStarted();

  void setApiResponse(ApiResponse<List<Chat>> result) {
    response = result;
    notifyListeners();
  }

  void addChat(Chat newChat) {
    response.data?.add(newChat);
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
    setApiResponse(ApiResponse.loading());

    try {
      // Send the new chat to the server
      Chat result = await _chatRepo.sendChat(prompt, chatgroupId);

      // Add the response chat to the chatList
      addChat(result);

      // Update the ApiResponse status to completed
      setApiResponse(ApiResponse.completed(response.data ?? []));
    } catch (error) {
      setApiResponse(ApiResponse.error(error.toString()));
    }
  }

  void updateChatgroupId(int newChatgroupId) {
    if (chatgroupId != newChatgroupId) {
      chatgroupId = newChatgroupId;
      fetchChatData();
    }
  }
}
