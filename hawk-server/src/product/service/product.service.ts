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
import { CloudinaryService } from 'src/cloudinary/cloudinary.service';

@Injectable()
export class ProductService {
  constructor(
    @InjectModel(Product.name) private productModel: Model<IProduct>,
    private readonly cloundinaryService: CloudinaryService,
  ) {}
  async create(createProductDto: CreateProductDto, photos: Express.Multer.File[]): Promise<IProduct> {

    const uploadPromises = photos.map(async (photo) => {
      const url = await this.cloundinaryService.upload(photo);
    })

    const photoUrls = await Promise.all(uploadPromises);

    try {

      return this.productModel.create({
        photos: photoUrls,
        ...createProductDto
      })


    } catch (err) {
      throw new BadRequestException('Something went wrong');
    }
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
}
