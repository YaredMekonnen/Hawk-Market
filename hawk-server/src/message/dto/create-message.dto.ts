import { IsNotEmpty, IsString } from "class-validator";

export class CreateMessageDto {
    @IsNotEmpty()
    @IsString()
    content;

    @IsNotEmpty()
    @IsString()
    senderId;

    @IsNotEmpty()
    @IsString()
    chatId;
}
