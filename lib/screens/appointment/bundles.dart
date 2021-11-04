import 'package:flutter/material.dart';
import 'package:my_app/screens/appointment/create_appointment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Bundles extends StatefulWidget {
  
  final String image;
  final String bundle;
  final String price;
  final String tag;
  final String? first, second, third, fourth, fifth, sixth, seventh, eighth;

  const Bundles({Key? key, required this.image, required this.bundle, required this.price, required this.tag, this.first, this.second, this.third, this.fourth, this.fifth, this.sixth, this.seventh, this.eighth,}) : super(key: key);

  @override
  BbundlesState createState() => BbundlesState();
}

class BbundlesState extends State<Bundles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Hero(
           tag: widget.tag,
            child: Material(
              child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.image),
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
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                    child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          child: Icon(Icons.arrow_back, color: Colors.white),
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
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    width: MediaQuery.of(context).size.width,
                    height: 500,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          colors: [
                            Colors.black.withOpacity(.9),
                            Colors.black.withOpacity(.0),
                          ]
                        )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(widget.bundle,style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold)),
                          SizedBox(height: 25),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: info(),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 40,
                                height: 40,
                                child: Center(
                                  child: Text(widget.price, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 0),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAppointment(bundle: widget.bundle, price: widget.price)));
                            },
                            child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)
                            ),
                            child: Center(
                              child: Text(AppLocalizations.of(context)!.buy_bundle, style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  )
                  //Text(widget.price,style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                ],
              ),
                      ),
            ),
        )
      ),
    );
  }

  List<Widget> info() {
    if(widget.fifth == null) {
      return <Widget> [
        Text("${widget.first}", style: TextStyle(color: Colors.white, fontSize: 20)),
        Text("${widget.second}", style: TextStyle(color: Colors.white, fontSize: 20)),
        Text("${widget.third}", style: TextStyle(color: Colors.white, fontSize: 20)),
        Text("${widget.fourth}", style: TextStyle(color: Colors.white, fontSize: 20)),
      ];
    }else if(widget.seventh == null){
      return <Widget> [
      Text("${widget.first}", style: TextStyle(color: Colors.white, fontSize: 20)),
      Text("${widget.second}", style: TextStyle(color: Colors.white, fontSize: 20)),
      Text("${widget.third}", style: TextStyle(color: Colors.white, fontSize: 20)),
      Text("${widget.fourth}", style: TextStyle(color: Colors.white, fontSize: 20)),
      Text("${widget.fifth}", style: TextStyle(color: Colors.white, fontSize: 20)),
      Text("${widget.sixth}", style: TextStyle(color: Colors.white, fontSize: 20)),
      ];
    } else {
      return <Widget> [
        Text("${widget.first}", style: TextStyle(color: Colors.white, fontSize: 20)),
        Text("${widget.second}", style: TextStyle(color: Colors.white, fontSize: 20)),
        Text("${widget.third}", style: TextStyle(color: Colors.white, fontSize: 20)),
        Text("${widget.fourth}", style: TextStyle(color: Colors.white, fontSize: 20)),
        Text("${widget.fifth}", style: TextStyle(color: Colors.white, fontSize: 20)),
        Text("${widget.sixth}", style: TextStyle(color: Colors.white, fontSize: 20)),
        Text("${widget.seventh}", style: TextStyle(color: Colors.white, fontSize: 20)),
        Text("${widget.eighth}", style: TextStyle(color: Colors.white, fontSize: 20)),
      ];
    }
  }
}