import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'bottom.dart';
import 'thanks.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: DonationForm(),
  ));
}

class DonationForm extends StatefulWidget {
  @override
  _DonationFormState createState() => _DonationFormState();
}

class _DonationFormState extends State<DonationForm> {
  final _dateController = TextEditingController();
  final _addressController = TextEditingController();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _timeController = TextEditingController();
  final List<TextEditingController> _donationControllers = [];
  final List<int> _quantityValues = [1]; // Start with one item
  final List<String?> _qualityValues = [null];
  final List<String> _qualityOptions = ['1', '2', '3', '4', '5'];

  @override
  void initState() {
    super.initState();
    _addNewRow(); // Adding one initial row for donation and quality
  }

  void _addNewRow() {
    _donationControllers.add(TextEditingController());
    _quantityValues.add(1); // Default initial quantity
    _qualityValues.add(null);
  }

  void _submitForm() {
    if (_nameController.text.isEmpty ||
        _contactController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _timeController.text.isEmpty ||
        _donationControllers.any((controller) => controller.text.isEmpty) ||
        _quantityValues.any((value) => value <= 0) ||
        _qualityValues.any((value) => value == null)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill all fields'),
      ));
    } else {
      FirebaseFirestore.instance.collection('donations').add({
        'name': _nameController.text,
        'contact': _contactController.text,
        'date': _dateController.text,
        'address': _addressController.text,
        'time': _timeController.text,
        'donations': _donationControllers.map((controller) => controller.text).toList(),
        'quantities': _quantityValues,
        'qualities': _qualityValues,
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ThankYouPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Donation Form',
          style: TextStyle(
            fontFamily: 'Gabriela-Regular',
          ),
        ),
        backgroundColor: Color(0xFFB99A45), // Background color
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
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
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (pickedTime != null) {
                  _timeController.text = pickedTime.format(context);
                }
              },
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < _donationControllers.length; i++)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _donationControllers[i],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Item ${i + 1}',
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (_quantityValues[i] > 1) {
                                    _quantityValues[i]--;
                                  }
                                });
                              },
                            ),
                            Text(_quantityValues[i].toString()),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  _quantityValues[i]++;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _qualityValues[i],
                            onChanged: (newValue) {
                              setState(() {
                                _qualityValues[i] = newValue;
                              });
                            },
                            items: _qualityOptions.map((option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Quality',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _addNewRow();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB99A45),
                  ),
                  child: Text(
                    'Add More Items',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Gabriela-Regular',
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Quality Options:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '1 - Like new, no signs of wear or damage\n'
                  '2 - Minimal signs of wear, no major flaws\n'
                  '3 - Some signs of wear, minor flaws but still usable\n'
                  '4 - Significant signs of wear, noticeable flaws, may need repair\n'
                  '5 - Severely damaged, not suitable for use',
                ),
                SizedBox(height: 30),
                Text(
                  'Standard Rules for Donation:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '1. Clothes must be in good condition: no tears, stains, or excessive wear.\n'
                  '2. Clothes must be clean: freshly laundered or dry-cleaned, free from odors, stains, or pet hair.\n'
                  '3. Ensure functionality: zippers, buttons, and closures should be intact.\n',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB99A45),
                    ),
                    child: Text(
                      'DONATE',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Gabriela-Regular',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(pageBackgroundColor: Colors.white,currentIndex: 0),
    );
  }
}