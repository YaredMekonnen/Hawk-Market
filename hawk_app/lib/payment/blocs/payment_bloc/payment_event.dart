part of 'payment_bloc.dart';

@immutable
sealed class PaymentEvent {}

final class PaymentCreateIntent extends PaymentEvent {
  final BillingDetails billingDetails;
  final String currency;
  final double amount;

  PaymentCreateIntent(
      {required this.billingDetails,
      required this.currency,
      required this.amount});
}

final class PaymentConfirm extends PaymentEvent {
  final String clientScreat;
  PaymentConfirm(this.clientScreat);
}
