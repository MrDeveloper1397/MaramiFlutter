import 'package:flutter/material.dart';

class Choice {
  final String direction;
  final int? total;
  final String? facing;
  final String? extend;
  final Color? color;
  final String status;

  const Choice(
      {required this.direction,
      this.facing,
      this.extend,
      this.total,
      this.color,
      required this.status});
}
