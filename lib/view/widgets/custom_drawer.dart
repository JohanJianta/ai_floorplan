part of 'widgets.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key, required this.onChatgroupSelected, required this.onChatgroupDeleted});

  final Function(int) onChatgroupSelected;
  final Function(int) onChatgroupDeleted;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late HistoryViewModel historyViewModel;

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(Util.getSnackBar(message));
  }

  void _handleRemoveHistory(int chatgroupId) async {
    try {
      bool isConfirmed = await _showAlertDialog(
        title: 'Konfirmasi Penghapusan',
        content: 'Apakah anda yakin ingin menghapus chatgroup ini?',
        primaryText: 'Hapus',
      );
      if (!isConfirmed) return;

      String message = await historyViewModel.removeHistory(chatgroupId);
      widget.onChatgroupDeleted(chatgroupId);
      _showSnackbar(message);
    } catch (e) {
      _showSnackbar(e.toString());
    }
  }

  void _handleLogOut() async {
    bool isConfirmed = await _showAlertDialog(
      title: 'Konfirmasi Keluar',
      content: 'Apakah anda yakin ingin keluar dari akun anda?',
      primaryText: 'Keluar',
    );
    if (!isConfirmed) return;

    // Reset informasi user
    Const.signout();

    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  void initState() {
    super.initState();
    historyViewModel = HistoryViewModel();
    historyViewModel.fetchhistoryList();
  }

  @override
  void dispose() {
    historyViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF393E46),
        padding: const EdgeInsets.only(top: 48, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildDrawerItem(
                title: 'Galeri',
                onTapEvent: () => Navigator.of(context).pushNamed('/gallery'),
              ),
              _buildDrawerItem(
                title: 'Sampah',
                onTapEvent: () => Navigator.of(context).pushNamed('/trashbin'),
              ),
              _buildExpansionPanel(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({required String title, required VoidCallback onTapEvent}) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFE1CDB5),
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTapEvent,
    );
  }

  Widget _buildExpansionPanel() {
    return ExpansionPanelList.radio(
      elevation: 0,
      expandIconColor: const Color(0xFFE1CDB5),
      dividerColor: const Color(0xFF393E46),
      children: [
        _buildHistoryExpansionPanel(),
        _buildSettingsExpansionPanel(),
      ],
    );
  }

  ExpansionPanelRadio _buildHistoryExpansionPanel() {
    return ExpansionPanelRadio(
      value: 'History',
      backgroundColor: const Color(0xFF393E46),
      headerBuilder: (BuildContext context, bool isExpanded) {
        return const ListTile(
          title: Text(
            'Riwayat',
            style: TextStyle(
              color: Color(0xFFE1CDB5),
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
      body: ChangeNotifierProvider<HistoryViewModel>.value(
        value: historyViewModel,
        child: Consumer<HistoryViewModel>(
          builder: (context, value, _) {
            return _buildHistoryPanelBody(value);
          },
        ),
      ),
      canTapOnHeader: true,
    );
  }

  Widget _buildHistoryPanelBody(HistoryViewModel value) {
    switch (value.historyList.status) {
      case Status.loading:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(child: CircularProgressIndicator(color: Color(0xFFE1CDB5))),
        );
      case Status.error:
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            value.historyList.message.toString(),
            style: const TextStyle(color: Colors.red),
          ),
        );
      case Status.completed:
        return _buildHistoryList(value);
      default:
        return Container();
    }
  }

  ExpansionPanelRadio _buildSettingsExpansionPanel() {
    return ExpansionPanelRadio(
      value: 'Setting',
      backgroundColor: const Color(0xFF393E46),
      headerBuilder: (BuildContext context, bool isExpanded) {
        return const ListTile(
          title: Text(
            'Pengaturan',
            style: TextStyle(
              color: Color(0xFFE1CDB5),
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
      body: Column(
        children: [
          _buildSettingsItem(
            title: 'Ubah Email',
            onTapEvent: () => Navigator.pop(context),
          ),
          _buildSettingsItem(
            title: 'Ubah Password',
            onTapEvent: () => Navigator.pop(context),
          ),
          _buildSettingsItem(
            title: 'Keluar',
            weight: FontWeight.bold,
            icon: Icons.logout_sharp,
            color: Colors.red,
            onTapEvent: _handleLogOut,
          ),
        ],
      ),
      canTapOnHeader: true,
    );
  }

  Widget _buildHistoryList(HistoryViewModel value) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 480),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const ScrollPhysics(),
        itemCount: value.historyList.data!.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onLongPressStart: (details) {
              // Tampilkan pop up menu untuk hapus history
              _showPopupMenu(details.globalPosition, value.historyList.data![index].chatgroupId!);
            },
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              dense: true,
              visualDensity: VisualDensity.compact,
              title: Text(
                value.historyList.data![index].chat!,
                style: const TextStyle(color: Color(0xFFE1CDB5)),
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                // Tutup drawer, kemudian tampilkan data chat di homepage
                Navigator.pop(context);
                widget.onChatgroupSelected(value.historyList.data![index].chatgroupId!);
              },
            ),
          );
        },
      ),
    );
  }

  void _showPopupMenu(Offset position, int chatgroupId) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      color: const Color(0xFF393E46),
      constraints: const BoxConstraints(maxWidth: 100),
      position: RelativeRect.fromRect(
        Rect.fromLTWH(position.dx, position.dy, 0, 0),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem<String>(
          padding: const EdgeInsets.all(8),
          child: const Row(
            children: [
              Icon(Icons.delete_sharp, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
          onTap: () => _handleRemoveHistory(chatgroupId),
        ),
      ],
    );
  }

  Future<bool> _showAlertDialog({
    required String title,
    required String content,
    required String primaryText,
  }) async {
    Completer<bool> completer = Completer<bool>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF393E46),
          title: Text(title, style: const TextStyle(color: Color(0xFFE1CDB5))),
          content: Text(content, style: const TextStyle(color: Color(0xFFE1CDB5))),
          actions: [
            TextButton(
              child: const Text("Batal", style: TextStyle(color: Color(0xFFE1CDB5))),
              onPressed: () {
                Navigator.of(context).pop();
                completer.complete(false);
              },
            ),
            TextButton(
              child: Text(primaryText, style: const TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                completer.complete(true);
              },
            ),
          ],
        );
      },
    );

    return completer.future;
  }

  Widget _buildSettingsItem({
    required String title,
    required VoidCallback onTapEvent,
    Color? color = const Color(0xFFE1CDB5),
    FontWeight? weight = FontWeight.normal,
    IconData? icon,
  }) {
    return ListTile(
      leading: icon != null ? Icon(icon, color: color) : null,
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: weight),
      ),
      onTap: onTapEvent,
    );
  }
}
