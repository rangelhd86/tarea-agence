import 'package:flutter/material.dart';

import 'package:websockets/pages/pantvacia.dart';
import 'package:websockets/utils/responsive.dart';
import 'dart:math';
import 'package:google_sign_in/google_sign_in.dart';

import '../login/login.dart';
import 'package:websockets/pages/compra.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class HomePage extends StatefulWidget {
  final int tipo; //Tipo de autenticacion 0 sin clave, 1 google , 2 face
  final String nombre;

  const HomePage({
    super.key,
    required this.title,
    required this.tipo,
    required this.nombre,
  });

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool shouldPop = true;

  final List<String> worlds = <String>['A', 'B', 'C', 'F', 'G', 'H'];
  final List<String> products = <String>['ABC'];

  final ScrollController _controller = ScrollController();
  bool _isLoading = false;
  List<String> _dummy = <String>['ABC'];

  _onScroll() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        _isLoading = true;
      });
      _fetchData();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    arma_lista(20);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future _fetchData() async {
    await new Future.delayed(new Duration(seconds: 2));
    int lastIndex = _dummy.length;

    setState(() {
      arma_lista(15);
      _isLoading = false;
    });
  }

  Future<void> arma_lista(int ctdad) async {
    int x = 0;
    int randomNumber = 0;
    Random random = new Random();

    while (x <= ctdad) {
      randomNumber = random.nextInt(5);
      _dummy.add(worlds[randomNumber] +
          worlds[random.nextInt(5)] +
          worlds[random.nextInt(5)] +
          worlds[random.nextInt(5)]);
      x = x + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    String datos_entrada = ""; // Entraste por : facebook,gmail, sin datos
    if (widget.tipo == 0) {
      datos_entrada = "Sin sesión";
    }
    if (widget.tipo == 1) {
      datos_entrada = "Sesión google";
    }
    if (widget.tipo == 2) {
      datos_entrada = "Sesión facebook";
    }
    final Responsive responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Productos'),
      ),
      drawer: menu(),
      body: WillPopScope(
          onWillPop: () async {
            return shouldPop;
          },
          child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                children: [
                  SizedBox(
                    height: responsive.hp(2.5),
                  ),
                  Text(datos_entrada),
                  widget.nombre.isNotEmpty
                      ? Column(
                          children: [
                            SizedBox(
                              height: responsive.hp(2.5),
                            ),
                            Text(widget.nombre.isNotEmpty
                                ? 'Bienvenido ${widget.nombre} '
                                : ''),
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: responsive.hp(2.5),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: ListaProd(),
                  ))
                ],
              ))),
    );
  }

  ListView ListaProd() {
    return ListView.builder(
      controller: _controller,
      itemCount: _isLoading ? _dummy.length + 1 : _dummy.length,
      itemBuilder: (context, index) {
        if (_dummy.length == index)
          return Center(child: CircularProgressIndicator());
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            child: GestureDetector(
              onTap: () {
                _compraProducto(index.toString(), _dummy[index]);
              },
              child: Card(
                  elevation: 1,
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          _compraProducto(index.toString(), _dummy[index]);
                        },
                        icon: const Icon(
                          Icons.production_quantity_limits_sharp,
                        ),
                        label: const Text(''), // <-- Text
                      ),
                      ListTile(title: Text(" Producto ${_dummy[index]}")),
                    ],
                  )),
            ));
      },
    );
  }

  ListView ListaProductos() {
    return ListView.builder(
        itemCount: products == null ? 0 : products.length,
        itemBuilder: (BuildContext context, index) {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              child: GestureDetector(
                onTap: () {
                  _compraProducto(index.toString(), products[index]);
                },
                child: Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 10.0),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      _compraProducto(
                                        index.toString(),
                                        products[index],
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.production_quantity_limits_sharp,
                                    ),
                                    label: const Text(''), // <-- Text
                                  ),
                                ),
                              ),
                              Text(products[index]),
                            ],
                          ),
                          Text('Detalles del producto'),
                        ],
                      ),
                    )),
              ));
        });
  }

  Drawer menu() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              widget.nombre.isNotEmpty ? widget.nombre : 'Sin perfil',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.production_quantity_limits),
            title: Text('Perfil'),
            onTap: () {
              _pantallaVacia('Perfil');
            },
          ),
          ListTile(
            leading: Icon(Icons.production_quantity_limits),
            title: Text('Mis productos'),
            onTap: () {
              _pantallaVacia('Mis productos');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuraciones'),
            onTap: () {
              _pantallaVacia('Configuraciones');
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Cerrar sesión'),
            onTap: () async {
              //await _googleSignIn.disconnect();
              if (widget.tipo == 1) {
                _handleSignOut();
              }
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => const Login(
                            title: 'a',
                          )),
                  (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  void _pantallaVacia(String nombrepa) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PantVacia(
                  title: nombrepa,
                )));
  }

  void _compraProducto(String id, String nombre) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CompraMaps(
                  id: id,
                  nombre: nombre,
                  tipo: widget.tipo,
                  nombre_user: widget.nombre,
                )));
  }
}
