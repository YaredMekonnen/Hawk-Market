import {
  Controller,
  Get,
  Post,
  Body,
  Put,
  Param,
  Delete,
  UseInterceptors,
  UploadedFile,
} from '@nestjs/common';
import { UserService } from '../service/user.service';
import { CreateUserDto } from '../dto/create-user.dto';
import { UpdateUserDto } from '../dto/update-user.dto';
import { FileInterceptor } from '@nestjs/platform-express';

@Controller('profile')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Post()
  create(@Body() createUserDto: CreateUserDto) {
    return this.userService.create(createUserDto);
  }

  @Post('bookmark/:productId/:userId')
  bookmark(@Param('productId') productId: string, @Param('userId') userId: string){
    return this.userService.bookmark(productId, userId);
  }

  @Get()
  findAll() {
    return this.userService.findAll();
  }

  @Get('bookmark/:userId')
  findBookmark(@Param('userId') userId: string){
    return this.userService.findBookmark(userId);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.userService.findOne(id);
  }

  @Put(':id')
  @UseInterceptors(FileInterceptor('image'))
  update(@UploadedFile() image: Express.Multer.File, @Param('id') id: string, @Body() updateUserDto: UpdateUserDto) {
    return this.userService.update(id, image, updateUserDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.userService.remove(id);
  }
}
