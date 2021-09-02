import 'package:flutter/material.dart';
import 'package:my_app/screens/authenticate/authenticate.dart';
import 'package:my_app/screens/home/home.dart';
import 'package:my_app/screens/wrapper.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/ui/input_decorations.dart';
import 'package:my_app/widgets/auth_background.dart';
import 'package:my_app/widgets/card_container.dart';
import 'package:my_app/widgets/language_picker.dart';
import 'package:my_app/widgets/loading.dart';
import 'package:my_app/widgets/login_form_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class verifyEmail extends StatefulWidget {
  @override
  _verifyEmailState createState() => _verifyEmailState();
}

class _verifyEmailState extends State<verifyEmail> {

  final AuthService _auth = AuthService();
  bool loading = false;

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
                    Text(AppLocalizations.of(context)!.verifyEmail_title, style: Theme.of(context).textTheme.headline4, textAlign: TextAlign.center, ),
                    SizedBox( height: 30 ),
                    Text(AppLocalizations.of(context)!.verifyEmail_message),
                    ElevatedButton(
                        child: Text(AppLocalizations.of(context)!.verifyEmail_resend_button),
                        onPressed: () => null,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pink[400],
                        )
                      ),
                  ],
                )
              ),
              SizedBox( height: 10 ),
              Padding(
                padding: EdgeInsets.symmetric( horizontal: 30 ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all( 20 ),
                  child: Column(
                    children: [
                      ElevatedButton(
                        child: Text(AppLocalizations.of(context)!.verifyEmail_login_button),
                        onPressed: () {
                          _auth.signOut();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pink[400],
                        )
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        )
      ),
    );
  }
}