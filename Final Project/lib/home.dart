import 'package:flutter/material.dart';
import 'description.dart';
import 'group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      // Permission granted
    } else {
      // Permission denied
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location permission is required.")),
      );
    }
  }

  String imageUrl = '';
  // final FirebaseStorage _storage = FirebaseStorage.instance;
  final CollectionReference _atlplacesReference =
      FirebaseFirestore.instance.collection('atl_places');
  final CollectionReference _otherplacesReference =
      FirebaseFirestore.instance.collection('places');
  final CollectionReference _cultural =
      FirebaseFirestore.instance.collection('cultural');

  String capitalizeAndJoin(String input) {
    return input
        .split('_')
        .map((word) =>
            "${word[0].toUpperCase()}${word.substring(1).toLowerCase()} ")
        .join('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ready for Adventure!!!'),
      ),
      backgroundColor: const Color.fromARGB(195, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Discover text
            Stack(
              children: [
                Image.asset(
                  'assets/background.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 300,
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: Text(
                      "Discover the Adventurer in YOU!!!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // "Explore the places of the world" text
            const Padding(
              padding: EdgeInsets.fromLTRB(
                  16, 8, 16, 24), // Adjust padding as needed
              child: Text(
                'Explore the places of the world',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Places Near Atlanta',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: FutureBuilder<QuerySnapshot>(
                future: _atlplacesReference.get(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      String imageUrl = documents[index]['image'];
                      String description = documents[index]['description'];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Description(
                                imageUrl: imageUrl,
                                placeName: capitalizeAndJoin(
                                    documents[index]['index']),
                                description: description,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 150,
                          // height: 200,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          child: SingleChildScrollView(
                            child: Stack(
                              children: [
                                Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  height: 200,
                                  width: 500,
                                ),
                                Center(
                                  child: Text(
                                    documents[index]['index'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      backgroundColor: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                'Other Places & Destinations',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 300,
              child: FutureBuilder<QuerySnapshot>(
                  future: _otherplacesReference.get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                    return CarouselSlider(
                      options: CarouselOptions(
                        height: 400,
                        autoPlay: true,
                        enlargeCenterPage: true,
                      ),
                      items: documents.map((item) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Description(
                                    imageUrl: item['image'],
                                    placeName: capitalizeAndJoin(item['index']),
                                    description: item['description'],
                                  ),
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                Image.network(
                                  item['image']!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                                Center(
                                  child: Text(
                                    item['index']!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      backgroundColor: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ));
                      }).toList(),
                    );
                  }),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Cultural Diversity',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: FutureBuilder<QuerySnapshot>(
                future: _cultural.get(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      String imageUrl = documents[index]['image'];
                      String description = documents[index]['description'];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Description(
                                imageUrl: imageUrl,
                                placeName: capitalizeAndJoin(
                                    documents[index]['index']),
                                description: description,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 150,
                          height: 250,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  height: 200,
                                  width: 200,
                                ),
                                Text(
                                  capitalizeAndJoin(documents[index]['index']),
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // Groups section
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(199, 131, 35, 35),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHome()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.navigation),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Group()),
                );
              },
            ),
            // IconButton(
            //   icon: const Icon(
            //     Icons.camera_alt,
            //     color: Colors.white,
            //   ),
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const Capture()),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
