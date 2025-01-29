import 'package:flutter/material.dart';

double width = 1, height = 1, arifmetik = 1;

extension ExtSize on num {
  double get w => this * width;
  double get h => this * height;
  double get o => this * arifmetik;
}

extension Gap on num {
  SizedBox get gapX => SizedBox(width: toDouble(),);
  SizedBox get gapY => SizedBox(height: toDouble(),);
  double sw(BuildContext context) => this * MediaQuery.of(context).size.width;
  double sh(BuildContext context) => this * MediaQuery.of(context).size.height;
  
}

