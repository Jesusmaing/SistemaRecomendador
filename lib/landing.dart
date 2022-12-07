import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sistemarecomendador/controller/skillProvider.dart';

import 'itemGrid.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer<SkillsProvider>(builder: (context, skillsProvider, child) {
      return Scaffold(
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          controller: scrollController,
          slivers: [
            //appbar with background image and text in center

            const Header(),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  recommendationSliver(),
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E88E5),
                    ),
                    // footer
                    child: Center(
                      child: Text(
                        'Proyecto de Ciencias de la Computación\nUniversidad de Sonora',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: skillsProvider.skills.length >= 3
              ? () async {
                  await skillsProvider.showRecommendationsDialog(context);
                }
              : () {
                  scrollController.animateTo(
                    1100,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Color.fromARGB(255, 229, 30, 30),
                      content: Text('Selecciona al menos 3 habilidades'),
                    ),
                  );
                },
          label: Row(
            children: [
              const Icon(Icons.add),
              const SizedBox(
                width: 10,
              ),
              const Text('Obtener recomendación'),
            ],
          ),
          backgroundColor: const Color(0xFF1E88E5),
        ),
      );
    });
  }

  Container recommendationSliver() {
    return Container(
      width: double.infinity,

      // background image
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/landing-page-background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          // text field search and list of 100 items in grid of 10 items per row
          const SizedBox(
            width: 500,
            child: Text(
              '¿Cómo funciona?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF262626),
                fontSize: 36,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            width: 500,
            child: Text(
              'Es muy sencillo, y lo diseñamos para que sea fácil de usar.',
              style: TextStyle(
                color: Color.fromARGB(181, 38, 38, 38),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // 3 container with icon and text in center
          const SizedBox(
            height: 50,
          ),
          Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.start,
            spacing: 100,
            runSpacing: 30,
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // circular container and color blue
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E88E5),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(90, 0, 0, 0),
                            offset: Offset(5, 13),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(
                        'assets/brain.svg',
                        width: 40,
                        height: 40,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '1. Ingresa tus habilidades',
                      style: TextStyle(
                        color: Color(0xFF262626),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      width: 200,
                      child: Text(
                        'Tienes que elegir minimo 3 habilidades que consideres tener o que te gustaría aprender.',
                        style: TextStyle(
                          color: Color.fromARGB(181, 38, 38, 38),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // circular container and color blue
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                          color: Color(0xFF1E88E5),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(90, 0, 0, 0),
                              offset: Offset(5, 13),
                              blurRadius: 6,
                            ),
                          ]),
                      child: SvgPicture.asset(
                        'assets/task-list.svg',
                        width: 40,
                        height: 40,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '1. Presiona el botón',
                      style: TextStyle(
                        color: Color(0xFF262626),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      width: 200,
                      child: Text(
                        'Obtendrás una lista de 20 trabajos que se ajustan a las habilidades seleccionadas.',
                        style: TextStyle(
                          color: Color.fromARGB(181, 38, 38, 38),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // circular container and color blue
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                          color: Color(0xFF1E88E5),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(90, 0, 0, 0),
                              offset: Offset(5, 13),
                              blurRadius: 6,
                            ),
                          ]),
                      child: SvgPicture.asset(
                        'assets/office.svg',
                        width: 40,
                        height: 40,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '1. ¡Manos a la obra!',
                      style: TextStyle(
                        color: Color(0xFF262626),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      width: 200,
                      child: Text(
                        'Si te interesa alguno de estos trabajos, podrás buscar más información de lo que necesitas para aplicar en internet.',
                        style: TextStyle(
                          color: Color.fromARGB(181, 38, 38, 38),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: double.infinity,
            child: Consumer<SkillsProvider>(
                builder: (context, skillsProvider, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Habilidades seleccionadas: ${skillsProvider.skills.length} / 3',
                    style: const TextStyle(
                      color: Color(0xFF262626),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Wrap(
                    children: skillsProvider.skills
                        .map((e) => InkWell(
                              onTap: () {
                                skillsProvider.removeSkill(e);
                              },
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E88E5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  e,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  skillsProvider.skills.length < 3
                      ? const SizedBox(
                          height: 20,
                          child: Text(
                            'Selecciona al menos 3 habilidades para poder continuar',
                            style: TextStyle(
                              color: Color.fromARGB(181, 59, 59, 59),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            onTap: () {
                              skillsProvider.showRecommendationsDialog(context);
                            },
                            child: const Text(
                              '¡Listo! Puedes presionar el botón',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                ],
              );
            }),
          ),

          const SkillsGrid(),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> with TickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: 70,
      stretch: true,
      pinned: true,
      snap: false,
      floating: false,
      backgroundColor: const Color(0xFF4441D5),
      expandedHeight: 1000,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(alignment: Alignment.topCenter, children: [
          Container(
            height: 1000,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background-original.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          //FILTER WHITE
          Container(
            color: const Color.fromARGB(22, 238, 238, 238),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Expanded(
                  flex: MediaQuery.of(context).size.width > 800 ? 8 : 12,
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 400,
                          child: Text(
                            'Sistema Recomendador de Trabajos',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width > 800
                                  ? 56
                                  : 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 400,
                              child: Text(
                                'Obtén recomendaciones de trabajos basados en tus gustos y habilidades',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 15),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text('¡Pruebalo!'))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: SizedBox(
                    child: Lottie.network(
                        'https://assets4.lottiefiles.com/packages/lf20_tyi61jpp.json',
                        animate: true,
                        frameRate: FrameRate.max,
                        width: 800,
                        repeat: true,
                        controller: _controller, onLoaded: (composition) {
                      // INFINITE LOOP
                      _controller
                        ..duration = composition.duration
                        ..forward()
                        ..repeat();
                    }),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
      title: const Text(
        'Sistema Recomendador de Trabajos',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        // medium, github and linkedin text buttons
        TextButton(
          onPressed: () {},
          child: const Text(
            'Medium',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Github',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Linkedin',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
