part of 'widgets.dart';

class GalleryCard extends CardBase {
  final Function(Floorplan) onDelete;

  const GalleryCard({
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
  BaseCardState<GalleryCard> createState() => _CardGalleryState();
}

class _CardGalleryState extends BaseCardState<GalleryCard> {
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
