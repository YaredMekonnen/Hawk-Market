import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hawk_app/auth/blocs/forgot_password_bloc/forgot_password_bloc.dart';
import 'package:hawk_app/commons/widgets/button-text.dart';
import 'package:hawk_app/commons/widgets/progress_indecator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OtpPage extends StatefulWidget {
  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  TextEditingController? contrller1;
  TextEditingController? contrller2;
  TextEditingController? contrller3;
  TextEditingController? contrller4;
  bool error = false;
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
        backgroundColor: Theme.of(context).colorScheme.background,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).colorScheme.secondary,
          onPressed: () {
            GoRouter.of(context).go('/forgot-password');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: 100.w,
          height: 85.h,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
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
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.w,
                    ),
                    Column(
                      children: [
                        Text(
                          'Verify Your Email',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(
                          height: 4.w,
                        ),
                        Text(
                          'Please enter the verification code sent to the email ${BlocProvider.of<ForgotPasswordBloc>(context).email}',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.w,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _textFieldOTP(
                            first: true, last: false, controllerr: contrller1),
                        SizedBox(
                          width: 3.w,
                        ),
                        _textFieldOTP(
                            first: false, last: false, controllerr: contrller2),
                        SizedBox(
                          width: 3.w,
                        ),
                        _textFieldOTP(
                            first: false, last: false, controllerr: contrller3),
                        SizedBox(
                          width: 3.w,
                        ),
                        _textFieldOTP(
                            first: false, last: true, controllerr: contrller4),
                      ],
                    ),
                    error
                        ? Text(
                            "Please! Fill in all values!",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.red),
                          )
                        : SizedBox(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Didn\'t receive the code?',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              'Resend',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                            ))
                      ],
                    ),
                  ],
                ),
                BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed:
                          state is VerifyOtpLoading || state is VerifyOtpSuccess
                              ? null
                              : () {
                                  if (getOtpValue().length < 4) {
                                    setState(() {
                                      error = true;
                                    });
                                  } else {
                                    BlocProvider.of<ForgotPasswordBloc>(context)
                                        .add(VerifyOtp(otp: getOtpValue()));
                                  }
                                },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.resolveWith(
                            (states) => Size(90.w, 13.w)),
                      ),
                      child: state is VerifyOtpLoading
                          ? ButtonProgress()
                          : state is VerifyOtpFailed
                              ? ButtonText(text: "Failed! Retry")
                              : state is VerifyOtpSuccess
                                  ? TextButton(
                                      onPressed: () {
                                        GoRouter.of(context)
                                            .go('/reset-password');
                                      },
                                      child: ButtonText(text: "Success! Tap"),
                                    )
                                  : ButtonText(text: "Verify"),
                    );
                  },
                ),
              ]),
        ),
      ),
    );
  }

  Widget _textFieldOTP(
      {bool? first, bool? last, TextEditingController? controllerr}) {
    return TextFormField(
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
        fillColor: Theme.of(context).colorScheme.secondary,
        contentPadding: EdgeInsets.only(top: 0),
        constraints: BoxConstraints(
          maxHeight: 15.w,
          maxWidth: 15.w,
        ),
        counter: Offstage(),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(2.4.w)),
      ),
    );
  }

  String getOtpValue() {
    return contrller1!.text +
        contrller2!.text +
        contrller3!.text +
        contrller4!.text;
  }
}
