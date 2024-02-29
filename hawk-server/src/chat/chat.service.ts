import { Injectable } from '@nestjs/common';
import { CreateChatDto } from './dto/create-chat.dto';
import { UpdateChatDto } from './dto/update-chat.dto';
import { MessageService } from 'src/message/message.service';
import { CreateMessageDto } from 'src/message/dto/create-message.dto';

@Injectable()
export class ChatService {

  constructor(
    private readonly messageService: MessageService
  ){}

  create(createChatDto: CreateChatDto) {
    return 'This action adds a new chat';
  }

  saveMessage(chatId: string, message: String, senderId: string) {
    
    const createMessageDto = new CreateMessageDto();
    createMessageDto.chatId = chatId;
    createMessageDto.content = message;
    createMessageDto.senderId = senderId;

    this.messageService.create(createMessageDto);

  }

  findAll() {
    return `This action returns all chat`;
  }

  findOne(id: number) {
    return `This action returns a #${id} chat`;
  }

  update(id: number, updateChatDto: UpdateChatDto) {
    return `This action updates a #${id} chat`;
  }

  remove(id: number) {
    return `This action removes a #${id} chat`;
  }
}
