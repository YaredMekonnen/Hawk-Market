import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateImageMessageDto } from './dto/create-image-message.dto';
import { CreateTextMessageDto } from './dto/create-text-message.dto';
import { UpdateMessageDto } from './dto/update-message.dto';
import { MessageDocument } from './schema/message.shema';
import { Model, Types } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
import { Message } from './entity/message.entity';
import { CloudinaryService } from 'src/cloudinary/cloudinary.service';
import { MESSAGE_TYPE } from './enum/message-type.enum';

@Injectable()
export class MessageService {

  constructor(
    @InjectModel(MessageDocument.name) private messageModel: Model<MessageDocument>,
    private readonly cloundinaryService: CloudinaryService,
  ) {}

  async createTextMessage(createMessageDto: CreateTextMessageDto) {

    const message = await this.messageModel.create({
      ...createMessageDto,
      senderId: new Types.ObjectId(createMessageDto.senderId),
      chatId: new Types.ObjectId(createMessageDto.chatId),
      type: MESSAGE_TYPE.TEXT,
    });

    return Message.fromDocument(message);
  }

  async createImagesMessage(createMessageDto: CreateImageMessageDto,  photos: Express.Multer.File[]) {
    const uploadPromises = photos.map(async (photo) => {
      return this.cloundinaryService.upload(photo);
    })

    const photoUrls = await Promise.all(uploadPromises);

    const formattedMessages = photoUrls.map((photoUrl) => {
      return {
        ...createMessageDto,
        image: photoUrl,
        senderId: new Types.ObjectId(createMessageDto.senderId),
        chatId: new Types.ObjectId(createMessageDto.chatId),
        type: MESSAGE_TYPE.IMAGE,
      }
    })

    const messages = await this.messageModel.insertMany(formattedMessages);
    return Message.fromDocuments(messages as unknown as MessageDocument[]);
  }

  async findAll(
    chatId: string,
    skip: number, 
    limit: number, 
  ) {

    const messages = await this.messageModel
    .find({ chatId: new Types.ObjectId(chatId) })
    .sort({ createdAt: -1 })
    .skip(skip || 0)
    .limit(limit || 10);

    return Message.fromDocuments(messages);
  }

  async findOne(id: string) {
    const message =  await this.messageModel.findById(id);
    if (!message) {
      throw new NotFoundException('Message not found');
    }

    return Message.fromDocument(message);

  }

  async update(id: string, updateMessageDto: UpdateMessageDto) {
    try{
      return await this.messageModel.findByIdAndUpdate(id, updateMessageDto, {new: true});
    } catch (err) {
      throw new Error('Something went wrong');
    }
  }

  async remove(id: string) {
    try {
      return await this.messageModel.findByIdAndDelete(id);
    } catch (err) {
      throw new Error('Something went wrong');
    }
  }
}
