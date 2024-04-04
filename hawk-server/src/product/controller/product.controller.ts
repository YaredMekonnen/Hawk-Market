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
import { FileFieldsInterceptor, FileInterceptor, FilesInterceptor } from '@nestjs/platform-express';
import { Express } from 'express';
import { JwtAuthGuard } from 'src/auth/guards/jwt-auth.guard';

@UseGuards(JwtAuthGuard)
@Controller('product')
export class ProductController {
  constructor(private readonly productService: ProductService) {}

  @Post()
  @UseInterceptors(FilesInterceptor('images', 5))
  create(@UploadedFiles() images: Express.Multer.File[], @Body() createProductDto: CreateProductDto) {
    return this.productService.create(createProductDto, images);
  }

  @Get()
  findAll(@Query('page') page: number, @Query('limit') limit: number, @Query('search') search: string = ''){
    return this.productService.findAll(page, limit, search);
  }

  @Get('posted/:userId')
  findPosted(@Param('userId') userId: string, @Query('page') page: number, @Query('limit') limit: number, @Query('search') search: string = ''){
    return this.productService.getPosted(userId, page, limit, search);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.productService.findOne(id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateProductDto: UpdateProductDto) {
    return this.productService.update(id, updateProductDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.productService.remove(id);
  }
}
