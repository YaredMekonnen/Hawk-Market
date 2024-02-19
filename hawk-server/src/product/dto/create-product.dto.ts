import { IsArray, IsNotEmpty, IsNumber, IsString, Min } from 'class-validator';

export class CreateProductDto {
  @IsNotEmpty()
  @IsString()
  name;

  @IsNotEmpty()
  @IsString()
  description;

  @IsNotEmpty()
  @IsNumber()
  @Min(0)
  price;

  @IsNotEmpty()
  @IsString()
  category;

  @IsNotEmpty()
  @IsString()
  condition;

  @IsNotEmpty()
  @IsString()
  brand;
}
