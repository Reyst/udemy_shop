import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udemy_shop/screens/product_list_screen.dart';

import '../data/auth_provider.dart';

class AuthScreen extends StatelessWidget {
  static const String route = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              width: deviceSize.width,
              height: deviceSize.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      margin: EdgeInsets.only(bottom: 20.0),
                      transform: Matrix4.rotationZ(-0.13)..translate(-10.0),
                      // (-8 * 3.1415 / 180),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black45,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        "Udemy Shop",
                        style: TextStyle(
                          color: Theme.of(context).accentTextTheme.subtitle1.color,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  static const _KEY_EMAIL = 'email';
  static const _KEY_PASSWORD = 'password';

  AuthMode _mode = AuthMode.SignIn;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();

  final _data = {
    _KEY_EMAIL: '',
    _KEY_PASSWORD: '',
  };

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 8,
        margin: const EdgeInsets.symmetric(horizontal: 32),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (newValue) => _data[_KEY_EMAIL] = newValue,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                controller: _passwordController,
                onSaved: (newValue) => _data[_KEY_PASSWORD] = newValue,
              ),
              IgnorePointer(
                ignoring: _mode != AuthMode.SignUp,
                child: Opacity(
                  opacity: _mode == AuthMode.SignUp ? 1 : 0,
                  child: TextFormField(
                    enabled: _mode == AuthMode.SignUp,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _validatePassword,
                  ),
                ),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : RaisedButton(
                      child: Text('Submit'),
                      onPressed: _submit,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).primaryTextTheme.button.color,
                    ),
              FlatButton(
                onPressed: _changeMode,
                child: Text(_mode == AuthMode.SignUp ? 'switch to Sign-In' : 'switch to Sign-Up'),
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _validatePassword(String value) {
    String result;
    if (_mode == AuthMode.SignUp && value != _passwordController.text) {
      result = 'Passwords do not match!';
    }
    return result;
  }

  void _changeMode() {
    setState(() {
      _mode = AuthMode.values.firstWhere((mode) => mode != _mode);
    });
  }

  Future<void> _submit() async {
    var formState = _formKey.currentState;
    if (!formState.validate()) return;

    try {
      setState(() => _isLoading = true);
      formState.save();

      final result = await _submitAction(_data[_KEY_EMAIL], _data[_KEY_PASSWORD]);
      if (result) Navigator.of(context).pushReplacementNamed(ProductListScreen.route);
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error'),
          content: Text(error.message),
          actions: [
            FlatButton(onPressed: () => Navigator.of(ctx).pop(), child: Text("OK")),
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<bool> Function(String, String) get _submitAction {
    if (_mode == AuthMode.SignUp)
      return context.read<AuthProvider>().register;
    else
      return context.read<AuthProvider>().login;
  }
}

enum AuthMode { SignUp, SignIn }
