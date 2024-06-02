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
  BaseCardState<GalleryCard> createState() => _GalleryCardState();
}

class _GalleryCardState extends BaseCardState<GalleryCard> {
  @override
  Widget addThumbnailProperty() {
    return const SizedBox.shrink();
  }

  @override
  List<Widget> listActionButtons() {
    return [
      buildActionButton(
        icon: Icons.share_sharp,
        label: 'Bagikan',
        onPressed: () => Util.shareImages(context, [widget.floorplan.imageData!]),
      ),
      const SizedBox(width: 16),
      buildActionButton(
        icon: Icons.download_sharp,
        label: 'Unduh',
        onPressed: () => Util.saveImage(context, widget.floorplan.imageData!),
      ),
      const SizedBox(width: 16),
      buildActionButton(
        icon: Icons.delete_sharp,
        label: 'Hapus',
        onPressed: () => widget.onDelete(widget.floorplan),
      ),
    ];
  }
}
