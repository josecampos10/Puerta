import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lapuerta2/widget_tree.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String? errorMessage = '';
  bool isLogin = true;
  bool selectLogin = true;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  final controller = TextEditingController();

  Widget _submitButton() {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.9,
      height: size.height * 0.07,
      child: ElevatedButton(
          onPressed: () {
            passwordReset();
            controller.clear();
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 96, 146, 255),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Text(
              'Enviar enlace',
              style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontSize: size.height * 0.021,
                  fontWeight: FontWeight.bold),
            ),
          )),
    );
  }

  final GlobalKey scrollKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: controller.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                'Se ha enviado el enlace al correo ingresado',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              elevation: 5,
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                  'Por favor ingresa el correo electrónico asociado a tu cuenta', textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(132, 4, 99, 128),
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
              fit: BoxFit.contain),
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
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image(image: AssetImage('assets/img/reset-password.png')),
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 0, 238, 255),
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  )),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Ingresa el correo electrónico asociado a tu cuenta para recibir el enlace para cambiar tu contraseña',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  )),
              SizedBox(
                height: size.height * 0.03,
              ),
              Container(
                height: size.height * 0.06,
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
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
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  style: TextStyle(
                      fontSize: size.height * 0.02,
                      color: const Color.fromARGB(255, 0, 0, 0)),
                  cursorHeight: size.height * 0.023,
                  controller: controller,
                  //keyboardType: TextInputType.visiblePassword,

                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    labelText: 'correo electrónico',
                    prefixIcon: Icon(
                      Icons.email,
                      color: const Color.fromARGB(255, 155, 155, 155),
                    ),
                    labelStyle: TextStyle(
                        fontSize: size.height * 0.02,
                        fontFamily: 'Arial',
                        color: const Color.fromARGB(255, 155, 155, 155)),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              _submitButton(),
              SizedBox(
                height: size.height * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return WidgetTree();
                      }));
                    },
                    child: Text(
                      'Atrás',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontSize: size.height * 0.017,
                          color: const Color.fromARGB(255, 0, 238, 255),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.025,
                  )
                ],
              ),

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
}
