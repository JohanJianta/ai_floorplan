part of 'pages.dart';

class ChangePasswordPage extends StatelessWidget {
  ChangePasswordPage({super.key});

  final UserRepository _userRepo = UserRepository();

  final TextEditingController oldPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();

  void handleChangePass(BuildContext context) async {
    try {
      final String oldPass = oldPassController.text;
      final String newPass = newPassController.text;

      String message = await _userRepo.updateUserData(newPassword: newPass, oldPassword: oldPass);
      ScaffoldMessenger.of(context).showSnackBar(Util.getSnackBar(context, message));

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(Util.getSnackBar(context, e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          'Perbarui Kata Sandi',
          style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_sharp, color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomTextForm(
              labelText: 'Kata Sandi Lama',
              iconData: Icons.lock_clock_sharp,
              obscureText: true,
              controller: oldPassController,
            ),
            const SizedBox(height: 16),
            CustomTextForm(
              labelText: 'Kata Sandi Baru',
              iconData: Icons.lock_sharp,
              obscureText: true,
              controller: newPassController,
            ),
            const SizedBox(height: 32),
            CustomElevatedButton(
              buttonText: 'Perbarui',
              onPressed: () => handleChangePass(context),
            ),
          ],
        ),
      ),
    );
  }
}
