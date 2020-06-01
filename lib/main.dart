import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import './contacts_list_page.dart';
import './contacts_picker_page.dart';

void main() => runApp(ContactsApp());

// iOS only: Localized labels language setting is equal to CFBundleDevelopmentRegion value (Info.plist) of the iOS project
// Set iOSLocalizedLabels=false if you always want english labels whatever is the CFBundleDevelopmentRegion value.
const iOSLocalizedLabels = false;

class ContactsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('=== ContactsApp build');
    return MaterialApp(
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        '/add': (BuildContext context) => AddContactPage(),
        '/contactsList': (BuildContext context) => ContactListPage(),
        '/nativeContactPicker': (BuildContext context) => ContactPickerPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    print('=== initState');
    super.initState();
    _askPermissions();
  }

  Future<void> _askPermissions() async {
    print('=== _askPermissions');
    PermissionStatus permissionStatus = await Permission.contacts.request();
    if (!permissionStatus.isGranted) {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied ||
        permissionStatus == PermissionStatus.permanentlyDenied) {
      throw PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to location data denied",
          details: null);
    } else if (permissionStatus == PermissionStatus.restricted) {
      throw PlatformException(
          code: "PERMISSION_RESTRICTED",
          message: "Permission active restrictions such as parental controls",
          details: null);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('=== build');
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts Plugin Example')),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RaisedButton(
              child: const Text('Contacts list'),
              onPressed: () => Navigator.pushNamed(context, '/contactsList'),
            ),
            RaisedButton(
              child: const Text('Native Contacts picker'),
              onPressed: () =>
                  Navigator.pushNamed(context, '/nativeContactPicker'),
            ),
          ],
        ),
      ),
    );
  }
}
