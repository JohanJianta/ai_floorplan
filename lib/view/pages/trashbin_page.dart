part of 'pages.dart';

class TrashbinPage extends StatefulWidget {
  const TrashbinPage({super.key});

  final Color primaryColor = const Color(0xFF222831);
  final Color secondaryColor = const Color(0xFFE1CDB5);
  final Color tertiaryColor = const Color(0xFF31363F);

  @override
  State<TrashbinPage> createState() => _TrashbinPageState();
}

class _TrashbinPageState extends State<TrashbinPage> {
  final TrashbinViewModel trashbinViewModel = TrashbinViewModel();
  final Set<Floorplan> _selectedList = {}; // pakai Set biar tidak ada data kembar
  bool _selectionView = false; // penanda mode selection sedang aktif atau tidak

  @override
  void initState() {
    trashbinViewModel.fetchCategorizedFloorplans();
    super.initState();
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(Util.getSnackBar(message));
  }

  void _handleRestoreCard(Floorplan floorplan) async {
    _restoreAllCardFloorplans({floorplan});
  }

  void _restoreAllCardFloorplans(Set<Floorplan> floorplans) async {
    final message = await trashbinViewModel.restoreFloorplans(floorplans);
    _showSnackbar(message);

    setState(() {
      _selectedList.clear();
      _selectionView = false;
    });
  }

  void _handleDeleteCard(Floorplan floorplan) async {
    _deleteAllCardFloorplans({floorplan});
  }

  void _deleteAllCardFloorplans(Set<Floorplan> floorplans) async {
    bool isConfirmed = await _showAlertDialog();
    if (isConfirmed) {
      final message = await trashbinViewModel.deleteFloorplans(floorplans);
      _showSnackbar(message);

      setState(() {
        _selectedList.clear();
        _selectionView = false;
      });
    }
  }

  void _handleSelectCard(Floorplan? floorplan) {
    if (floorplan != null) {
      if (_selectedList.contains(floorplan)) {
        _selectedList.remove(floorplan);
      } else {
        _selectedList.add(floorplan);
      }
    }
    setState(() => _selectionView = true);
  }

  void _handleBackButton() {
    if (_selectionView) {
      setState(() => _selectionView = false);
      _selectedList.clear();
    } else {
      Navigator.of(context).pop();
    }
  }

  void handleClick(String value) {
    switch (value) {
      case 'Edit':
        _handleSelectCard(null);
        break;
      case 'Pilih Semua':
        if (trashbinViewModel.floorplanList.data != null) {
          setState(() {
            _selectedList.addAll(trashbinViewModel.floorplanList.data!);
            _selectionView = true;
          });
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _handleBackButton();
        return false;
      },
      child: Scaffold(
        backgroundColor: widget.primaryColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            _selectionView ? '${_selectedList.length}  Dipilih' : 'Sampah',
            style: TextStyle(color: widget.secondaryColor, fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            onPressed: _handleBackButton,
            icon: Icon(Icons.arrow_back_sharp, color: widget.secondaryColor),
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: handleClick,
              color: widget.tertiaryColor,
              icon: Icon(Icons.more_vert_sharp, color: widget.secondaryColor),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: widget.secondaryColor, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              itemBuilder: (BuildContext context) {
                return {'Edit', 'Pilih Semua'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice, style: TextStyle(color: widget.secondaryColor)),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: ChangeNotifierProvider<TrashbinViewModel>(
          create: (BuildContext context) => trashbinViewModel,
          child: Consumer<TrashbinViewModel>(builder: (context, value, _) {
            switch (value.floorplanList.status) {
              case Status.loading:
                return _buildLoading();
              case Status.error:
                WidgetsBinding.instance.addPostFrameCallback((_) => _showSnackbar(value.floorplanList.message.toString()));
                return _buildError();
              case Status.completed:
                return _buildTrashbin();
              default:
            }
            return Container();
          }),
        ),
        bottomNavigationBar: _selectionView ? _buildBottomNavbar() : null,
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(color: widget.secondaryColor),
    );
  }

  Widget _buildError() {
    return Center(
      child: ElevatedButton(
        onPressed: _handleBackButton,
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(widget.tertiaryColor)),
        child: Text('Kembali ke Homepage', style: TextStyle(color: widget.secondaryColor)),
      ),
    );
  }

  Widget _buildTrashbin() {
    if (trashbinViewModel.floorplanList.data != null && trashbinViewModel.floorplanList.data!.isNotEmpty) {
      return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
                child: Text(
                  'Floorplan yang anda hapus akan tersimpan di Sampah selama 30 hari sebelum terhapus secara permanen',
                  style: TextStyle(color: widget.secondaryColor, fontWeight: FontWeight.w500, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: trashbinViewModel.floorplanList.data?.length,
                itemBuilder: (context, index) {
                  return TrashbinCard(
                    floorplan: trashbinViewModel.floorplanList.data!.elementAt(index),
                    selectionView: _selectionView,
                    isSelected: _selectedList.contains(trashbinViewModel.floorplanList.data!.elementAt(index)),
                    onRestore: _handleRestoreCard,
                    onDelete: _handleDeleteCard,
                    onSelected: _handleSelectCard,
                    secondaryColor: widget.secondaryColor,
                    tertiaryColor: widget.tertiaryColor,
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
              ),
            ],
          ));
    } else {
      return Center(
        child: Text('Sampah anda kosong', style: TextStyle(color: widget.secondaryColor)),
      );
    }
  }

  Widget _buildBottomNavbar() {
    return BottomNavigationBar(
      backgroundColor: widget.tertiaryColor,
      selectedItemColor: widget.secondaryColor,
      unselectedItemColor: widget.secondaryColor,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.restore_sharp), label: 'Pulihkan'),
        BottomNavigationBarItem(icon: Icon(Icons.delete_forever_sharp), label: 'Hapus'),
      ],
      onTap: (value) {
        switch (value) {
          case 0:
            _restoreAllCardFloorplans(_selectedList);
            break;
          case 1:
            _deleteAllCardFloorplans(_selectedList);
            break;
        }
      },
    );
  }

  Future<bool> _showAlertDialog() async {
    Completer<bool> completer = Completer<bool>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF393E46),
          title: const Text("Konfirmasi Penghapusan", style: TextStyle(color: Color(0xFFE1CDB5))),
          content: const Text(
            "Apakah anda yakin ingin menghapus floorplan ini secara permanen?",
            style: TextStyle(color: Color(0xFFE1CDB5)),
          ),
          actions: [
            TextButton(
              child: const Text("Batal", style: TextStyle(color: Color(0xFFE1CDB5))),
              onPressed: () {
                Navigator.of(context).pop();
                completer.complete(false);
              },
            ),
            TextButton(
              child: const Text("Hapus", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.settings.name == '/trashbin');
                completer.complete(true);
              },
            ),
          ],
        );
      },
    );

    return completer.future;
  }
}
