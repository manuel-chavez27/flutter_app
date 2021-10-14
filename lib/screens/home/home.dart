import 'package:flutter/material.dart';
import 'package:my_app/screens/appointment/appointment.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/widgets/language_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_app/widgets/navigation_drawer_widget.dart';

class Home extends StatelessWidget {

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
          IconButton(onPressed: () {}, icon: ImageIcon(AssetImage('assets/images/shopping_car.png'))),
          const SizedBox(width: 12)
        ],
      ),
      drawer: NavigationDrawerWidget(),
      body: Container(
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
          child: Column(
            children: <Widget>[
              Flexible(
                child: GridView.count(
                  primary: false,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  crossAxisCount: 2,
                  children: <Widget>[
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage('assets/images/promo.jpg'),
                          fit: BoxFit.cover
                        )
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Column(
                        children: <Widget>[
                          Text(AppLocalizations.of(context)!.promo_home, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 20),
                          Text(AppLocalizations.of(context)!.promo_message_home, style: TextStyle(fontSize: 13)),
                          SizedBox(height: 45),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (context) => Appointment(),
                              ));
                            },
                            child: Text(AppLocalizations.of(context)!.appointment_button_home, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            style: TextButton.styleFrom(
                              backgroundColor: Color.fromRGBO(63, 63, 156, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                              )
                            ),
                          )
                        ],
                      )
                    ),
                    Container(
                      child: sections(AppLocalizations.of(context)!.section_1_home, 'assets/images/estetica.jpg'),
                    ),
                    Container(
                      child: sections(AppLocalizations.of(context)!.section_2_home, 'assets/images/lavado_motor.jpg'),
                    ),
                    Container(
                      child: sections(AppLocalizations.of(context)!.section_3_home, 'assets/images/limpieza_faros.png'),
                    ),
                    Container(
                      child: sections(AppLocalizations.of(context)!.section_4_home, 'assets/images/lavado_exterior.jpg'),
                    ),
                  ],
                ),
              ),
            ],
          )
        ),
      ),
    );
  }

  Widget sections(title, img) {
    return Container(
        child: Column(
          children: <Widget>[
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage(img),
                  fit: BoxFit.cover
                )
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(.7),
                      Colors.black.withOpacity(.5),
                    ]
                  )
                ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(title, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold))
                ],
              ),
              ),
            ),
          ],
        ),
      );
  }
}