import 'package:app/components/login_button.dart';
import 'package:app/components/login_field.dart';
import 'package:app/screens/home_scaffold.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  bool isLoading = false;
  String? errorMessage;

  bool rememberMe = false;


  /// Função para realizar o login real via API
  Future<void> _handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError("Preencha todos os campos");
      return;
    }

    setState(() => isLoading = true);

    // Chamada ao serviço de API que criamos
    final success = await ApiService.login(email, password);

    if (!mounted) return;

    setState(() => isLoading = false);

    if (success) {
      // Navega para a HomeScaffold se o login for bem-sucedido
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (_) => const HomeScaffold())
      );
    } else {
      _showError("E-mail ou senha incorretos");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message), 
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [ Colors.white,Colors.lightGreen,]
                )
            ),
            child: Column(children: [
                SizedBox(height: 100,),
                Center(
                    child: Image.asset(
                        "assets/images/logo-pronto.png",
                        height: 100,),
                ),
                SizedBox(height: 30,),
                Expanded(child: Container(
                    decoration: BoxDecoration(
                       color: Colors.green[800],
                       borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)) 
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(25),
                        child: Center( child: Column(
                            children: [
                                const Text("Acesse sua conta", 
                                    textAlign: TextAlign.center, 
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, 
                                        fontSize: 40,
                                        color: Colors.white),
                                ),
                                const SizedBox(height: 5,),
                                const Text("Insira o seu email para entrar na sua conta",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white
                                    ),),
                                const SizedBox(height: 15,),
                                Container(
                                    padding: EdgeInsets.all(25),
                                    height: 500,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.all(Radius.circular(30)),
                                    ),
                                    child: Column(children: [
                                        LoginButton(),
                                        const SizedBox(height: 10,),
                                        Divider(),
                                        const SizedBox(height: 10,),
                                        LoginField(controller: emailController, obscureText: false, hintText: "Email",),
                                        const SizedBox(height: 15,),
                                        LoginField(controller: passwordController, obscureText: true, hintText: "Senha",),
                                        const SizedBox(height: 5,),
                                        Row(
                                            children: [
                                                Checkbox(
                                                value: rememberMe,
                                                onChanged: (value) {
                                                    setState(() {
                                                    rememberMe = value!;
                                                    });
                                                },
                                                ),
                                                const Text('Lembrar de mim'),
                                                const Spacer(),
                                                TextButton(
                                                    onPressed: () {},
                                                    child: Text('Esqueceu a senha?',
                                                        style: TextStyle(color: Colors.grey[600], 
                                                        decoration: TextDecoration.underline,
                                                        ),
                                                    ),
                                                )
                                            ],
                                        ),
                                        SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: ElevatedButton(
                                            onPressed: isLoading ? null : _handleLogin,
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
                                                : const Text("Entrar", style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold
                                                )),
                                            )
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                                const Text("Não possui conta?"),
                                                TextButton(
                                                    onPressed: () {},
                                                    child:const  Text('Criar Conta',
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
                        ),),
                ))
                )
            ],),
        ),
    );
  }
}