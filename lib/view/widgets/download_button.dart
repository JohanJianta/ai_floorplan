part of 'widgets.dart';

class DownloadButton extends StatelessWidget {
  const DownloadButton({super.key, required this.secondaryColor});

  final Color secondaryColor;

  final String url =
      'https://foyr.com/learn/wp-content/uploads/2021/12/best-floor-plan-apps-1.jpg';

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        // TODO: implement onPressed download floorplan
      },
      icon: Icon(Icons.download_sharp, color: secondaryColor),
    );
  }
}
