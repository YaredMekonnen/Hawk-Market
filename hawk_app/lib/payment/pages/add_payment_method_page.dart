import 'package:flutter/material.dart';

class AddPaymentMethodPage extends StatefulWidget {
  
  @override
  State<AddPaymentMethodPage> createState() => _AddPaymentMethodPageState();
}

class _AddPaymentMethodPageState extends State<AddPaymentMethodPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AddPaymentMethod Verification'),
      ),
    );
  }
}