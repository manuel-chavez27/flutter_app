import 'package:flutter/material.dart';
import 'package:my_app/screens/appointment/bundles.dart';
import 'package:my_app/widgets/language_picker.dart';
import 'package:my_app/widgets/navigation_drawer_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Appointment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              makeBundle(image: 'assets/images/first_bundle.jpg', tag: '1', bundle: AppLocalizations.of(context)!.first_bundle, price: '80\$', context: context, first: AppLocalizations.of(context)!.first_bundle_one, second: AppLocalizations.of(context)!.first_bundle_two, third: AppLocalizations.of(context)!.first_bundle_three, fourth: AppLocalizations.of(context)!.first_bundle_four),
              makeBundle(image: 'assets/images/second_bundle.jpg', tag: '2', bundle:  AppLocalizations.of(context)!.second_bundle, price: '150\$', context: context, first: AppLocalizations.of(context)!.second_bundle_one, second: AppLocalizations.of(context)!.second_bundle_two, third: AppLocalizations.of(context)!.second_bundle_three, fourth: AppLocalizations.of(context)!.second_bundle_four, fifth: AppLocalizations.of(context)!.second_bundle_five, sixth: AppLocalizations.of(context)!.second_bundle_six ),
              makeBundle(image: 'assets/images/third_bundle.jpg', tag: '3', bundle:  AppLocalizations.of(context)!.third_bundle, price: '200\$', context: context, first: AppLocalizations.of(context)!.three_bundle_one, second: AppLocalizations.of(context)!.three_bundle_two, third: AppLocalizations.of(context)!.three_bundle_three, fourth: AppLocalizations.of(context)!.three_bundle_four, fifth: AppLocalizations.of(context)!.three_bundle_five, sixth: AppLocalizations.of(context)!.three_bundle_six, seventh: AppLocalizations.of(context)!.three_bundle_seven, eighth: AppLocalizations.of(context)!.three_bundle_eight),
            ],
          ),
        ),
      )
    );
  }

  Widget makeBundle({image, tag, bundle, price, context, first, second, third, fourth, fifth, sixth, seventh, eighth}) {
    return Hero(
      tag: tag,
      child: Material(
        child: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Bundles(image: image, bundle: bundle, price: price, tag: tag, first: first, second: second, third: third, fourth: fourth, fifth: fifth, sixth: sixth, seventh: seventh, eighth: eighth,)));
          },
          child: Container(
            height: 250,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10,
                  offset: Offset(0, 10)
                )
              ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(bundle,style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white
                      ),
                      child: Center(
                        child: Icon(Icons.favorite_border, size: 20),
                      ),
                    )
                  ],
                ),
                Text(price,style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}