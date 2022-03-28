import 'package:buzz_buzz_app/PairingRoute.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class CalibrationRoute extends StatelessWidget {
  static const String routeName = "/calibration";
  const CalibrationRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calibrate Resting Heart Rate'),
      ),
      body: StreamBuilder<bool>(
        stream: bioData.deviceConnected(),
        initialData: bioData.currentlyConnected(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data ?? false) {
            return const CalibrationSequence();
          } else {
            return const Disconnected();
          }
        },
      ),
    );
  }
}



class CalibrationSequence extends StatelessWidget {
  const CalibrationSequence({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text("This page allows you to calibrate the Buzz Buzz Bracelet"
                        " to your resting heart rate. When your heart rate is "
                        "significantly higher than the calibrated resting "
                        "heart rate, the Buzz Buzz Bracelet will vibrate.",
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodyMedium
            ),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          elevation: 5,
          color: Theme.of(context).secondaryHeaderColor,
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Before starting:", style: Theme.of(context).textTheme.headline6,),
                Text("\t1. Sit down\n\t2. Breathe normally\n\t3. Stay still",
                  style: Theme.of(context).textTheme.subtitle2
              ),
            ]
            ),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          elevation: 5,
          color: Theme.of(context).secondaryHeaderColor,
        ),
        const Expanded(child: MeasureHR())
      ],
    );
  }
}

class MeasureHR extends StatefulWidget {
  const MeasureHR({Key? key}) : super(key: key);

  @override
  State<MeasureHR> createState() => _MeasureHRState();
}

class _MeasureHRState extends State<MeasureHR> with TickerProviderStateMixin{
  static const measureDuration = Duration(seconds: 30);
  late AnimationController controller;
  final List<double> _heartrates = [];
  bool _measuring = false;
  bool _completed = false;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: measureDuration,
    )..addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void measure() async {
    _heartrates.clear();
    var subscription = bioData.heartRateStream().listen((value) => _heartrates.add(value));
    controller.reset();
    controller.animateTo(1.0);
    setState(() {
      _measuring = true;
      _completed = false;
    });

    await Future.delayed(measureDuration);

    subscription.cancel();
    double average = _heartrates.reduce((a,b)=>(a+b))/_heartrates.length;
    options.setRestingHeartrate(average);
    setState(() {
      _measuring = false;
      _completed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height:200,
          child: _measuring
          ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: LinearProgressIndicator(value: controller.value),
              ),
              const SizedBox(height: 10),
              const Text("Measuring Heart Rate\nPlease Wait", textAlign: TextAlign.center),
            ],
          )
          : _completed
          ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.check, size: 100, color: Theme.of(context).primaryColor),
              const Text("Calibration Complete"),
            ],
          )
          : Icon(Icons.favorite, size: 100, color: Theme.of(context).primaryColor),
        ),
        ElevatedButton(
            onPressed: _measuring ? null : measure,
            child: Text("Calibrate" + (_completed ? " Again" : "")),
        )
      ],
    );
  }
}

class Disconnected extends StatelessWidget {
  const Disconnected({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Theme.of(context).secondaryHeaderColor,
        margin: const EdgeInsets.all(20),
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.bluetooth_disabled,
              size: 70,
              color: Colors.grey,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('You cannot calibrate when the BuzzBuzz Bracelet is disconnected.',
                textAlign: TextAlign.center,
              ),
            ),
            TextButton(
              child: const Text('Pair Device'),
              onPressed: () {
                Navigator.pushNamed(context, PairingRoute.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
