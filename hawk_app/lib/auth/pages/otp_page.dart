import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hawk_app/auth/blocs/forgot_password_bloc/forgot_password_bloc.dart';
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
                  BlocProvider.of<ForgotPasswordBloc>(context).add(VerifyOtp(otp: getOtpValue()))
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.resolveWith((states) => Size(90.w, 13.w)),
                ), 
                child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                      builder: (context, state) {
                        if (state is VerifyOtpLoading) {
                          return CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.background,
                            strokeWidth: 1.w,
                          );
                        }
                        if (state is VerifyOtpFailed) {
                          return Text(
                            'Error',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.background),
                          );
                        }
                        if (state is VerifyOtpSuccess) {
                          GoRouter.of(context).go('/reset-password');
                          return Text(
                            'Success',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.background),
                          );
                        }
                        return Text(
                          'Verify',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.background),
                        );
                      },
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

  getOtpValue(){
    return contrller1!.text + contrller2!.text + contrller3!.text + contrller4!.text;
  }
}