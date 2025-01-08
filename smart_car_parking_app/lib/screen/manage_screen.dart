import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:smart_car_parking_app/constants/size.dart';
import 'package:smart_car_parking_app/screen/home_screen.dart';
import 'package:smart_car_parking_app/widget/common.dart';
import 'package:smart_car_parking_app/widget/navbar.dart';

class ClockWidget extends StatefulWidget {
  const ClockWidget({super.key});

  @override
  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget>
    with SingleTickerProviderStateMixin {
  late final tickerProvider = createTicker((elapsed) => setState(() {}));

  @override
  void initState() {
    tickerProvider.start();
    super.initState();
  }

  @override
  void dispose() {
    tickerProvider.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat('MM/dd/yyyy hh:mm:ss').format(DateTime.now()),
      style: TextStyle(
        fontSize: 20.sp
      ),
    );
  }
}

class ManageScreen extends StatefulWidget {
  const ManageScreen({super.key});

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  final List<Map<String, String>> parkingData = [
    {'location': 'A1', 'state': 'empty'},
    {'location': 'A2', 'state': 'empty'},
    {'location': 'A3', 'state': 'empty'},
    {'location': 'A4', 'state': 'empty'},
    {'location': 'A5', 'state': 'empty'}
  ];
  final Future<FirebaseApp> _fApp = Firebase.initializeApp(
    // options: const FirebaseOptions(
    //   // apiKey: "1:980407563367:android:dedfd5450ff1a07f2410c2", 
    //   // appId: appId, 
    //   // messagingSenderId: messagingSenderId, 
    //   // projectId: projectId
    // )
  );
  String temp = "";
  String humid = "";
  String smoke = "";
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
      },
      child: Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          title: Text(
            "Smart Parking System",
            style: TextStyle(
              fontSize: 20.sp
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: vPadding, horizontal: hPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 12.h,),
                Center(child: ClockWidget()),
                SizedBox(height: 40.h,),
                Center(
                  child: Row(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: 50.w,
                            height: 50.h,
                            child: Image.asset(
                              "images/temperature.png",
                              // scale: 0.52.h,
                              fit: BoxFit.fill,
                              // opacity: const AlwaysStoppedAnimation(.5),
                            ),
                          ),
                          SizedBox(height: 12.h,),
                          RichText(
                            text: TextSpan(
                              children: <InlineSpan>[
                                const WidgetSpan(
                                    child: Text(
                                  "Temperature: ",
                                )),
                                 WidgetSpan(
                                    child: FutureBuilder(
                                      future: _fApp,
                                      builder: (context, snapshot){
                                        if(snapshot.hasData){
                                          DatabaseReference _temp = FirebaseDatabase.instance.ref().child('sensor/temperature');
                                          _temp.onValue.listen((event) {
                                            setState(() {
                                              temp = event.snapshot.value.toString();
                                            });
                                          },);
                                          return Text(temp);
                                        }
                                        return Text("null");
                                      }
                                    )),
                                const WidgetSpan(
                                    child: Text(
                                  "℃",
                                )),
                              ]
                            )
                          )
                        ],
                      ),
                      SizedBox(width: 20.w,),
                      Column(
                        children: [
                          SizedBox(
                            width: 50.w,
                            height: 50.h,
                            child: Image.asset(
                              "images/humidity.png",
                              // scale: 0.52.h,
                              fit: BoxFit.fill,
                              // opacity: const AlwaysStoppedAnimation(.5),
                            ),
                          ),
                          SizedBox(height: 12.h,),
                          RichText(
                            text: TextSpan(
                              children: <InlineSpan>[
                                const WidgetSpan(
                                    child: Text(
                                  "Humidity: ",
                                )),
                                 WidgetSpan(
                                    child: FutureBuilder(
                                      future: _fApp,
                                      builder: (context, snapshot){
                                        if(snapshot.hasData){
                                          DatabaseReference _humid = FirebaseDatabase.instance.ref().child('sensor/humidity');
                                          _humid.onValue.listen((event) {
                                            setState(() {
                                              humid = event.snapshot.value.toString();
                                            });
                                          },);
                                          return Text(humid);
                                        }
                                        return Text("null");
                                      }
                                    )),
                                const WidgetSpan(
                                    child: Text(
                                  "%",
                                )),
                              ]
                            )
                          )
                        ],
                      ),        
                      SizedBox(width: 20.w,),
                      Column(
                        children: [
                          SizedBox(
                            width: 50.w,
                            height: 50.h,
                            child: Image.asset(
                              "images/smoke.png",
                              // scale: 0.52.h,
                              fit: BoxFit.fill,
                              // opacity: const AlwaysStoppedAnimation(.5),
                            ),
                          ),
                          SizedBox(height: 12.h,),
                          RichText(
                            text: TextSpan(
                              children: <InlineSpan>[
                                const WidgetSpan(
                                    child: Text(
                                  "Gas: ",
                                )),
                                 WidgetSpan(
                                    child: FutureBuilder(
                                      future: _fApp,
                                      builder: (context, snapshot){
                                        if(snapshot.hasData){
                                          DatabaseReference _smoke = FirebaseDatabase.instance.ref().child('sensor/gas');
                                          _smoke.onValue.listen((event) {
                                            setState(() {
                                              smoke = event.snapshot.value.toString();
                                            });
                                          },);
                                          return Text(smoke);
                                        }
                                        return Text("null");
                                      }
                                    )
                                  ),
                              ]
                            )
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h,),
                FutureBuilder(
                    future: _fApp,
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        DatabaseReference _prox1 = FirebaseDatabase.instance.ref().child('sensor/proximity01');
                        DatabaseReference _prox2 = FirebaseDatabase.instance.ref().child('sensor/proximity02');
                        DatabaseReference _prox3 = FirebaseDatabase.instance.ref().child('sensor/proximity03');
                        DatabaseReference _prox4 = FirebaseDatabase.instance.ref().child('sensor/proximity04');
                        DatabaseReference _prox5 = FirebaseDatabase.instance.ref().child('sensor/proximity05');

                        _prox1.onValue.listen((event) {
                          if(event.snapshot.value is int){
                            if(event.snapshot.value == 0){
                              setState(() {
                                parkingData[4]['state'] = "already exists";
                              });
                            }
                            else{
                              setState(() {
                                parkingData[4]['state'] = "empty";
                              });
                            }
                          }
                        },);
                        _prox2.onValue.listen((event) {
                          if(event.snapshot.value is int){
                            if(event.snapshot.value == 0){
                              setState(() {
                                parkingData[3]['state'] = "already exists";
                              });
                            }
                            else{
                              setState(() {
                                parkingData[3]['state'] = "empty";
                              });
                            }
                          }
                        },);
                        _prox3.onValue.listen((event) {
                          if(event.snapshot.value is int){
                            if(event.snapshot.value == 0){
                              setState(() {
                                parkingData[2]['state'] = "already exists";
                              });
                            }
                            else{
                              setState(() {
                                parkingData[2]['state'] = "empty";
                              });
                            }
                          }
                        },);
                        _prox4.onValue.listen((event) {
                          if(event.snapshot.value is int){
                            if(event.snapshot.value == 0){
                              setState(() {
                                parkingData[1]['state'] = "already exists";
                              });
                            }
                            else{
                              setState(() {
                                parkingData[1]['state'] = "empty";
                              });
                            }
                          }
                        },);
                        _prox5.onValue.listen((event) {
                          if(event.snapshot.value is int){
                            if(event.snapshot.value == 0){
                              setState(() {
                                parkingData[0]['state'] = "already exists";
                              });
                            }
                            else{
                              setState(() {
                                parkingData[0]['state'] = "empty";
                              });
                            }
                          }
                        },);
                        return Center(
                            child: DataTable(
                              // border: TableBorder.symmetric(outside: const BorderSide(color: Theme.of(context).colorScheme.onBackground, width: 1)),
                              columns: [
                                DataColumn(
                                  label: Text("Parking Location")
                                ),
                                DataColumn(
                                  label: Text("State")
                                ),
                              ],
                              rows: parkingData.map((data) {
                                return DataRow(cells: [
                                  DataCell(Text(data['location']!)),
                                  DataCell(
                                    Text(data['state']!)
                                  ),
                                ]);
                              }).toList(),
                            ),
                          );
                      }
                      return SizedBox();
                    }
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}