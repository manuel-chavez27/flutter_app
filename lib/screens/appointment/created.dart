import 'package:flutter/material.dart';
import 'package:my_app/screens/wrapper.dart';
import 'package:my_app/widgets/card_container.dart';
import 'package:my_app/widgets/language_picker.dart';
import 'package:my_app/widgets/loading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppointmentCreated extends StatefulWidget {
  const AppointmentCreated({ Key? key, required this.bundle, required this.price, required this.date, required this.time }) : super(key: key);

  final String bundle;
  final String price;
  final String date;
  final String time;

  @override
  _AppointmentCreatedState createState() => _AppointmentCreatedState();
}

class _AppointmentCreatedState extends State<AppointmentCreated> {

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
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox( height: 30 ),
              CardContainer(
                child: Column(
                  children: [
                    SizedBox( height: 10 ),
                    Text(AppLocalizations.of(context)!.appointment_created, style: Theme.of(context).textTheme.headline4, textAlign: TextAlign.center, ),
                    SizedBox( height: 30 ),
                    Text(AppLocalizations.of(context)!.appointment_info),
                    SizedBox(height: 10),
                    Text(AppLocalizations.of(context)!.appointment_bundle+': '+widget.bundle),
                    Text(AppLocalizations.of(context)!.appointment_date+': '+widget.date),
                    Text(AppLocalizations.of(context)!.appointment_time+': '+widget.time),
                    Text(AppLocalizations.of(context)!.appointment_price+': '+widget.price),
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
                        child: Text(AppLocalizations.of(context)!.home_sideMenu),
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) => Wrapper(),
                          ));
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