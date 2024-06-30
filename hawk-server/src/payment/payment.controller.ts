import { Body, Controller, Get, Post } from '@nestjs/common';
import { PaymentService } from './payment.service';
import { CreatePaymentDto } from './dto/create-payment';
import { ConfirmPaymentDto } from './dto/confirm-payment';

@Controller('payment')
export class PaymentController {
  constructor(private readonly paymentService: PaymentService) {}

  @Post('create')
  async createPayment(@Body() createPaymentDto: CreatePaymentDto) {
    return this.paymentService.createPayment(createPaymentDto);
  }

  @Post('confirm')
  async confirmPayment(@Body() confirmPayment: ConfirmPaymentDto) {
    return this.paymentService.confirmPayment(confirmPayment);
  }
}
