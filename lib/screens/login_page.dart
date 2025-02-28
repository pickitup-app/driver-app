import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pickitupdriver/services/api_service.dart'; // Import layanan API

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordHidden = true;
  bool _isLoading = false;

  // Fungsi untuk memproses login
  void _login() async {
    // Validasi input
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Panggil API untuk login
    final response = await ApiService().login(
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (response['success']) {
      // Navigasi ke halaman home jika login berhasil
      Navigator.pushNamed(context, '/');
    } else {
      // Tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color(0xFF0C382B),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Image.asset('assets/images/pu-driver.png', height: 100),
              SizedBox(height: 20),
              Image.asset('assets/images/logindriver.png', height: 200),
              SizedBox(height: 20),
              Text(
                'Log in',
                style: GoogleFonts.balooBhai2(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFFBF9861),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Login as Driver',
                style: GoogleFonts.balooBhai2(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20),
              // Form Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  fillColor: Color(0XFF6D9773),
                  filled: true,
                  labelText: 'Email',
                  labelStyle: GoogleFonts.balooBhai2(color: Colors.white),
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Form Password
              TextFormField(
                controller: _passwordController,
                obscureText: _isPasswordHidden,
                decoration: InputDecoration(
                  fillColor: Color(0XFF6D9773),
                  filled: true,
                  labelText: 'Password',
                  labelStyle: GoogleFonts.balooBhai2(color: Colors.white),
                  hintText: 'Enter your password',
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordHidden
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isPasswordHidden = !_isPasswordHidden;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Forgot Password',
                  style: GoogleFonts.balooBhai2(color: Colors.green.shade800),
                ),
              ),
              SizedBox(height: 20),
              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0XFF6D9773),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            'Log In',
                            style: GoogleFonts.balooBhai2(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
