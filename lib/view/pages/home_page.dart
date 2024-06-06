part of 'pages.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController loadingController;
  late ChatViewModel chatViewModel;

  bool isLoadingChat = false;
  int currentChatgroupId = 0;

  @override
  void initState() {
    chatViewModel = ChatViewModel();
    chatViewModel.addListener(_scrollToBottom);
    chatViewModel.fetchChatData();
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    loadingController.dispose();
    _scrollController.dispose();
    chatViewModel.removeListener(_scrollToBottom);
    super.dispose();
  }

  void _showSnackbar(String message) {
    if (Navigator.of(context).canPop() && mounted) {
      Navigator.of(context).pop();
    }
    ScaffoldMessenger.of(context).showSnackBar(Util.getSnackBar(context, message));
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
    if (_chatController.text.isEmpty || isLoadingChat) return;
    isLoadingChat = true;

    // Mulai animasi loading
    loadingController.forward(from: 0.0);

    try {
      await chatViewModel.postChat(_chatController.text.trim());
      _chatController.clear();
    } finally {
      // Hentikan animasi loading
      loadingController.stop();
      isLoadingChat = false;
    }
  }

  void _handleDeletedChatgroup(int chatgroupId) async {
    if (chatgroupId != chatViewModel.chatgroupId) return;

    // Reset homepage apabila sedang menampilkan data chatgroup yang sudah dihapus
    chatViewModel.updateChatgroupId(0);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      drawer: CustomDrawer(
        currentChatgroupId: currentChatgroupId,
        onChatgroupSelected: (chatgroupId) {
          setState(() => currentChatgroupId = chatgroupId);
          chatViewModel.updateChatgroupId(chatgroupId);
        },
        onChatgroupDeleted: _handleDeletedChatgroup,
      ),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Text(
        'AI Floorplan',
        style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
        icon: Icon(Icons.menu, color: Theme.of(context).colorScheme.primary),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      actions: [
        Tooltip(
          message: 'Halaman Baru',
          triggerMode: TooltipTriggerMode.longPress,
          child: IconButton(
            icon: Icon(Icons.add_to_photos_sharp, color: Theme.of(context).colorScheme.primary),
            onPressed: () => chatViewModel.updateChatgroupId(0),
          ),
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
                        ? _buildLoading(isLoadingChat)
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

  Widget _buildLoading(bool withPercentage) {
    // Berhenti di 90% apabila belum selesai
    double progressValue = loadingController.value < 0.9 ? loadingController.value : 0.9;

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 30),
      child: Center(
        child: withPercentage
            // Indikator loading ketika menunggu floorplan di generate
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progressValue,
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                    strokeCap: StrokeCap.round,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${(progressValue * 100).round()}%',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              )
            : CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
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
            return errMsg.isNotEmpty ? _buildError(errMsg) : _buildLoading(isLoadingMore);
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
        Text(chatData.chat!, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
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
        colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
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
    double defaultOpacity = 0.1;
    double loadingOpacity = 0.3;

    if (Theme.of(context).brightness == Brightness.dark) {
      defaultOpacity = 1;
      loadingOpacity = 0.7;
    }

    return Expanded(
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 200,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.secondary.withOpacity(isLoadingChat ? loadingOpacity : defaultOpacity),
        ),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: TextField(
              controller: _chatController,
              readOnly: isLoadingChat ? true : false,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Masukkan kriteria floorplan anda',
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              ),
              cursorColor: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ),
      ),
    );
  }

  ClipOval _buildIconButton({required IconData icon, required VoidCallback onPressed}) {
    Color containerColor = Colors.transparent;
    Color iconColor = Theme.of(context).colorScheme.primary;

    if (Theme.of(context).brightness == Brightness.dark) {
      containerColor = Theme.of(context).colorScheme.primary;
      iconColor = Theme.of(context).colorScheme.background;
    }

    return ClipOval(
      child: Container(
        color: containerColor,
        child: IconButton(onPressed: onPressed, icon: Icon(icon, color: iconColor)),
      ),
    );
  }
}
