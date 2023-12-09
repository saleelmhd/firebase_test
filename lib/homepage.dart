import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:saleel/addStud.dart';
import 'package:saleel/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _nameController = TextEditingController();
  // void searchByName() async {
  //   String nameToSearch = _nameController.text;

  //   // Assuming "users" is the collection name
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection('Students')
  //       .where('name', isEqualTo: nameToSearch)
  //       .get();

  //   // Iterate over the documents in the query result
  //   querySnapshot.docs.forEach((doc) {
  //     // Access the data of the document
  //     Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
  //     print("${userData}=====");
  //   });
  // }

  final CollectionReference Stud =
      FirebaseFirestore.instance.collection('Students');
 RangeValues _rangeValues = const RangeValues(0, 100);
  double minRange = 0;
  double maxRange = 100;  String enteredName = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: ((context) => const AddStud())));
        },
  backgroundColor: Colors.indigo,        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        label: const Text("Add Student"),
        icon: const Icon(Icons.add),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
  backgroundColor: Colors.indigo,        actions: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  enteredName = value.toLowerCase();
                });
              },
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
                filled: true,
                contentPadding: const EdgeInsets.all(10),
                fillColor: Colors.white,
                prefixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        enteredName = _nameController.text;
                      });
                    },
                    child: const Icon(Icons.search)),
                hintText: 'Search',
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
          )),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: ((context) => const Login())));
              },
              child: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Age Range: ${_rangeValues.start.round()} - ${_rangeValues.end.round()}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            RangeSlider(
  activeColor: Colors.indigo,
  values: _rangeValues,
  min: minRange,
  max: maxRange,
  onChanged: (RangeValues values) {
    if (values.start >= minRange &&
        values.end <= maxRange &&
        values.start <= values.end) {
      setState(() {
        _rangeValues = values;
      });
    } else {
      // Print values for debugging
      print('Invalid values: $values');

      //
    }})
              
            ],
          ),
          StreamBuilder(
              stream: Stud.snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                     
                        itemBuilder: (context, index) {
                          final DocumentSnapshot Studsnap =
                              snapshot.data!.docs[index];
                          final String nameInSnapshot = Studsnap['name'];
                       final String ageString = Studsnap['age'];
                           int age = int.tryParse(ageString) ?? 0;
                        print('age:${age}=======');
                          bool isEnteredNameMatch = enteredName.isEmpty ||
                              nameInSnapshot.contains(enteredName);
                              bool isAgeInRange =
                age >= _rangeValues.start && age <= _rangeValues.end;
                          return Card(
                            child: Visibility(
                              visible: isEnteredNameMatch && isAgeInRange,
                              child: ListTile(
                                leading: const CircleAvatar(
                                  radius: 20,
                                ),
                                title: Text(Studsnap['name']),
                                subtitle: Text(Studsnap['age']),
                              ),
                            ),
                          );
                        }),
                  );
                }
                return Container();
              })
        ],
      ),
    );
  }
}
