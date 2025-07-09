import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lapuerta2/administrador/admin_auth.dart';
import 'package:lapuerta2/onboarding.dart';

class AdminLoginNow extends StatefulWidget {
  const AdminLoginNow({Key? key}) : super(key: key);

  @override
  State<AdminLoginNow> createState() => _AdminLoginNowState();
}

class _AdminLoginNowState extends State<AdminLoginNow> {
  String? errorMessage = '';
  bool isLogin = true;
  bool selectLogin = true;
  bool _isObscure = true;
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> adminsignInWithEmailAndPassword() async {
    try {
      await AdminAuth().adminsignInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> admincreateUserWithEmailAndPassword() async {
    try {
      await AdminAuth().admincreateUserWithEmailAndPassword(
          name: _controllerName.text,
          email: _controllerEmail.text,
          password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
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
                fontFamily: 'Impact',
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
                fontFamily: 'Impact',
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
              ? adminsignInWithEmailAndPassword
              : admincreateUserWithEmailAndPassword,
          style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff193551),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Text(
              isLogin ? 'Inicar Sesión' : 'Registrarse',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: size.height * 0.021,
                  fontWeight: FontWeight.bold),
            ),
          )),
    );
  }

  Widget _loginOrRegisterButton() {
    return SizedBox(
      width: 300,
      child: TextButton(
          onPressed: () {
            setState(() {
              isLogin = !isLogin;
              _controllerPassword.clear();
              _controllerEmail.clear();
              _controllerName.clear();
            });
          },
          child: Text(
            isLogin
                ? 'Ingrese sus credenciales de administrador'
                : 'Ir a inicar sesión',
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
          )),
    );
  }

  final GlobalKey scrollKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/img/foto4.jpg'),
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3), BlendMode.dstATop),
              fit: BoxFit.cover),
        ),
        padding: const EdgeInsets.all(30),
        child: Center(
            child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          key: scrollKey,
          reverse: true,
          primary: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.0,
              ),
              Container(
                width: size.height * 0.17,
                height: size.height * 0.17,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.white),
                  color: Colors.white,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    scale: size.height * 0.0044,
                    alignment: Alignment(0, 0),
                    image: AssetImage('assets/img/logo.png'),
                    //fit: BoxFit.fitWidth,
                  ),
                ),
              )
                  .animate()
                  .fade(delay: 300.ms, duration: 500.ms, curve: Curves.easeIn),
              SizedBox(
                height: size.height * 0.01,
              ),
              (isLogin) ? _boxLogin() : _boxRegister(),
              SizedBox(
                height: size.height * 0.03,
              ),
            ],
          ),
        )),
      ),
    );
  }

  Widget _boxLogin() {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: 10.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _loginOrRegisterButton(),
            _entryField(
              'correo electrónico',
              _controllerEmail,
              Icons.email_outlined,
            ),
            SizedBox(
              height: 10.0,
            ),
            _entryFieldPassword(
                'contraseña', _controllerPassword, Icons.lock_outline_rounded),
            SizedBox(
              height: 5.0,
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
          ],
        ).animate().fade(delay: 500.ms, duration: 500.ms, curve: Curves.easeIn)
      ],
    );
  }

  Widget _boxRegister() {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: 10.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _loginOrRegisterButton(),
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
              height: 5.0,
            ),
            _errorMessage(),
            SizedBox(
              height: 15.0,
            ),
            _submitButton(),
            SizedBox(height: size.height*0.01,),
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
        ).animate().fade(delay: 500.ms, duration: 500.ms, curve: Curves.easeIn)
      ],
    );
  }
}
