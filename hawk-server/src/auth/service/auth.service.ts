import { BadRequestException, ConflictException, Injectable, InternalServerErrorException } from '@nestjs/common';
import { UserService } from 'src/user/service/user.service';
import { JwtService } from '@nestjs/jwt';
import { IUser } from 'src/user/interface/user.interface';
import { CreateUserDto } from 'src/user/dto/create-user.dto';
import { LoginPayload } from '../interface/login-payload.interface';
import { comparePassword, hashPassword } from 'src/utils/auth/password_utils';

import * as otpGenerator from 'otp-generator';
import { Otp } from 'src/user/types/otp.type';
import { VerifyOtpDto } from '../dto/verify-otp.dto';
import { ResetPasswordDto } from '../dto/reset-password.dto';
import { sendOtp } from 'src/utils/auth/otp-sender';

@Injectable()
export class AuthService {
  constructor(
    private readonly usersService: UserService,
    private readonly jwtService: JwtService,
  ) {}

  async validateUser(payload: LoginPayload) {
    const user = await this.usersService.findOneByEmail(payload.email);

    if (!user) {
      throw new BadRequestException("User not found")
    }

    const isMatch = await comparePassword(payload.password, user.password);

    if (!isMatch) {
      throw new BadRequestException('Wrong Password');
    }

    return user;
  }

  async login(user: IUser) {
    const token = this.jwtService.sign({
        email: user.email,
        userId: user._id.toString(),
      });

    return {
      token
    };

  }

  async register(createUserDto: CreateUserDto) {

    const userExist = await this.usersService.checkUser(createUserDto.email);

    if (userExist) {
      throw new ConflictException('User Already Exist');
    }

    const user = await this.usersService.create(createUserDto);

    if (!user) {
      throw new InternalServerErrorException('Something went wrong');
    }

    return {
      message: 'User Created Successfully',
    };
  }

  async forgotPassword(email: string) {
    const user = await this.usersService.findOneByEmail(email);

    if (!user) {
      throw new BadRequestException('User Not Found');
    }

    const otp = otpGenerator.generate(6, { lowerCaseAlphabets: false, upperCaseAlphabets: false, specialChars: false });

    await sendOtp(user.email, otp);

    await this.usersService.update(user._id, null, { 
      otp: {
        otp: await hashPassword(otp),
        expiry: new Date(Date.now() + 240000),
        verified: false,
      }
    })

    return {
      message: 'Reset Information sent to email',
    };
  }

  async verifyOtp(otp: VerifyOtpDto) {
    const user = await this.usersService.findOneByEmail(otp.email);

    if (!user) {
      throw new BadRequestException('User Not Found');
    }

    if (user.otp.expiry < new Date()) {
      throw new BadRequestException('OTP expired');
    }

    if (!(await comparePassword(otp.otp, user.otp.otp))) {
      throw new BadRequestException('Invalid OTP');
    }

    await this.usersService.update(user._id, null, { 
      otp: {
        otp: user.otp.otp,
        expiry: user.otp.expiry,
        verified: true,
      }
    })

    return {
      message: 'OTP Verified',
    };
  }

  async resetPassword(resetPasswordDto: ResetPasswordDto) {
    const user = await this.usersService.findOneByEmail(resetPasswordDto.email);

    if (!user) {
      throw new BadRequestException('User Not Found');
    }

    if (!user.otp.verified) {
      throw new BadRequestException('OTP not verified');
    }

    if (user.otp.expiry < new Date()) {
      throw new BadRequestException('OTP expired');
    }

    if (!(await comparePassword(resetPasswordDto.otp, user.otp.otp))) {
      throw new BadRequestException('Invalid OTP');
    }

    await this.usersService.update(user._id, null, { 
      password: await hashPassword(resetPasswordDto.password),
      otp: {
        otp: '',
        expiry: new Date(),
        verified: false,
      }
    })

    return {
      message: 'Password Reseted Successfully',
    };
  }
}
