import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DonorOnboardingScreen extends StatefulWidget {
  const DonorOnboardingScreen({super.key});

  @override
  State<DonorOnboardingScreen> createState() => _DonorOnboardingScreenState();
}

class _DonorOnboardingScreenState extends State<DonorOnboardingScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/img/Donate2.png',
      'title': 'DONA CON PROPÓSITO'.tr(),
      'description':
          'Gracias por tu interés en apoyar nuestras iniciativas comunitarias. Tu generosidad transforma vidas.'.tr(),
    },
    {
      'image': 'assets/img/people.png',
      'title': 'APOYA A LA COMUNIDAD'.tr(),
      'description':
          'Tu ayuda permite que más personas reciban recursos, educación y esperanza en su día a día.'.tr(),
    },
    {
      'image': 'assets/img/family.png',
      'title': 'TRANSFORMA VIDAS'.tr(),
      'description':
          'Cada donación cuenta. Únete al cambio y forma parte de un impacto duradero en la comunidad.'.tr(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          image: DecorationImage(
              filterQuality: FilterQuality.low,
              image: AssetImage('assets/img/foto5.jpg'),
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3), BlendMode.dstATop),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.1),

            // 📱 PageView (contenido deslizable)
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingData.length,
                onPageChanged: (index) {
                  setState(() => currentIndex = index);
                },
                itemBuilder: (context, index) {
                  final data = onboardingData[index];
                  return Column(
                    children: [
                      Container(
                          height: size.height * 0.55,
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.transparent,
                              image: DecorationImage(
                                //olorFilter: ColorFilter.mode(Colors.blue, BlendMode.),
                                  image: AssetImage(data['image']!),
                                  filterQuality: FilterQuality.low,
                                  fit: BoxFit.scaleDown,
                                  scale: size.height / 400)
                              //image:
                              ),
                          child: Container()),
                      SizedBox(height: size.height * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            data['title']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: size.height * 0.025,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.03),
                      SingleChildScrollView(
                        child: Container(
                          width: size.width * 0.75,
                          height: size.height * 0.1,
                          child: Column(
                            children: [
                              Text(
                                data['description']!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: size.height * 0.018,
                                  color: Colors.white54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            SizedBox(height: size.height * 0.0),

            // 🔘 Indicador de páginas
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(onboardingData.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: currentIndex == index ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: currentIndex == index
                          ? Theme.of(context).colorScheme.tertiary
                          : Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),

            SizedBox(height: size.height * 0.03),

            // ✅ Botón
            Row(
              children: [
                SizedBox(
                  width: size.width * 0.03,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Omitir'.tr())),
                Expanded(child: Container()),
                SizedBox(
                  height: size.height * 0.035,
                  width: size.width * 0.27,
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentIndex == onboardingData.length - 1) {
                        Navigator.pop(context); // Finaliza onboarding
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor: const Color(0xFF034558),
                      //padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentIndex == onboardingData.length - 1
                              ? 'Comenzar'.tr()
                              : 'Siguiente'.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: size.height * 0.013,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.03,
                )
              ],
            ),

            SizedBox(height: size.height * 0.04),
          ],
        ),
      ),
    );
  }
}
