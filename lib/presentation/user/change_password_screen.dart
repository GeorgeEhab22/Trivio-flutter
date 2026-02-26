import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/authentication/widgets/password_field.dart';
import 'package:auth/presentation/manager/profile_cubit/change_password_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/change_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Visibility States
  bool _isCurrentVisible = false;
  bool _isNewVisible = false;
  bool _isConfirmVisible = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<ChangePasswordCubit>().updatePassword(
        _currentPasswordController.text,
        _newPasswordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password", style: Styles.textStyle20),
      ),
      body: BlocListener<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Password Updated!"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is ChangePasswordError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // 1. Current Password (Simple, no restrictions needed usually)
                PasswordField(
                  controller: _currentPasswordController,
                  isPasswordVisible: _isCurrentVisible,
                  onVisibilityToggle: () =>
                      setState(() => _isCurrentVisible = !_isCurrentVisible),
                  onSubmit: _handleSubmit,
                  label: "Current Password",
                  hint: "Enter current password",
                  isLogin: true, // login mode hides complex requirements
                ),
                const SizedBox(height: 25),

                // 2. New Password (With complex vanishing requirements)
                PasswordField(
                  controller: _newPasswordController,
                  isPasswordVisible: _isNewVisible,
                  onVisibilityToggle: () =>
                      setState(() => _isNewVisible = !_isNewVisible),
                  onSubmit: _handleSubmit,
                  label: "New Password",
                  hint: "Enter new password",
                ),
                const SizedBox(height: 25),

                // 3. Confirm New Password (Matches original)
                PasswordField(
                  controller: _confirmPasswordController,
                  originalController: _newPasswordController,
                  isPasswordVisible: _isConfirmVisible,
                  onVisibilityToggle: () =>
                      setState(() => _isConfirmVisible = !_isConfirmVisible),
                  onSubmit: _handleSubmit,
                  label: "Confirm New Password",
                  hint: "Re-enter new password",
                  isConfirm: true,
                ),

                const SizedBox(height: 50),

                // 4. Action Button
                BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: state is ChangePasswordLoading
                          ? null
                          : _handleSubmit,
                      child: state is ChangePasswordLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Save New Password",
                              style: TextStyle(fontSize: 16),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
