import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Types, Document } from 'mongoose';
import { UserDocument } from 'src/user/schema/user.schema';

@Schema({
  collection: "products",
  timestamps: true,
  versionKey: false,
})
export class ProductDocument extends Document {
  _id: Types.ObjectId;

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

  @Prop({ type: Types.ObjectId, required: true, ref: UserDocument.name })
  owner: UserDocument;
}

export const ProductSchema = SchemaFactory.createForClass(ProductDocument);
