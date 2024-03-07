import 'package:flutter/material.dart';

class PaymentMethodsPage extends StatefulWidget {
  
  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PaymentMethods Verification'),
      ),
    );
  }
}