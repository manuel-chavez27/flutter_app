import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NumbersWidget extends StatelessWidget {
  const NumbersWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildButton(context, '4.3', AppLocalizations.of(context)!.profile_review),
        buildDivider(),
        buildButton(context, '145', AppLocalizations.of(context)!.profile_positive),
        buildDivider(),
        buildButton(context, '20', AppLocalizations.of(context)!.profile_negative),
      ],
    ),
  );

  Widget buildDivider() => Container(
    height: 24,
    child: VerticalDivider(),
  );

  Widget buildButton(BuildContext context, String value, String text) => 
    MaterialButton(
      padding: EdgeInsets.symmetric(vertical: 4),
      onPressed: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          SizedBox(height: 2),
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold)
          )
        ],
      ),
    );

  
}