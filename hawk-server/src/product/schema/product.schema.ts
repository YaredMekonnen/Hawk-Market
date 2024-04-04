import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Types } from 'mongoose';

@Schema({
  timestamps: true,
  versionKey: false,
})
export class Product {
  @Prop({ required: true })
  name: string;

  @Prop({ required: true })
  description: string;

  @Prop({ required: true })
  price: number;

  @Prop({ required: true })
  photos: string[];

  @Prop({ required: true })
  tags: string;

  @Prop({ type: Types.ObjectId, required: true, ref: 'User' })
  owner: Types.ObjectId;

}

export const ProductSchema = SchemaFactory.createForClass(Product);
