import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { CreateProductDto } from '../dto/create-product.dto';
import { UpdateProductDto } from '../dto/update-product.dto';
import { InjectModel } from '@nestjs/mongoose';
import { Product } from '../schema/product.schema';
import { Model, Types } from 'mongoose';
import { IProduct } from '../interface/product.interface';
import { CloudinaryService } from 'src/cloudinary/cloudinary.service';

@Injectable()
export class ProductService {
  constructor(
    @InjectModel(Product.name) private productModel: Model<IProduct>,
    private readonly cloundinaryService: CloudinaryService,
  ) {}
  async create(createProductDto: CreateProductDto, photos: Express.Multer.File[]): Promise<IProduct> {

    const uploadPromises = photos.map(async (photo) => {
      return this.cloundinaryService.upload(photo);
    })

    const photoUrls = await Promise.all(uploadPromises);

    try {

      return await this.productModel.create({
        photos: photoUrls,
        ...createProductDto,
        owner: new Types.ObjectId(createProductDto.owner)
      })


    } catch (err) {
      throw new BadRequestException('Something went wrong');
    }
  }

  async findAll(page: number, limit: number, search: string): Promise<{data: IProduct[]}> {
    let products: IProduct[];

    const skip = ((page || 1) - 1) * (limit || 10);
    
    try {
      products = await this.productModel.find(
        search !== '' ? { name: { $regex: search, $options: 'i' } } : {}
      ).skip(skip)
      .limit(limit || 10)
      .populate('owner')
      .exec();

      return {
        data: products
      }
    } catch (err) {
      throw new BadRequestException('Something Went Wrong');
    }
  }

  async findOne(id: string): Promise<IProduct> {
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
    id: string,
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

  async remove(id: string): Promise<IProduct> {
    let product: IProduct;
    try {
      await this.findOne(id);
      this.productModel.deleteOne((product) => product.id == id);
    } catch (err) {
      throw err;
    }
    return product;
  }

  async getPosted(userId: string, page: number, limit: number, search: string): Promise<{data: IProduct[]}> {
    let products: IProduct[];

    const skip = ((page || 1) - 1) * (limit || 10);
    
    try {
      products = await this.productModel.find(
        { owner: userId }
      ).skip(skip)
      .limit(limit)
      .populate('owner')
      .exec();

      return {
        data: products
      }
    } catch (err) {
      throw new BadRequestException('Something Went Wrong');
    }
  }
}
