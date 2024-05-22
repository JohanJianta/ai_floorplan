part of 'pages.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ChatViewModel chatViewModel;

  @override
  void initState() {
    super.initState();
    chatViewModel = ChatViewModel();
    chatViewModel.fetchChatData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    chatViewModel.removeListener(_scrollToBottom);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      backgroundColor: const Color(0xFF222831),
      drawer: CustomDrawer(onChatgroupSelected: _handleUpdateChatgroupId), // Drawer
      body: _buildBody(),
      bottomNavigationBar: _buildInputRow(),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(Util.getSnackBar(message));
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleUpdateChatgroupId(int newChatgroupId) {
    chatViewModel.updateChatgroupId(newChatgroupId);
    _scrollToBottom();
  }

  void _handleSendChat() async {
    if (_chatController.text.isEmpty) {
      return;
    }
    await chatViewModel.postChat(_chatController.text);
    _chatController.clear();
    _scrollToBottom();
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF222831),
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Color(0xFFE1CDB5)),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      title: const Text(
        'AI Floorplan',
        style: TextStyle(color: Color(0xFFE1CDB5), fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBody() {
    return ChangeNotifierProvider<ChatViewModel>(
      create: (context) => chatViewModel,
      child: Consumer<ChatViewModel>(
        builder: (context, value, _) {
          switch (value.response.status) {
            case Status.loading:
              return _buildLoading();
            case Status.error:
              WidgetsBinding.instance.addPostFrameCallback((_) => _showSnackbar(value.response.message.toString()));
              return _buildError();
            case Status.completed:
              return _buildChatList(value.response.data);
            default:
              return Container();
          }
        },
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: Color(0xFFE1CDB5)),
    );
  }

  Widget _buildError() {
    return const Center(
      child: Text('Error occurred', style: TextStyle(color: Color(0xFFE1CDB5))),
    );
  }

  Widget _buildChatList(List<Chat>? chats) {
    if (chats == null || chats.isEmpty) {
      return _buildLogo();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: chats.length,
        itemBuilder: (context, index) {
          return _buildChat(chats[index]);
        },
      ),
    );
  }

  Widget _buildChat(Chat chatData) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(chatData.chat!, style: const TextStyle(color: Color(0xFFE1CDB5))),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: chatData.floorplans?.length ?? 0,
          itemBuilder: (context, index) {
            return HomePageCard(
              floorplan: chatData.floorplans!.elementAt(index),
              onSave: (floorplan) {
                // TODO: Implement save functionality
              },
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildLogo() {
    return Center(
      child: SvgPicture.asset(
        'lib/assets/logo.svg',
        width: 70,
        height: 58,
      ),
    );
  }

  Widget _buildInputRow() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildTextField(),
          const SizedBox(width: 16),
          _buildIconButton(
            icon: Icons.send_sharp,
            onPressed: _handleSendChat,
          ),
        ],
      ),
    );
  }

  Expanded _buildTextField() {
    return Expanded(
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 100,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[200],
        ),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: TextField(
              controller: _chatController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                hintText: 'Enter your text here',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ClipOval _buildIconButton({required IconData icon, required VoidCallback onPressed}) {
    return ClipOval(
      child: Container(
        color: const Color(0xFFE1CDB5),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
        ),
      ),
    );
  }
}
