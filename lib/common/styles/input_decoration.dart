import 'package:flutter/material.dart';

InputDecoration inputDecoration(String hint) => InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.amber,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(32),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(32),
        ),
      ),
    );
