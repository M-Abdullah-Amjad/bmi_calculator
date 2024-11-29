import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package
import 'dart:io'; // For exit functionality
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'BMI Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw 'Could not launch $url';
  }
}

class _MyHomePageState extends State<MyHomePage> {
  var wtController = TextEditingController();
  var heightController = TextEditingController();
  String selectedHeightUnit = 'Feet'; // Default selected height unit
  var result = '', msg = '';
  Color bgColor = Colors.teal.shade700; // Default background color (teal tone)
  Color textColor = Colors.white; // Default text color

  // Dropdown items for height units
  final List<String> heightUnits = [
    'Feet', 'Inches', 'Centimeters', 'Meters', 'Yards', 'Millimeters'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                color: bgColor, // Dynamic background color based on BMI result
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 80,),
                        // "Welcome to" on a separate line
                        Text(
                          'Welcome to',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 22,
                              color: textColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // "BMI Calculator" on a separate line
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 22,
                                color: textColor,
                              ),
                            ),
                            children: const [
                              TextSpan(
                                text: 'BMI',
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(text: ' Calculator', style: TextStyle(fontSize: 28)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        SizedBox(
                          width: 280,
                          child: Column(
                            children: [
                              // Weight input
                              TextField(
                                controller: wtController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: textColor),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.monitor_weight, color: Colors.orangeAccent),
                                  hintText: 'Enter your Weight (KGs)',
                                  hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.2),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              // Dropdown for height unit selection
                              DropdownButton<String>(
                                value: selectedHeightUnit,
                                icon: const Icon(Icons.arrow_drop_down, color: Colors.orangeAccent),
                                isExpanded: true,
                                dropdownColor: Colors.teal.shade800,
                                style: TextStyle(color: textColor),
                                underline: Container(
                                  height: 2,
                                  color: Colors.orangeAccent,
                                ),
                                items: heightUnits.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedHeightUnit = newValue!;
                                  });
                                },
                              ),
                              const SizedBox(height: 15),
                              // Height input
                              TextField(
                                controller: heightController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: textColor),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.height, color: Colors.orangeAccent),
                                  hintText: 'Enter your Height',
                                  hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.2),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              // Calculate Button
                              ElevatedButton(
                                onPressed: () {
                                  var wt = wtController.text.toString();
                                  var height = heightController.text.toString();

                                  if (wt != '' && height != '') {
                                    var twt = double.parse(wt);
                                    var theight = double.parse(height);
                                    var bmi;

                                    // Convert height to meters based on selected unit
                                    if (selectedHeightUnit == 'Feet') {
                                      theight = theight * 0.3048; // Convert feet to meters
                                    } else if (selectedHeightUnit == 'Inches') {
                                      theight = theight * 0.0254; // Convert inches to meters
                                    } else if (selectedHeightUnit == 'Centimeters') {
                                      theight = theight / 100; // Convert cm to meters
                                    } else if (selectedHeightUnit == 'Meters') {
                                      // Meters to meters, no conversion needed
                                    } else if (selectedHeightUnit == 'Yards') {
                                      theight = theight * 0.9144; // Convert yards to meters
                                    } else if (selectedHeightUnit == 'Millimeters') {
                                      theight = theight / 1000; // Convert mm to meters
                                    }

                                    bmi = twt / (theight * theight);
                                    result = 'Your BMI is ${bmi.toStringAsFixed(2)}';
                                    setState(() {});

                                    // Change background color, message, and text color based on BMI
                                    if (bmi > 25) {
                                      msg = 'You are Overweight';
                                      bgColor = Colors.red.shade700; // Darker red
                                      textColor = Colors.white; // Ensure text remains visible
                                    } else if (bmi < 18) {
                                      msg = 'You are Underweight';
                                      bgColor = Colors.orange.shade700; // Darker orange
                                      textColor = Colors.white;
                                    } else {
                                      msg = 'You are Healthy';
                                      bgColor = Colors.green.shade700; // Darker green
                                      textColor = Colors.white;
                                    }
                                    setState(() {});
                                  } else {
                                    setState(() {
                                      result = 'Fill all the fields!!!';
                                    });
                                  }
                                  FocusScope.of(context).unfocus();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orangeAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                ),
                                child: const Text(
                                  'Calculate',
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                result,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: textColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                msg,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: textColor,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: bgColor,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Powered by ",
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _launchUrl("https://codecamp.website");
                  },
                  child: Text(
                    "codecamp.website",
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: CircleAvatar(
        radius: 18,
        child: FloatingActionButton(
          onPressed: () {
            exit(0); // Close the app
          },
          backgroundColor: Colors.redAccent,
          child: const Icon(Icons.exit_to_app,size: 20,),
        ),
      ),
    );
  }
}
