import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  TextEditingController name = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();

  GlobalKey<FormState> globalkey = GlobalKey();
  String? item;
  String select = "";
  String? day;
  List daylist = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thusday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  var items = [
    'BBA',
    'BCA',
    'BCOM',
    'BscIT',
    'MCA',
  ];
  @override
  Widget build(BuildContext context) {
    return Form(
      key: globalkey,
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "*required..";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: "Enter name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: date,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "*required..";
                      }
                      return null;
                    },
                    onTap: () async {
                      var data = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          initialDate: DateTime.now(),
                          lastDate: DateTime(2025));
                      date.text = "${data?.day}-${data?.month}-${data?.year}";
                    },
                    keyboardType: TextInputType.none,
                    readOnly: true,
                    decoration: InputDecoration(
                        labelText: "Select Date",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: time,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "*required..";
                      }
                      return null;
                    },
                    onTap: () async {
                      var pickedtime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          initialEntryMode: TimePickerEntryMode.input);
                      if (pickedtime != null) {
                        String formattedTime = DateFormat('hh:mm a').format(
                          DateTime(
                              2024, 1, 1, pickedtime.hour, pickedtime.minute),
                        );
                        setState(() {
                          time.text = formattedTime;
                        });
                      }
                    },
                    keyboardType: TextInputType.none,
                    readOnly: true,
                    decoration: InputDecoration(
                        labelText: "Select Time",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButtonFormField(
                        hint: const Text("Select Course"),
                        validator: (value) {
                          if (value == null) {
                            return "*required..";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        value: item == null ? null : item,
                        items: items.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                        onChanged: (value) {
                          item = value!;
                        },
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: ListView.builder(
                      itemCount: daylist.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return RadioListTile(
                          value: "${index}".toString(),
                          groupValue: select,
                          onChanged: (value) {
                            setState(() {});
                            select = value.toString();
                            day = daylist[int.parse(value!)];
                            print("$day ++++++");
                          },
                          activeColor: Colors.amber,
                          title: Text("${daylist[index]}"),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  InkWell(
                    onTap: () {
                      if (globalkey.currentState!.validate()) {
                        add();
                        // setState(() {
                        //   name.clear();
                        //   date.clear();
                        //   time.clear();
                        //   item = null;
                        //   select = "";
                        // });
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amber),
                      child: const Center(
                          child: Text(
                        "Submit",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15),
                      )),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void add() {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    String id = "Data_${DateTime.now().microsecondsSinceEpoch.toString()}";
    firebaseFirestore.collection("Data").doc(id).set({
      "id": id,
      "name": name.text,
      "date": date.text,
      "time": time.text,
      "course": item,
      "day": day
    });
  }
}
