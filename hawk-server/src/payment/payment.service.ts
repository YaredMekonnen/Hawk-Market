import { Injectable } from '@nestjs/common';
import Stripe from 'stripe';
import { CreatePaymentDto } from './dto/create-payment';
import { ConfirmPaymentDto } from './dto/confirm-payment';
import { ConfigService } from '@nestjs/config';

enum ConfirmationMethod {
	Automatic = 'automatic',
	Manual = 'manual',
}

@Injectable()
export class PaymentService {

	stripe: Stripe;
	constructor(private configService: ConfigService) {
		this.stripe = new Stripe(configService.get<string>('stripeSecretKey'));
	}

	async createPayment(createPaymentDto: CreatePaymentDto) {
		const params = {
			amount: createPaymentDto.amount * 100,
			confirm: true,
			currency: createPaymentDto.currency,
			payment_method: createPaymentDto.paymentMethodId,
			use_stripe_sdk: true,
			'automatic_payment_methods[enabled]': 'true',
			'automatic_payment_methods[allow_redirects]': 'never',
		};

		console.log(params); 

		const paymentIntent = await this.stripe.paymentIntents.create(params);

		console.log(paymentIntent);

		return this.generateResponse(paymentIntent);
	}

	async confirmPayment(confirmPaymentDto: ConfirmPaymentDto) {
		const { paymentIntentId } = confirmPaymentDto;

		try {
			// Confirm the PaymentIntent to finalize payment after handling a required action
			// on the client.
			const intent = await this.stripe.paymentIntents.confirm(paymentIntentId);
			// After confirm, if the PaymentIntent's status is succeeded, fulfill the order.
			return this.generateResponse(intent);
		} catch (e) {
			// Handle "hard declines" e.g. insufficient funds, expired card, etc
			// See https://stripe.com/docs/declines/codes for more.
			return { error: e.message };
		}
	}


	generateResponse(intent: Stripe.PaymentIntent) {
		// Generate a response based on the intent's status
		switch (intent.status) {
			case 'requires_action':
				// Card requires authentication
				return {
					clientSecret: intent.client_secret,
					requiresAction: true,
					status: intent.status,
				};
			case 'requires_payment_method':
				// Card was not properly authenticated, suggest a new payment method
				return {
					error: 'Your card was denied, please provide a new payment method',
				};
			case 'succeeded':
				// Payment is complete, authentication not required
				// To cancel the payment after capture you will need to issue a Refund (https://stripe.com/docs/api/refunds).
				console.log('💰 Payment received!');
				return { clientSecret: intent.client_secret, status: intent.status };
		}
		return {
			error: 'Failed',
		};
	};
}