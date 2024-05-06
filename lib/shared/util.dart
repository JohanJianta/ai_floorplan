part of 'shared.dart';

class Util {
  static SnackBar getSnackBar(String message) {
    return SnackBar(content: Text(message, style: const TextStyle(color: Color(0xFFE1CDB5))));
  }

  static Future<void> downloadImage(BuildContext context, String url) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    late String message;

    try {
      // Download image
      final http.Response response = await http.get(Uri.parse(url));

      final dir = await getTemporaryDirectory();

      // Create an image name
      var filename = '${dir.path}/Floorplan-${DateTime.timestamp()}.png';

      // Save to filesystem
      final file = File(filename);
      await file.writeAsBytes(response.bodyBytes);

      // Ask the user to save it
      final params = SaveFileDialogParams(sourceFilePath: filename);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      if (finalPath != null) {
        message = 'Floorplan berhasil disimpan';
      } else {
        message = '';
      }
    } catch (e) {
      message = 'Terjadi kesalahan ketika menyimpan floorplan: ${e.toString()}';
    }

    if (message.isNotEmpty) {
      scaffoldMessenger.showSnackBar(Util.getSnackBar(message));
    }
  }

  static Future<void> shareImage(BuildContext context, String url) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    late String message;

    try {
      // Download image
      final http.Response response = await http.get(Uri.parse(url));

      final dir = await getTemporaryDirectory();

      // Create an image name
      var filename = '${dir.path}/Floorplan-${DateTime.timestamp()}.png';

      // Save to filesystem
      final file = File(filename);
      await file.writeAsBytes(response.bodyBytes);

      // Share image
      final result = await Share.shareXFiles([XFile(filename)], subject: 'AIFloorplan Share', text: 'Lihatlah floorplan yang saya dapatkan');

      if (result.status == ShareResultStatus.success) {
        message = 'Floorplan berhasil dibagikan';
      } else {
        message = '';
      }
    } catch (e) {
      message = 'Terjadi kesalahan ketika menyimpan floorplan: ${e.toString()}';
    }

    if (message.isNotEmpty) {
      scaffoldMessenger.showSnackBar(Util.getSnackBar(message));
    }
  }
}
