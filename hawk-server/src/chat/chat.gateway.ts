import { 
  WebSocketGateway, 
  SubscribeMessage,
  MessageBody, 
  WebSocketServer, 
  ConnectedSocket 
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { ChatService } from './chat.service';
import { CreateChatDto } from './dto/create-chat.dto';
import { UseFilters, UsePipes, ValidationPipe } from '@nestjs/common';
import { AllExceptionsFilter } from './filters/websocket-exception.filter';
import { ConnectedDto } from './dto/connected.dto';
import { WEBSOCKET_EVENTS } from './events/event.enum';
import { CreateTextMessageDto } from 'src/message/dto/create-text-message.dto';
import { ReadMessageDto } from './dto/read-message.dto';
import { WSValidationPipe } from './pipes/ws-validation.pipe';
import { RTO } from 'src/utils/models/response';

@UseFilters(new AllExceptionsFilter())
@UsePipes(new WSValidationPipe())
@WebSocketGateway()
export class ChatGateway {

  @WebSocketServer()
  server: Server;

  constructor(private readonly chatService: ChatService) {}

  @SubscribeMessage(WEBSOCKET_EVENTS.CONNECTED)
  onConnection(
    @MessageBody() payload: ConnectedDto,
    @ConnectedSocket() client: Socket
  ) {
    client.join(payload.userId);
  }

  @SubscribeMessage(WEBSOCKET_EVENTS.NEW_CHAT)
  async createChat(@MessageBody() createChatDto: CreateChatDto) {
    const chat = await this.chatService.create(createChatDto);

    this.sendEventToRoom(
      WEBSOCKET_EVENTS.UPDATE_CHAT, 
      new RTO(true, chat),
      chat.owners.find((owner)=>owner.id !== createChatDto.senderId).id
    );

    return new RTO(true, chat);
  }

  @SubscribeMessage(WEBSOCKET_EVENTS.NEW_MESSAGES)
  async sendImageMessage(@MessageBody() data: any) {
    const chat = await this.chatService.findOne(data.chatId);

    this.sendEventToRoom(
      WEBSOCKET_EVENTS.NEW_MESSAGES,
      new RTO(true, data.messages),
      data.reciverId
    );

    this.sendEventToRooms(
      WEBSOCKET_EVENTS.UPDATE_CHAT,
      new RTO(true, chat),
      chat.owners.map((owner)=>owner.id)
    )
  }

  @SubscribeMessage(WEBSOCKET_EVENTS.NEW_MESSAGE)
  async sendMessage(@MessageBody() payload: CreateTextMessageDto) {
    const chat = await this.chatService.findOne(payload.chatId);
    const otherOwner = chat.owners.find((owner)=>owner.id !== payload.senderId).id
    const message = await this.chatService.createMessage(payload, otherOwner);

    const updatedChat = await this.chatService.findOne(message.chatId);

    this.sendEventToRoom(
      WEBSOCKET_EVENTS.NEW_MESSAGE,
      new RTO(true, message),
      chat.owners.find((owner)=>owner.id !== message.senderId).id
    );

    this.sendEventToRooms(
      WEBSOCKET_EVENTS.UPDATE_CHAT,
      new RTO(true, updatedChat),
      chat.owners.map((owner)=>owner.id)
    )

    return new RTO(true, message);
  }

  @SubscribeMessage(WEBSOCKET_EVENTS.READ_MESSAGE)
  async readMessage(@MessageBody() payload: ReadMessageDto) {
    const chat = await this.chatService.readMessage(payload.chatId, payload.userId);

    this.sendEventToRoom(
      WEBSOCKET_EVENTS.UPDATE_CHAT,
      new RTO(true, chat),
      payload.userId
    );
  }

  sendEventToRoom(event: WEBSOCKET_EVENTS, data: any, room: string){
    this.server.to(room).emit(event, data);
  }

  sendEventToRooms(event: WEBSOCKET_EVENTS, data: any, room: string[]){
    this.server.to(room).emit(event, data);
  }
}
