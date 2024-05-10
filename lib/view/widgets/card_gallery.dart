part of 'widgets.dart';

class CardGallery extends CardBase {
  final Function(Floorplan) onDelete;

  const CardGallery({
    super.key,
    required super.floorplan,
    required super.selectionView,
    required super.isSelected,
    required super.secondaryColor,
    required super.tertiaryColor,
    required super.onSelected,
    required this.onDelete,
  });

  @override
  BaseCardState<CardGallery> createState() => _CardGalleryState();
}

class _CardGalleryState extends BaseCardState<CardGallery> {
  @override
  Widget addThumbnailProperty() {
    return const SizedBox.shrink();
  }

  @override
  List<Widget> listActionButtons() {
    return [
      buildActionButton(
        icon: Icons.share_sharp,
        onPressed: () => Util.shareImages(context, [_url]),
      ),
      const SizedBox(width: 16),
      buildActionButton(
        icon: Icons.download_sharp,
        onPressed: () => Util.saveImage(context, _url),
      ),
      const SizedBox(width: 16),
      buildActionButton(
        icon: Icons.delete_sharp,
        onPressed: () => widget.onDelete(widget.floorplan),
      ),
    ];
  }
}
