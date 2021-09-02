import 'package:flutter/material.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/ui/input_decorations.dart';
import 'package:my_app/widgets/auth_background.dart';
import 'package:my_app/widgets/card_container.dart';
import 'package:my_app/widgets/language_picker.dart';
import 'package:my_app/widgets/loading.dart';
import 'package:my_app/widgets/login_form_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ required this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // Text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(90, 70, 178, 1),
        actions: [
          LanguagePickerWidget(),
          const SizedBox(width: 12),
        ],
      ),
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox( height: 250 ),
              CardContainer(
                child: Column(
                  children: [
                    SizedBox( height: 10 ),
                    Text(AppLocalizations.of(context)!.login_title, style: Theme.of(context).textTheme.headline4 ),
                    SizedBox( height: 30 ),
                    ChangeNotifierProvider(
                      create: ( _ ) => LoginFormProvider(),
                      child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 20.0),
                                  TextFormField(
                                    autocorrect: false,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecorations.authInputDecoration(
                                      hintText: 'john.doe@gmail.com',
                                      labelText: AppLocalizations.of(context)!.mail_field,
                                      prefixIcon: Icons.alternate_email_rounded
                                    ),
                                    validator: (val) => !val!.contains('@') ? AppLocalizations.of(context)!.mail_field_error : null,
                                    onChanged: (val) {
                                      setState(() => email = val);
                                    },
                                  ),
                                  SizedBox(height: 20.0),
                                  TextFormField(
                                    autocorrect: false,
                                    obscureText: true,
                                    decoration: InputDecorations.authInputDecoration(
                                      hintText: '************',
                                      labelText: AppLocalizations.of(context)!.password_field,
                                      prefixIcon: Icons.lock_outline
                                    ),
                                    validator: (val) => val!.isEmpty ? AppLocalizations.of(context)!.password_field_error : null,
                                    onChanged: (val) {
                                      setState(() => password = val);
                                    },
                                  ),
                                  SizedBox(height: 20.0),
                                  ElevatedButton(
                                    child: Text(AppLocalizations.of(context)!.signIn_button,),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()){
                                        setState(() => loading = true);
                                        dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                                        if(result == null){
                                          setState(() {
                                            error = AppLocalizations.of(context)!.login_error;
                                            loading = false;
                                          }); 
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.pink[400],
                                    )
                                    ),
                                    SizedBox(height: 12.0),
                                    Text(
                                      error,
                                      style: TextStyle(color: Colors.red, fontSize: 14.0))
                                ],
                              ),
                            ),
                    )
                  ],
                )
              ),
              SizedBox( height: 50 ),
              TextButton(
                onPressed: () => widget.toggleView(), 
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all( Colors.indigo.withOpacity(0.1)),
                  shape: MaterialStateProperty.all( StadiumBorder() )
                ),
                child: Text(AppLocalizations.of(context)!.createAccount_button, style: TextStyle( fontSize: 18, color: Colors.black87 ),)
              ),
              SizedBox( height: 50 ),
            ],
          )
        )
      ),
    );
  }
}