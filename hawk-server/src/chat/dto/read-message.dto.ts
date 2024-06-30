import { IsMongoId, IsNotEmpty, IsString } from "class-validator";

export class ReadMessageDto {
    @IsNotEmpty()
    @IsString()
    @IsMongoId()
    chatId: string;
    
    @IsNotEmpty()
    @IsString()
    @IsMongoId()
    userId: string;
}