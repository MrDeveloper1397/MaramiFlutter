import 'package:flutter/material.dart';

class InProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Image(
            image: AssetImage('assets/images/work_in_progress.png'),
          ),
        ),
      ),
    );
  }
}
