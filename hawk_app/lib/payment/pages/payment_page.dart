import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:hawk_app/auth/blocs/auth_cubit/auth_cubit.dart';
import 'package:hawk_app/commons/utils/validators.dart';
import 'package:hawk_app/commons/widgets/button-text.dart';
import 'package:hawk_app/commons/widgets/progress_indecator.dart';
import 'package:hawk_app/commons/widgets/textfield.dart';
import 'package:hawk_app/create_product/blocs/create_product_bloc/create_product_bloc.dart';
import 'package:hawk_app/payment/blocs/payment_bloc/payment_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PaymentPage extends StatefulWidget {
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late CardFormEditController _paymentCardController;
  late TextEditingController _amountController;
  late TextEditingController _currencyController;
  late GlobalKey<FormState> _formKey;
  late List<String> currencies = [
    'USD',
    'EUR',
    'GBP',
    'AED',
    'JPY',
    'INR',
    'AUD',
    'CAD'
  ];

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _paymentCardController = CardFormEditController(
      initialDetails: const CardFieldInputDetails(complete: false),
    );
    _amountController = TextEditingController();
    _currencyController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              GoRouter.of(context).go('/');
            },
          ),
          title: Text(
            'Confirm Payment',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 6.5.w,
                ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: 100.w,
                ),
                Form(
                  key: _formKey,
                  child: SizedBox(
                    width: 90.w,
                    child: CardFormField(
                      controller: _paymentCardController,
                      style: CardFormStyle(
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        cursorColor: Theme.of(context).colorScheme.primary,
                        textColor: Theme.of(context).colorScheme.secondary,
                        fontSize: 4.w.toInt(),
                        placeholderColor: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.7),
                        textErrorColor: Theme.of(context).colorScheme.error,
                        borderColor: Theme.of(context).colorScheme.secondary,
                        borderWidth: 1,
                        borderRadius: 6,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 3.w),
                CustomeTextField(
                  hintText: "Amount",
                  controller: _amountController,
                  validator: priceValidator,
                  inputType: TextInputType.number,
                  enabled: false,
                  value: '1',
                ),
                SizedBox(height: 3.w),
                DropdownMenu(
                  width: 90.w,
                  controller: _currencyController,
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.w),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2.w,
                      ),
                    ),
                  ),
                  textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 4.w,
                      ),
                  initialSelection: currencies.first,
                  dropdownMenuEntries:
                      currencies.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                      value: value,
                      label: value,
                    );
                  }).toList(),
                ),
                SizedBox(height: 20.w),
                BlocBuilder<PaymentBloc, PaymentState>(
                    builder: (context, state) {
                  if (state is PaymentSuccess) {
                    context.read<CreateProductBloc>().add(CreateProduct());
                    Future.delayed(Duration(seconds: 3),
                        () => GoRouter.of(context).go('/?from=/payment'));
                  }
                  return ElevatedButton(
                      onPressed: state is PaymentLoading ||
                              state is PaymentSuccess
                          ? null
                          : () {
                              if (_formKey.currentState!.validate() &&
                                  _paymentCardController.details.complete) {
                                context
                                    .read<PaymentBloc>()
                                    .add(
                                        PaymentCreateIntent(
                                            billingDetails: BillingDetails(
                                                email: context
                                                    .read<AuthCubit>()
                                                    .user!
                                                    .email),
                                            amount: double.parse(
                                                _amountController.text),
                                            currency: _currencyController.text
                                                .toLowerCase()));
                              }
                            },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.resolveWith(
                            (states) => Size(90.w, 13.w)),
                      ),
                      child: state is PaymentLoading
                          ? ButtonProgress()
                          : state is PaymentSuccess
                              ? ButtonText(text: 'Success!')
                              : state is PaymentFailure
                                  ? ButtonText(text: 'Failed')
                                  : const ButtonText(text: 'Pay'));
                }),
              ]),
        ));
  }
}
