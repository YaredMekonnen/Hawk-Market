import { IsEnum, IsNotEmpty, IsOptional, IsString } from "class-validator";
import { Types } from "mongoose";
import { MESSAGE_TYPE } from "../enum/message-type.enum";

export class CreateImageMessageDto {
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
