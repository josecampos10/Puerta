import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AdminPanel extends StatefulWidget {
  AdminPanel({Key? key}) : super(key: key);
  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        bottomOpacity: 0.0,
        toolbarHeight: size.height * 0.09,
        leadingWidth: size.width * 0.17,
        leading: Container(
          padding: EdgeInsets.all(size.width * 0.015),
          width: size.width * 0.2,
          child: CircleAvatar(
            backgroundColor: const Color.fromARGB(0, 240, 195, 195),
            child: Image.asset(
              'assets/img/logo.png',
              fit: BoxFit.scaleDown,
              scale: size.height * 0.008,
              color: Colors.white,
            ),
          ),
        ),
        title: Container(
            padding: EdgeInsets.only(top: size.height * 0.03),
            child: Text(
              'Panel de Administrador',
            )),
        centerTitle: true,
        titleTextStyle: TextStyle(
            fontFamily: '',
            fontWeight: FontWeight.bold,
            fontSize: size.height * 0.023,
            color: const Color.fromARGB(255, 255, 255, 255)),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        actions: [],
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * 0.08),
                topRight: Radius.circular(size.width * 0.08))),
        height: size.height,
        width: size.width,
        //color: Color.fromRGBO(255, 255, 255, 1),
        child: SingleChildScrollView(
          //physics: NeverScrollableScrollPhysics(),
          primary: false,
          reverse: false,
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.025,
              ),
              AnimationConfiguration.staggeredGrid(
                position: 1,
                columnCount: 1,
                child: ScaleAnimation(
                  duration: Duration(milliseconds: 300),
                  child: FadeInAnimation(
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.05,
                              ),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => Navigator.pushNamed(
                                        context, '/recursos'),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Theme.of(context).colorScheme.tertiary,
                                        
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: size.height * 0.18,
                                            width: size.width / 2 -
                                                size.width * 0.05 -
                                                size.width * 0.05,
                                            padding: const EdgeInsets.all(12),
                                            child: Icon(Icons.edit,
                                                size: size.height * 0.1,
                                                color: Theme.of(context).colorScheme.primary,)
                                          ),
                                          Container(
                                            width: size.width / 2 -
                                                size.width * 0.05 -
                                                size.width * 0.05,
                                            decoration: const BoxDecoration(
                                                color: Color.fromARGB(
                                                    120, 118, 68, 255),
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(12),
                                                    bottomLeft:
                                                        Radius.circular(12))),
                                            padding: const EdgeInsets.all(12),
                                            child: Text(
                                              "Editar Recursos",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: size.height * 0.017,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: size.width * 0.1,
                              ),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        Navigator.pushNamed(context, '/clases'),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Theme.of(context).colorScheme.tertiary,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: size.height * 0.18,
                                            width: size.width / 2 -
                                                size.width * 0.05 -
                                                size.width * 0.05,
                                            padding: const EdgeInsets.all(12),
                                            child: Icon(Icons.edit,
                                                size: size.height * 0.1,
                                                color: Theme.of(context).colorScheme.primary),
                                          ),
                                          Container(
                                            width: size.width / 2 -
                                                size.width * 0.05 -
                                                size.width * 0.05,
                                            decoration: const BoxDecoration(
                                                color: Color.fromRGBO(167, 0, 117, 0.549),
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(12),
                                                    bottomLeft:
                                                        Radius.circular(12))),
                                            padding: const EdgeInsets.all(12),
                                            child: Text("Editar Clases",
                                            style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: size.height * 0.017,
                                                  fontWeight: FontWeight.bold),
                                                  ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.025,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.05,
                              ),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => Navigator.pushNamed(
                                        context, '/publicaciones'),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Theme.of(context).colorScheme.tertiary,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: size.height * 0.18,
                                            width: size.width / 2 -
                                                size.width * 0.05 -
                                                size.width * 0.05,
                                            padding: const EdgeInsets.all(12),
                                            child: Icon(Icons.post_add,
                                                size: size.height * 0.1,
                                                color: Theme.of(context).colorScheme.primary),
                                          ),
                                          Container(
                                            width: size.width / 2 -
                                                size.width * 0.05 -
                                                size.width * 0.05,
                                            decoration: const BoxDecoration(
                                                color: Color.fromARGB(
                                                    151, 255, 165, 47),
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(12),
                                                    bottomLeft:
                                                        Radius.circular(12))),
                                            padding: const EdgeInsets.all(12),
                                            child: Text("Crear Post",
                                            style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: size.height * 0.017,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: size.width * 0.1,
                              ),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => Navigator.pushNamed(
                                        context, '/usuarios'),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Theme.of(context).colorScheme.tertiary,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: size.height * 0.18,
                                            width: size.width / 2 -
                                                size.width * 0.05 -
                                                size.width * 0.05,
                                            padding: const EdgeInsets.all(12),
                                            child: Icon(Icons.list_alt,
                                                size: size.height * 0.1,
                                                color: Theme.of(context).colorScheme.primary),
                                          ),
                                          Container(
                                            width: size.width / 2 -
                                                size.width * 0.05 -
                                                size.width * 0.05,
                                            decoration: const BoxDecoration(
                                                color: Color.fromARGB(
                                                    136, 14, 151, 44),
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(12),
                                                    bottomLeft:
                                                        Radius.circular(12))),
                                            padding: const EdgeInsets.all(12),
                                            child: Text("Lista de Usuarios",
                                            style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: size.height * 0.017,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.025,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.05,
                              ),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => Navigator.pushNamed(
                                        context, '/control'),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Theme.of(context).colorScheme.tertiary,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: size.height * 0.18,
                                            width: size.width / 2 -
                                                size.width * 0.05 -
                                                size.width * 0.05,
                                            padding: const EdgeInsets.all(12),
                                            child: Icon(Icons.settings,
                                                size: size.height * 0.1,
                                                color: Theme.of(context).colorScheme.primary),
                                          ),
                                          Container(
                                            width: size.width / 2 -
                                                size.width * 0.05 -
                                                size.width * 0.05,
                                            decoration: const BoxDecoration(
                                                color: Color.fromARGB(
                                                    120, 255, 68, 68),
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(12),
                                                    bottomLeft:
                                                        Radius.circular(12))),
                                            padding: const EdgeInsets.all(12),
                                            child: Text("Control",
                                            style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: size.height * 0.017,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: size.width * 0.1,
                              ),
                              GestureDetector(
                                onTap: () =>
                                    Navigator.pushNamed(context, '/posts'),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Theme.of(context).colorScheme.tertiary,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: size.height * 0.18,
                                            width: size.width / 2 -
                                                size.width * 0.05 -
                                                size.width * 0.05,
                                            padding: const EdgeInsets.all(12),
                                            child: Icon(Icons.local_activity,
                                                size: size.height * 0.1,
                                                color: Theme.of(context).colorScheme.primary),
                                          ),
                                          Container(
                                            width: size.width / 2 -
                                                size.width * 0.05 -
                                                size.width * 0.05,
                                            decoration: const BoxDecoration(
                                                color: Color.fromARGB(
                                                    132, 68, 137, 255),
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(12),
                                                    bottomLeft:
                                                        Radius.circular(12))),
                                            padding: const EdgeInsets.all(12),
                                            child: Text("Actividad",
                                            style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: size.height * 0.017,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
