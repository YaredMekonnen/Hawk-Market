import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { CreateProductDto } from '../dto/create-product.dto';
import { UpdateProductDto } from '../dto/update-product.dto';
import { InjectModel } from '@nestjs/mongoose';
import { Product } from '../schema/product.schema';
import { Model } from 'mongoose';
import { IProduct } from '../interface/product.interface';

@Injectable()
export class ProductService {
  constructor(
    @InjectModel(Product.name) private productModel: Model<IProduct>,
  ) {}
  async create(createProductDto: CreateProductDto): Promise<IProduct> {
    let product = new this.productModel(CreateProductDto);
    let savedProduct: IProduct;

    try {
      savedProduct = await product.save();
    } catch (err) {
      throw new BadRequestException('Something went wrong');
    }

    if (!savedProduct) {
      throw new BadRequestException('Something Went Wrong');
    }
    return savedProduct;
  }

  async findAll(): Promise<IProduct[]> {
    let products: IProduct[];

    try {
      products = await this.productModel.find();
    } catch (err) {
      throw new BadRequestException('Something Went Wrong');
    }

    if (!products) {
      throw new NotFoundException('Products Not Found');
    }
    return products;
  }

  async findOne(id: number): Promise<IProduct> {
    let product: IProduct;

    try {
      product = await this.productModel.findById(id);
    } catch (err) {
      throw err;
    }

    if (!product) {
      throw new NotFoundException('Product not found');
    }

    return product;
  }

  async update(
    id: number,
    updateProductDto: UpdateProductDto,
  ): Promise<IProduct> {
    let updatedProduct: IProduct;
    try {
      await this.findOne(id);
      updatedProduct = await this.productModel.findByIdAndUpdate(
        id,
        updateProductDto,
        { new: true },
      );
    } catch (err) {
      throw err;
    }
    return updatedProduct;
  }

  async remove(id: number): Promise<IProduct> {
    let product: IProduct;
    try {
      await this.findOne(id);
      this.productModel.deleteOne((product) => product.id == id);
    } catch (err) {
      throw err;
    }
    return product;
  }
}
