part of 'widgets.dart';

class HomePageCard extends CardBase {
  final Function(Floorplan) onSave;

  static void _defaultOnSelected(Floorplan fp) {}

  const HomePageCard({
    super.key,
    required super.floorplan,
    required this.onSave,
    super.selectionView = false,
    super.isSelected = false,
    super.secondaryColor = const Color(0xFFE1CDB5),
    super.tertiaryColor = const Color(0xFF31363F),
    super.onSelected = _defaultOnSelected,
  });

  @override
  BaseCardState<HomePageCard> createState() => _HomePageCardState();
}

class _HomePageCardState extends BaseCardState<HomePageCard> {
  @override
  Widget addThumbnailProperty() {
    return const SizedBox.shrink();
  }

  @override
  List<Widget> listActionButtons() {
    return [
      buildActionButton(
        icon: Icons.share_sharp,
        onPressed: () => Util.shareImages(context, [widget.floorplan.imageData!]),
      ),
      const SizedBox(width: 16),
      buildActionButton(
        icon: Icons.download_sharp,
        onPressed: () => Util.saveImage(context, widget.floorplan.imageData!),
      ),
      const SizedBox(width: 16),
      buildActionButton(
        icon: Icons.bookmark_sharp,
        onPressed: () {
          // TODO: Save floorplan to gallery
        },
      ),
    ];
  }
}
