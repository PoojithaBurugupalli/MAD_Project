import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:wandermate/group.dart';
import 'package:floating_bubbles/floating_bubbles.dart';
import 'helpers.dart';

// ignore: slash_for_doc_comments
/**
 * 
 *start Location: 
  { 
    building: Eon at Lindbergh, 
    house_number: 535, 
    road: Morosgo Drive Northeast, 
    suburb: Lindbergh, 
    city: Atlanta, 
    county: Fulton County, 
    state: Georgia, ISO3166-2-lvl4: US-GA, 
    postcode: 30324, 
    country: United States, 
    country_code: us
  }
 * 
 * end Location:  
 * { 
 *    house_number: 800, 
 *    road: Cedar Chase Circle Northeast, 
 *    residential: Lindridge Martin Manor, 
 *    suburb: Lindbergh,
 *    city: Atlanta, 
 *    county: Fulton County, 
 *    state: Georgia, ISO3166-2-lvl4: US-GA, 
 *    postcode: 30324, 
 *    country: United States,
 *    country_code: us
 * }
 * end Location: 
 * 
 * 
 */

class CreateHike extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const CreateHike({Key? key});

  @override
  State<CreateHike> createState() => _CreateHikeState();
}

class _CreateHikeState extends State<CreateHike> {
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('hike');
  Map<String, String>? startLocation = {};
  Map<String, String>? endLocation = {};
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  DateTime? date;

  Map<String, dynamic> jsonToMap(dynamic jsonType) {
    if (jsonType is Map<String, dynamic>) {
      return jsonType;
    } else if (jsonType is String) {
      return Map<String, dynamic>.from(jsonDecode(jsonType));
    } else {
      throw Exception("Unsupported type for conversion to Map");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Trip'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: FloatingBubbles.alwaysRepeating(
            noOfBubbles: 25,
            colorsOfBubbles: [
              Colors.green.withAlpha(30),
              Colors.red,
            ],
            sizeFactor: 0.16,
            opacity: 70,
            paintingStyle: PaintingStyle.fill,
            shape: BubbleShape.circle,
            speed: BubbleSpeed.slow,
          )),
          Center(
              child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => _buildLocationPicker(),
                        ),
                      ).then((startAddress) {
                        if (startAddress != null) {
                          // debugPrint('start Location: $startAddress');
                          setState(() {
                            startLocation =
                                jsonToMap(startAddress).cast<String, String>();
                          });
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Background color
                      foregroundColor: Colors.white, // Text and icon color
                    ),
                    child: const Text('Select Start Location'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => _buildLocationPicker(),
                        ),
                      ).then((value) {
                        if (value != null) {
                          // debugPrint('end Location: $value');
                          setState(() {
                            endLocation =
                                jsonToMap(value).cast<String, String>();
                          });
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Background color
                      foregroundColor: Colors.white, // Text and icon color
                    ),
                    child: const Text('Select End Location'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Background color
                      foregroundColor: Colors.white, // Text and icon color
                    ),
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            date = value;
                          });
                        }
                      });
                    },
                    child: const Text('Select Date'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Start Location:',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                  AddressWidget(addressData: startLocation!),
                  const SizedBox(height: 12),
                  const Text(
                    'End Location:',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                  AddressWidget(addressData: endLocation!),
                  const SizedBox(height: 30),
                  const Text(
                    'Date:',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    date?.toString() ?? 'Not selected',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.red, // Set date text color
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                    controller: titleController,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.blue),
                        hintText: "Enter Hike Name: "),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: amountController,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.blue),
                        hintText: "Enter Round Trip Amount (\$USD): "),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _submitData,
                    child: const Text('Submit'),
                  ),
                ]),
          )),
        ],
      ),
    );
  }

  Widget _buildLocationPicker() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Picker'),
      ),
      body: SizedBox(
        height: double.infinity,
        child: Center(
          child: OpenStreetMapSearchAndPick(
            hintText: 'Search Location',
            buttonColor: Colors.blue,
            buttonText: 'Set Location',
            onPicked: (pickedData) {
              Navigator.pop(context, pickedData.address);
            },
          ),
        ),
      ),
    );
  }

  Future<void> _submitData() async {
    if (startLocation == null ||
        endLocation == null ||
        date == null ||
        titleController.text == "" ||
        amountController.text == "") {
      showAlert(
          context, 'Pending Information', 'Complete all the fields', () {});
      return;
    }

    try {
      await _reference.add({
        'title': titleController.text,
        'start': startLocation,
        'end': endLocation,
        'timings': date,
        'amount': num.parse(amountController.text),
      });
      // ignore: use_build_context_synchronously
      showAlert(context, 'Confirmation', 'Created Hike!!!', () {
        Navigator.push(
          context,
          (MaterialPageRoute(builder: (context) => const Group())),
        );
      });
      setState(() {
        startLocation = {};
        endLocation = {};
        date = null;
        titleController.text = "";
        amountController.text = "";
      });
      // Data saved successfully, show success message or navigate to the next screen
    } catch (error) {
      // Handle error, show error message or retry logic
      // print('Error saving data: $error');
    }
  }
}

class AddressWidget extends StatelessWidget {
  final Map<String, String> addressData;

  const AddressWidget({super.key, required this.addressData});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: addressData.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text('${entry.key}: ${entry.value}',
                  style: TextStyle(fontSize: 16, color: Colors.black)),
            );
          }).toList(),
        ),
      ),
    );
  }
}
