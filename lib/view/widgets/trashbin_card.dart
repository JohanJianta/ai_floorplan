part of 'widgets.dart';

class TrashbinCard extends BaseCard {
  final Function(Floorplan) onRestore;
  final Function(Floorplan) onDelete;

  const TrashbinCard({
    super.key,
    required super.floorplan,
    required super.selectionView,
    required super.isSelected,
    required super.onSelected,
    required this.onRestore,
    required this.onDelete,
  });

  @override
  BaseCardState<TrashbinCard> createState() => _TrashbinCardState();
}

class _TrashbinCardState extends BaseCardState<TrashbinCard> {
  @override
  Widget addThumbnailProperty() {
    Color textColor = Theme.of(context).colorScheme.background;

    if (Theme.of(context).brightness == Brightness.dark) {
      textColor = Theme.of(context).colorScheme.primary;
    }
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
        ),
        padding: const EdgeInsets.all(4),
        child: Text(
          getDateTimeLeft(widget.floorplan.createTime),
          style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  List<Widget> listActionButtons() {
    return [
      super.buildActionButton(
        icon: Icons.restore_sharp,
        label: 'Pulihkan',
        onPressed: () {
          Navigator.of(context).pop();
          widget.onRestore(widget.floorplan);
        },
      ),
      const SizedBox(width: 16),
      super.buildActionButton(
        icon: Icons.delete_forever_sharp,
        label: 'Hapus Permanen',
        onPressed: () => widget.onDelete(widget.floorplan),
      ),
    ];
  }

  String getDateTimeLeft(DateTime? datetime) {
    if (datetime == null) {
      return '??? days';
    }

    DateTime now = DateTime.now();
    DateTime limit = datetime.add(const Duration(days: 30));
    Duration difference = limit.difference(now);

    if (difference.inDays > 0 && difference.inDays < 30) {
      return '${difference.inDays} hari';
    } else if (difference.inHours > 0 && difference.inHours < 24) {
      return '${difference.inHours} jam';
    } else if (difference.inMinutes > 0 && difference.inMinutes < 60) {
      return '${difference.inMinutes} menit';
    } else if (difference.inSeconds > 0 && difference.inSeconds < 60) {
      return '${difference.inSeconds} detik';
    } else {
      return '??? days';
    }
  }
}
