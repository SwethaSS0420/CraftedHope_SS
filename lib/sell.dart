import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sls/top.dart';
import 'bottom.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'buy.dart';

class SellThriftPage extends StatefulWidget {
  @override
  _SellThriftPageState createState() => _SellThriftPageState();
}

class _SellThriftPageState extends State<SellThriftPage> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  TextEditingController _costController = TextEditingController();
  TextEditingController _materialController = TextEditingController();

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadDetails(BuildContext context) async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please upload an image.'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    final firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');

    await ref.putFile(_image!);

    String downloadURL = await ref.getDownloadURL();

    await FirebaseFirestore.instance.collection('thrift').add({
      'imageURL': downloadURL,
      'costDetails': _costController.text,
      'materialDetails': _materialController.text,
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BuyThriftPage(
          imagePath: downloadURL,
          costDetails: _costController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.black, // Set background color to black
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _getImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB99A45), // Set button color to B99A45
              ),
              child: Text(
                'Upload Image',
                style: TextStyle(color: Colors.black), // Set text color to black
              ),
            ),
            _image != null
                ? Image.file(_image!)
                : Text(
                    'No image selected.',
                    style: TextStyle(color: Colors.white), // Set text color to white
                  ),
            SizedBox(height: 20),
            TextField(
              controller: _costController,
              style: TextStyle(color: Colors.white), // Set text color to white
              decoration: InputDecoration(
                labelText: 'Cost Details',
                labelStyle: TextStyle(color: Colors.white), // Set label color to white
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _materialController,
              style: TextStyle(color: Colors.white), // Set text color to white
              decoration: InputDecoration(
                labelText: 'Material Details',
                labelStyle: TextStyle(color: Colors.white), // Set label color to white
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _uploadDetails(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB99A45), // Set button color to B99A45
              ),
              child: Text(
                'Upload Details',
                style: TextStyle(color: Colors.black), // Set text color to black
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }

  @override
  void dispose() {
    _costController.dispose();
    _materialController.dispose();
    super.dispose();
  }
}
