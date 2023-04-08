import 'package:flutter/material.dart';
import 'package:websockets/pages/homepage.dart';
import 'package:websockets/utils/responsive.dart';
import 'package:websockets/pages/map.dart';

class CompraMaps extends StatefulWidget {
  final String id; //Tipo de autenticacion 0 sin clave, 1 google , 2 face
  final String nombre;
  final int tipo; //Tipo de autenticacion 0 sin clave, 1 google , 2 face
  final String nombre_user;

  const CompraMaps(
      {super.key,
      required this.id,
      required this.nombre,
      required this.tipo,
      required this.nombre_user});

  @override
  State<CompraMaps> createState() => _CompraMapsState();
}

class _CompraMapsState extends State<CompraMaps> {
  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return SafeArea(
      child: Scaffold(
        /*appBar: AppBar(
          title: Text(
            'CompraProducto ${widget.nombre}',
            style: TextStyle(color: Colors.white, fontSize: responsive.ip(2)),
          ),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  print("Comprando Producto ${widget.nombre}");
                },
                icon: const Icon(Icons.add_shopping_cart))
          ],
        ),*/
        body: WillPopScope(
            onWillPop: _onWillPopScope,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                children: [
                  MapComp(),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
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
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.food_bank,
                                      ),
                                      label: const Text(''), // <-- Text
                                    ),
                                  ),
                                ),
                                Text("Producto :${widget.nombre}"),
                              ],
                            ),
                            Text('Descripción del producto'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  comprabutton(responsive),
                ],
              ),
            )),
      ),
    );
  }

  Future<bool> _onWillPopScope() async {
    return true;
  }

  Align comprabutton(Responsive responsive) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: ElevatedButton(
          child: const Text('Comprar'),
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: responsive.hp(30),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text('Desea confirmar la compra'),
                        ElevatedButton(
                            child: const Text('SI'),
                            onPressed: () {
                              Navigator.pop(context);
                              _showMyDialog();
                            }),
                        ElevatedButton(
                          child: const Text('NO'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles de la compra'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'La compra del producto ${widget.nombre} se ha realizado correctamente'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => HomePage(
                              tipo: widget.tipo,
                              nombre: widget.nombre_user,
                              title: 'Tarea Agence',
                            )),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }
}
