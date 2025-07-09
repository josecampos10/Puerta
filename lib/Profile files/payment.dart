import 'dart:developer';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

// ignore: depend_on_referenced_packages

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> with SingleTickerProviderStateMixin {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _stripe = TextEditingController();
  final GlobalKey scrollKey = GlobalKey();
  String init = '10';
  String selectedamount = '';
  bool isTouchingone = false;
  bool isTouchingtwo = false;
  bool isTouchingthree = false;
  bool isTouchingfour = false;
  Map<String, dynamic>? paymentIntent;

  bool isLoading = true;
  bool applePayEnabled = false;
  bool googlePayEnabled = false;

  Future<void> send(emailAddress) async {
    final Email email = Email(
      body: '',
      subject: '',
      recipients: ['ppjjosejair@gmail.com'],
      //attachmentPaths: attachments,
      isHTML: false,
    );

    // ignore: unused_local_variable
    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      print(error);
      platformResponse = error.toString();
    }

    if (!mounted) return;

    /*ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );*/
  }

  @override
  void initState() {
    super.initState();
    _controllerName.text = init;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/hands.png'),
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
        bottomOpacity: 0.0,
        toolbarHeight: size.height * 0.28,
        leadingWidth: size.width * 0.17,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.01,
            ),
            Container(
              padding: EdgeInsets.all(6),
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
          ],
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
                padding: EdgeInsets.only(top: size.height * 0.22),
                child: Text(
                  'Seleccione un monto',
                )),
          ],
        ),
        centerTitle: true,
        titleTextStyle: TextStyle(
            fontFamily: '',
            fontWeight: FontWeight.bold,
            fontSize: size.height * 0.023,
            color: const Color.fromARGB(255, 255, 255, 255)),
        backgroundColor: Color.fromRGBO(4, 99, 128, 1),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.01,
              ),
              IconButton(
                iconSize: size.height * 0.045,
                color: Colors.white,
                icon: Icon(Icons.logout),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
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
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                key: scrollKey,
                reverse: false,
                primary: true,
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Container(
                      height: size.height * 0.1,
                      width: size.width * 0.8,
                      //color: const Color.fromARGB(255, 141, 141, 141),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color.fromARGB(0, 107, 107, 107)),
                      child: Center(
                        child: IntrinsicWidth(
                          stepWidth: 1.0,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {},
                            controller: _controllerName,
                            style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontSize: size.height * 0.078,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              prefix: Text('\$'),
                              prefixStyle: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontSize: size.height * 0.07,
                                  fontWeight: FontWeight.bold),
                              hintText: '',
                              hintStyle: TextStyle(
                                  fontSize: size.height * 0.022,
                                  color:
                                      const Color.fromARGB(255, 148, 148, 148)),
                              border: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_rounded,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: size.width * 0.01,
                          ),
                          Text(
                            'Pago Seguro',
                            style: TextStyle(fontSize: size.width * 0.033),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _controllerName.clear();
                                  _stripe.clear();
                                  const newText = '10';
                                  final updatedText =
                                      _controllerName.text + newText;
                                  _controllerName.value =
                                      _controllerName.value.copyWith(
                                    text: updatedText,
                                    selection: TextSelection.collapsed(
                                        offset: updatedText.length),
                                  );
                                  const newTextStripe = '10';
                                  final updatedTextStripe =
                                      _stripe.text + newTextStripe;
                                  _stripe.value = _stripe.value.copyWith(
                                    text: updatedTextStripe,
                                    selection: TextSelection.collapsed(
                                        offset: updatedTextStripe.length),
                                  );
                                },
                                child: Listener(
                                  child: Container(
                                    height: size.height * 0.08,
                                    width: size.width * 0.4,
                                    //color: Colors.grey,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: isTouchingone == true
                                          ? const Color.fromARGB(
                                              255, 132, 88, 0)
                                          : const Color.fromARGB(
                                              255, 224, 149, 0),
                                    ),
                                    //const Color.fromARGB(255, 224, 149, 0)),
                                    child: Center(
                                        child: Text(
                                      '\$10',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.width * 0.06,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                  onPointerDown: (event) => setState(() {
                                    isTouchingone = true;
                                  }),
                                  onPointerUp: (event) => setState(() {
                                    isTouchingone = false;
                                  }),
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.1,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _controllerName.clear();
                                  _stripe.clear();
                                  const newText = '20';
                                  final updatedText =
                                      _controllerName.text + newText;
                                  _controllerName.value =
                                      _controllerName.value.copyWith(
                                    text: updatedText,
                                    selection: TextSelection.collapsed(
                                        offset: updatedText.length),
                                  );
                                  const newTextStripe = '20';
                                  final updatedTextStripe =
                                      _stripe.text + newTextStripe;
                                  _stripe.value = _stripe.value.copyWith(
                                    text: updatedTextStripe,
                                    selection: TextSelection.collapsed(
                                        offset: updatedTextStripe.length),
                                  );
                                },
                                child: Listener(
                                  child: Container(
                                    height: size.height * 0.08,
                                    width: size.width * 0.4,
                                    //color: Colors.grey,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: isTouchingtwo == true
                                          ? const Color.fromARGB(
                                              255, 132, 88, 0)
                                          : const Color.fromARGB(
                                              255, 224, 149, 0),
                                    ),
                                    //const Color.fromARGB(255, 224, 149, 0)),
                                    child: Center(
                                        child: Text(
                                      '\$20',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.width * 0.06,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                  onPointerDown: (event) => setState(() {
                                    isTouchingtwo = true;
                                  }),
                                  onPointerUp: (event) => setState(() {
                                    isTouchingtwo = false;
                                  }),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _controllerName.clear();
                                  _stripe.clear();
                                  const newText = '40';
                                  final updatedText =
                                      _controllerName.text + newText;
                                  _controllerName.value =
                                      _controllerName.value.copyWith(
                                    text: updatedText,
                                    selection: TextSelection.collapsed(
                                        offset: updatedText.length),
                                  );
                                  const newTextStripe = '40';
                                  final updatedTextStripe =
                                      _stripe.text + newTextStripe;
                                  _stripe.value = _stripe.value.copyWith(
                                    text: updatedTextStripe,
                                    selection: TextSelection.collapsed(
                                        offset: updatedTextStripe.length),
                                  );
                                },
                                child: Listener(
                                  child: Container(
                                    height: size.height * 0.08,
                                    width: size.width * 0.4,
                                    //color: Colors.grey,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: isTouchingthree == true
                                          ? const Color.fromARGB(
                                              255, 132, 88, 0)
                                          : const Color.fromARGB(
                                              255, 224, 149, 0),
                                    ),
                                    //const Color.fromARGB(255, 224, 149, 0)),
                                    child: Center(
                                        child: Text(
                                      '\$40',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.width * 0.06,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                  onPointerDown: (event) => setState(() {
                                    isTouchingthree = true;
                                  }),
                                  onPointerUp: (event) => setState(() {
                                    isTouchingthree = false;
                                  }),
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.08,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _controllerName.clear();
                                  _stripe.clear();
                                  const newText = '50';
                                  final updatedText =
                                      _controllerName.text + newText;
                                  _controllerName.value =
                                      _controllerName.value.copyWith(
                                    text: updatedText,
                                    selection: TextSelection.collapsed(
                                        offset: updatedText.length),
                                  );
                                  const newTextStripe = '50';
                                  final updatedTextStripe =
                                      _stripe.text + newTextStripe;
                                  _stripe.value = _stripe.value.copyWith(
                                    text: updatedTextStripe,
                                    selection: TextSelection.collapsed(
                                        offset: updatedTextStripe.length),
                                  );
                                },
                                child: Listener(
                                  child: Container(
                                    height: size.height * 0.08,
                                    width: size.width * 0.4,
                                    //color: Colors.grey,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: isTouchingfour == true
                                          ? const Color.fromARGB(
                                              255, 132, 88, 0)
                                          : const Color.fromARGB(
                                              255, 224, 149, 0),
                                    ),
                                    //const Color.fromARGB(255, 224, 149, 0)),
                                    child: Center(
                                        child: Text(
                                      '\$50',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.width * 0.06,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                  onPointerDown: (event) => setState(() {
                                    isTouchingfour = true;
                                  }),
                                  onPointerUp: (event) => setState(() {
                                    isTouchingfour = false;
                                  }),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Container(
                      height: size.height * 0.07,
                      width: size.width * 0.8,
                      //color: const Color.fromARGB(255, 141, 141, 141),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color.fromARGB(255, 0, 0, 0)),
                      child: Center(
                        child: TextField(
                          onChanged: (value) {},
                          controller: _controller,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: size.height * 0.020,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            prefix: Text('  '),
                            hintText: 'Ingrese el motivo del pago',
                            hintStyle: TextStyle(
                                color:
                                    const Color.fromARGB(255, 148, 148, 148)),
                            border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PaypalCheckoutView(
                                  sandboxMode: true,
                                  clientId:
                                      "AfOU-7U5t1161vEhSdRqkAazrJIo5XeMbpGmc7bYGPCmMeQOO19138ZqUQ4VhU4WuN0Sj_FTMdI4prm3",
                                  secretKey:
                                      "EMmH2q19Xdd-o_-IWjf4fgwvVnPHy1BIG8SD1jTlLNRWlynoG4yqTG91qZoR16hBJHCf8ax9MBFNYNvM",
                                  transactions: [
                                    {
                                      "amount": {
                                        "total": _controllerName.text,
                                        "currency": "USD",
                                        "details": {
                                          "subtotal": _controllerName.text,
                                          "shipping": '0',
                                          "shipping_discount": 0
                                        }
                                      },
                                      "description":
                                          "The payment transaction description.",
                                      // "payment_options": {
                                      //   "allowed_payment_method":
                                      //       "INSTANT_FUNDING_SOURCE"
                                      // },
                                      "item_list": {
                                        "items": [
                                          {
                                            "name": _controller.text,
                                            "quantity": '1',
                                            "price": _controllerName.text,
                                            "currency": "USD"
                                          },
                                        ],

                                        // Optional
                                        //   "shipping_address": {
                                        //     "recipient_name": "Tharwat samy",
                                        //     "line1": "tharwat",
                                        //     "line2": "",
                                        //     "city": "tharwat",
                                        //     "country_code": "EG",
                                        //     "postal_code": "25025",
                                        //     "phone": "+00000000",
                                        //     "state": "ALex"
                                        //  },
                                      }
                                    }
                                  ],
                                  note:
                                      "Contact us for any questions on your order.",
                                  onSuccess: (Map params) async {
                                    log("onSuccess: $params");
                                    Navigator.pop(context);
                                  },
                                  onError: (error) {
                                    log("onError: $error");
                                    Navigator.pop(context);
                                  },
                                  onCancel: () {
                                    print('cancelled:');
                                    Navigator.pop(context);
                                  },
                                ),
                              ));
                            },
                            child: Container(
                              height: size.height * 0.09,
                              width: size.width * 0.4,
                              //color: Color.fromRGBO(4, 99, 128, 1),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(4, 99, 128, 1),
                                borderRadius: BorderRadius.circular(30),
                              ),

                              child: Row(
                                children: [
                                  Row(
                                    children: [
                                      Stack(children: [
                                        Container(
                                          height: size.height * 0.09,
                                          width: size.width * 0.2,
                                          //color: const Color.fromARGB(255, 52, 51, 51),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0)),
                                          child: Center(
                                              child: Icon(
                                            Icons.paypal,
                                            color: Colors.white,
                                            size: size.width * 0.09,
                                          )),
                                        ),
                                      ]),
                                      Stack(children: [
                                        Container(
                                          height: size.height * 0.09,
                                          width: size.width * 0.2,
                                          //color: const Color.fromARGB(255, 52, 51, 51),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: const Color.fromRGBO(
                                                  4, 99, 128, 1)),
                                          child: Center(
                                              child: Text(
                                            'Paypal',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: size.width * 0.04),
                                          )),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          /*GestureDetector(
                            onTap: () async {
                              await makePayment();
                              
                            },
                            child: Container(
                              height: size.height * 0.09,
                              width: size.width * 0.4,
                              //color: Color.fromRGBO(4, 99, 128, 1),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(4, 99, 128, 1),
                                borderRadius: BorderRadius.circular(30),
                              ),

                              child: Row(
                                children: [
                                  Row(
                                    children: [
                                      Stack(children: [
                                        Container(
                                          height: size.height * 0.09,
                                          width: size.width * 0.2,
                                          //color: const Color.fromARGB(255, 52, 51, 51),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0)),
                                          child: Center(
                                              child: Icon(
                                            Icons.wallet,
                                            color: Colors.white,
                                            size: size.width * 0.09,
                                          )),
                                        ),
                                      ]),
                                      Stack(children: [
                                        Container(
                                          height: size.height * 0.09,
                                          width: size.width * 0.2,
                                          //color: const Color.fromARGB(255, 52, 51, 51),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: const Color.fromRGBO(
                                                  4, 99, 128, 1)),
                                          child: Center(
                                              child: Text(
                                            'Stripe',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: size.width * 0.04),
                                          )),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
