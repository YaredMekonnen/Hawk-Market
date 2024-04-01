import { Prop, Schema, SchemaFactory, } from '@nestjs/mongoose';
import mongoose, { Types, Document } from 'mongoose';
import { Product, ProductSchema } from 'src/product/schema/product.schema';
import { Otp } from '../types/otp.type';

@Schema({
  timestamps: true,
})
class User extends Document {
  @Prop({ required: true })
  firstName: string;

  @Prop({ required: true })
  lastName: string;

  @Prop({ required: true, unique: true })
  email: string;

  @Prop({ required: true })
  password: string;

  @Prop({ default: '' })
  profileUrl: string;

  @Prop({ default: '' })
  bio: string;

  @Prop({ type: [Types.ObjectId], ref: Product.name, default: []})
  bookmarks: Product[];

  @Prop({ type: Otp, default: null })
  otp: Otp;
}


const UserSchema = SchemaFactory.createForClass(User);

UserSchema.index({ email: 1 });

export { UserSchema, User };