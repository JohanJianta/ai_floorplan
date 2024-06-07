part of 'pages.dart';

class LoginPage extends StatelessWidget {
  final UserRepository _userRepo = UserRepository();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(Util.getSnackBar(context, message));
  }

  void handleLogin(BuildContext context) async {
    try {
      final String email = emailController.text;
      final String password = passwordController.text;

      await _userRepo.login(email, password);

      // String message = await _userRepo.login(data);
      // _showSnackbar(context, message);

      Navigator.of(context).pushNamedAndRemoveUntil('/home', ((route) => false));
    } catch (e) {
      _showSnackbar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
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

                  // Text "Login Page"
                  Text(
                    'Login Page',
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

                  // Sign In Button
                  CustomElevatedButton(
                    buttonText: 'Masuk',
                    onPressed: () => handleLogin(context),
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
                        'Belum memiliki akun?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          // Pindah ke halaman register jika sudah punya akun
                          Navigator.of(context).pushNamed('/register');
                        },
                        child: Text(
                          'Register',
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
                      // TODO: Add logic for "Continue as a guest" here
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
