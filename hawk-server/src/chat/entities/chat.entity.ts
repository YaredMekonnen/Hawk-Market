import { Message } from "src/message/entity/message.entity";
import { User } from "src/user/entity/user.entity";
import { UserDocument } from "src/user/schema/user.schema";
import { ChatDocument } from "../model/chat.model";
import { Types } from "mongoose";

export class Chat {
  id: string;
  numberOfUnread: {};
  messages: Message[];
  owners: User[];

  constructor(document: ChatDocument) {
    this.id = document._id.toString();
    this.numberOfUnread = document.numberOfUnread;
    this.messages = 
      document.messages.length &&
      document.messages[0] instanceof Types.ObjectId ?
      [Message.fromDocument(document.messages[0])] :  Message.fromDocuments(document.messages);
    this.owners = document.owners.map((user)=>User.fromDocument(user));
  }

  static fromDocument(document: ChatDocument): Chat {
    return new Chat(document);
  }

  static fromDocuments(documents: ChatDocument[]): Chat[] {
    return documents.map((document)=>new Chat(document))
  }
}
