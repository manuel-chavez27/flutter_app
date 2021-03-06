import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/screens/appointment/created.dart';
import 'package:my_app/services/constants.dart';
import 'package:my_app/services/database.dart';
import 'package:my_app/ui/input_decorations.dart';
import 'package:my_app/widgets/language_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateAppointment extends StatefulWidget {
  const CreateAppointment({ Key? key, required this.bundle, required this.price }) : super(key: key);

  final String bundle;
  final String price;

  @override
  _CreateAppointmentState createState() => _CreateAppointmentState();
}



class _CreateAppointmentState extends State<CreateAppointment> {

  TextEditingController dateCtl = TextEditingController();
  TextEditingController timeCtl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? address;
  String? city;
  String? zip;
  int? bundlePicked;

  DateTime? _dateTime;
  String? dateFormat;
  String? timeFormat;

  Timestamp? finalDate;

  getBundle(bundle) {
    if(bundle=='Exterior Wash' || bundle=='Lavado Exterior') {
      bundlePicked=1;
    } else if(bundle=='Cleaning and Vacuuming' || bundle=='Lavado y Aspirado') {
      bundlePicked=2;
    } else if(bundle=='Deluxe Wash' || bundle=='Lavado Deluxe') {
      bundlePicked=3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(AppLocalizations.of(context)!.appointment_checkout, style: TextStyle(color: Colors.white)),
            Text(widget.bundle, style: Theme.of(context).textTheme.caption),
          ],
        ),
        actions: <Widget>[
          LanguagePickerWidget(),
          const SizedBox(width: 12),
          // ignore: deprecated_member_use
        ]
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(),
                    Text(AppLocalizations.of(context)!.appointment_address),
                    TextFormField(
                      autocorrect: false,
                      keyboardType: TextInputType.streetAddress,
                      decoration: InputDecoration(
                                    hintText: '',
                                    labelText: AppLocalizations.of(context)!.appointment_address,
                                    prefixIcon: Icon(Icons.house),
                                  ),
                      validator: (val) => val!.isEmpty ? 'error' : null,
                      onChanged: (val) {
                        setState(() => address = val);
                      },
                    ),
                    TextFormField(
                      autocorrect: false,
                      keyboardType: TextInputType.streetAddress,
                      decoration: InputDecoration(
                                    hintText: '',
                                    labelText: AppLocalizations.of(context)!.appointment_city,
                                    prefixIcon: Icon(Icons.location_city),
                                  ),
                      validator: (val) => val!.isEmpty ? 'error' : null,
                      onChanged: (val) {
                        setState(() => city = val);
                      },
                    ),
                    TextFormField(
                      autocorrect: false,
                      keyboardType: TextInputType.streetAddress,
                      decoration: InputDecoration(
                                    hintText: '',
                                    labelText: AppLocalizations.of(context)!.appointment_zip,
                                    prefixIcon: Icon(Icons.location_on),
                                  ),
                      validator: (val) => val!.isEmpty ? 'error' : null,
                      onChanged: (val) {
                        setState(() => zip = val);
                      },
                    ),
                    SizedBox(height: 20),
                    Text(AppLocalizations.of(context)!.appointment_date),
                    TextFormField(
                      controller: dateCtl,
                      decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)!.appointment_date,
                                    prefixIcon: Icon(Icons.date_range),
                                  ),
                      validator: (val) => val!.isEmpty ? 'error' : null,
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2022)
                        ).then((date) {
                          setState(() {
                            _dateTime = date!.add(new Duration(hours: 18));
                            dateFormat = DateFormat('yyyy-MM-dd').format(date);
                            dateCtl.text=dateFormat!;
                            finalDate = Timestamp.fromDate(_dateTime);
                            print('Timestamp: $finalDate');
                          });
                        });
                      }
                    ),
                    SizedBox(height: 20),
                    Text(AppLocalizations.of(context)!.appointment_time),
                    TextFormField(
                      controller: timeCtl,
                      decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)!.appointment_time,
                                    prefixIcon: Icon(Icons.timelapse),
                                  ),
                      validator: (val) => val!.isEmpty ? 'error' : null,
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          builder: (context, child) => MediaQuery(
                            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                            child: child!,
                          ),
                        ).then((time) => {
                          setState(() {
                            timeFormat = time!.format(context);
                            timeCtl.text=timeFormat!;
                          })
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    Text(AppLocalizations.of(context)!.appointment_details),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(AppLocalizations.of(context)!.appointment_bundle+': '+widget.bundle),
                          SizedBox(height: 10),
                          Text(AppLocalizations.of(context)!.appointment_price+': '+widget.price,style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      )
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      child: Text(AppLocalizations.of(context)!.appointment_creation),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()){
                          String employee = await DatabaseService().getRandomEmployee();
                          List<String> users = [employee, Constants.myName];
                          getBundle(widget.bundle);
                          String appointmentID = dateFormat!;
                          Map<String, dynamic> appointmentMap = {
                            "users": users,
                            "address": address,
                            "appointmentID" : appointmentID,
                            "bundle": bundlePicked,
                            "city": city,
                            "date": finalDate,
                            "time": timeFormat,
                            "zip": zip,
                          };
                          DatabaseService().createAppointment(appointmentID, appointmentMap);
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) => AppointmentCreated(bundle: bundlePicked!, price: widget.price, date: dateFormat!, time: timeFormat!,),
                          ));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue[400],
                      )
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}