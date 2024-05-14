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
    galleryViewModel.fetchFloorplanList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.title,
            style: TextStyle(
                color: widget.secondaryColor, fontWeight: FontWeight.w600)),
        leading: IconButton(
          onPressed: () {
            // TODO: implement onPressed back button
          },
          icon: Icon(Icons.arrow_back_sharp, color: widget.secondaryColor),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: implement onPressed more button
            },
            icon: Icon(Icons.more_vert_sharp, color: widget.secondaryColor),
          )
        ],
      ),
      body: ChangeNotifierProvider<GalleryViewModel>(
        create: (BuildContext context) => galleryViewModel,
        child: Consumer<GalleryViewModel>(builder: (context, value, _) {
          switch (value.floorplanList.status) {
            case Status.loading:
              return const Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            case Status.error:
              var snackBar = SnackBar(
                content: Text(value.floorplanList.message.toString(),
                    style: TextStyle(color: widget.secondaryColor)),
              );
              WidgetsBinding.instance.addPostFrameCallback(
                  (_) => ScaffoldMessenger.of(context).showSnackBar(snackBar));
              return Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: implement onPressed back button
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(widget.tertiaryColor)),
                  child: Text('Kembali ke Homepage',
                      style: TextStyle(color: widget.secondaryColor)),
                ),
              );
            case Status.completed:
              return Container(
                margin: const EdgeInsets.all(16),
                child: GridView.builder(
                  itemCount: value.floorplanList.data?.length,
                  itemBuilder: (context, index) {
                    return CardFloorplan(
                      floorplan: value.floorplanList.data!.elementAt(index),
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
              );
            default:
          }
          return Container();
        }),
      ),
    );
  }
}
