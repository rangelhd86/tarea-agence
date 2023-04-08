import 'package:flutter/material.dart';
import 'package:websockets/utils/app_colors.dart';

class InputText extends StatefulWidget {
  String placeholder, initValue;
  IconButton icon;
  bool onlyNumber;
  bool Function(String text) validator;
  bool obscureText;
  TextInputType keyboartyp;
  int maxlines;

  InputText(
      {super.key,
      required this.icon,
      required this.placeholder,
      required this.validator,
      this.initValue = '',
      this.obscureText = false,
      this.keyboartyp = TextInputType.text,
      this.onlyNumber = false,
      this.maxlines = 0}); // requieres para que sea obligado este paramentro
  // Para validar que este creado correctamente
  @override
  State<InputText> createState() => InputTextState();
}

class InputTextState extends State<InputText> {
  bool _validationOk = false;
  TextEditingController _controller =
      TextEditingController(); //Se inicializa despues del initstate
  bool _showPassword = false;

  bool get isOK =>
      _validationOk; //retorna el valor de validationOK si es válido
  String get value => _controller.text; // Para tomar el valor del texto escrito

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initValue);
    _showPassword = widget.obscureText;
    _checkValidation();
  }

  void actualizarValor() {
    _controller.text = "";
  }

  void _checkValidation() // Para ir chequeando en mi onchange
  {
    if (widget.validator != null) {
      final bool isok = widget.validator(_controller.text);
      if (_validationOk != isok) {
        //Para evitar que constantemente se vuelva a renderizar la vista,
        // solo se renderizara
        //si cambia el valor de la validación
        setState(() {
          _validationOk = isok;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose(); //liberacion del controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (text) => _checkValidation(),
      obscureText: _showPassword,
      controller: _controller,
      keyboardType: widget.keyboartyp,
      style: TextStyle(fontFamily: 'sans', color: AppColors.primary),
      decoration: InputDecoration(
        hintText: widget.placeholder,
        hintStyle: TextStyle(fontFamily: 'sans', color: Colors.grey),
        prefixIcon: widget.icon,
        //border: const OutlineInputBorder(),
        suffixIcon: widget.validator != null && !widget.obscureText
            ? Icon(Icons.check_circle,
                color: _validationOk ? Colors.transparent : Colors.black12)
            : _validationOk
                ? GestureDetector(
                    child: Icon(
                        _showPassword ? Icons.visibility : Icons.visibility_off,
                        color: const Color(0xff1f6157)),
                    onTap: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  )
                : Icon(Icons.check_circle,
                    color: _validationOk ? AppColors.primary : Colors.black12),
      ),
    );
  }
}
