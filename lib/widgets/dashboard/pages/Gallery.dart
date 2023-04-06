import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../common_alert_dialog.dart';

class Gallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Gallery",
          style: Theme.of(context).textTheme.overline,
        ),
      ),
      body: Center(
        child: AlertDialog(
          content: const Text('No Data Available.'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),

      // body: Center(
      //   child: ElevatedButton(
      //     onPressed: () => showAlertDialog(context),
      //     child: Text('Show Dialog'),
      //
      //   ),
      // ),
      // backgroundColor: Colors.white,
      // body: Card(
      //
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(5.0),
      //   ),
      //   elevation: 2,
      //   margin: EdgeInsets.fromLTRB(10,25,10,25),
      //   child: Padding (
      //     padding: const EdgeInsets.all(20.0),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Text('Get in touch',
      //             style: TextStyle(
      //                 color: Theme.of(context).primaryColor,
      //                 fontSize: 25.0,
      //                 fontFamily: 'Roboto',
      //                 fontWeight: FontWeight.bold)),
      //         const SizedBox(height: 10.0),
      //         const Text(
      //             "We'd like to hear from you. Our friendly team is always here to connect"
      //                 ".",
      //             style: TextStyle(
      //                 color: Colors.black,
      //                 fontSize: 18.0,
      //                 fontFamily: 'Roboto',
      //                 fontWeight: FontWeight.normal)),
      //         const SizedBox(height: 30.0),
      //
      //
      //         TextButton(
      //           onPressed: () {
      //             //logic  goes here
      //           },
      //           style: TextButton.styleFrom(
      //             padding: const EdgeInsets.all(15),
      //           ),
      //
      //
      //           child: Row(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               Icon(Icons.location_pin, color: Theme.of(context).primaryColor),
      //               SizedBox(width: 20.0),
      //               Text('6-3-251/4, Road No.1,\nBanjarahills, Hyd – 500034,\nTelangana, India.',
      //                   style: TextStyle(
      //                       color: Colors.black,
      //                       fontSize: 16.0,
      //                       fontFamily: 'Roboto',
      //                       fontWeight: FontWeight.normal)),
      //
      //             ],
      //
      //           ),
      //
      //         ),
      //         TextButton(
      //           onPressed: () {
      //             //logic  goes here
      //           },
      //           style: TextButton.styleFrom(
      //             padding: const EdgeInsets.all(15),
      //           ),
      //           child: Row(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               Icon(Icons.phone, color: Theme.of(context).primaryColor),
      //               SizedBox(width: 20.0),
      //               Text('1800-120-5153',
      //                   style: TextStyle(
      //                       color: Colors.black,
      //                       fontSize: 16.0,
      //                       fontFamily: 'Roboto',
      //                       fontWeight: FontWeight.normal)),
      //             ],
      //           ),
      //         ),
      //
      //         TextButton(
      //           onPressed: () {
      //             //logic  goes here
      //           },
      //           style: TextButton.styleFrom(
      //             padding: const EdgeInsets.all(15),
      //           ),
      //           child: Row(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               Icon(Icons.mail, color: Theme.of(context).primaryColor),
      //               SizedBox(width: 20.0),
      //               Text('contact@tricolour.co.in',
      //                   style: TextStyle(
      //                       color: Colors.black,
      //                       fontSize: 16.0,
      //                       fontWeight: FontWeight.normal)),
      //             ],
      //           ),
      //         ),
      //         TextButton(
      //           onPressed: () {
      //             //logic  goes here
      //           },
      //           style: TextButton.styleFrom(
      //             padding: const EdgeInsets.all(15),
      //           ),
      //           child: Row(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               Icon(Icons.language, color: Theme.of(context).primaryColor),
      //               SizedBox(width: 20.0),
      //               Text('www.tricolour.co.in',
      //                   style: TextStyle(
      //                       color: Colors.black,
      //                       fontSize: 16.0,
      //                       fontWeight: FontWeight.normal)),
      //             ],
      //           ),
      //         ),
      //
      //       ],
      //     ),
      //   ),
      // )
    );
  }

  showAlertDialog(BuildContext context) {
    VoidCallback continueCallBack = () => {
          Navigator.of(context).pop(),
          // code on continue comes here
        };
    CommonAlert alert = CommonAlert("Abort",
        "Are you sure you want to abort this operation?", continueCallBack);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
