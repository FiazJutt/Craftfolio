import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final int? maxLines;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.6),
          fontSize: 14,
        ),
        prefixIcon: Icon(prefixIcon, color: Colors.white70, size: 20),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
      ),
    );
  }
}








// import 'package:flutter/material.dart';
//
// class CustomTextField extends StatelessWidget {
//   final String hintText;
//   final IconData prefixIcon;
//   final Widget? suffixIcon;
//   final bool obscureText;
//   final int? maxLines;
//   final TextInputType keyboardType;
//   final TextEditingController? controller;
//
//   const CustomTextField({
//     super.key,
//     required this.hintText,
//     required this.prefixIcon,
//     this.suffixIcon,
//     this.obscureText = false,
//     this.maxLines = 1,
//     this.keyboardType = TextInputType.text,
//     this.controller,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       obscureText: obscureText,
//       keyboardType: keyboardType,
//       maxLines: maxLines,
//
//       style: const TextStyle(color: Colors.white, fontSize: 14),
//       decoration: InputDecoration(
//         hintText: hintText,
//         hintStyle: TextStyle(
//           color: Colors.white.withOpacity(0.6),
//           fontSize: 14,
//         ),
//
//         prefixIcon: Icon(prefixIcon, color: Colors.white70, size: 20),
//         suffixIcon: suffixIcon,
//
//         contentPadding: const EdgeInsets.symmetric(
//           vertical: 14,
//           horizontal: 16,
//         ),
//
//         filled: true,
//         fillColor: Colors.white.withOpacity(0.12),
//
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide.none,
//         ),
//
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.white, width: 1.5),
//         ),
//       ),
//     );
//   }
// }