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

@UseGuards(JwtAuthGuard)
@Controller('product')
export class ProductController {
  constructor(private readonly productService: ProductService) {}

  @Post()
  @UseInterceptors(FilesInterceptor('images', 5))
  create(
    @User() user: UserEntity, 
    @UploadedFiles() images: Express.Multer.File[], 
    @Body() createProductDto: CreateProductDto
  ) {
    return this.productService.create(user.id, createProductDto, images);
  }

  @Get()
  findAll(@Query('page') page: number, @Query('limit') limit: number, @Query('search') search: string = ''){
    return this.productService.findAll(page, limit, search);
  }

  @Get('posted/:userId')
  findPosted(@User() user: UserEntity, @Query('page') page: number, @Query('limit') limit: number, @Query('search') search: string = ''){
    return this.productService.getPosted(user.id, page, limit, search);
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
