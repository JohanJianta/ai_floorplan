part of 'widgets.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key, required this.onChatgroupSelected}) : super(key: key);

  final Function(int) onChatgroupSelected;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late HistoryViewModel historyViewModel;

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
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildDrawerItem(
                title: 'Gallery',
                onTapEvent: () => Navigator.of(context).pushNamed('/gallery'),
              ),
              _buildDrawerItem(
                title: 'Trash Bin',
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
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTapEvent,
    );
  }

  Widget _buildExpansionPanel() {
    return ExpansionPanelList.radio(
      elevation: 0,
      expandIconColor: Colors.white,
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
            'History',
            style: TextStyle(
              color: Colors.white,
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
          child: Center(child: CircularProgressIndicator()),
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
            'Setting',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
      body: Column(
        children: [
          _buildSettingsItem(
            title: 'Change Email',
            onTapEvent: () => Navigator.pop(context),
          ),
          _buildSettingsItem(
            title: 'Change Password',
            onTapEvent: () => Navigator.pop(context),
          ),
          _buildSettingsItem(
            title: 'Log Out',
            onTapEvent: () => Navigator.pop(context),
          ),
        ],
      ),
      canTapOnHeader: true,
    );
  }

  Widget _buildHistoryList(HistoryViewModel value) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 500),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const ScrollPhysics(),
        itemCount: value.historyList.data!.length,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            dense: true,
            visualDensity: VisualDensity.compact,
            title: Text(
              value.historyList.data![index].chat!,
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Navigator.pop(context);
              widget.onChatgroupSelected(value.historyList.data![index].chatgroupId!);
            },
          );
        },
      ),
    );
  }

  Widget _buildSettingsItem({required String title, required VoidCallback onTapEvent}) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: onTapEvent,
    );
  }
}
