part of 'widgets.dart';

class CardFloorplan extends StatefulWidget {
  final Floorplan floorplan;
  final bool selectionView;
  final Color tertiaryColor;
  final Color secondaryColor;
  final bool isSelected;
  final Function(Floorplan) onDelete;
  final Function(Floorplan) onSelected;

  const CardFloorplan({super.key, required this.floorplan, required this.selectionView, required this.isSelected, required this.secondaryColor, required this.tertiaryColor, required this.onDelete, required this.onSelected});

  @override
  State<CardFloorplan> createState() => _CardFloorplanState();
}

class _CardFloorplanState extends State<CardFloorplan> {
  final String _url = 'https://foyr.com/learn/wp-content/uploads/2021/12/best-floor-plan-apps-1.jpg';
  // final String _url = 'https://medialibrarycfo.entrata.com/4104/MLv3/4/22/2023/04/07/092045/643034cd565304.45217433746.png';
  // final Image _image = Image.memory(base64Decode(encodedImage), fit: BoxFit.fill);

  late bool _isSelected;
  late double _maskOpacity;

  void _setSelectedStatus() {
    if (!widget.selectionView) {
      _isSelected = false;
      _maskOpacity = 0;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _isSelected = widget.isSelected);
      });

      if (_isSelected) {
        _maskOpacity = 0.55;
      } else {
        _maskOpacity = 0;
      }
    }
  }

  void _handleSelection() {
    widget.onSelected(widget.floorplan);
    setState(() => _isSelected = !_isSelected);
  }

  @override
  Widget build(BuildContext context) {
    _setSelectedStatus();
    return GestureDetector(
      onTap: widget.selectionView ? _handleSelection : _showImageDialog,
      onLongPress: _handleSelection,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        margin: const EdgeInsets.all(0),
        elevation: 2,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(_url, fit: BoxFit.fill, colorBlendMode: BlendMode.srcATop, color: Colors.black.withOpacity(_maskOpacity)),
            widget.selectionView ? _buildSelection() : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildSelection() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: (!_isSelected)
            ? Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.tertiaryColor.withOpacity(0.3),
                  border: Border.all(width: 2.5, color: widget.tertiaryColor),
                ))
            : const Icon(
                Icons.check_circle_sharp,
                color: Colors.blue,
              ),
      ),
    );
  }

  void _showImageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 16),
            backgroundColor: Colors.transparent,
            child: SingleChildScrollView(
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
                      '${widget.floorplan.prompt}',
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
                        onPressed: () => widget.onDelete(widget.floorplan),
                      ),
                      const SizedBox(width: 16),
                      _buildActionButton(
                        icon: Icons.download_sharp,
                        onPressed: () => Util.saveImage(context, _url),
                      ),
                      const SizedBox(width: 16),
                      _buildActionButton(
                        icon: Icons.share_sharp,
                        onPressed: () => Util.shareImages(context, [_url]),
                      ),
                    ],
                  ),
                ],
              ),
            ));
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
}
