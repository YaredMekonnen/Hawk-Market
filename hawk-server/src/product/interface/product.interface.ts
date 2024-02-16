import { Document } from 'mongoose';

export interface IProduct extends Document {
  name: string;
  description: string;
  price: number;
  photos: string[];
  category: string;
  condition: string;
  brand: string;
}
