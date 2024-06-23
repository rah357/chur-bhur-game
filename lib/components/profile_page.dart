import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _referralCodeController = TextEditingController();

  Future<void> _submitData() async {
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String referralCode = _referralCodeController.text;

    // Replace 'your_api_endpoint' with your actual API endpoint
    final Uri apiUrl = Uri.parse('your_api_endpoint');

    try {
      final response = await http.post(
        apiUrl,
        body: {
          'name': name,
          'email': email,
          'referral_code': referralCode,
        },
      );

      if (response.statusCode == 200) {
        // Handle success
        print('API call successful');
      } else {
        // Handle error
        print('API call failed');
      }
    } catch (error) {
      // Handle network error
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _referralCodeController,
              decoration: InputDecoration(labelText: 'Referral Code'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitData,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
