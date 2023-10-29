import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _matricNoController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  bool _isLoading = true;
  bool _hasAccount = false;
  Map<String, dynamic>? _profile;

  @override
  void initState() {
    super.initState();
    checkIfUserHasAccount();
  }

  Future<void> checkIfUserHasAccount() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final response =
        await http.get(Uri.parse('http://146.190.102.198:3001/profiles'));
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          final profile =
          data.firstWhere((profile) => profile['uid'] == user.uid, orElse: () => null);
          if (profile != null) {
            setState(() {
              _hasAccount = true;
              _profile = profile;
            });
          }
        } else {
          print(
              'Failed to load profiles. Status code: ${response.statusCode}');
        }
      }
    } catch (error) {
      print('Error checking if user has account: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> createAccount() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final response = await http.post(
            Uri.parse('http://146.190.102.198:3001/profiles'),
            body: json.encode({
              'matric_no': int.tryParse(_matricNoController.text),
              'first_name': _firstNameController.text,
              'last_name': _lastNameController.text,
              'email_address': _emailAddressController.text,
              'phone_number': _phoneNumberController.text,
              'uid': user.uid,
            }),
            headers: {'Content-Type': 'application/json'},
          );
          if (response.statusCode == 200) {
            await checkIfUserHasAccount();
          } else {
            print(
                'Failed to create profile. Status code: ${response.statusCode}');
          }
        }
      } catch (error) {
        print('Error creating account: $error');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : !_hasAccount
            ? Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _matricNoController,
                decoration:
                InputDecoration(labelText: 'Matriculation Number'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? 'Please enter a value' : null,
              ),
              TextFormField(
                controller: _firstNameController,
                decoration:
                InputDecoration(labelText: 'First Name'),
                validator: (value) =>
                value!.isEmpty ? 'Please enter a value' : null,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration:
                InputDecoration(labelText: 'Last Name'),
                validator: (value) =>
                value!.isEmpty ? 'Please enter a value' : null,
              ),
              TextFormField(
                controller: _emailAddressController,
                decoration:
                InputDecoration(labelText: 'Email Address'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                value!.isEmpty ? 'Please enter a value' : null,
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration:
                InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                value!.isEmpty ? 'Please enter a value' : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: createAccount,
                child: Text('Create Account'),
              ),
            ],
          ),
        )
            : ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              title: Text('Matriculation Number'),
              subtitle: Text(_profile!['matric_no'].toString()),
            ),
            ListTile(
              title: Text('First Name'),
              subtitle: Text(_profile!['first_name']),
            ),
            ListTile(
              title: Text('Last Name'),
              subtitle: Text(_profile!['last_name']),
            ),
            ListTile(
              title: Text('Email Address'),
              subtitle: Text(_profile!['email_address']),
            ),
            ListTile(
              title: Text('Phone Number'),
              subtitle: Text(_profile!['phone_number']),
            ),
          ],
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // Pop routes until the NavigationExample route is reached
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
            child: Text('Sign Out'),
          ),
        ),
      ),
    );
  }
}
