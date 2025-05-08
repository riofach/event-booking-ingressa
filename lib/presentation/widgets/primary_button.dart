import 'package:flutter/material.dart';
import '../../core/themes/app_colors.dart';

/// PrimaryButton - Button reusable utama untuk aplikasi Ingressa
/// Disesuaikan dengan desain Figma (node-id=4-2685)
///
/// Cara pakai:
/// PrimaryButton(
///   text: 'Sign Up',
///   onPressed: () {},
///   isLoading: false,
///   enabled: true,
/// )
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool enabled;

  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient:
              enabled
                  ? AppColors.horizontal01
                  : LinearGradient(
                    colors: [
                      AppColors.primary950.withOpacity(0.5),
                      AppColors.secondary950.withOpacity(0.5),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
        ),
        child: MaterialButton(
          onPressed: enabled && !isLoading ? onPressed : null,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child:
              isLoading
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  : Text(
                    text,
                    style: const TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.white,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
        ),
      ),
    );
  }
}
