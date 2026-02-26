import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/manager/profile_cubit/change_password_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/change_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//TODO: password restrictions 
class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Local values to track input
    String currentPass = "";
    String newPass = "";
    String confirmPass = "";

    // A simple notifier to trigger button state updates
    final ValueNotifier<bool> isFormValid = ValueNotifier(false);

    void validateForm() {
      isFormValid.value = currentPass.isNotEmpty &&
          newPass.isNotEmpty &&
          newPass.length >= 6 &&
          newPass == confirmPass;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password", style: Styles.textStyle20),
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: BlocListener<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Password Updated!"), backgroundColor: Colors.green),
            );
            Navigator.pop(context);
          } else if (state is ChangePasswordError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              TextFormField(
                obscureText: true,
                cursorColor: AppColors.primary,
                decoration: _buildDecoration("Current Password", Icons.lock_outline),
                onChanged: (val) {
                  currentPass = val;
                  validateForm();
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                cursorColor: AppColors.primary,
                decoration: _buildDecoration("New Password", Icons.vpn_key_outlined),
                onChanged: (val) {
                  newPass = val;
                  validateForm();
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                cursorColor: AppColors.primary,
                decoration: _buildDecoration("Confirm Password", Icons.check_circle_outline),
                onChanged: (val) {
                  confirmPass = val;
                  validateForm();
                },
              ),
              const Spacer(),
              ValueListenableBuilder<bool>(
                valueListenable: isFormValid,
                builder: (context, isValid, child) {
                  return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: AppColors.lightGrey,
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        // Button is disabled if form is invalid or cubit is loading
                        onPressed: (isValid && state is! ChangePasswordLoading)
                            ? () => context.read<ChangePasswordCubit>().updatePassword(currentPass, newPass)
                            : null,
                        child: state is ChangePasswordLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Save New Password", style: TextStyle(color: Colors.white)),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.primary),
      floatingLabelStyle: const TextStyle(color: AppColors.primary),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }
}