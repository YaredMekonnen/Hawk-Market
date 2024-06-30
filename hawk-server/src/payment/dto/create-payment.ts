import { IsNotEmpty, IsNumber, IsString } from "class-validator";

export class CreatePaymentDto {
    @IsString()
    @IsNotEmpty()
    currency: string;

    @IsNotEmpty()
    @IsString()
    paymentMethodId: string;
    
    @IsNumber()
    @IsNotEmpty()
    amount: number;
}