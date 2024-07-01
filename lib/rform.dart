import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bottom.dart';
import 'top.dart';
import 'thanks.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: rform(),
  ));
}

class rform extends StatefulWidget {
  @override
  _rformState createState() => _rformState();
}

class _rformState extends State<rform> {
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();
  final _otherMaterialControllers = <TextEditingController>[];

  bool _otherSelected = false;
  bool _cottonSelected = false;
  bool _rayonSelected = false;
  bool _woollenSelected = false;
  bool _polyesterSelected = false;
  bool _silkSelected = false;

  void _addOtherMaterialField() {
    setState(() {
      _otherMaterialControllers.add(TextEditingController());
    });
  }

  void _removeOtherMaterialField(int index) {
    setState(() {
      _otherMaterialControllers.removeAt(index);
    });
  }

  Future<void> _saveToFirestore() async {
    final materials = {
      'cotton': _cottonSelected,
      'rayon': _rayonSelected,
      'woollen': _woollenSelected,
      'polyester': _polyesterSelected,
      'silk': _silkSelected,
      'other': _otherSelected,
      'otherMaterials': _otherMaterialControllers.map((controller) => controller.text).toList(),
    };

    await FirebaseFirestore.instance.collection('recycle').add({
      'name': _nameController.text,
      'contactNumber': _contactController.text,
      'dateToPickup': _dateController.text,
      'address': _addressController.text,
      'timeToPickup': _timeController.text,
      'materials': materials,
    });
  }

  void _validateAndSubmit() async {
    if (_nameController.text.isEmpty ||
        _contactController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _timeController.text.isEmpty ||
        (!_cottonSelected &&
         !_rayonSelected &&
         !_woollenSelected &&
         !_polyesterSelected &&
         !_silkSelected &&
         !_otherSelected) ||
        (_otherSelected && _otherMaterialControllers.any((controller) => controller.text.isEmpty))) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields'),
        ),
      );
    } else {
      await _saveToFirestore();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ThankYouPage()),
      );
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _contactController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Contact Number',
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Date to Pickup',
              ),
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 1),
                );
                if (date != null) {
                  _dateController.text = DateFormat('dd-MM-yyyy').format(date);
                }
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Address',
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _timeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Time to Pickup',
              ),
              readOnly: true,
              onTap: () async {
                final pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  _timeController.text = pickedTime.format(context);
                }
              },
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('What material'),
            ),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 3,
              children: <Widget>[
                CheckboxListTile(
                  title: Text('Cotton'),
                  value: _cottonSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      _cottonSelected = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('Rayon'),
                  value: _rayonSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      _rayonSelected = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('Woollen'),
                  value: _woollenSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      _woollenSelected = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('Polyester'),
                  value: _polyesterSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      _polyesterSelected = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('Silk'),
                  value: _silkSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      _silkSelected = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('Other'),
                  value: _otherSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      _otherSelected = value ?? false;
                      if (!_otherSelected) {
                        _otherMaterialControllers.clear();
                      } else {
                        _addOtherMaterialField();
                      }
                    });
                  },
                ),
              ],
            ),
            _otherSelected
                ? Column(
                    children: [
                      for (int i = 0; i < _otherMaterialControllers.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _otherMaterialControllers[i],
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Enter Material',
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.remove_circle),
                                onPressed: () => _removeOtherMaterialField(i),
                              ),
                            ],
                          ),
                        ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          icon: Icon(Icons.add),
                          label: Text('Add another material'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color(0xFFB99A45),
                          ),
                          onPressed: _addOtherMaterialField,
                        ),
                      ),
                    ],
                  )
                : Container(),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _validateAndSubmit,
              child: Text(
                'Recycle Now',
                style: TextStyle(
                  fontFamily: 'Gabriela-Regular',
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB99A45),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(pageBackgroundColor: Colors.white,currentIndex: 0),
    );
  }
}