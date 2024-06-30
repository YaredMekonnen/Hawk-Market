import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateChatDto } from './dto/create-chat.dto';
import { UpdateChatDto } from './dto/update-chat.dto';
import { MessageService } from 'src/message/message.service';
import { CreateTextMessageDto } from 'src/message/dto/create-text-message.dto';
import { InjectModel } from '@nestjs/mongoose';
import { ChatDocument } from './model/chat.model';
import { Model, Types } from 'mongoose';
import { Chat } from './entities/chat.entity';
import { MESSAGE_TYPE } from 'src/message/enum/message-type.enum';
import { RTO } from 'src/utils/models/response';
import { UserService } from 'src/user/service/user.service';
import { Message } from 'src/message/entity/message.entity';

@Injectable()
export class ChatService {

  constructor(
    @InjectModel(ChatDocument.name) private readonly chatModel: Model<ChatDocument>,
    private readonly messageService: MessageService,
    private readonly userService: UserService,
  ){}

  async create(createChatDto: CreateChatDto) {

    // Create a chat
    const chatDoc = await this.chatModel.create({
      owners: createChatDto.owners.map((ownerId)=>new Types.ObjectId(ownerId)),
      numberOfUnread: createChatDto.owners.reduce((acc, ownerId)=>({...acc, [ownerId]: 0}), {}),
    });

    // after creating a chat, create a message
    const createMessageDto = new CreateTextMessageDto();
    createMessageDto.chatId = chatDoc._id.toString();
    createMessageDto.senderId = createChatDto.senderId;
    createMessageDto.text = createChatDto.text;

    const message = await this.messageService.createTextMessage(createMessageDto);

    // update the chat with the message and updating the unread number of messsages
    const otherOwner = createChatDto.owners.filter((ownerId)=>ownerId !== createChatDto.senderId)[0];

    const chatDocUpdated = await this.chatModel
    .findByIdAndUpdate(
      chatDoc._id.toString(), 
      {
        messages: [new Types.ObjectId(message.id)], 
        numberOfUnread: {
          [otherOwner]: 1,
          [createChatDto.senderId]: 0
        }
      },
      {new: true}
    )
    .populate(
      [
        {path: 'owners'},
        {path: 'messages'},

      ]
    );

    return Chat.fromDocument(chatDocUpdated);
  }

  async findAll(userId: string) {
    const chats = await this.chatModel
    .find()
    .where({owners: new Types.ObjectId(userId)})
    .populate([
      {path: 'owners'},
      {path: 'messages', options: {
        limit: 1,
        sort: {createdAt: -1}
      }}
    ]);

    return Chat.fromDocuments(chats);
  }

  async findOne(id: string) {
    const chat = await this.chatModel.findById(id).populate([
      {path: 'owners'},
      {path: 'messages', options: {
        sort: { createdAt: -1 },
        limit: 10,
      }}
    ]);
    return Chat.fromDocument(chat);
  }

  async createMessage(createMessageDto: CreateTextMessageDto, otherOwner: string) {
    const message = await this.messageService.createTextMessage(createMessageDto);

    await this.chatModel.findByIdAndUpdate(
      createMessageDto.chatId,
      {
        $inc: { [`numberOfUnread.${otherOwner}`]: 1 },
        $push: { messages: new Types.ObjectId(message.id) } 
      }
    )
    return message;
  }

  async addMessage(chatId: string, messageId: string, otherOwner: string) {
    await this.chatModel.findByIdAndUpdate(
      chatId,
      {
        $inc: { [`numberOfUnread.${otherOwner}`]: 1 },
        $push: { messages: new Types.ObjectId(messageId) } 
      }
    )
  }

  async readMessage(chatId: string, userId: string) {
    const chatDoc = await this.chatModel
    .findByIdAndUpdate(
      chatId,
      { $set: { [`numberOfUnread.${userId}`]: 0 } }
    )
    .populate([
      {path: 'owners'},
      {path: 'messages', options: {
        sort: { createdAt: -1 },
        limit: 1,
      }}
    ]);

    return Chat.fromDocument(chatDoc);
  }

  async remove(id: string) {
    const deletedChat = await this.chatModel.findByIdAndDelete(id);
    return deletedChat;
  }

  async checkChat(userId: string, otherOwner: string) {
    const chatDoc = await this.chatModel.findOne({
      owners: { 
        $all: [
          new Types.ObjectId(userId), 
          new Types.ObjectId(otherOwner)
        ] 
      }
    })
    if (!chatDoc) {
      const otherUser = await this.userService.findOne(otherOwner);
      if (!otherUser) {
        throw new NotFoundException('User not found');
      }
      return new RTO(false, otherUser);
    }

    const chat = await this.findOne(chatDoc._id.toString());
    return new RTO(true, chat);
  }
}
