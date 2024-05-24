import { Document, Types } from 'mongoose';
import { ProductDocument } from '../schema/product.schema';
import { User } from 'src/user/entity/user.entity';

export class Product{
  id: string;
  name: string;
  description: string;
  price: number;
  photos: string[];
  tags: string;
  owner: User;

  constructor(document: ProductDocument) {
    this.id = document._id.toString();
    this.name = document.name;
    this.description = document.description;
    this.price = document.price;
    this.photos = document.photos;
    this.tags = document.tags;
    this.owner = document.owner instanceof Types.ObjectId ? 
      document.owner : 
      User.fromDocument(document.owner);
  }

  static fromDocument(document: ProductDocument): Product {
    return new Product(document);
  }

  static fromDocuments(documents: ProductDocument[]): Product[] {
    return documents.map((document)=>new Product(document))
  }
}
