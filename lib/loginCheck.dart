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
  bool visibility = true;
  bool _isObscure = true;

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      /*await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.email)
          .update({'token': await FirebaseMessaging.instance.getToken()});*/
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
        _errorMessage();
        if (_errorMessage() == '') {}
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

      /*await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.email)
          .update({'token': await FirebaseMessaging.instance.getToken()});*/
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
        height: size.height * 0.06,
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
          cursorHeight: size.height * 0.023,
          controller: controller,
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            labelText: title,
            prefixIcon:
                Icon(icon, color: const Color.fromARGB(255, 155, 155, 155)),
            labelStyle: TextStyle(
                fontSize: size.height * 0.02,
                fontFamily: 'Arial',
                color: const Color.fromARGB(255, 155, 155, 155)),
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
        height: size.height * 0.06,
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            border: Border(
                top: BorderSide(
                    color: const Color.fromARGB(255, 110, 110, 110), width: 1),
                bottom: BorderSide(
                    color: const Color.fromARGB(255, 110, 110, 110), width: 1),
                left: BorderSide(
                    color: const Color.fromARGB(255, 110, 110, 110), width: 1),
                right: BorderSide(
                    color: const Color.fromARGB(255, 110, 110, 110), width: 1)),
            borderRadius: BorderRadius.circular(10)),
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
          cursorHeight: size.height * 0.023,
          controller: controller,
          //keyboardType: TextInputType.visiblePassword,
          obscureText: _isObscure,
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            labelText: title,
            prefixIcon: Icon(
              icon,
              color: const Color.fromARGB(255, 155, 155, 155),
            ),
            labelStyle: TextStyle(
                fontSize: size.height * 0.02,
                fontFamily: 'Arial',
                color: const Color.fromARGB(255, 155, 155, 155)),
            suffix: IconButton(
              padding: const EdgeInsets.all(20),
              iconSize: size.height * 0.03,
              icon: _isObscure
                  ? const Icon(
                      Icons.visibility_off,
                      color: Colors.grey,
                    )
                  : const Icon(
                      Icons.visibility,
                      color: Colors.black,
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
          onPressed: isLogin
              ? signInWithEmailAndPassword
              : createUserWithEmailAndPassword,
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 96, 146, 255),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Text(
              isLogin ? 'Inicar Sesión' : 'Registrarse',
              style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontSize: size.height * 0.021,
                  fontWeight: FontWeight.bold),
            ),
          )),
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

  @override
  void initState() {
    super.initState();
    visibility = true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      body: Container(
        alignment: Alignment.topCenter,
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
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
                  width: size.height * 0.15,
                  height: size.height * 0.15,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 5,
                        color: const Color.fromARGB(255, 255, 255, 255)),
                    color: Colors.white,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      scale: size.height * 0.006,
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
              height: size.height * 0.01,
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
              height: size.height * 0.01,
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
