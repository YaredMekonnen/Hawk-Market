import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Types, Document } from 'mongoose';
import { MessageDocument } from 'src/message/schema/message.shema';
import { UserDocument } from 'src/user/schema/user.schema';

@Schema({
  collection: "chats",
  timestamps: true,
  versionKey: false,
})
export class ChatDocument extends Document{
  @Prop({ type: Object, default:{}})
  numberOfUnread: {}

  @Prop({ type: [Types.ObjectId], default: [], ref: MessageDocument.name})
  messages: MessageDocument[]

  @Prop({ type: [Types.ObjectId], required: true, ref: UserDocument.name })
  owners: UserDocument[];
}

export const ChatSchema = SchemaFactory.createForClass(ChatDocument);
