import 'package:chamitosapp/controllers/login_form_controller.dart';
import 'package:chamitosapp/ui/input_decorations.dart';
import 'package:chamitosapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/services.dart';

class RegisterScreen extends StatelessWidget {
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
                'Crear Cuenta',
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
            onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
            child: const Text(
              'Ya tienes una cuenta?',
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
    final registerForm = Get.put(LoginFormController());
    return Form(
        key: registerForm.registerformkey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'john.doe@gmail.com',
                  labelText: 'Correo electronico',
                  prefixIcon: Icons.alternate_email_sharp),
              onChanged: (value) => registerForm.email.value = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);
                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'Ha ingresado un correo no valido';
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
                onChanged: (value) => registerForm.password.value = value,
                validator: (value) {
                  if (value != null && value.length >= 6) return null;
                  return 'La contraseña debe de ser de al menos 6 caracteres';
                }),
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
              onPressed: registerForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final authService = AuthService();
                      if (!registerForm.isValidRegisterForm()) return;

                      registerForm.isLoading = true;

                      final String? errorMessage = await authService.createUser(
                          registerForm.email.value,
                          registerForm.password.value);

                      if (errorMessage == null) {
                        Navigator.pushReplacementNamed(context, 'forms');
                      } else {
                        NotificationsService.showSnackbar(errorMessage);
                        registerForm.isLoading = false;
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
                  registerForm.isLoading ? 'Espere...' : 'Ingresar',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ));
  }
}
