import { MessageDocument } from '../schema/message.shema';

export class Message {
  image: string;
  text: string;
  type: string;
  senderId: string;
  chatId: string;

  constructor(document: MessageDocument) {
    this.image = document.image,
    this.text = document.text,
    this.type = document.type,
    this.senderId = document.senderId.toString(),
    this.chatId = document.chatId.toString()
  }

  static fromDocument(document: MessageDocument): Message {
    return new Message(document);
  }

  static fromDocuments(documents: MessageDocument[]): Message[] {
    return documents.map((document)=>new Message(document))
  }
}
