import { WebSocketGateway, SubscribeMessage, MessageBody, WebSocketServer } from '@nestjs/websockets';
import { Server } from 'socket.io';
import { ChatService } from './chat.service';
import { CreateChatDto } from './dto/create-chat.dto';
import { UpdateChatDto } from './dto/update-chat.dto';

@WebSocketGateway()
export class ChatGateway {

  @WebSocketServer()
  server: Server;

  constructor(private readonly chatService: ChatService) {}

  @SubscribeMessage('createChat')
  create(@MessageBody() createChatDto: CreateChatDto) {
    return this.chatService.create(createChatDto);
  }

  @SubscribeMessage("joinChat")
  async handleJoinChat(client: any, payload: {chatId: string}){
    const {chatId} = payload;

    try{

      client.join(chatId)
    } catch(e){
      this.server.to(chatId).emit("chatError", "Error on joing chat room")
    }
    
  }

  @SubscribeMessage("message")
  async handleMessage(client: any, payload: {chatId: string, message: string, senderId: string}): Promise<void> {

    const {chatId, message, senderId} = payload

    const savedMessage = await this.chatService.saveMessage(chatId, message, senderId)

    this.server.to(chatId).emit("message", savedMessage);
  }

  @SubscribeMessage('findAllChat')
  findAll() {
    return this.chatService.findAll();
  }

  @SubscribeMessage('findOneChat')
  findOne(@MessageBody() id: number) {
    return this.chatService.findOne(id);
  }

  @SubscribeMessage('updateChat')
  update(@MessageBody() updateChatDto: UpdateChatDto) {
    return this.chatService.update(updateChatDto.id, updateChatDto);
  }

  @SubscribeMessage('removeChat')
  remove(@MessageBody() id: number) {
    return this.chatService.remove(id);
  }
}
