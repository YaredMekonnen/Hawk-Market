import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OtpPage extends StatefulWidget {
  
  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {

  TextEditingController ? contrller1;
  TextEditingController ? contrller2;
  TextEditingController ? contrller3;
  TextEditingController ? contrller4;
   @override
  void initState() {
   // TODO: implement initState
    super.initState();
    contrller1 = TextEditingController();
    contrller2 = TextEditingController();
    contrller3 = TextEditingController();
    contrller4 = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            GoRouter.of(context).go('/forgot-password');
          },
        ),
      ),
      body:SingleChildScrollView(
        child: Container(
          width: 100.w,
          height: 85.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 90.w,
                child: Column(
                  children: [
                    Image(
                      image: AssetImage('assets/verify.png'),
                      width: 90.w,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      'Verify Your Email',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 4.w,),
                    Text(
                      'Please enter the verification code sent to the email user@example.com',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4.w,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _textFieldOTP(first: true, last: false, controllerr: contrller1),
                        SizedBox(width: 5.w,),
                        _textFieldOTP(first: false, last: false, controllerr: contrller2),
                        SizedBox(width: 5.w,),
                        _textFieldOTP(first: false, last: false, controllerr: contrller3),
                        SizedBox(width: 5.w,),
                        _textFieldOTP(first: false, last: true, controllerr: contrller4)
                      ],
                    ),
                  ],
                ),
              ),

              ElevatedButton(
                onPressed: ()=>{
                  GoRouter.of(context).go('/reset-password')
                }, 
                child: Text(
                  'Verify',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.background
                  ),
                ),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.resolveWith((states) => Size(90.w, 13.w)),
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }

  Widget _textFieldOTP({
    bool ? first, 
    bool ? last, 
    TextEditingController ?controllerr
  }) {
    return 
    TextFormField(
      controller: controllerr,
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.top,
      style: Theme.of(context).textTheme.bodyLarge,
      autofocus: true,
      onChanged: (value) {
        if (value.length == 1 && last == false) {
          FocusScope.of(context).nextFocus();
        }
        if (value.isEmpty && first == false) {
          FocusScope.of(context).previousFocus();
        }
      },
      showCursor: false,
      readOnly: false,
      keyboardType: TextInputType.number,
      maxLength: 1,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top: 0),
        constraints: BoxConstraints(
          maxHeight: 12.w,
          maxWidth: 12.w,
        ),
        counter: Offstage(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2.4.w)
        ),
      ),
    );
  }
}