import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:learn/components/gradient_button.dart';
import 'package:learn/widgets/login/loginAppBar.dart';
import 'package:learn/widgets/login/loginInfoContainter.dart';
import 'package:learn/classes.dart';
import 'package:learn/components/newBack_button.dart';
import 'package:learn/pages/loginPage.dart';

class LoginInputFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginInputFields({
    Key? key,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
              height: 54,
              child: TextField(
                controller: emailController,
                style: const TextStyle(
                    fontFamily: "Spartan",
                    fontWeight: FontWeight.w500,
                    color: Color(0xff626262),
                    fontSize: 14),
                decoration: InputDecoration(
                  labelStyle: const TextStyle(
                      fontFamily: "Spartan",
                      fontWeight: FontWeight.w500,
                      color: Color(0xff626262),
                      fontSize: 14),
                  labelText: 'E-mail',
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(46)),
                ),
                keyboardType: TextInputType.emailAddress,
              )),
          const SizedBox(height: 16),
          SizedBox(
            height: 54,
            child: TextField(
              controller: passwordController,
              style: const TextStyle(
                  fontFamily: "Spartan",
                  fontWeight: FontWeight.w500,
                  color: Color(0xff5A5A5A),
                  fontSize: 14),
              decoration: InputDecoration(
                labelStyle: const TextStyle(
                    fontFamily: "Spartan",
                    fontWeight: FontWeight.w500,
                    color: Color(0xff9A9A9A),
                    fontSize: 14),
                labelText: 'Senha',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(46)),
              ),
              obscureText: true,
            ),
          )
        ],
      ),
    );
  }
}

class LoginParentsPage extends StatefulWidget {
  @override
  _LoginParentsPageState createState() => _LoginParentsPageState();
}

class _LoginParentsPageState extends State<LoginParentsPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: CoinnyBackButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(builder: (context) => LoginPage()
                      )
                    );
                  }
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16), 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    const LoginInfoContainer(
                        title: "Seja bem-vindo\nde volta!",
                        description:
                            "Insira suas credenciais para acessar o aplicativo da Coinny."),
                    const SizedBox(height: 32),
                    LoginInputFields(
                      emailController: _emailController,
                      passwordController: _passwordController,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Esqueci minha senha',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontFamily: "Spartan",
                        fontWeight: FontWeight.w500,
                        fontSize: 10
                      ),
                    ),
                    const SizedBox(height: 64),
                    CoinnyGradientButton(
                        onPressed: () async {
                          try {
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                            print('Credencial: $credential');
        
                            User? parent = credential.user;
                            print('Parent: $parent');
                            if (parent != null) {
                              Parents parentUser =
                                  await loadParent(parent.email ?? "");
                              Navigator.pushReplacementNamed(
                                  context, '/parentsMain',
                                  arguments: parentUser);
                              print(
                                  'Parent user is AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA $parentUser');
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              print('No user found for that email.');
                            } else if (e.code == 'wrong-password') {
                              print('Wrong password provided for that user.');
                            } else {
                              print('the error is $e');
                            }
                            rethrow;
                          } on Exception catch (e) {
                            String error = e.toString();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'As credenciais informadas não são válidas, tente novamente $error')));
                          }
                        },
                        title: "ENTRAR",
                        color: const Color(0xFF5D61D6)),
                        const SizedBox(height: 32),
                        Center(
                          child: RichText(
                          text: TextSpan(
                            text: 'Ainda não é cadastrado? ',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF060C20),
                              fontFamily: "Fieldwork-Geo",
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(
                                text: 'Cadastre-se',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(context, '/signUp');
                                  },
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF646AE3),
                                
                                ),
                              ),
                            ],
                          ),
                        ),
                        )
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }
}
