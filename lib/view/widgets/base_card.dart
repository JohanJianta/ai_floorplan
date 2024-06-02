part of 'widgets.dart';

abstract class CardBase extends StatefulWidget {
  final Floorplan floorplan;
  final bool selectionView;
  final Color tertiaryColor;
  final Color secondaryColor;
  final bool isSelected;
  final Function(Floorplan) onSelected;

  const CardBase({
    super.key,
    required this.floorplan,
    required this.selectionView,
    required this.isSelected,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.onSelected,
  });

  @override
  BaseCardState<CardBase> createState();
}

abstract class BaseCardState<T extends CardBase> extends State<T> {
  late bool _isSelected;
  late double _maskOpacity;

  // Method abstrak untuk tambah widget di thumbnail
  Widget addThumbnailProperty();

  // Method abstrak untuk buat daftar action button
  List<Widget> listActionButtons();

  void _setSelectedStatus() {
    if (!widget.selectionView) {
      _isSelected = false;
      _maskOpacity = 0;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _isSelected = widget.isSelected);
      });

      _maskOpacity = _isSelected ? 0.55 : 0;
    }
  }

  void _handleSelection() {
    widget.onSelected(widget.floorplan);
    setState(() => _isSelected = !_isSelected);
  }

  @override
  void initState() {
    super.initState();
    _setSelectedStatus();
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
            Image.memory(
              base64Decode(widget.floorplan.imageData!),
              fit: BoxFit.fill,
              gaplessPlayback: true,
              colorBlendMode: BlendMode.srcATop,
              color: Colors.black.withOpacity(_maskOpacity),
            ),
            widget.selectionView ? _buildSelection() : Container(),
            addThumbnailProperty(),
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
                  color: widget.tertiaryColor.withOpacity(0.4),
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
      barrierColor: const Color.fromARGB(221, 21, 21, 21),
      context: context,
      builder: (context) {
        return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 16),
            shadowColor: const Color.fromARGB(221, 21, 21, 21),
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
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
                  WidgetZoom(
                    heroAnimationTag: 'floorplanTag',
                    zoomWidget: Image.memory(base64Decode(widget.floorplan.imageData!)),
                  ),
                  Container(
                    height: 150,
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    padding: const EdgeInsets.all(12),
                    color: widget.tertiaryColor,
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Text(
                        '${widget.floorplan.prompt}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: widget.secondaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: listActionButtons(),
                  ),
                ],
              ),
            ));
      },
    );
  }

  Widget buildActionButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return Expanded(
      child: SizedBox(
        height: 55,
        child: Material(
          color: widget.tertiaryColor,
          child: InkWell(
            onTap: onPressed,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: widget.secondaryColor),
                Text(label, style: TextStyle(color: widget.secondaryColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
