import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class FaceRecognitionView extends StatefulWidget {
  @override
  _FaceRecognitionViewState createState() => _FaceRecognitionViewState();
}

class _FaceRecognitionViewState extends State<FaceRecognitionView> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticating = false;
  String _authorized = 'Not Authorized';

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
      localizedReason: 'Please authenticate to access this feature',
      options: const AuthenticationOptions(
        useErrorDialogs: true,
        stickyAuth: true,
      ),
    );
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authorized';
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) return;

    setState(() {
      _authorized = authenticated ? 'Authorized' : 'Not Authorized';
      if (authenticated) {
        Navigator.pushReplacementNamed(context, '/nextView');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Recognition'),
      ),
      body: Center(
        child: _isAuthenticating
            ? CircularProgressIndicator()
            : Text(_authorized),
      ),
    );
  }
}