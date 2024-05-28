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
    chatViewModel.addListener(_scrollToBottom);
    chatViewModel.fetchChatData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    chatViewModel.removeListener(_scrollToBottom);
    super.dispose();
  }

  void _showSnackbar(String message) {
    if (Navigator.of(context).canPop() && mounted) {
      Navigator.of(context).pop();
    }
    ScaffoldMessenger.of(context).showSnackBar(Util.getSnackBar(message));
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSaveFloorplan(Floorplan floorplan) async {
    String message = await chatViewModel.saveToGallery(floorplan.floorplanId!);
    _showSnackbar(message);
  }

  void _handleSendChat() async {
    if (_chatController.text.isEmpty) return;
    await chatViewModel.postChat(_chatController.text.trim());
    _chatController.clear();
  }

  void _handleDeletedChatgroup(int chatgroupId) async {
    if (chatgroupId != chatViewModel.currentChatgroupId) return;

    // Reset homepage apabila sedang menampilkan data chatgroup yang sudah dihapus
    chatViewModel.updateChatgroupId(0);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      backgroundColor: const Color(0xFF222831),
      drawer: CustomDrawer(
        onChatgroupSelected: chatViewModel.updateChatgroupId,
        onChatgroupDeleted: _handleDeletedChatgroup,
      ),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF222831),
      title: const Text(
        'AI Floorplan',
        style: TextStyle(color: Color(0xFFE1CDB5), fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Color(0xFFE1CDB5)),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_square, color: Color(0xFFE1CDB5)),
          onPressed: () => chatViewModel.updateChatgroupId(0),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return ChangeNotifierProvider<ChatViewModel>(
      create: (context) => chatViewModel,
      child: Consumer<ChatViewModel>(
        builder: (context, value, _) {
          final status = value.response.status;
          final data = value.response.data;
          final message = value.response.message;

          return Column(
            children: [
              Expanded(
                child: {Status.loading, Status.error}.contains(status) && (data == null || data.isEmpty)
                    // Tampilkan indikator loading atau pesan error saja apabila belum ada data chat
                    ? status == Status.loading
                        ? _buildLoading()
                        : _buildError(message.toString())
                    // Tampilkan data chat apabila sudah ada, kemudian tambahkan indikator loading atau pesan error tergantung status
                    : _buildChatList(data, {Status.loading, Status.error}.contains(status), message?.toString() ?? ''),
              ),
              _buildInputRow(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoading() {
    return const Padding(
      padding: EdgeInsets.only(top: 16, bottom: 30),
      child: Center(
        child: CircularProgressIndicator(color: Color(0xFFE1CDB5)),
      ),
    );
  }

  Widget _buildError(String error) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 30),
      child: Center(
        child: Text(
          error,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildChatList(List<Chat>? chats, bool isLoadingMore, String errMsg) {
    if (chats == null || chats.isEmpty) {
      return _buildLogo();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: chats.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == chats.length) {
            // Tampilkan pesan error apabila terjadi error, atau indikator loading apabila sedang menunggu
            return errMsg.isNotEmpty ? _buildError(errMsg) : _buildLoading();
          } else {
            return _buildChat(chats[index]);
          }
        },
      ),
    );
  }

  Widget _buildChat(Chat chatData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(chatData.chat!, style: const TextStyle(color: Color(0xFFE1CDB5), fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: chatData.floorplans?.length ?? 0,
          itemBuilder: (context, index) {
            return HomePageCard(
              floorplan: chatData.floorplans![index],
              onSave: _handleSaveFloorplan,
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
        ),
        const SizedBox(height: 30),
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                hintText: 'Masukkan kriteria floorplan anda',
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
