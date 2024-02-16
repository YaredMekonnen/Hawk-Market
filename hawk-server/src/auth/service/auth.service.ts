import { ConflictException, Injectable } from '@nestjs/common';
import { LoginDto } from '../dto/LoginDto';
import { UserService } from 'src/user/service/user.service';
import { JwtService } from '@nestjs/jwt';
import { JwtPayload } from '../interface/jwtpayload.interface';
import { IUser } from 'src/user/interface/user.interface';
import { CreateUserDto } from 'src/user/dto/create-user.dto';

@Injectable()
export class AuthService {
  constructor(
    private readonly usersService: UserService,
    private readonly jwtService: JwtService,
  ) {}

  async login(loginDto: LoginDto) {
    try {
      const userExist = await this.usersService.checkUserPassword(
        loginDto.email,
        loginDto.password,
      );

      if (!userExist) {
        throw new ConflictException('Invalid Credentials');
      }

      const user: IUser = await this.usersService.findOneByEmail(
        loginDto.email,
      );

      const payload: JwtPayload = {
        id: user.id,
        iat: Math.floor(Date.now() / 1000), // issued at time in seconds
        exp: Math.floor(Date.now() / 1000) + 60 * 60 * 24 * 90, // expiration time in seconds, 90 days
      };

      const token = this.jwtService.sign(payload);

      return {
        token,
        user,
      };
    } catch (error) {
      throw error;
    }
  }
  async register(createUserDto: CreateUserDto) {
    try {
      const userExist = await this.usersService.checkUser(createUserDto.email);

      if (userExist) {
        throw new ConflictException('User Already Exist');
      }

      await this.usersService.create(createUserDto);

      return {
        message: 'User Created Successfully',
      };
    } catch (error) {
      throw error;
    }
  }
}
