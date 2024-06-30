import {
  Controller,
  Post,
  Body,
  UseGuards,
  UseInterceptors,
  UploadedFile,
  Get,
} from '@nestjs/common';
import { AuthService } from '../service/auth.service';
import { CreateUserDto } from 'src/user/dto/create-user.dto';
import { LocalAuthGuard } from '../guards/local-auth.guard';
import { User } from '../decorators/user.decorator';
import { VerifyOtpDto } from '../dto/verify-otp.dto';
import { ResetPasswordDto } from '../dto/reset-password.dto';
import { User as UserEntity } from 'src/user/entity/user.entity';
import { RTO } from 'src/utils/models/response';
import { FileInterceptor } from '@nestjs/platform-express';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @UseGuards(LocalAuthGuard)
  @Post('login')
  async login(@User() user: UserEntity) {
    const response = await this.authService.login(user);
    return new RTO(true, response);
  }

  @Post('register')
  @UseInterceptors(FileInterceptor('image'))
  async register(
    @Body() createUserDto: CreateUserDto, 
    @UploadedFile() image: Express.Multer.File
  ) {
    const response = await this.authService.register(createUserDto, image);

    return new RTO(true, response);
  }

  @Get('user')
  @UseGuards(JwtAuthGuard)
  async user(@User() user: UserEntity) {
    return new RTO(true, user);
  }

  @Post('forgot-password')
  async forgotPassword(@Body() body: { email: string } ) {
    const response = await this.authService.forgotPassword(body.email);

    return new RTO(true, response);
  }

  @Post('verify-otp')
  async verifyOtp(@Body() otp: VerifyOtpDto) {
    const response = await this.authService.verifyOtp(otp);

    return new RTO(true, response);
  }

  @Post('reset-password')
  async resetPassword(@Body() resetPasswordDto: ResetPasswordDto) {
    const response = await this.authService.resetPassword(resetPasswordDto);

    return new RTO(true, response);
  }
}
