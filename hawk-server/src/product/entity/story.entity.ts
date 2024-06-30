import { User } from "src/user/entity/user.entity";
import { ProductDocument } from "../schema/product.schema";
import { Types } from "mongoose";

export class Story{
    id: string;
    name: string;
    photos: string[];
    owner: User;
  
    constructor(document: ProductDocument) {
      this.id = document._id.toString();
      this.name = document.name;
      this.photos = document.photos;
      this.owner = User.fromDocument(document.owner);
    }
  
    static fromDocument(document: ProductDocument): Story {
      return new Story(document);
    } 
  
    static fromDocuments(documents: ProductDocument[]): Story[] {
      return documents.map((document)=>new Story(document))
    }
  }
  