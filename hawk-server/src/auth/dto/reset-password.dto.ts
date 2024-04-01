import { IsString, IsNotEmpty } from "class-validator";

export class ResetPasswordDto {

  @IsNotEmpty()
  @IsString()
  otp: string;

  @IsNotEmpty()
  @IsString()
  email: string;

  @IsNotEmpty()
  @IsString()
  password: string;
}