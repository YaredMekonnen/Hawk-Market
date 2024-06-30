import { IsEnum, IsNotEmpty, IsString } from "class-validator";
import { MESSAGE_TYPE } from "../enum/message-type.enum";

export class CreateTextMessageDto {
    @IsNotEmpty()
    @IsString()
    text: string;

    @IsNotEmpty()
    @IsString()
    senderId: string;

    @IsNotEmpty()
    @IsString()
    chatId: string;
    
    @IsNotEmpty()
    @IsEnum(MESSAGE_TYPE)
    type: string;
}
