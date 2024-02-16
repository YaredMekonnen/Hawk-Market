import { Module } from '@nestjs/common';
import { AuthService } from './service/auth.service';
import { AuthController } from './controllers/auth.controller';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { UserModule } from 'src/user/user.module';

@Module({
  imports: [
    JwtModule.register({
      secret: 'YOUR_SECRET_KEY',
      signOptions: { expiresIn: '90d' },
    }),
    PassportModule,
    UserModule,
  ],
  controllers: [AuthController],
  providers: [AuthService],
})
export class AuthModule {}
