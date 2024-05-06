part of 'widgets.dart';

class CardFloorplan extends StatefulWidget {
  final Floorplan floorplan;
  final Function(int) onDelete;
  final Color tertiaryColor;
  final Color secondaryColor;

  const CardFloorplan({super.key, required this.floorplan, required this.onDelete, required this.secondaryColor, required this.tertiaryColor});

  @override
  State<CardFloorplan> createState() => _CardFloorplanState();
}

class _CardFloorplanState extends State<CardFloorplan> {
  final String _url = 'https://foyr.com/learn/wp-content/uploads/2021/12/best-floor-plan-apps-1.jpg';
  // final Image _image = Image.memory(base64Decode(encodedImage), fit: BoxFit.fill);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showImageDialog,
      onLongPress: () {
        // TODO: implement onPressed select floorplan
      },
      child: Card(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        margin: const EdgeInsets.all(0),
        elevation: 2,
        child: Image.network(_url),
      ),
    );
  }

  void _showImageDialog() {
    Floorplan data = widget.floorplan;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          backgroundColor: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: ClipOval(
                  child: Container(
                    color: widget.tertiaryColor,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_sharp),
                      color: widget.secondaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Image.network(_url),
              Container(
                height: 120,
                margin: const EdgeInsets.symmetric(vertical: 24),
                color: widget.tertiaryColor,
                alignment: Alignment.center,
                child: Text(
                  '${data.prompt}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.secondaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.delete_sharp,
                    onPressed: () => _showAlertDialog(context, data.floorplanId!),
                  ),
                  const SizedBox(width: 16),
                  _buildActionButton(
                    icon: Icons.download_sharp,
                    onPressed: () => Util.downloadImage(context, _url),
                  ),
                  const SizedBox(width: 16),
                  _buildActionButton(
                    icon: Icons.share_sharp,
                    onPressed: () => Util.shareImage(context, _url),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton({required IconData icon, required VoidCallback onPressed}) {
    return Expanded(
      child: Container(
        height: 50,
        color: widget.tertiaryColor,
        child: IconButton(onPressed: onPressed, icon: Icon(icon, color: widget.secondaryColor)),
      ),
    );
  }

  void _showAlertDialog(BuildContext context, int floorplanId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Penghapusan"),
          content: const Text("Apakah anda yakin ingin memindahkan floorplan in ke trash bin?"),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Lanjut"),
              onPressed: () {
                widget.onDelete(floorplanId);
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }
}
