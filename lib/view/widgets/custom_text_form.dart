part of 'widgets.dart';

class CustomTextForm extends StatelessWidget {
  const CustomTextForm({super.key, required this.labelText, required this.iconData, this.obscureText = false, required this.controller});

  final String labelText;
  final IconData iconData;
  final bool obscureText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
        filled: true,
        fillColor: Theme.of(context).colorScheme.secondary.withOpacity(0.15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        prefixIcon: Icon(iconData),
      ),
    );
  }
}
