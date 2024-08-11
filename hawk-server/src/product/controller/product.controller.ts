import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseInterceptors,
  UploadedFiles,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ProductService } from '../service/product.service';
import { CreateProductDto } from '../dto/create-product.dto';
import { UpdateProductDto } from '../dto/update-product.dto';
import { FilesInterceptor } from '@nestjs/platform-express';
import { JwtAuthGuard } from 'src/auth/guards/jwt-auth.guard';
import { User as UserEntity } from 'src/user/entity/user.entity';
import { User } from 'src/auth/decorators/user.decorator';
import { RTO } from 'src/utils/models/response';

@UseGuards(JwtAuthGuard)
@Controller('product')
export class ProductController {
  constructor(private readonly productService: ProductService) {}

  @Post()
  @UseInterceptors(FilesInterceptor('images', 5))
  async create(
    @User() user: UserEntity, 
    @UploadedFiles() images: Express.Multer.File[], 
    @Body() createProductDto: CreateProductDto
  ) {
    const response = await this.productService.create(user.id, createProductDto, images);
    return new RTO(true, response);
  }

  @Get()
  async findAll(
    @Query('skip') skip: number, 
    @Query('limit') limit: number,
    @Query('search') search: string = '',
    @User() user: UserEntity,
  ){
    const response = await this.productService.findAll(skip, limit, search, user);
    return new RTO(true, response);
  }

  @Get('posted/:userId')
  async findPosted(
    @User() user: UserEntity, 
    @Query('index') index: number, 
    @Query('limit') limit: number,
    @Query('search') search: string = ''
  ){
    const response = await this.productService.getPosted(user.id, index, limit, search);
    return new RTO(true, response);
  }

  @Get('story')
  async findStory(
    @Query('skip') skip: number, 
    @Query('limit') limit: number, 
  ){
    const response = await this.productService.findAllStory(skip, limit);
    return new RTO(true, response);
  }

  @Get('story/:id')
  async findUserStory(
    @Param('id') userId: string,
    @Query('skip') skip: number, 
    @Query('limit') limit: number, 
  ){
    const response = await this.productService.findUserStories(userId, skip, limit);
    return new RTO(true, response);
  }

  @Get(':id')
  async findOne(
    @Param('id') id: string, 
    @User() user: UserEntity
  ) {
    const response = await this.productService.findOne(id, user);
    return new RTO(true, response);
  }

  @Patch(':id')
  async update(
    @Param('id') id: string, 
    @Body() updateProductDto: UpdateProductDto
  ) {
    const response = await this.productService.update(id, updateProductDto);
    return new RTO(true, response);
  }

  @Delete(':id')
  async remove(@Param('id') id: string) {
    const response = await this.productService.remove(id);
    return new RTO(true, response);
  }

  @Post('story/:id')
  async makeStory(@Param('id') id: string) {
    const response = await this.productService.createStory(id);
    return new RTO(true, response);
  }

  @Delete('story/:id')
  async removeStory(@Param('id') id: string) {
    const response = await this.productService.removeStory(id);
    return new RTO(true, response);
  }
}
