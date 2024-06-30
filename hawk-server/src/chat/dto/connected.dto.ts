import { IsMongoId, IsNotEmpty, IsString } from "class-validator";

export class ConnectedDto {
  @IsNotEmpty()
  @IsString()
  @IsMongoId()
  userId: string;
}