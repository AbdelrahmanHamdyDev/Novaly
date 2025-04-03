import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:novaly/Controller/firebase.dart';
import 'package:novaly/pageView.dart';

class signScreen extends StatefulWidget {
  const signScreen({super.key, required this.type});

  final String type;

  @override
  State<signScreen> createState() => _signScreenState();
}

class _signScreenState extends State<signScreen> {
  final _formKey = GlobalKey<FormState>();
  final firebase = Firebase_Auth();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userNameController = TextEditingController();
  bool _obscurePassword = true; // Not visible

  void _sign(bool SignIn) async {
    if (_formKey.currentState!.validate()) {
      final userEmail = _emailController.text;
      final userPassword = _passwordController.text;
      final userName = _userNameController.text;
      bool res = false;

      String? errorMessage;

      if (SignIn) {
        errorMessage = await firebase.signInUser(userEmail, userPassword);
      } else {
        errorMessage = await firebase.registerUser(
          userEmail,
          userPassword,
          userName,
        );
      }

      if (errorMessage == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => pageViewController()),
        );
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool is_SignIn = widget.type == "i";
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.h),
                      width: 180.w,
                      height: 180.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/logo.png"),
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(70),
                      ),
                    ),
                    Text("Welcome To", style: TextStyle(fontSize: 24.sp)),
                    Text(
                      "Novaly",
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40),
                    if (!is_SignIn)
                      TextFormField(
                        controller: _userNameController,
                        decoration: InputDecoration(
                          labelText: 'UserName',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Name';
                          }
                          return null;
                        },
                      ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                      ),
                      onPressed: () {
                        _sign(is_SignIn);
                      },
                      child: Text(is_SignIn ? "Enter" : "Register"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder:
                                (ctx) =>
                                    signScreen(type: (is_SignIn) ? "u" : "i"),
                          ),
                        );
                      },
                      child:
                          (is_SignIn)
                              ? Text("Create new account?")
                              : Text("Have an email?"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
