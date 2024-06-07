part of 'widgets.dart';

class HomePageCard extends BaseCard {
  final Function(Floorplan) onSave;

  static void _defaultOnSelected(Floorplan fp) {}

  const HomePageCard({
    super.key,
    required super.floorplan,
    required this.onSave,
    super.selectionView = false,
    super.isSelected = false,
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
        label: 'Bagikan',
        onPressed: () => Util.shareImages(context, [widget.floorplan.imageData!]),
      ),
      const SizedBox(width: 16),
      buildActionButton(
        icon: Icons.download_sharp,
        label: 'Unduh',
        onPressed: () => Util.saveImage(context, widget.floorplan.imageData!),
      ),
      (Const.userId != 0 && Const.auth.isNotEmpty) ? const SizedBox(width: 16) : const SizedBox.shrink(),
      (Const.userId != 0 && Const.auth.isNotEmpty)
          ? buildActionButton(
              icon: Icons.save_sharp,
              label: 'Simpan',
              onPressed: () => widget.onSave(widget.floorplan),
            )
          : const SizedBox.shrink(),
    ];
  }
}
