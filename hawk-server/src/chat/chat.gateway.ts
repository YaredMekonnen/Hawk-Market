import { WebSocketGateway, SubscribeMessage, MessageBody, WebSocketServer, ConnectedSocket, OnGatewayConnection, OnGatewayDisconnect } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { ChatService } from './chat.service';
import { CreateChatDto } from './dto/create-chat.dto';
import { UpdateChatDto } from './dto/update-chat.dto';

@WebSocketGateway()
export class ChatGateway implements OnGatewayConnection, OnGatewayDisconnect {

  @WebSocketServer()
  server: Server;

  constructor(private readonly chatService: ChatService) {}

  handleConnection(client: Socket) {
    this.chatService
    client.join
  }

  handleDisconnect(client: any) {
    console.log(`Client disconnected: ${client.id}`);
  }

  @SubscribeMessage('createChat')
  create(@MessageBody() createChatDto: CreateChatDto) {
    this.server.emit("createChat", "This action adds a new chat" )
    return "This action adds a new chat";
    // return this.chatService.create(createChatDto);
  }

  @SubscribeMessage("joinChat")
  async handleJoinChat(@ConnectedSocket() client: Socket, @MessageBody() payload: {chatId: string}){
    const {chatId} = payload;

    try{
      client.join(chatId);
    } catch(e){
      this.server.to(chatId).emit("chatError", "Error on joing chat room");
    }
  }

  @SubscribeMessage("message")
  async handleMessage(@ConnectedSocket() client: Socket, @MessageBody() payload: {chatId: string, message: string, senderId: string}): Promise<void> {

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
