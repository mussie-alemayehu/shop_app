import 'dart:math';

import 'package:flutter/material.dart';

import '../models/http_exception.dart';
import '../providers/auth.dart';

enum AuthMode { login, signUp }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Container(
        height: mediaQuery.size.height - mediaQuery.viewInsets.top,
        width: mediaQuery.size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
              const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0, 1],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 80,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.red.shade600,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 8.0,
                    color: Colors.black38,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
              child: const Text(
                'My Shop',
                style: TextStyle(
                  fontFamily: 'Anton',
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),
            ),
            const FormCard(),
          ],
        ),
      ),
    );
  }
}

class FormCard extends StatefulWidget {
  const FormCard({super.key});

  @override
  State<FormCard> createState() => _FormCardState();
}

class _FormCardState extends State<FormCard>
    with SingleTickerProviderStateMixin {
  var _authMode = AuthMode.login;
  var _isLoading = false;

  final _form = GlobalKey<FormState>();
  final _passwordFocusNode = FocusNode();
  final _rePasswordFocusNode = FocusNode();
  final _passwordController = TextEditingController();
  final Map<String, String> _userInfo = {
    'email': '',
    'password': '',
  };

  AnimationController? _animationController;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        curve: Curves.linear,
        parent: _animationController!,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -2),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeIn),
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An error occured.'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveForm() async {
    final isFormValid = _form.currentState!.validate();

    if (isFormValid) {
      try {
        setState(() {
          _isLoading = true;
        });
        _form.currentState!.save();
        if (_authMode == AuthMode.login) {
          await Auth.login(_userInfo);
        } else {
          await Auth.signup(_userInfo);
        }
      } on HttpException catch (error) {
        var message = 'Authentication failed.';
        if (error.toString().contains('INVALID_LOGIN_CREDENTIALS')) {
          message = 'Email-Password combination incorrect.';
        } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
          message = 'There is no account with this email, signup instead.';
        } else if (error.toString().contains('EMAIL_EXISTS')) {
          message = 'Email is already in use by another user.';
        }
        _showErrorDialog(message);
      } catch (error) {
        rethrow;
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Card(
        elevation: 10,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
          height: _authMode == AuthMode.login ? 260 : 330,
          width: 300,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SingleChildScrollView(
            child: Form(
              key: _form,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      label: const Text('E-Mail'),
                      labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      errorStyle: const TextStyle(fontSize: 8),
                    ),
                    cursorColor: Theme.of(context).primaryColor,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your e-mail.';
                      } else if (!value.contains('@')) {
                        return 'Please enter a valid e-mail address.';
                      }
                      return null;
                    },
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_passwordFocusNode),
                    onSaved: (newValue) {
                      if (newValue == null) {
                        return;
                      }
                      _userInfo['email'] = newValue;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      label: const Text('Password'),
                      labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      errorStyle: const TextStyle(fontSize: 8),
                    ),
                    cursorColor: Theme.of(context).primaryColor,
                    focusNode: _passwordFocusNode,
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password must not be empty.';
                      } else if (value.length <= 5) {
                        return 'Password must be at least 6 characters long.';
                      }
                      return null;
                    },
                    onEditingComplete: _authMode == AuthMode.signUp
                        ? () => FocusScope.of(context)
                            .requestFocus(_rePasswordFocusNode)
                        : _saveForm,
                    onSaved: (newValue) {
                      if (newValue == null) {
                        return;
                      }
                      _userInfo['password'] = newValue;
                    },
                  ),
                  AnimatedContainer(
                    constraints: BoxConstraints(
                      maxHeight: _authMode == AuthMode.login ? 0 : 120,
                      minHeight: _authMode == AuthMode.login ? 0 : 60,
                    ),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    child: FadeTransition(
                      opacity: _opacityAnimation!,
                      child: SlideTransition(
                        position: _slideAnimation!,
                        child: TextFormField(
                          decoration: InputDecoration(
                            label: const Text('Re-Enter Password'),
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            errorStyle: const TextStyle(fontSize: 8),
                          ),
                          cursorColor: Theme.of(context).primaryColor,
                          focusNode: _rePasswordFocusNode,
                          obscureText: true,
                          onEditingComplete: _saveForm,
                          validator: _authMode == AuthMode.login
                              ? null
                              : (password) {
                                  if (password!.isEmpty ||
                                      _passwordController.text != password) {
                                    return 'You must enter the same password here!';
                                  }
                                  return null;
                                },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _isLoading
                      ? CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        )
                      : ElevatedButton(
                          onPressed: _saveForm,
                          style: ButtonStyle(
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).primaryColor,
                            ),
                            foregroundColor: const WidgetStatePropertyAll(
                              Colors.white,
                            ),
                          ),
                          child: Text(
                              _authMode == AuthMode.login ? 'Login' : 'SignUp'),
                        ),
                  TextButton(
                    onPressed: () {
                      setState(
                        () {
                          if (_authMode == AuthMode.login) {
                            _authMode = AuthMode.signUp;
                            _animationController!.forward();
                          } else {
                            _authMode = AuthMode.login;
                            _animationController!.reverse();
                          }
                        },
                      );
                    },
                    style: ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                    child: Text(
                        '${_authMode == AuthMode.login ? 'SignUp' : 'Login'} instead'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _rePasswordFocusNode.dispose();
    _animationController!.dispose();
    super.dispose();
  }
}
