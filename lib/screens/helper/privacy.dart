import 'package:flutter/material.dart';
import 'package:my_app/widgets/language_picker.dart';
import 'package:my_app/widgets/navigation_drawer_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivacyPolicies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appbar_privacy),
        backgroundColor: Color.fromRGBO(63, 63, 156, 1),
        elevation: 0.0,
        actions: <Widget>[
          LanguagePickerWidget(),
          const SizedBox(width: 12),
          // ignore: deprecated_member_use
        ],
      ),
      drawer: NavigationDrawerWidget(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(AppLocalizations.of(context)!.privacy_introduction_topic, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(AppLocalizations.of(context)!.privacy_introduction_info, style: TextStyle(fontSize: 10)),
              SizedBox(height: 10),
              Text(AppLocalizations.of(context)!.privacy_agreement_topic, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(AppLocalizations.of(context)!.privacy_agreement_info, style: TextStyle(fontSize: 10)),
              SizedBox(height: 10),
              Text(AppLocalizations.of(context)!.privacy_effective_topic, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(AppLocalizations.of(context)!.privacy_effective_info, style: TextStyle(fontSize: 10)),
              SizedBox(height: 10),
              Text(AppLocalizations.of(context)!.privacy_policy_topic, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(AppLocalizations.of(context)!.privacy_policy_info, style: TextStyle(fontSize: 10)),
              SizedBox(height: 10),
              Text(AppLocalizations.of(context)!.privacy_personal_topic, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(AppLocalizations.of(context)!.privacy_personal_info, style: TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }
}