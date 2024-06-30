import { Document } from 'mongoose';
import { UserDocument } from '../schema/user.schema';

export class User {
  id: string;
  username: string;
  email: string;
  profileUrl: string;
  bio: string;
  bookmarks: string[];

  constructor(document: UserDocument) {
    this.id = document._id.toString(),
    this.username = document.username,
    this.email = document.email,
    this.profileUrl = document.profileUrl,
    this.bio = document.bio
    this.bookmarks = document.bookmarks.map((bookmark)=>bookmark.toString())
  };

  static fromDocument(document: UserDocument): User {
    return new User(document);
  }

  static fromDocuments(documents: UserDocument[]): User[] {
    return documents.map((document)=>new User(document))
  }

}
