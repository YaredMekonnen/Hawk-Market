import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { MESSAGE_TYPE } from '../enum/message-type.enum';
import { Types, Document } from 'mongoose';

@Schema({
  collection: "messages",
  timestamps: true,
  versionKey: false
})
export class MessageDocument extends Document {
  _id: Types.ObjectId;
  
  @Prop({ type: String, required: false, default: '' })
  image: string;

  @Prop({ type: String, required: false, default: '' })
  text: string;

  @Prop({ type: String, enum : MESSAGE_TYPE, required: true, default: 'text' })
  type: string;

  @Prop({ type: Types.ObjectId, required: true })
  senderId: Types.ObjectId;

  @Prop({ type: Types.ObjectId, required: true })
  chatId: Types.ObjectId;

  @Prop({ type: Date, default: Date.now })
  createdAt: Date;
}

export const MessageSchema = SchemaFactory.createForClass(MessageDocument);
