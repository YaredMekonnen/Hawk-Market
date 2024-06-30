import { MESSAGE_TYPE } from '../enum/message-type.enum';
import { MessageDocument } from '../schema/message.shema';

export class Message {
  id: string;
  image: string;
  text: string;
  type: MESSAGE_TYPE;
  senderId: string;
  chatId: string;
  createdAt: Date;

  constructor(document: MessageDocument) {
    this.id = document._id.toString();
    this.image = document.image;
    this.text = document.text;
    this.type = document.type as MESSAGE_TYPE;
    this.senderId = document.senderId.toString();
    this.chatId = document.chatId.toString();
    this.createdAt = document.createdAt;
  }

  static fromDocument(document: MessageDocument): Message {
    return new Message(document);
  }

  static fromDocuments(documents: MessageDocument[]): Message[] {
    return documents.map((document) => new Message(document))
  }
}
