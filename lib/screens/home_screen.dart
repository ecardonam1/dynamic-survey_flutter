import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => Get.offNamed("/login")),
        centerTitle: true,
        title: const Text('Menu'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              onPressed: () {
                Get.toNamed("/forms");
              },
              child: const Text('Crear nueva encuesta')),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                Get.toNamed("/surveys");
              },
              child: const Text('Mis encuestas')),
        ]),
      ),
    );
  }
}
