import { Document } from 'mongoose';
import { UserDocument } from '../schema/user.schema';

export class User {
  id: string;
  firstName: string;
  lastName: string;
  email: string;
  profileUrl: string;
  bio: string;

  constructor(document: UserDocument) {
    this.id = document._id.toString(),
    this.firstName = document.firstName,
    this.lastName = document.lastName,
    this.email = document.email,
    this.profileUrl = document.profileUrl,
    this.bio = document.bio
  };

  static fromDocument(document: UserDocument): User {
    return new User(document);
  }

  static fromDocuments(documents: UserDocument[]): User[] {
    return documents.map((document)=>new User(document))
  }

}
