part of 'pages.dart';

class RegisterPage extends StatelessWidget {
  final UserRepository _userRepo = UserRepository();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RegisterPage({super.key});

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(Util.getSnackBar(context, message));
  }

  void handleRegister(BuildContext context) async {
    try {
      final String email = emailController.text;
      final String password = passwordController.text;

      await _userRepo.register(email, password);

      // String message = await _userRepo.register(email, password);
      // _showSnackbar(context, message);

      Navigator.of(context).pushNamedAndRemoveUntil('/home', ((route) => false));
    } catch (e) {
      _showSnackbar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  SvgPicture.asset(
                    'lib/assets/logo.svg',
                    width: 80,
                    height: 80,
                    colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                  ),
                  const SizedBox(height: 20),

                  // Text "Register Page"
                  Text(
                    'Register Page',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Email Input Field
                  CustomTextForm(
                    labelText: 'Email',
                    iconData: Icons.email_sharp,
                    controller: emailController,
                  ),
                  const SizedBox(height: 16),

                  // Password Input Field
                  CustomTextForm(
                    labelText: 'Kata Sandi',
                    iconData: Icons.lock_sharp,
                    obscureText: true,
                    controller: passwordController,
                  ),
                  const SizedBox(height: 16),

                  // Register Button
                  CustomElevatedButton(
                    buttonText: 'Daftar',
                    onPressed: () => handleRegister(context),
                  ),
                  const SizedBox(height: 16),

                  // Divider and "Continue as a guest" Button
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                          height: 1.5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'or',
                          style: TextStyle(color: Theme.of(context).colorScheme.secondary.withOpacity(0.5)),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sudah memiliki akun?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          // Pindah ke halaman login jika sudah punya akun
                          Navigator.of(context).pushNamed('/login');
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Continue as a guest Button
                  TextButton(
                    onPressed: () {
                      // TODO: Tambahkan logika untuk "Continue as a guest" di sini
                      ScaffoldMessenger.of(context).showSnackBar(Util.getSnackBar(context, 'Mode ini belum tersedia'));
                      // Const.signIn(0, '');
                      // Navigator.of(context).pushNamedAndRemoveUntil('/home', ModalRoute.withName('/'));
                    },
                    child: Text(
                      'Masuk sebagai Tamu',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
