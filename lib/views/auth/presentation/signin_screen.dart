import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/home_controller.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Logo and App Name
              _buildHeader(context),
              const SizedBox(height: 40),

              // Welcome Text
              _buildWelcomeText(),
              const SizedBox(height: 30),

              // Login Form
              _buildLoginForm(),
              const SizedBox(height: 20),

              // Remember Me & Forgot Password
              _buildRememberAndForgot(),
              const SizedBox(height: 30),

              // Login Button
              _buildLoginButton(),
              const SizedBox(height: 40),

              // Footer
              _buildFooter(constext: context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // App Logo
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Image.asset(
            'assets/app_logo.png',
            width: MediaQuery.of(context).size.width * 0.3,
          ),
        ),
        const SizedBox(height: 15),

        // App Name
        const Text(
          'Multi-Omics Study',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A237E),
          ),
        ),
        // Text(
        //   'Child Surveillance',
        //   style: TextStyle(
        //     fontSize: 14,
        //     color: Colors.grey.shade600,
        //   ),
        // ),
      ],
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Welcome Back!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A237E),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to continue to the dashboard',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        // Email Field
        Obx(
          () => TextFormField(
            // controller: TextEditingController(text: '211'),
            decoration: InputDecoration(
              labelText: 'User Id',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF2196F3)),
              ),
              errorText: AuthController.to.userId.length != 3
                  ? 'Enter a valid user id'
                  : null,
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) => AuthController.to.userId = value,
          ),
        ),

        const SizedBox(height: 20),

        // Password Field
        Obx(
          () => TextFormField(
            // controller: TextEditingController(text: '123'),
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  AuthController.to.isPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: AuthController.to.togglePasswordVisibility,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF2196F3)),
              ),
              errorText:
                  AuthController.to.password.isNotEmpty &&
                      !AuthController.to.isPasswordValid
                  ? 'Minimum 3 characters required'
                  : null,
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            obscureText: !AuthController.to.isPasswordVisible,
            onChanged: (value) => AuthController.to.password = value,
          ),
        ),
      ],
    );
  }

  Widget _buildRememberAndForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Remember Me
        Obx(
          () => Row(
            children: [
              Checkbox(
                value: AuthController.to.rememberMe,
                onChanged: (_) => AuthController.to.toggleRememberMe(),
                activeColor: const Color(0xFF2196F3),
              ),
              Text(
                'Remember me',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
        ),

        // Forgot Password
        TextButton(
          onPressed: AuthController.to.resetPassword,
          child: const Text(
            'Forgot Password?',
            style: TextStyle(color: Color(0xFF2196F3)),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: AuthController.to.isLoading
              ? null
              : AuthController.to.login,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2196F3),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
          child: AuthController.to.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }

  Widget _buildFooter({required BuildContext constext}) {
    return Column(
      children: [
        // Divider
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade300)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text('OR', style: TextStyle(color: Colors.grey.shade500)),
            ),
            Expanded(child: Divider(color: Colors.grey.shade300)),
          ],
        ),

        const SizedBox(height: 20),

        // Contact Support
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.support_agent, color: Color(0xFF2196F3), size: 18),
            const SizedBox(width: 8),
            Text('Need help?', style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(width: 5),
            Text(
              'Contact With Admin',
              style: TextStyle(color: Colors.grey.shade600),
            ),

            // GestureDetector(
            //   onTap: () async {
            //     showLoader(context: constext);
            //     await AuthController.to.downloadUsers();
            //     Navigator.of(constext).pop();
            //   },
            //   child: const Text(
            //     'Download User',
            //     style: TextStyle(
            //       color: Color(0xFF2196F3),
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
          ],
        ),

        const SizedBox(height: 20),

        // Version Info
        Obx(
          () => Text(
            'Version: ${HomeController.to.appVersion}',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
          ),
        ),
      ],
    );
  }
}
