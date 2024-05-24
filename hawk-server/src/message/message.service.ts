import { Injectable } from '@nestjs/common';
import { CreateMessageDto } from './dto/create-message.dto';
import { UpdateMessageDto } from './dto/update-message.dto';
import { MessageDocument } from './schema/message.shema';
import { Model } from 'mongoose';
import { InjectModel } from '@nestjs/mongoose';
import { Message } from './entity/message.entity';

@Injectable()
export class MessageService {

  constructor(
    @InjectModel(MessageDocument.name) private messageModel: Model<MessageDocument>,
  ) {}

  async create(createMessageDto: CreateMessageDto) {

    try{
      return await  this.messageModel.create(createMessageDto);
    } catch (err) {
      throw new Error('Something went wrong');
    }
  }

  async findAll() {
    try {
      return await this.messageModel.find();
    } catch (err) {
      throw new Error('Something went wrong');
    }
  }

  async findOne(id: string) {
    try {
      return await this.messageModel.findById(id);
    } catch (err) {
      throw new Error('Something went wrong');
    }
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
