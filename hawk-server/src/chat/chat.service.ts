import { Injectable } from '@nestjs/common';
import { CreateChatDto } from './dto/create-chat.dto';
import { UpdateChatDto } from './dto/update-chat.dto';
import { MessageService } from 'src/message/message.service';
import { CreateMessageDto } from 'src/message/dto/create-message.dto';
import { InjectModel } from '@nestjs/mongoose';
import { ChatDocument } from './model/chat.model';
import { Model, Types } from 'mongoose';
import { Chat } from './entities/chat.entity';

@Injectable()
export class ChatService {

  constructor(
    @InjectModel(ChatDocument.name) private readonly chatModel: Model<ChatDocument>,
    private readonly messageService: MessageService
  ){}

  async create(createChatDto: CreateChatDto) {
    const chat = await this.chatModel.create({
      owners: createChatDto.owners.map((ownerId)=>new Types.ObjectId(ownerId)),
      numberOfUnread: createChatDto.owners.reduce((acc, ownerId)=>({...acc, [ownerId]: 0}), {}),
    });

    const populatedChat = await this.chatModel.findById(chat._id).populate('owners');
    return Chat.fromDocument(populatedChat);
  }

  async saveMessage(chatId: string, message: String, senderId: string) {
    
    const createMessageDto = new CreateMessageDto();
    createMessageDto.chatId = chatId;
    createMessageDto.content = message;
    createMessageDto.senderId = senderId;

    return await this.messageService.create(createMessageDto);
  }

  async findAll() {
    const chats = await this.chatModel.find();
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
