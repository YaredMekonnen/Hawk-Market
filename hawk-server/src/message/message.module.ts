import { Module } from '@nestjs/common';
import { MessageService } from './message.service';
import { MessageController } from './message.controller';
import { MessageDocument, MessageSchema } from './schema/message.shema';
import { MongooseModule } from '@nestjs/mongoose';
import { CloudinaryService } from 'src/cloudinary/cloudinary.service';
import { ChatService } from 'src/chat/chat.service';
import { ChatModule } from 'src/chat/chat.module';
import { ChatDocument, ChatSchema } from 'src/chat/model/chat.model';
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
    UserModule
  ],
  controllers: [MessageController],
  providers: [MessageService, CloudinaryService, ChatService],
})
export class MessageModule {}
