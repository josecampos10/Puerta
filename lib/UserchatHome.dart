import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class UserchatHome extends StatefulWidget {
  const UserchatHome({super.key});
  @override
  State<UserchatHome> createState() => _UserchatHomeState();
}

class _UserchatHomeState extends State<UserchatHome> {



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(4, 99, 128, 1),
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
              filterQuality: FilterQuality.low,
            ),
          ),
        ),
        title: Container(
            padding: EdgeInsets.only(top: size.height * 0.03),
            child: const Text(
              'Soporte',
            )),
        centerTitle: true,
        titleTextStyle: TextStyle(
            fontFamily: '',
            fontWeight: FontWeight.bold,
            fontSize: size.height * 0.023,
            color: const Color.fromARGB(255, 255, 255, 255)),
        backgroundColor: const Color.fromRGBO(4, 99, 128, 1),
        actions: [],
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * 0.08),
                topRight: Radius.circular(size.width * 0.08))),
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                  height: size.height * 0.9,
                  width: size.width * 1,
                  child: HtmlWidget('''
                  <iframe id="embed-preview-iframe" loading="eager" src="https://embed.pickaxeproject.com/axe?id=La_Puerta_Waco_EWTWZ&mode=embed_gold&host=beta&theme=custom&opacity=100&font_header=Real+Head+Pro&size_header=${size.width * 0.05}&font_body=Real+Head+Pro&size_body=${size.width * 0.04}&font_labels=Real+Head+Pro&size_labels=${size.width * 0.04}&font_button=Real+Head+Pro&size_button=16&c_fb=FFFFFF&c_ff=DEDEDE&c_fbd=090707&c_rb=FFFFFF&c_bb=030303&c_bt=050505&c_t=000000&s_ffo=100&s_rbo=50&s_bbo=100&s_f=box&s_b=filled&s_t=0.5&s_to=1&s_r=0&image=hide" width="${size.width}" height="${size.height * 0.82}" class="transition hover:translate-y-[-2px] hover:shadow-[0_6px_20px_0px_rgba(0,0,0,0.15)]" style="border:0px solid rgba(0, 0, 0, 1);transition:.3s;border-radius:${size.width * 0.08}px;width="${size.width}" height="${size.height}" overflow: auto;" frameBorder="0" scrolling="no"></iframe>
                    '''))
            ],
          ),
        ),
      ),
    );
  }
  /*_buildhtml(){
    HtmlWidget('''
<iframe id="embed-preview-iframe" loading="eager" src="https://embed.pickaxeproject.com/axe?id=La_Puerta_Waco_EWTWZ&mode=embed_gold&host=beta&theme=custom&opacity=100&font_header=Real+Head+Pro&size_header=${size.width * 0.05}&font_body=Real+Head+Pro&size_body=${size.width * 0.04}&font_labels=Real+Head+Pro&size_labels=${size.width * 0.04}&font_button=Real+Head+Pro&size_button=16&c_fb=FFFFFF&c_ff=DEDEDE&c_fbd=090707&c_rb=FFFFFF&c_bb=030303&c_bt=050505&c_t=000000&s_ffo=100&s_rbo=50&s_bbo=100&s_f=box&s_b=filled&s_t=0.5&s_to=1&s_r=0&image=hide" width="${size.width}" height="${size.height * 0.799}" class="transition hover:translate-y-[-2px] hover:shadow-[0_6px_20px_0px_rgba(0,0,0,0.15)]" style="border:0px solid rgba(0, 0, 0, 1);transition:.3s;border-radius:${size.width * 0.08}px;width="${size.width}" height="${size.height}" overflow: auto;" frameBorder="0" scrolling="no"></iframe>
''');
  }*/
}
