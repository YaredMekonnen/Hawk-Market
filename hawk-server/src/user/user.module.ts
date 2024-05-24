import { Module } from '@nestjs/common';
import { UserService } from './service/user.service';
import { UserController } from './controller/user.controller';
import { MongooseModule } from '@nestjs/mongoose';
import { UserDocument, UserSchema } from './schema/user.schema';
import { CloudinaryService } from 'src/cloudinary/cloudinary.service';
import { ProductService } from 'src/product/service/product.service';
import { ProductModule } from 'src/product/product.module';
import { ProductDocument, ProductSchema } from 'src/product/schema/product.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      {
        name: UserDocument.name,
        schema: UserSchema,
      },
    ]),
    MongooseModule.forFeature([
      {
        name: ProductDocument.name,
        schema: ProductSchema,
      },
    ]),
  ],
  controllers: [UserController],
  providers: [UserService, CloudinaryService, ProductService],
  exports: [UserService],
})
export class UserModule {}
