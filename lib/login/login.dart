import 'package:flutter/material.dart';
import 'package:websockets/utils/responsive.dart';
import 'package:websockets/widgets/inputtext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:websockets/pages/homepage.dart';
import 'dart:async';
import 'dart:convert' show json;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class Login extends StatefulWidget {
  const Login({
    super.key,
    required this.title,
  });

  final String title;
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GoogleSignInAccount? _currentUser;
  String _contactText = 'as';
  final _username = '', _email = '', _password = '';
  String name = '';
  final _isFetching = false;
  final _ok = false;

  final GlobalKey<InputTextState> _usernamekey = GlobalKey();
  final GlobalKey<InputTextState> _clavekey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        final GoogleSignInAccount? user = _currentUser;
        _contactText = "";
        if (user != null) {
          _contactText = user.displayName ?? '';
        }

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      title: 'asdad',
                      tipo: 1,
                      nombre: _contactText,
                    )));
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = 'Loading contact info...';
    });

    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = 'People API gave a ${response.statusCode} '
            'response. Check logs for details.';
      });
      return;
    }
    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);

    setState(() {
      if (namedContact != null) {
        _contactText = 'I see you know $namedContact!';
      } else {
        _contactText = 'No contacts to display.';
      }
    });
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
      (dynamic contact) => (contact as Map<Object?, dynamic>)['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final List<dynamic> names = contact['names'] as List<dynamic>;
      final Map<String, dynamic>? name = names.firstWhere(
        (dynamic name) =>
            (name as Map<Object?, dynamic>)['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Scaffold(
        //backgroundColor: AppColors.primary,
        body: SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: logo(),
                                  )),
                              SizedBox(
                                height: responsive.hp(2.5),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  SizedBox(
                                    height: responsive.hp(2),
                                  ),
                                  Text("Iniciar Sesión",
                                      style: TextStyle(
                                          color: const Color(0xff2962FF),
                                          fontSize: responsive.ip(3),
                                          fontFamily: 'DMSerifDisplay')),
                                  SizedBox(
                                    height: responsive.hp(2.5),
                                  ),
                                  userCamp(),
                                  SizedBox(
                                    height: responsive.hp(2.5),
                                  ),
                                  userpassword(),
                                  Align(
                                      alignment: Alignment.bottomRight,
                                      child: forgotPasbutton(responsive)),
                                  autbutton(responsive),
                                ],
                              ),
                              SizedBox(
                                height: responsive.hp(2.5),
                              ),
                              Text("O continuar con:",
                                  style: TextStyle(
                                      color: const Color(0xff2962FF),
                                      fontSize: responsive.ip(2),
                                      fontFamily: 'DMSerifDisplay')),
                              socialNetword(responsive),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              _isFetching
                  ? Positioned.fill(
                      child: Container(
                      color: Colors.black45,
                      child: const Center(
                        child: CupertinoActivityIndicator(
                          radius: 15,
                        ),
                      ),
                    ))
                  : Container(),
            ],
          ),
        ),
      ),
    ));
  }

  Align logo() {
    return Align(
      alignment: Alignment.center,
      child: Image.asset(
        'images/agenceLogo.jpg',
      ),
    );
  }

  TextButton forgotPasbutton(Responsive responsive) {
    return TextButton(
      onPressed: () {},
      child: Text(
        'Olvide mi contraseña',
        style: TextStyle(
            color: const Color(0xff2962FF), fontSize: responsive.ip(2)),
      ),
    );
  }

  Align autbutton(Responsive responsive) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: ElevatedButton.icon(
          onPressed: () {
            _submit();
          },
          icon: const Icon(
            Icons.input_sharp,
          ),
          label: Text('Acceder'),
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xff2962FF)),
          // <-- Text
        ),
      ),
    );
  }

  Padding userpassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: InputText(
        key: _clavekey,
        icon: IconButton(
          icon: const Icon(
            Icons.key,
            color: const Color(0xff2962FF),
          ),
          onPressed: () {},
        ),
        placeholder: "Contraseña",
        obscureText: true,
        validator: (text) {
          return text.trim().isNotEmpty;
        },
      ),
    );
  }

  Padding userCamp() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: InputText(
        key: _usernamekey,
        icon: IconButton(
          icon: const Icon(
            Icons.person,
            color: const Color(0xff2962FF),
          ),
          onPressed: () {},
        ),
        placeholder: "Nombre de usuario",
        obscureText: false,
        validator: (text) {
          return text.trim().isNotEmpty;
        },
      ),
    );
  }

  Align socialNetword(Responsive responsive) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 15.0),
                child: CupertinoButton(
                  onPressed: () {},
                  child: Container(
                    width: 50,
                    height: 50,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: SvgPicture.asset('images/facebook.svg',
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                        semanticsLabel: 'A red up arrow'),
                    decoration: BoxDecoration(
                      color: Color(0xff2962FF),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: responsive.hp(1.5),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 15.0),
                child: CupertinoButton(
                  onPressed: () {
                    _signgoogle();
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: SvgPicture.asset('images/google.svg',
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                        semanticsLabel: 'A red up arrow'),
                    decoration: BoxDecoration(
                      color: Color(0xff2962FF),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* Access to google */

  Future<void> _signgoogle() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print("Error");
    }
  }

  void _submit() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const HomePage(
                  title: 'Tarea Agence',
                  tipo: 0,
                  nombre: '',
                )));
  }
}
