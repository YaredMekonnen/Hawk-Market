import 'package:bloc/bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hawk_app/commons/utils/response.dart';
import 'package:hawk_app/payment/repository/payment.repository.dart';
import 'package:meta/meta.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository paymentRepository;

  PaymentBloc(this.paymentRepository) : super(PaymentInitial()) {
    on<PaymentCreateIntent>((event, emit) async {
      emit(PaymentLoading());

      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: event.billingDetails,
          ),
        ),
      );

      final Result paymentIntent =
          await paymentRepository.createPaymentIntent(data: {
        'currency': event.currency,
        'paymentMethodId': paymentMethod.id,
        'amount': event.amount,
      });

      if (paymentIntent is Error) {
        emit(PaymentFailure());
        return;
      }

      if (paymentIntent is Success) {
        var paymentIntentResult = paymentIntent.value;

        if (paymentIntentResult['error'] != null) {
          emit(PaymentFailure());
        }

        if (paymentIntentResult['clientSecret'] != null &&
            paymentIntentResult['requiresAction'] == null) {
          emit(PaymentSuccess());
        }

        if (paymentIntentResult['clientSecret'] != null &&
            paymentIntentResult['requiresAction'] == true) {
          final String clientSecret = paymentIntentResult['clientSecret'];
          add(PaymentConfirm(clientSecret));
        } else {}
      }
    });

    on<PaymentConfirm>(_onPaymentConfirmIntent);
  }

  void _onPaymentConfirmIntent(
    PaymentConfirm event,
    Emitter<PaymentState> emit,
  ) async {
    // The payment requires action calling handleNextAction
    try {
      final paymentIntent =
          await Stripe.instance.handleNextAction(event.clientScreat);

      if (paymentIntent.status == PaymentIntentsStatus.RequiresConfirmation) {
        // Call API to confirm intent

        final Result result = await paymentRepository.confirmPaymentIntent(
          data: {
            'paymentIntentId': paymentIntent.id,
          },
        );

        if (result is Error) {
          emit(PaymentFailure());
        }

        if (result is Success) {
          var value = result.value;
          if (value['error'] != null) {
            emit(PaymentFailure());
          } else {
            emit(PaymentSuccess());
          }
        }
      }
    } catch (err) {
      emit(PaymentFailure());
    }
  }
}
