import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' as ez;

class changePasswordView extends StatefulWidget {
  const changePasswordView({super.key});

  @override
  State<changePasswordView> createState() => _changePasswordViewState();
}

class _changePasswordViewState extends State<changePasswordView> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerCurrent = TextEditingController();
  final TextEditingController _controllerNew = TextEditingController();
  final TextEditingController _controllerConfirm = TextEditingController();
  Uint8List? pickedImage;
  bool isLoading = false;

  // Estado de visibilidad para los campos
  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  @override
  void initState() {
    super.initState();
    getProfilePicture();
  }

  Future<void> getProfilePicture() async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child(currentUser.email.toString());

    try {
      final imageBytes = await imageRef.getData();
      if (imageBytes == null) return;
      setState(() => pickedImage = imageBytes);
    } catch (e) {
      print('Profile Picture could not be found');
    }
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Ingrese una contraseña'.tr();
    if (value.length < 8) return 'Mínimo 8 caracteres'.tr();
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Debe tener una mayúscula'.tr();
    if (!RegExp(r'[a-z]').hasMatch(value)) return 'Debe tener una minúscula'.tr();
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Debe tener un número'.tr();
    if (!RegExp(r'[!@#\\$&*~]').hasMatch(value)) return 'Debe tener un símbolo: !@#%?_'.tr();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        iconTheme: CupertinoIconThemeData(
          color: Colors.white,
          size: size.height * 0.035,
        ),
        bottomOpacity: 0.0,
        toolbarHeight: size.height * 0.12,
        leadingWidth: size.width * 0.13,
        //leading:
        title: Container(
            padding: EdgeInsets.only(top: size.height * 0.0),
            child: Text(
              'Cambiar contraseña'.tr(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: size.height * 0.024,
                  color: Colors.white,
                  fontFamily: ''),
            )),
        centerTitle: false,
        titleTextStyle: TextStyle(
            fontFamily: '',
            fontWeight: FontWeight.bold,
            fontSize: size.height * 0.023,
            color: const Color.fromARGB(255, 255, 255, 255)),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/puntos.png'),
              fit: BoxFit.fill,
              colorFilter: (Theme.of(context).colorScheme.tertiary !=
                      Color.fromRGBO(4, 99, 128, 1))
                  ? ColorFilter.mode(
                      const Color.fromARGB(255, 68, 68, 68), BlendMode.color)
                  : ColorFilter.mode(
                      const Color.fromARGB(0, 255, 29, 29), BlendMode.color),
            ),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            height: size.height * 0.065,
            width: size.height * 0.065,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              border: Border.all(
                color: Color.fromRGBO(255, 255, 255, 0.174),
                width: size.height * 0.003,
              ),
              shape: BoxShape.circle,
              image: pickedImage != null
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: MemoryImage(pickedImage!),
                    )
                  : null,
            ),
          ),
        ],
      ),
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(size.width * 0.08),
            topRight: Radius.circular(size.width * 0.08),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              CircleAvatar(
                radius: size.height * 0.08,
                backgroundColor: Theme.of(context).colorScheme.primary,
                backgroundImage: AssetImage('assets/img/lock.png'),
              ),
              SizedBox(height: size.height * 0.02),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        buildLabel('Contraseña actual'.tr()),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Cambiar contraseña'.tr(),
                                        style: TextStyle(
                                            fontFamily: 'Arial',
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                      ),
                                      content: Text(
                                        'Ingrese la contraseña actual para poder cambiar su contraseña'.tr(),
                                        style: TextStyle(
                                            fontFamily: 'Arial',
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              'Cerrar'.tr(),
                                              style: TextStyle(
                                                  fontFamily: 'Arial',
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                            )),
                                      ],
                                    );
                                  });
                            },
                            icon: Icon(
                              Icons.info,
                              color: Theme.of(context).colorScheme.tertiary,
                              size: size.height * 0.026,
                            ))
                      ],
                    ),
                    SizedBox(height: size.height * 0.01),
                    buildPasswordField(_controllerCurrent, _showCurrent, () {
                      setState(() => _showCurrent = !_showCurrent);
                    }),
                    SizedBox(height: size.height*0.01,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, '/passwordreset'),
                          child: Text(
                            '¿Olvidaste tu contraseña?'.tr(),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontSize: size.height * 0.014,
                                color: const Color.fromARGB(255, 42, 159, 255),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.025,
                        )
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),
                    buildLabel('Nueva contraseña'.tr()),
                    SizedBox(height: size.height * 0.01),
                    buildPasswordField(_controllerNew, _showNew, () {
                      setState(() => _showNew = !_showNew);
                    }, validator: validatePassword),
                    SizedBox(height: size.height * 0.02),
                    buildLabel('Confirmar contraseña'.tr()),
                    SizedBox(height: size.height * 0.01),
                    buildPasswordField(_controllerConfirm, _showConfirm, () {
                      setState(() => _showConfirm = !_showConfirm);
                    }),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.04),
              SizedBox(
                width: double.infinity,
                height: size.height * 0.06,
                child: ElevatedButton(
                  onPressed: isLoading ? null : handleChangePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Confirmar',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.height * 0.02,
                              color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String label) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: size.height * 0.018,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arial'),
      ),
    );
  }

  Widget buildPasswordField(
    TextEditingController controller,
    bool isVisible,
    VoidCallback toggleVisibility, {
    String? Function(String?)? validator,
  }) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.06,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(-1, 1),
            ),
          ],
        ),
        child: SizedBox(
            width: size.height * 0.01,
            child: TextFormField(
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontFamily: 'Arial',
                fontSize: size.height * 0.02,
                fontWeight: FontWeight.normal,
              ),
              cursorHeight: size.height * 0.017,
              cursorColor: Theme.of(context).colorScheme.secondary,
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              controller: controller,
              obscureText: !isVisible,
              validator: validator,
              decoration: InputDecoration(
                errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
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
                hintText: '',
                hintStyle:
                    TextStyle(color: const Color.fromARGB(255, 174, 174, 174)),
                filled: true,
                fillColor: Theme.of(context).colorScheme.primary,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.transparent), // Sin borde inactivo
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.transparent), // Sin borde enfocado
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                suffixIcon: IconButton(
                  icon: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: toggleVisibility,
                ),
              ),
            )),
      ),
    );
  }

  Future<void> handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final currentPassword = _controllerCurrent.text.trim();
    final newPassword = _controllerNew.text.trim();
    final confirmPassword = _controllerConfirm.text.trim();
    final user = FirebaseAuth.instance.currentUser;

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Las contraseñas no coinciden'.tr(),style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.red,
      ));
      return;
    }

    if (user == null) return;

    setState(() => isLoading = true);

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);

      _controllerCurrent.clear();
      _controllerNew.clear();
      _controllerConfirm.clear();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Contraseña actualizada exitosamente'.tr(),style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
      ));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${e.message}'),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() => isLoading = false);
    }
  }
}
