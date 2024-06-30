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
  Patch,
  UseGuards,
} from '@nestjs/common';
import { UserService } from '../service/user.service';
import { CreateUserDto } from '../dto/create-user.dto';
import { UpdateUserDto } from '../dto/update-user.dto';
import { FileInterceptor } from '@nestjs/platform-express';
import { RTO } from 'src/utils/models/response';
import { JwtAuthGuard } from 'src/auth/guards/jwt-auth.guard';
import { User } from 'src/auth/decorators/user.decorator';
import {User as UserEntity} from '../entity/user.entity';

@Controller('profile')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Post()
  async create(@Body() createUserDto: CreateUserDto) {
    const response = await this.userService.create(createUserDto);
    return new RTO(true, response);
  }

  @UseGuards(JwtAuthGuard)
  @Post('bookmark/:productId')
  async bookmark(
    @Param('productId') productId: string, 
    @User() user: UserEntity,
  ){
    const response = await this.userService.bookmark(productId, user.id);
    return new RTO(true, response);
  }

  @Get()
  async findAll() {
    const response = await this.userService.findAll();
    return new RTO(true, response);
  }

  @Get('bookmark/:userId')
  async findBookmark(@Param('userId') userId: string){
    const response = await this.userService.findBookmark(userId);
    return new RTO(true, response);
  }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    const response = await this.userService.findOne(id);
    return new RTO(true, response);
  }

  @Patch(':id')
  @UseInterceptors(FileInterceptor('image'))
  async update(
    @UploadedFile() image: Express.Multer.File, 
    @Param('id') id: string, 
    @Body() updateUserDto: UpdateUserDto
  ) {
    const response = await this.userService.update(id, image, updateUserDto);
    return new RTO(true, response);
  }

  @Delete(':id')
  async remove(@Param('id') id: string) {
    const response = await this.userService.remove(id);
    return new RTO(true, response);
  }
}
