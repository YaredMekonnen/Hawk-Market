import { Prop, Schema, SchemaFactory, } from '@nestjs/mongoose';
import { Types, Document } from 'mongoose';
import { ProductDocument, ProductSchema } from 'src/product/schema/product.schema';
import { Otp } from '../types/otp.type';

@Schema({
  collection: "users",
  timestamps: true,
  versionKey: false,
})
export class UserDocument extends Document {
  _id: Types.ObjectId;

  @Prop({ required: true })
  username: string;

  @Prop({ required: true, unique: true })
  email: string;

  @Prop({ required: true })
  password: string;

  @Prop({ default: '' })
  profileUrl: string;

  @Prop({ default: '' })
  bio: string;

  @Prop({ type: [Types.ObjectId], default: []})
  bookmarks: Types.ObjectId[];

  @Prop({ type: Otp, default: null })
  otp: Otp;
}


export const UserSchema = SchemaFactory.createForClass(UserDocument);