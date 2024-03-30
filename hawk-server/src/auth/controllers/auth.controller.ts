import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
} from '@nestjs/common';
import { AuthService } from '../service/auth.service';
import { LoginDto } from '../dto/Login.dto';
import { CreateUserDto } from 'src/user/dto/create-user.dto';
import { LocalAuthGuard } from '../guards/local-auth.guard';
import { User } from '../decorators/user.decorator';
import { IUser } from 'src/user/interface/user.interface';
import { VerifyOtpDto } from '../dto/verify-otp.dto';
import { ResetPasswordDto } from '../dto/reset-password.dto';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @UseGuards(LocalAuthGuard)
  @Post('login')
  login(@User() user: IUser) {
    return this.authService.login(user);
  }

  @Post('register')
  register(@Body() createUserDto: CreateUserDto) {
    return this.authService.register(createUserDto);
  }

  @Post('forgot-password')
  forgotPassword(@Body() body: { email: string } ) {
    return this.authService.forgotPassword(body.email);
  }

  @Post('verify-otp')
  verifyOtp(@Body() otp: VerifyOtpDto) {
    return this.authService.verifyOtp(otp);
  }

  @Post('reset-password')
  resetPassword(@Body() resetPasswordDto: ResetPasswordDto) {
    return this.authService.resetPassword(resetPasswordDto);
  }
}
