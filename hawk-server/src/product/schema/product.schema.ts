import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

@Schema({
  timestamps: true,
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
  category: string;

  @Prop({ required: true })
  condition: string;

  @Prop({ required: true })
  brand: string;
}

export const ProductSchema = SchemaFactory.createForClass(Product);
