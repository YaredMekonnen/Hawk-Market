import { Module } from '@nestjs/common';
import { ChatService } from './chat.service';
import { ChatGateway } from './chat.gateway';
import { MessageService } from 'src/message/message.service';
import { MongooseModule } from '@nestjs/mongoose';
import { MessageDocument, MessageSchema } from 'src/message/schema/message.shema';
import { ChatDocument, ChatSchema } from './model/chat.model';
import { ChatController } from './chat.controller';
import { CloudinaryService } from 'src/cloudinary/cloudinary.service';
import { UserModule } from 'src/user/user.module';

@Module({
  imports: [
    MongooseModule.forFeature([
      {
        name: MessageDocument.name,
        schema: MessageSchema,
      },
    ]),
    MongooseModule.forFeature([
      {
        name: ChatDocument.name,
        schema: ChatSchema,
      },
    ]),
    UserModule,
  ],
  providers: [ChatGateway, ChatService, MessageService, CloudinaryService],
  controllers: [ChatController],
})
export class ChatModule {}
