import { Body, Controller, Delete, Get, Param, UseGuards } from '@nestjs/common';
import { ChatService } from './chat.service';
import { JwtAuthGuard } from 'src/auth/guards/jwt-auth.guard';
import { User } from 'src/auth/decorators/user.decorator';
import { User as UserEntity } from 'src/user/entity/user.entity';
import { RTO } from 'src/utils/models/response';

@UseGuards(JwtAuthGuard)
@Controller('chat')
export class ChatController {
  constructor(private readonly chatService: ChatService) {}

  @Get()
  async findAll(@User() user: UserEntity){
    const response = await this.chatService.findAll(user.id);
    return new RTO(true, response);
  }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    const response = await this.chatService.findOne(id);
    return new RTO(true, response);
  }

  @Delete(':id')
  async remove(@Param('id') id: string) {
    const response = await this.chatService.remove(id);
    return new RTO(true, response);
  }

  @Get('check/:userId')
  async checkChat(
    @User() user: UserEntity, 
    @Param('userId') userId: string
  ){
    const response = await this.chatService.checkChat(user.id, userId);
    return response;
  }
}
