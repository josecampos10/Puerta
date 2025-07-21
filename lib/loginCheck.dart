import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lapuerta2/ForgotPasswordPage.dart';
import 'package:lapuerta2/auth.dart';
import 'package:lapuerta2/onboarding.dart';

class LoginNow extends StatefulWidget {
  const LoginNow({super.key});

  @override
  State<LoginNow> createState() => _LoginNowState();
}

class _LoginNowState extends State<LoginNow> {
  String? errorMessage = '';
  bool isLogin = true;
  bool selectLogin = true;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool visibility = true;
  bool _isObscure = true;

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Ingrese una contraseña';
    if (value.length < 8) return 'Mínimo 8 caracteres';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Debe tener una mayúscula';
    if (!RegExp(r'[a-z]').hasMatch(value)) return 'Debe tener una minúscula';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Debe tener un número';
    if (!RegExp(r'[!@#\\$&*~]').hasMatch(value)) return 'Debe tener un símbolo';
    return null;
  }

  


  Future<void> signInWithEmailAndPassword() async {
  try {
    await Auth().signInWithEmailAndPassword(
      email: _controllerEmail.text,
      password: _controllerPassword.text,
    );

  } on FirebaseAuthException catch (e) {
    setState(() {
      errorMessage = e.message;
      _errorMessage();
    });
  }
}

  Future<void> createUserWithEmailAndPassword() async {
     // Quitamos espacios en blanco alrededor
  final name     = _controllerName.text.trim();
  final email    = _controllerEmail.text.trim();
  final password = _controllerPassword.text.trim();
  final role     = _selectedItem?.trim() ?? '';

  // 1️⃣  Comprobamos si falta alguno
  if (name.isEmpty || email.isEmpty || password.isEmpty || role.isEmpty) {
    // Aquí puedes mostrar un SnackBar, diálogo, print, etc.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Llene todos los campos necesarios')),
    );
    return; // ⬅️  Salimos sin llamar a Firebase
  }
    try {
      await Auth().createUserWithEmailAndPassword(
      name: name,
      email: email,
      password: password,
      rol: role,
    );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
        _errorMessage();
        if (_errorMessage() == '') {}
      });
    }
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
    IconData icon,
  ) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        height: size.height * 0.065,
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: const Color.fromARGB(255, 110, 110, 110), width: 1),
                bottom: BorderSide(
                    color: const Color.fromARGB(255, 110, 110, 110), width: 1),
                left: BorderSide(
                    color: const Color.fromARGB(255, 110, 110, 110), width: 1),
                right: BorderSide(
                    color: const Color.fromARGB(255, 110, 110, 110), width: 1)),
            color: const Color.fromARGB(255, 248, 248, 248),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: TextField(
            
            onTapOutside: (event) {
                                      print('onTapOutside');
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
            cursorColor: Colors.black,
            style: TextStyle(
                fontSize: size.height * 0.018,
                color: const Color.fromARGB(255, 0, 0, 0)),
            cursorHeight: size.height * 0.015,
            controller: controller,
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              hintText: title,
              prefixIcon:
                  Icon(icon, color: const Color.fromARGB(255, 155, 155, 155), size: size.height*0.02,),
              hintStyle: TextStyle(
                  fontSize: size.height * 0.017,
                  fontFamily: 'Arial',
                  color: const Color.fromARGB(255, 155, 155, 155)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _entryFieldPassword(
    String title,
    TextEditingController controller,
    IconData icon,
  ) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        height: size.height * 0.065,
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          border: Border.all(color: const Color.fromARGB(255, 110, 110, 110)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: TextFormField(
            
            cursorHeight: size.height*0.015,
            controller: controller,
            obscureText: _isObscure,
            validator: validatePassword,
            cursorColor: Colors.black,
            style: TextStyle(
              fontSize: size.height * 0.018,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
            decoration: InputDecoration(
              
              errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(40),
                ),
                errorStyle: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .error, // Color del texto del error
                  fontSize: size.height * 0.015, // Tamaño del texto
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Arial',
                ),
              border: InputBorder.none,
              hintText: title,
              prefixIcon: Icon(icon, color: const Color.fromARGB(255, 155, 155, 155),size: size.height*0.02,),
              hintStyle: TextStyle(
                fontSize: size.height * 0.017,
                fontFamily: 'Arial',
                color: const Color.fromARGB(255, 155, 155, 155),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == '' ? '' : 'Correo o contraseña incorrectos',
      style: TextStyle(color: Colors.white),
    );
  }

  Widget _submitButton() {
  Size size = MediaQuery.of(context).size;
  return SizedBox(
    width: size.width * 0.9,
    height: size.height * 0.07,
    child: ElevatedButton(
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          isLogin ? signInWithEmailAndPassword() : createUserWithEmailAndPassword();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 96, 146, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Text(
          isLogin ? 'Inicar Sesión' : 'Registrarse',
          style: TextStyle(
            color: const Color.fromARGB(255, 255, 255, 255),
            fontSize: size.height * 0.021,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}


  Widget _loginOrRegisterButton() {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.height,
      child: TextButton(
          onPressed: () {
            setState(() {
              isLogin = !isLogin;
              _controllerPassword.clear();
              _controllerEmail.clear();
              _controllerName.clear();
              _selectedItem = '';
            });
          },
          child: Text(
            isLogin ? 'No tienes una cuenta? Registrate' : 'Ir a inicar sesión',
            style: TextStyle(
                color: const Color.fromARGB(255, 0, 238, 255),
                fontWeight: FontWeight.bold,
                fontSize: size.height * 0.016),
          )),
    );
  }

  final GlobalKey scrollKey = GlobalKey();
  String _selectedItem = '';

  bool _imagePrecached = false;

@override
void didChangeDependencies() {
  super.didChangeDependencies();

  if (!_imagePrecached) {
    precacheImage(const AssetImage('assets/img/fondo_login.png'), context);
    _imagePrecached = true;
  }
}

  @override
  void initState() {
    super.initState();
    visibility = true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Container(
          
          alignment: Alignment.topCenter,
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            image: DecorationImage(
                filterQuality: FilterQuality.low,
                image: AssetImage('assets/img/fondo_login.png'),
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3), BlendMode.dstATop),
                fit: BoxFit.fill),
          ),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.08,
                ),
                Hero(
                  tag: 'logo',
                  child: Container(
                    width: size.width * 0.35,
                    height: size.height * 0.15,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 5,
                          color: const Color.fromARGB(255, 255, 255, 255)),
                      color: Colors.white,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        scale: size.height * 0.0048,
                        alignment: Alignment(0, 0),
                        image: AssetImage('assets/img/logo.png'),
                        //fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                _loginOrRegisterButton(),
                (isLogin) ? _boxLogin() : _boxRegister(),
      
                //_loginOrRegisterButton(),
      
                Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _boxLogin() {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.0,
        ),
        Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //_loginOrRegisterButton(),
            _entryField(
              'correo electrónico',
              _controllerEmail,
              Icons.email_outlined,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            _entryFieldPassword(
                'contraseña', _controllerPassword, Icons.lock_outline_rounded),
            SizedBox(
              height: size.height * 0.0,
            ),
            //_errorMessage(),
            SizedBox(
              height: size.height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ForgotPasswordPage();
                    }));
                  },
                  child: Text(
                    'Olvidaste tu contraseña?',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: size.height * 0.014,
                        color: const Color.fromARGB(255, 0, 238, 255),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.025,
                )
              ],
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            _submitButton(),
            SizedBox(
              height: size.height * 0.05,
            ),
            InkWell(
              child: Text(
                'Ir atrás',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: size.width * 0.04),
              ),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const OnboardingPage())),
            ),
          ],
        )
      ],
    );
  }

  Widget _boxRegister() {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // _loginOrRegisterButton(),
            _entryField('nombre', _controllerName, Icons.person_2_outlined),
            SizedBox(
              height: 10.0,
            ),
            _entryField(
                'correo electrónico', _controllerEmail, Icons.email_outlined),
            SizedBox(
              height: 10.0,
            ),
            _entryFieldPassword(
                'contraseña', _controllerPassword, Icons.lock_outline_rounded),
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: Container(
                width: size.width * 0.5,
                height: size.height * 0.06,
                margin: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: const Color.fromARGB(255, 110, 110, 110),
                            width: 1),
                        bottom: BorderSide(
                            color: const Color.fromARGB(255, 110, 110, 110),
                            width: 1),
                        left: BorderSide(
                            color: const Color.fromARGB(255, 110, 110, 110),
                            width: 1),
                        right: BorderSide(
                            color: const Color.fromARGB(255, 110, 110, 110),
                            width: 1)),
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    dropdownColor: const Color.fromARGB(255, 255, 255, 255),
                    underline: null,
                    padding: EdgeInsets.only(left: 10),
                    hint: _selectedItem == ''
                        ? Row(
                            children: [
                              Icon(
                                Icons.add_box_outlined,
                                color: const Color.fromARGB(255, 155, 155, 155),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                'elija su rol',
                                style: TextStyle(
                                    fontFamily: 'Arial',
                                    color: const Color.fromARGB(
                                        255, 155, 155, 155),
                                    fontSize: size.height * 0.018),
                              ),
                            ],
                          )
                        : Text(
                            _selectedItem,
                            style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0)),
                          ),
                    isExpanded: false,
                    iconSize: 30.0,
                    style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                    items:
                        ['Estudiante', 'Voluntario', 'Profesor', 'Staff'].map(
                      (val) {
                        return DropdownMenuItem(
                          alignment: Alignment.center,
                          value: val,
                          child: Container(
                            color: Colors.white,
                            //width: size.width*0.5,
                            child: Text(val),
                          ),
                        );
                      },
                    ).toList(),
                    onTap: () {},
                    onChanged: (val) {
                      setState(
                        () {
                          _selectedItem = val!;
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            _errorMessage(),
            SizedBox(
              height: 15.0,
            ),
            _submitButton(),
            SizedBox(
              height: size.height * 0.05,
            ),
            InkWell(
              child: Text(
                'Ir atrás',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: size.width * 0.04),
              ),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const OnboardingPage())),
            ),
            //_loginOrRegisterButton(),
          ],
        )
      ],
    );
  }
}
