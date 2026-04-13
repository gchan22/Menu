import 'package:flutter/material.dart';

/// A wrapper to keep track of either a text controller or image data
class DescriptionItem {
  TextEditingController? controller;
  String? imageData; // Base64 encoded image string
  bool isImage;

  DescriptionItem({this.controller, this.imageData, this.isImage = false});
}