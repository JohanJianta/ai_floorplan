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
  GalleryViewModel galleryViewModel = GalleryViewModel();

  @override
  void initState() {
    galleryViewModel.fetchCategorizedFloorplans();
    super.initState();
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(Util.getSnackBar(message));
  }

  void _deleteCardFloorplan(int floorplanId) async {
    final message = await galleryViewModel.deleteFloorplan(floorplanId);
    _showSnackbar(message);
  }

  void _handleBackButton() {
    // TODO: implement onPressed back button
  }

  void handleClick(String value) {
    switch (value) {
      case 'Edit':
        // TODO: implement onPressed edit
        break;
      case 'Select All':
        // TODO: implement onPressed select all
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: widget.primaryColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(widget.title, style: TextStyle(color: widget.secondaryColor, fontWeight: FontWeight.w600)),
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
        ));
  }

  Widget _buildLoading() {
    return Align(
      alignment: Alignment.center,
      child: CircularProgressIndicator(color: widget.secondaryColor),
    );
  }

  Widget _buildError() {
    return Align(
      alignment: Alignment.center,
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
      return Align(
        alignment: Alignment.center,
        child: Text('Gallery anda kosong', style: TextStyle(color: widget.secondaryColor)),
      );
    }
  }

  Widget _buildCategory(String label, List<Floorplan> floorplans) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            label,
            style: TextStyle(color: widget.secondaryColor, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          itemCount: floorplans.length,
          itemBuilder: (context, index) {
            return CardFloorplan(
              floorplan: floorplans.elementAt(index),
              onDelete: _deleteCardFloorplan,
              secondaryColor: widget.secondaryColor,
              tertiaryColor: widget.tertiaryColor,
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
