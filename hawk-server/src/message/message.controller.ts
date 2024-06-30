import { Controller, Get, Post, Body, Patch, Param, Delete, Query, UseInterceptors, UploadedFiles } from '@nestjs/common';
import { MessageService } from './message.service';
import { CreateImageMessageDto } from './dto/create-image-message.dto';
import { UpdateMessageDto } from './dto/update-message.dto';
import { FilesInterceptor } from '@nestjs/platform-express';
import { RTO } from 'src/utils/models/response';
import { ChatService } from 'src/chat/chat.service';

@Controller('chat/:chatId/message')
export class MessageController {
  constructor(private readonly messageService: MessageService, private readonly chatService: ChatService) {}

  @Post()
  @UseInterceptors(FilesInterceptor('images', 5))
  async create(
    @UploadedFiles() images: Express.Multer.File[],
    @Body() createMessageDto: CreateImageMessageDto
  ) {
    const response = await this.messageService.createImagesMessage(createMessageDto, images);
    const chat = await this.chatService.findOne(response[0].chatId);
    const otherOwner = chat.owners.find((user)=>user.id !== response[0].senderId).id
    const promises = response.map(
      (message) => 
        this.chatService.addMessage(
          createMessageDto.chatId, 
          message.id, 
          otherOwner
        )
      );
    await Promise.all(promises);
    return new RTO(true, response)
  }

  @Get()
  async findAll(
    @Query('skip') skip: number,
    @Query('limit') limit: number,
    @Param('chatId') chatId: string
  ) {
    const response = await this.messageService.findAll(chatId, skip, limit);
    return new RTO(true, response)
  }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    const response = await this.messageService.findOne(id);
    return new RTO(true, response)
  }
}
