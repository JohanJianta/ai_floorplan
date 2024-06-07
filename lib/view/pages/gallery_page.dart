part of 'pages.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

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
    ScaffoldMessenger.of(context).showSnackBar(Util.getSnackBar(context, message));
  }

  void _handleDeleteCard(Floorplan floorplan) async {
    _deleteAllCardFloorplans({floorplan});
  }

  void _deleteAllCardFloorplans(Set<Floorplan> floorplans) async {
    bool isConfirmed = await Util.showAlertDialog(
      context: context,
      title: 'Konfirmasi Penghapusan',
      content: 'Apakah anda yakin ingin memindahkan floorplan ke Sampah?',
    );
    if (isConfirmed) {
      Navigator.of(context).popUntil((route) => route.settings.name == '/gallery');

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
      case 'Pilih Semua':
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
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(
            _selectionView ? '${_selectedList.length}  Dipilih' : 'Galeri',
            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            onPressed: _handleBackButton,
            icon: Icon(Icons.arrow_back_sharp, color: Theme.of(context).colorScheme.primary),
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: handleClick,
              color: Theme.of(context).primaryColor,
              surfaceTintColor: Colors.transparent,
              icon: Icon(Icons.more_vert_sharp, color: Theme.of(context).colorScheme.primary),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              itemBuilder: (BuildContext context) {
                return {'Edit', 'Pilih Semua'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
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
      child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
    );
  }

  Widget _buildError() {
    return Center(
      child: ElevatedButton(
        onPressed: _handleBackButton,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
          surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: const Text('Kembali ke Homepage'),
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
        child: Text('Galeri anda kosong', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
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
            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
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
      backgroundColor: Theme.of(context).primaryColor,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(context).colorScheme.primary,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.share_sharp), label: 'Bagikan'),
        BottomNavigationBarItem(icon: Icon(Icons.delete_sharp), label: 'Hapus'),
      ],
      onTap: (value) {
        switch (value) {
          case 0:
            List<String> base64StringList = List.generate(_selectedList.length, (index) => _selectedList.elementAt(index).imageData!);
            Util.shareImages(context, base64StringList);
            break;
          case 1:
            _deleteAllCardFloorplans(_selectedList);
            break;
        }
      },
    );
  }
}
