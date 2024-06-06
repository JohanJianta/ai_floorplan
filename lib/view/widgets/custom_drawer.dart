part of 'widgets.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key, required this.currentChatgroupId, required this.onChatgroupSelected, required this.onChatgroupDeleted});

  final int currentChatgroupId;
  final Function(int) onChatgroupSelected;
  final Function(int) onChatgroupDeleted;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late HistoryViewModel historyViewModel;
  final historyController = ExpansionTileController();
  final settingController = ExpansionTileController();

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(Util.getSnackBar(context, message));
  }

  void _handleExpansionChanged(int index, bool isExpanded) {
    if (!isExpanded) return;

    if (index == 0) {
      settingController.collapse();
    }

    if (index == 1) {
      historyController.collapse();
    }
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
        color: Theme.of(context).colorScheme.background,
        padding: const EdgeInsets.only(top: 48, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildHistoryTile(),
              _buildDrawerItem(
                title: 'Galeri',
                onTapEvent: () => Navigator.of(context).pushNamed('/gallery'),
              ),
              _buildDrawerItem(
                title: 'Sampah',
                onTapEvent: () => Navigator.of(context).pushNamed('/trashbin'),
              ),
              _buildSettingTile(),
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
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTapEvent,
    );
  }

  Widget _buildHistoryTile() {
    return ExpansionTile(
      title: Text(
        'Riwayat',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      initiallyExpanded: true,
      controller: historyController,
      collapsedIconColor: Theme.of(context).colorScheme.primary,
      onExpansionChanged: (value) => _handleExpansionChanged(0, value),
      children: [
        ChangeNotifierProvider<HistoryViewModel>.value(
          value: historyViewModel,
          child: Consumer<HistoryViewModel>(
            builder: (context, value, _) {
              switch (value.response.status) {
                case Status.loading:
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
                    ),
                  );
                case Status.error:
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      value.response.message.toString(),
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                case Status.completed:
                  return _buildHistoryList(value);
                default:
                  return Container();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryList(HistoryViewModel value) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 480),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const ScrollPhysics(),
        itemCount: value.response.data?.length,
        itemBuilder: (context, index) {
          return _buildCategory(value.response.data![index]);
        },
      ),
    );
  }

  Widget _buildCategory(CategorizedHistory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(
            category.label,
            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: category.histories.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onLongPressStart: (details) {
                // Tampilkan pop up menu untuk hapus history
                _showPopupMenu(details.globalPosition, category.histories[index].chatgroupId!);
              },
              child: Container(
                color: category.histories[index].chatgroupId == widget.currentChatgroupId ? Theme.of(context).primaryColor : null,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  title: Text(
                    category.histories[index].chat!,
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    // Tutup drawer, kemudian tampilkan data chat di homepage
                    Navigator.pop(context);
                    widget.onChatgroupSelected(category.histories[index].chatgroupId!);
                  },
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSettingTile() {
    return ExpansionTile(
      title: Text(
        'Pengaturan',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      controller: settingController,
      collapsedIconColor: Theme.of(context).colorScheme.primary,
      onExpansionChanged: (value) => _handleExpansionChanged(1, value),
      children: [
        _buildSettingsItem(
          title: 'Pilih Tema',
          icon: Icons.brightness_6_sharp,
          onTapEvent: () => _showThemeDialog(),
        ),
        _buildSettingsItem(
          title: 'Ubah Password',
          icon: Icons.lock_reset_sharp,
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
    );
  }

  Widget _buildSettingsItem({
    required String title,
    required VoidCallback onTapEvent,
    required IconData icon,
    FontWeight? weight = FontWeight.w500,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Theme.of(context).colorScheme.primary.withOpacity(0.75)),
      title: Text(
        title,
        style: TextStyle(color: color ?? Theme.of(context).colorScheme.primary, fontWeight: weight),
      ),
      onTap: onTapEvent,
    );
  }

  void _showPopupMenu(Offset position, int chatgroupId) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      color: Theme.of(context).primaryColor,
      surfaceTintColor: Colors.transparent,
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
          surfaceTintColor: Colors.transparent,
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(title, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          content: Text(content, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          actions: [
            TextButton(
              child: const Text("Batal"),
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

  void _showThemeDialog() {
    ThemeMode selectedTheme = Const.themeMode;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Theme.of(context).colorScheme.background,
            title: Text('Pilih Tema', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            content: SizedBox(
              width: 280,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: ThemeMode.values.map((theme) {
                  return RadioListTile<ThemeMode>(
                    contentPadding: const EdgeInsets.all(0),
                    value: theme,
                    groupValue: selectedTheme,
                    onChanged: (ThemeMode? value) {
                      if (value != null) {
                        setState(() => selectedTheme = value);
                      }
                    },
                    title: Text(
                      _getThemeModeName(theme),
                      style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                    ),
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await Const.changeTheme(selectedTheme);
                },
              ),
            ],
          );
        });
      },
    );
  }

  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'Sistem (Default)';
      case ThemeMode.light:
        return 'Terang';
      case ThemeMode.dark:
        return 'Gelap';
      default:
        return '';
    }
  }
}
