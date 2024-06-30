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
  story: boolean;
  isBookmarked: boolean;
  isOwn: boolean;
  createdAt: Date;

  constructor(document: ProductDocument) {
    this.id = document._id.toString();
    this.name = document.name;
    this.description = document.description;
    this.price = document.price;
    this.photos = document.photos;
    this.tags = document.tags;
    this.owner = User.fromDocument(document.owner);
    this.story = document.story;
    this.createdAt = document.createdAt;
  }

  static fromDocument(document: ProductDocument): Product {
    return new Product(document);
  }

  static fromDocuments(documents: ProductDocument[]): Product[] {
    return documents.map((document)=>new Product(document))
  }

  static fromDocumentWithBookmark(document: ProductDocument, user: User): Product {
    const bookmarks = new Set(user.bookmarks)

    const product = new Product(document);
    product.isBookmarked = bookmarks.has(document._id.toString());
    product.isOwn = document.owner._id.toString() === user.id;
    
    return product;
  }

  static fromDocumentsWithBookmark(documents: ProductDocument[], user: User): Product[] {
    const bookmarks = new Set(user.bookmarks)
    const productsBookmarked: Product[] = []

    for (const document of documents) {
      const product = new Product(document);
      product.isBookmarked = bookmarks.has(document._id.toString());
      product.isOwn = document.owner._id.toString() === user.id;
      productsBookmarked.push(product);
    }

    return productsBookmarked;
  }
}
