import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoppinglist/screens/login_screen.dart';
import 'package:shoppinglist/backend/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  final User user;

// ignore: prefer_const_constructors_in_immutables
  HomeScreen({super.key, required this.user});

  @override
// ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          // ignore: prefer_const_constructors
          title: Text('HomeScreen'),
          centerTitle: true,
        ),
        body: WillPopScope(
          onWillPop: () async {
            final logout = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  // ignore: prefer_const_constructors, unnecessary_new
                  title: new Text('Are you sure?'),
                  // ignore: unnecessary_new, prefer_const_constructors
                  content: new Text('Do you want to logout from this App'),
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                  actions: [
                    TextButton(
                      onPressed: () {
                        Logout();
                      },
                      child: const Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text('No'),
                    ),
                  ],
                );
              },
            );
            return logout!;
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'NAME: ${_currentUser.displayName}',
                  // ignore: deprecated_member_use
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                // ignore: prefer_const_constructors
                SizedBox(height: 16.0),
                Text(
                  'EMAIL: ${_currentUser.email}',
                  // ignore: deprecated_member_use
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                // ignore: prefer_const_constructors
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();

                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        // ignore: prefer_const_constructors
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  // ignore: sort_child_properties_last
                  child: const Text('Sign out'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.redAccent),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

// ignore: non_constant_identifier_names
  Future<dynamic> Logout() async {
    await FirebaseAuth.instance.signOut();

    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        // ignore: prefer_const_constructors
        builder: (context) => LoginScreen(),
      ),
    );
  }
}
