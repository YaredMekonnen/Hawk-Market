import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';

@Schema({
  timestamps: true,
})
export class Message {
  @Prop({ required: true })
  content: string;

  @Prop({ required: true })
  senderId: string;

  @Prop({ required: true })
  chatId: string;
}

export const MessageSchema = SchemaFactory.createForClass(Message);
