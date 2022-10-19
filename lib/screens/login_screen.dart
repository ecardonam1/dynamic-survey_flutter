import 'package:chamitosapp/controllers/login_form_controller.dart';
import 'package:chamitosapp/services/services.dart';
import 'package:chamitosapp/ui/input_decorations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 250,
          ),
          CardContainer(
              child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                'Login',
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(
                height: 30,
              ),
              _LoginForm(),
            ],
          )),
          const SizedBox(
            height: 50,
          ),
          TextButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(const StadiumBorder()),
                overlayColor:
                    MaterialStateProperty.all(Colors.indigo.withOpacity(0.1))),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, 'register'),
            child: const Text(
              'Crear una nueva cuenta',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    )));
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginFormCtrl = Get.put(LoginFormController());
    return Form(
        key: loginFormCtrl.loginformkey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'john.doe@gmail.com',
                  labelText: 'Correo electronico',
                  prefixIcon: Icons.person),
              onChanged: (value) => loginFormCtrl.email.value = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);
                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'Ha ingresado un correo no válido';
              },
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
                autocorrect: false,
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                    hintText: '****',
                    labelText: 'Password',
                    prefixIcon: Icons.lock_outline),
                onChanged: (value) => loginFormCtrl.password.value = value,
                validator: (value) {
                  if (value != null && value.length >= 6) return null;
                  return 'La contraseña debe de ser de al menos 6 caracteres';
                }),
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
              onPressed: loginFormCtrl.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final authService = AuthService();
                      if (!loginFormCtrl.isValidLoginForm()) return;

                      loginFormCtrl.isLoading = true;

                      final String? errorMessage = await authService.loginUser(
                          loginFormCtrl.email.value,
                          loginFormCtrl.password.value);

                      if (errorMessage == null) {
                        Navigator.pushReplacementNamed(context, 'forms');
                      } else {
                        NotificationsService.showSnackbar(errorMessage);
                        loginFormCtrl.isLoading = false;
                      }
                    },
              disabledColor: Colors.grey,
              color: Colors.deepPurple,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginFormCtrl.isLoading ? 'Espere...' : 'Ingresar',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ));
  }
}
