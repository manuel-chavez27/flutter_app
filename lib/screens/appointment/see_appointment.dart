import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/screens/appointment/selected_appointment.dart';
import 'package:my_app/services/constants.dart';
import 'package:my_app/services/database.dart';
import 'package:my_app/services/helperfunctions.dart';
import 'package:my_app/widgets/language_picker.dart';
import 'package:my_app/widgets/navigation_drawer_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyAppointments extends StatefulWidget {
  const MyAppointments({ Key? key }) : super(key: key);

  @override
  _MyAppointmentsState createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends State<MyAppointments> {

  DatabaseService databaseMethods = new DatabaseService();

  String? bundleValue;
  String? answerValue;
  String? filterValue;
  String? customerFilter;
  String filter = 'none';
  String dateFormat = 'Choose a Date';
  String timeFormat = 'Choose a Hour';

  int? length;
  int bundle = 0;

  bool customersCalled = false;

  DateTime? _dateTime;
  
  Stream? appointmentStream;
  Stream? customerStream;

  List<String> customers = [];
  List<String> filters = [];


  Widget appointmentList(length) {
    return StreamBuilder(
      stream: appointmentStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: (snapshot.data! as QuerySnapshot).documents.length,
          itemBuilder: (context, index) {
            return AppointmentsTile((snapshot.data! as QuerySnapshot ).documents[index]["appointmentID"], (snapshot.data! as QuerySnapshot).documents[index]["bundle"], (snapshot.data! as QuerySnapshot).documents[index]["time"]);
          },
        ) : Container(child: Text('You have no appointments'));
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState(); 
  }

  _getFilterList(value) async {
  if(value=='Bundles' || value=='Paquetes'){
    print('Filtrando Bundles');
    filters = [AppLocalizations.of(context)!.first_bundle, AppLocalizations.of(context)!.second_bundle, AppLocalizations.of(context)!.third_bundle];
  }else if(value=='Customer' || value=='Clientes'){
    print('Filtrando customers');
    filters = customers;
  }
}


  getUserInfo() async {
    print('FilterValue: $filterValue');
    print('Filter es: $filter');
    if(filter=='none') {
      print('No estoy usando filtros');
      Constants.myName = await HelperFunctions.getUserNameSharedPreference();
      databaseMethods.getAppointments().then((value){
        setState(() {
          appointmentStream = value;
        });
      });
    }else if(filter=='Bundles') {
      print('Filtrando por bundles');
      databaseMethods.getAppointmentsBundle(bundle).then((value){
      setState(() {
        appointmentStream = value;
      });
    });
    }else if(filter=='Customers') {
      print('Filtrando por Customers');
      databaseMethods.getAppointmentsCustomer(customerFilter!).then((value) {
        setState(() {
          appointmentStream = value;
        });
      });
    }else if(filter=='Date'){
      print('Filtrando por Fecha');
      databaseMethods.getAppointmentsDate(customerFilter!).then((value) {
        setState(() {
          appointmentStream = value;
        });
      });
    }else if(filter=='Time'){
      print('Filtrando por Hora');
      databaseMethods.getAppointmentsTime(customerFilter!).then((value) {
        setState(() {
          appointmentStream = value;
        });
      });
    }
  }

  getCustomers() async {
    print('Llamando clientes');
    await databaseMethods.getCustomers().then((value){
      for(int i = 0; i<value.documents.length; i++) {
        customers.add(value.documents[i]["username"]);
      }
    });
    customersCalled = true;
    print('Clientes llamados');
    
  }

  @override
  Widget build(BuildContext context) {
    List<String> bundles = [AppLocalizations.of(context)!.first_bundle, AppLocalizations.of(context)!.second_bundle, AppLocalizations.of(context)!.third_bundle];
    List<String> options = [AppLocalizations.of(context)!.filter_bundles, AppLocalizations.of(context)!.filter_customers, AppLocalizations.of(context)!.filter_date, AppLocalizations.of(context)!.filter_time];
    
    
                        
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appbar_appointment),
        backgroundColor: Color.fromRGBO(63, 63, 156, 1),
        elevation: 0.0,
        actions: <Widget>[
          LanguagePickerWidget(),
          const SizedBox(width: 12),
          // ignore: deprecated_member_use
        ],
      ),
      drawer: NavigationDrawerWidget(),
      body: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              // Search Filter
              Container(
                width: 200,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: filterValue,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                    iconSize: 36,
                    items: options.map(buildMenuItem).toList(),
                    onChanged: (value) async {
                      if(value=='Customer' || value=='Clientes') {
                        if(customersCalled==false) {
                          await getCustomers();
                        }
                      }
                      setState(() {
                        answerValue = null;
                        this.filterValue = value;
                        _getFilterList(value);
                        filter='none';
                        getUserInfo();
                        dateFormat = AppLocalizations.of(context)!.date_format;
                        timeFormat = AppLocalizations.of(context)!.time_format;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(width: 10),
              // Filter Answer
               Container(
                width: 200,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: filterValue=='Date'|| filterValue=='Fecha' ? DropdownButton<DateTime>(
                    hint: Text('Choose A Date'),
                    items: [
                      dateFormat
                    ].map((e) => DropdownMenuItem<DateTime>(child: Text(e))).toList(),
                    onChanged: (DateTime? value) {
                    showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2021),
                          lastDate: DateTime(2022)
                        ).then((date) {
                          setState(() {
                            _dateTime = date;
                            dateFormat = DateFormat('yyyy-MM-dd').format(date!);
                            print('Procederé a filtrar por fecha');
                            filter='Date';
                            customerFilter = dateFormat;
                            getUserInfo();
                          });
                        });
                    }) : filterValue=='Time' || filterValue=='Hora' ? DropdownButton<TimeOfDay>(
                      hint: Text('Choose a Hour'),
                      items: [
                      timeFormat
                    ].map((e) => DropdownMenuItem<TimeOfDay>(child: Text(e))).toList(),
                    onChanged: (TimeOfDay? value) {
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
                            print('Procederé a filtrar por Hora');
                            filter='Time';
                            customerFilter = timeFormat;
                            getUserInfo();
                          })
                        });
                    },
                    ) : DropdownButton<String>(
                    value: answerValue,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                    iconSize: 36,
                    items: filters.map(buildMenuItem).toList(),
                    onChanged: (value) async {
                      //length = await databaseMethods.getLength(value!, Constants.myName);
                      setState(() {
                        this.answerValue = value;
                        if(filterValue=='Bundles' || filterValue=='Paquetes') {
                          print('Procederé a filtrar por Bundles');
                          filter='Bundles';
                          if(value=='Exterior Wash' || value=='Lavado Exterior') {
                            bundle=1;
                          } else if(value=='Cleaning and Vacuuming' || value=='Lavado y Aspirado') {
                            bundle=2;
                          } else{
                            bundle=3;
                          }
                          setState(() {
                            appointmentList(length);
                          });
                          getUserInfo();
                        }else if(filterValue=='Customer' || filterValue=='Clientes') {
                          print('Procederé a filtrar por customers');
                          filter='Customers';
                          customerFilter = value;
                          getUserInfo();
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SizedBox(
              child: appointmentList(length),
            ),
          ),
        ],
      ),
    );
  }
}

DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
  value: item,
  child: Text(
      item,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  );

class AppointmentsTile extends StatelessWidget {
  final String appointmentID;
  final int bundle;
  final String time;
  AppointmentsTile(this.appointmentID, this.bundle, this.time);

  String? bundlePicked;

  getBundle(bundle, context) {
    if(bundle==1) {
      bundlePicked = AppLocalizations.of(context)!.first_bundle;
    } else if(bundle==2) {
      bundlePicked = AppLocalizations.of(context)!.second_bundle;
    } else if(bundle==3) {
      bundlePicked = AppLocalizations.of(context)!.third_bundle;
    }
  }

  @override
  Widget build(BuildContext context) {
    getBundle(bundle, context);
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => AppointmentSelected(appointmentID: appointmentID),
        ));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!.appointment_bundle+': '+bundlePicked!),
            SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.appointment_for+' '+appointmentID, style: TextStyle(
              color: Colors.black,
              fontSize: 16
            ),),
            Text(AppLocalizations.of(context)!.appointment_at+' '+time, style: TextStyle(
              color: Colors.black,
              fontSize: 16
            ),)
          ],
        ),
      ),
    );
  }
}