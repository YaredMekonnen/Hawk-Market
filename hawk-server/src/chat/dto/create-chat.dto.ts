import { IsArray, IsMongoId, IsNotEmpty, IsString, Max, Min } from "class-validator";

export class CreateChatDto {
  
  @Max(2)
  @Min(2)
  @IsNotEmpty()
  @IsArray()
  @IsMongoId({each: true})
  owners: string[];

  @IsString()
  @IsNotEmpty()
  text: string;

  @IsNotEmpty()
  @IsString()
  @IsMongoId()
  senderId: string;
}
