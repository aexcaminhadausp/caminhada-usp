import 'package:app/components/login_field.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _handleRegister() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showMessage("Preencha todos os campos", Colors.redAccent);
      return;
    }

    setState(() => isLoading = true);
    final success = await ApiService.register(name, email, password);
    setState(() => isLoading = false);

    if (success) {
      _showMessage("Conta criada com sucesso! Faça login.", Colors.green);
      if (!mounted) return;
      Navigator.pop(context); // Volta para a tela de login
    } else {
      _showMessage("Erro ao criar conta. Tente outro e-mail.", Colors.redAccent);
    }
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [Colors.white, Colors.lightGreen,]
                )
            ),
            child: Column(children: [
                const SizedBox(height: 100,),
                Center(
                    child: Image.asset(
                        "assets/images/logo-pronto.png",
                        height: 100,),
                ),
                const SizedBox(height: 30,),
                Expanded(child: Container(
                    decoration: BoxDecoration(
                       color: Colors.green[800],
                       borderRadius: const BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)) 
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Center( child: SingleChildScrollView( child: Column(
                            children: [
                                const Text("Crie sua conta", 
                                    textAlign: TextAlign.center, 
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, 
                                        fontSize: 40,
                                        color: Colors.white),
                                ),
                                const SizedBox(height: 5,),
                                const Text("Preencha os dados abaixo para se cadastrar",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white
                                    ),),
                                const SizedBox(height: 15,),
                                Container(
                                    padding: const EdgeInsets.all(25),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: const BorderRadius.all(Radius.circular(30)),
                                    ),
                                      child: Column(children: [
                                          LoginField(controller: nameController, obscureText: false, hintText: "Nome",),
                                          const SizedBox(height: 15,),
                                          LoginField(controller: emailController, obscureText: false, hintText: "Email",),
                                          const SizedBox(height: 15,),
                                          LoginField(controller: passwordController, obscureText: true, hintText: "Senha",),
                                          const SizedBox(height: 30,),
                                          SizedBox(
                                              width: double.infinity,
                                              height: 50,
                                              child: ElevatedButton(
                                              onPressed: isLoading ? null : _handleRegister,
                                              style: ElevatedButton.styleFrom(
                                                  elevation: 2,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                      side: const BorderSide(color: Colors.blue)
                                                  ),
                                                  backgroundColor: Colors.blueAccent
                                              ),
                                              child: isLoading 
                                                  ? const CircularProgressIndicator(color: Colors.white)
                                                  : const Text("Cadastrar", style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold
                                                  )),
                                              )
                                          ),
                                          const SizedBox(height: 10,),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                  const Text("Já possui conta?"),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context); // Retorna à tela de Login
                                                      },
                                                      child:const  Text('Entrar',
                                                          style: TextStyle(color: Colors.blue, 
                                                          decoration: TextDecoration.underline,
                                                          decorationColor: Colors.blue,
                                                          fontWeight: FontWeight.bold,
                                                          ),
                                                      ),
                                                  )
                                              ],
                                          )
                                      ],),
                                ),
                                ],
                        ),),),
                ))
                )
            ],),
        ),
    );
  }
}