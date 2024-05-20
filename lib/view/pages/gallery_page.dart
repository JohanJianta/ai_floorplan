part of 'pages.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key, required this.title});

  final String title;

  final Color primaryColor = const Color(0xFF222831);
  final Color secondaryColor = const Color(0xFFE1CDB5);
  final Color tertiaryColor = const Color(0xFF31363F);

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final GalleryViewModel galleryViewModel = GalleryViewModel();
  final Set<Floorplan> _selectedList = {}; // pakai Set biar tidak ada data kembar
  bool _selectionView = false; // penanda mode selection sedang aktif atau tidak

  @override
  void initState() {
    galleryViewModel.fetchCategorizedFloorplans();
    super.initState();
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(Util.getSnackBar(message));
  }

  void _handleDeleteCard(Floorplan floorplan) async {
    _deleteAllCardFloorplans({floorplan});
  }

  void _deleteAllCardFloorplans(Set<Floorplan> floorplans) async {
    bool isConfirmed = await _showAlertDialog();
    if (isConfirmed) {
      final message = await galleryViewModel.deleteFloorplans(floorplans);
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
      case 'Select All':
        if (galleryViewModel.categoryList.data != null) {
          setState(() {
            galleryViewModel.categoryList.data?.forEach((category) {
              _selectedList.addAll(category.floorplans);
            });
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
            _selectionView ? '${_selectedList.length}  Dipilih' : widget.title,
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
                return {'Edit', 'Select All'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice, style: TextStyle(color: widget.secondaryColor)),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: ChangeNotifierProvider<GalleryViewModel>(
          create: (BuildContext context) => galleryViewModel,
          child: Consumer<GalleryViewModel>(builder: (context, value, _) {
            switch (value.categoryList.status) {
              case Status.loading:
                return _buildLoading();
              case Status.error:
                WidgetsBinding.instance.addPostFrameCallback((_) => _showSnackbar(value.categoryList.message.toString()));
                return _buildError();
              case Status.completed:
                return _buildGallery();
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

  Widget _buildGallery() {
    if (galleryViewModel.categoryList.data != null && galleryViewModel.categoryList.data!.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ListView.builder(
          itemCount: galleryViewModel.categoryList.data?.length,
          itemBuilder: (context, index) {
            final category = galleryViewModel.categoryList.data![index];
            return _buildCategory(category.label, category.floorplans);
          },
        ),
      );
    } else {
      return Center(
        child: Text('Gallery anda kosong', style: TextStyle(color: widget.secondaryColor)),
      );
    }
  }

  Widget _buildCategory(String label, List<Floorplan> floorplans) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            label,
            style: TextStyle(color: widget.secondaryColor, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: floorplans.length,
          itemBuilder: (context, index) {
            return GalleryCard(
              floorplan: floorplans.elementAt(index),
              selectionView: _selectionView,
              isSelected: _selectedList.contains(floorplans.elementAt(index)),
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
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildBottomNavbar() {
    return BottomNavigationBar(
      backgroundColor: widget.tertiaryColor,
      selectedItemColor: widget.secondaryColor,
      unselectedItemColor: widget.secondaryColor,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.share_sharp), label: 'Share'),
        BottomNavigationBarItem(icon: Icon(Icons.delete_sharp), label: 'Delete'),
      ],
      onTap: (value) {
        switch (value) {
          case 0:
            List<String> imageUrlList = List.generate(_selectedList.length, (index) => 'https://foyr.com/learn/wp-content/uploads/2021/12/best-floor-plan-apps-1.jpg');
            Util.shareImages(context, imageUrlList);
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
          title: const Text("Konfirmasi Penghapusan"),
          content: const Text("Apakah anda yakin ingin memindahkan floorplan ke trash bin?"),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
                completer.complete(false);
              },
            ),
            TextButton(
              child: const Text("Lanjut"),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.settings.name == '/gallery');
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
