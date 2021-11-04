import 'package:flutter/material.dart';
import 'package:my_app/widgets/language_picker.dart';
import 'package:my_app/widgets/navigation_drawer_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Faq extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('FAQ'),
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
              questions(AppLocalizations.of(context)!.faq_first_question),
              SizedBox(height: 5),
              Text((AppLocalizations.of(context)!.faq_first_answer), style: TextStyle(fontSize: 10),),
              SizedBox(height: 10),
              questions(AppLocalizations.of(context)!.faq_second_question),
              SizedBox(height: 5),
              Text((AppLocalizations.of(context)!.faq_second_answer), style: TextStyle(fontSize: 10),),
              SizedBox(height: 10),
              questions(AppLocalizations.of(context)!.faq_third_question),
              SizedBox(height: 5),
              Text((AppLocalizations.of(context)!.faq_third_answer), style: TextStyle(fontSize: 10),),
              Divider(),
              Text((AppLocalizations.of(context)!.faq_first_details), style: TextStyle(fontSize: 10),),
              SizedBox(height: 5),
              Text((AppLocalizations.of(context)!.faq_second_details), style: TextStyle(fontSize: 10),),
              SizedBox(height: 10),
              questions(AppLocalizations.of(context)!.faq_fourth_question),
              SizedBox(height: 5),
              Text((AppLocalizations.of(context)!.faq_fourth_answer), style: TextStyle(fontSize: 10),),
              SizedBox(height: 10),
              questions(AppLocalizations.of(context)!.faq_fifth_question),
              SizedBox(height: 5),
              Text((AppLocalizations.of(context)!.faq_fifth_answer), style: TextStyle(fontSize: 10),),
              SizedBox(height: 10),
              questions(AppLocalizations.of(context)!.faq_sixth_question),
              SizedBox(height: 5),
              Text((AppLocalizations.of(context)!.faq_sixth_answer), style: TextStyle(fontSize: 10),),
              SizedBox(height: 10),
              questions(AppLocalizations.of(context)!.faq_seventh_question),
              SizedBox(height: 5),
              Text((AppLocalizations.of(context)!.faq_seventh_answer), style: TextStyle(fontSize: 10),),
              SizedBox(height: 10),
              questions(AppLocalizations.of(context)!.faq_eighth_question),
              SizedBox(height: 5),
              Text((AppLocalizations.of(context)!.faq_eighth_answer), style: TextStyle(fontSize: 10),),
              SizedBox(height: 10),
              questions(AppLocalizations.of(context)!.faq_ninth_question),
              SizedBox(height: 5),
              Text((AppLocalizations.of(context)!.faq_ninth_answer), style: TextStyle(fontSize: 10),),
              SizedBox(height: 10),
              questions(AppLocalizations.of(context)!.faq_tenth_question),
              SizedBox(height: 5),
              Text((AppLocalizations.of(context)!.faq_tenth_answer), style: TextStyle(fontSize: 10),),
              SizedBox(height: 10),
              questions(AppLocalizations.of(context)!.faq_eleventh_question),
              SizedBox(height: 5),
              Text((AppLocalizations.of(context)!.faq_eleventh_answer), style: TextStyle(fontSize: 10),),
              SizedBox(height: 10),
              questions(AppLocalizations.of(context)!.faq_twelfth_question),
              SizedBox(height: 5),
              Text((AppLocalizations.of(context)!.faq_twelfth_answer), style: TextStyle(fontSize: 10),),
              SizedBox(height: 10),
              questions(AppLocalizations.of(context)!.faq_thirteenth_question),
              SizedBox(height: 5),
              Text((AppLocalizations.of(context)!.faq_thirteenth_answer), style: TextStyle(fontSize: 10),),
              SizedBox(height: 10),
              questions(AppLocalizations.of(context)!.faq_fourteenth_question),
              SizedBox(height: 5),
              Text((AppLocalizations.of(context)!.faq_fourteenth_answer), style: TextStyle(fontSize: 10),),
              SizedBox(height: 10),
              questions(AppLocalizations.of(context)!.faq_fifteenth_question),
              SizedBox(height: 5),
              Text((AppLocalizations.of(context)!.faq_fifteenth_answer), style: TextStyle(fontSize: 10),),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget questions(text) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12)),
      decoration: BoxDecoration(
        color: Colors.yellow[700],
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}