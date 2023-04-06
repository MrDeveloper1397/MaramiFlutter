import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mil/widgets/dashboard/pages/Brouchers.dart';
import 'package:mil/widgets/dashboard/pages/Contest.dart';

import 'Associate.dart';
import 'Birthday.dart';
import 'CustApplications.dart';
import 'Gallery.dart';
import 'Greetings.dart';
import 'Offers.dart';

class ServicesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Services',
            style: Theme.of(context).textTheme.overline,
          ),
        ),
        body: Container(
            child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Card(
                child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/app_icon/offers.png'),
              ),
              title: Text('Offers'),
              onTap: () {
//Navigator pushes FirstScreen.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Offers(),
                  ),
                );
              },
            )),
            Card(
                child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/app_icon/brochuer.png'),
              ),
              title: Text('Brouchers'),
              onTap: () {
//Navigator pushes FirstScreen.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Brouchers(),
                  ),
                );
              },
            )),
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/app_icon/contest.png'),
                ),
                title: Text('Contest'),
                onTap: () {
//Navigator pushes FirstScreen.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Contest(),
                    ),
                  );
                },
              ),
            ),
            Card(
                child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/app_icon/forms.png'),
              ),
              title: Text('Customer Appllication'),
              onTap: () {
//Navigator pushes FirstScreen.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustApplications(),
                  ),
                );
              },
            )),
            Card(
                child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/app_icon/forms.png'),
              ),
              title: Text('Associate '),
              onTap: () {
//Navigator pushes FirstScreen.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Associate(),
                  ),
                );
              },
            )),
            Card(
                child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/app_icon/gallery.png'),
              ),
              title: Text('Gallery'),
              onTap: () {
//Navigator pushes FirstScreen.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Gallery(),
                  ),
                );
              },
            )),
            Card(
                child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/app_icon/greetings.png'),
              ),
              title: Text('Greetings'),
              onTap: () {
//Navigator pushes FirstScreen.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Greetings(),
                  ),
                );
              },
            )),
            Card(
                child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/app_icon/birthday.png'),
              ),
              title: Text('Birthday'),
              onTap: () {
//Navigator pushes FirstScreen.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Birthday(),
                  ),
                );
              },
            )),
          ],
        )),
      ),
    );
  }
}
