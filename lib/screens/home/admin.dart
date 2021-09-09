import 'package:flutter/material.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/widgets/language_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Admin extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('CarWash'),
        backgroundColor: Color.fromRGBO(63, 63, 156, 1),
        elevation: 0.0,
        actions: <Widget>[
          LanguagePickerWidget(),
          const SizedBox(width: 12),
          // ignore: deprecated_member_use
          FlatButton.icon(
            icon: Icon(Icons.person),
            onPressed: () async{
              await _auth.signOut();
            },
            label: Text(AppLocalizations.of(context)!.logout_button),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Admin view, you are logged in as an Admin'),
          ],
        ),
      ),
    );
  }
}