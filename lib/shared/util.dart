part of 'shared.dart';

class Util {
  static SnackBar getSnackBar(BuildContext context, String message) {
    return SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text(message, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
    );
  }

  static Future<bool> showAlertDialog({
    required BuildContext context,
    required String title,
    required String content,
    String primaryText = 'Hapus',
  }) async {
    Completer<bool> completer = Completer<bool>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(title, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          content: Text(content, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
                completer.complete(false);
              },
            ),
            TextButton(
              child: Text(primaryText, style: const TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                completer.complete(true);
              },
            ),
          ],
        );
      },
    );

    return completer.future;
  }

  static Future<void> saveImage(BuildContext context, String base64String) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    late String message;

    try {
      // Download image
      final XFile file = await _downloadImage(base64String);

      // Ask the user to save it
      final params = SaveFileDialogParams(sourceFilePath: file.path);
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
      scaffoldMessenger.showSnackBar(Util.getSnackBar(context, message));
    }
  }

  static Future<void> shareImages(BuildContext context, List<String> base64StringList) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    late String message;

    try {
      List<Future<XFile>> downloadFutures = [];

      // Parallel Download images
      for (var base64String in base64StringList) {
        downloadFutures.add(_downloadImage(base64String));
      }
      List<XFile> files = await Future.wait(downloadFutures);

      // Share images
      final result = await Share.shareXFiles(
        files,
        subject: 'AIFloorplan Share',
        text: 'Lihatlah floorplan yang saya dapatkan',
      );

      if (result.status == ShareResultStatus.success) {
        message = 'Floorplan berhasil dibagikan';
      } else {
        message = '';
      }
    } catch (e) {
      message = 'Terjadi kesalahan ketika menyimpan floorplan: ${e.toString()}';
    }

    if (message.isNotEmpty) {
      scaffoldMessenger.showSnackBar(Util.getSnackBar(context, message));
    }
  }

  static Future<XFile> _downloadImage(String base64String) async {
    // Get image
    // final http.Response response = await http.get(Uri.parse(url));

    // Decode the base64 string into bytes
    List<int> bytes = base64Decode(base64String);

    final dir = await getTemporaryDirectory();

    // Create an unique image name
    var filename = '${dir.path}/${const Uuid().v4()}.png';

    // Save to filesystem
    final file = File(filename);
    await file.writeAsBytes(bytes);

    return XFile(filename);
  }
}
