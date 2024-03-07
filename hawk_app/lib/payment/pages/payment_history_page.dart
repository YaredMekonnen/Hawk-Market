import 'package:flutter/material.dart';

class PaymentHistoryPage extends StatefulWidget {
  
  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PaymentHistory Verification'),
      ),
    );
  }
}