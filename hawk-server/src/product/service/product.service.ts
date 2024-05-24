import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { CreateProductDto } from '../dto/create-product.dto';
import { UpdateProductDto } from '../dto/update-product.dto';
import { InjectModel } from '@nestjs/mongoose';
import { ProductDocument } from '../schema/product.schema';
import { Model, Types } from 'mongoose';
import { Product } from '../entity/product.entity';
import { CloudinaryService } from 'src/cloudinary/cloudinary.service';

@Injectable()
export class ProductService {
  constructor(
    @InjectModel(ProductDocument.name) private productModel: Model<ProductDocument>,
    private readonly cloundinaryService: CloudinaryService,
  ) {}

  async create(
    ownerId: string,
    createProductDto: CreateProductDto, 
    photos: Express.Multer.File[]
  ): Promise<Product> {

    try {
      createProductDto.price = parseInt(createProductDto.price as any);
    } catch (error) {
      throw new BadRequestException('Price must be a number');
    }

    const uploadPromises = photos.map(async (photo) => {
      return this.cloundinaryService.upload(photo);
    })

    const photoUrls = await Promise.all(uploadPromises);
    
    const createdDoc = await this.productModel.create({
      photos: photoUrls,
      ...createProductDto,
      owner: new Types.ObjectId(ownerId)
    })

    const productDoc = await this.productModel.findById(createdDoc._id).populate('owner');
    return Product.fromDocument(productDoc);
  }

  async findAll(page: number, limit: number, search: string): Promise<{data: Product[]}> {

    const skip = ((page || 1) - 1) * (limit || 10);

    const products = await this.productModel.find(
      search !== '' ? { name: { $regex: search, $options: 'i' } } : {}
    ).skip(skip)
    .limit(limit || 10)
    .populate('owner')
    .exec();

    return {
      data: Product.fromDocuments(products)
    }
  }

  async findOne(id: string): Promise<Product> {
    const product = await this.productModel.findById(id).populate('owner');

    if (!product) {
      throw new NotFoundException('Product not found');
    }

    return Product.fromDocument(product);
  }

  async update(
    id: string,
    updateProductDto: UpdateProductDto,
  ): Promise<Product> {
    const updatedProduct = await this.productModel.findByIdAndUpdate(
      id,
      updateProductDto,
      { new: true },
    ).populate("owner");

    if (!updatedProduct)
      throw new NotFoundException("Product not found");

    return Product.fromDocument(updatedProduct);
  }

  async remove(id: string): Promise<Product> {
    const deletedDoc = (await this.productModel.findByIdAndDelete(id)).populated('owner');

    if (!deletedDoc)
      throw new NotFoundException('Product not found');

    return Product.fromDocument(deletedDoc);
  }

  async getPosted(userId: string, page: number, limit: number, search: string): Promise<{data: Product[]}> {

    const skip = ((page || 1) - 1) * (limit || 10);

    const products = await this.productModel.find(
      { owner: new Types.ObjectId(userId) }
    ).skip(skip)
    .limit(limit)
    .populate('owner')
    .exec();

    return {
      data: Product.fromDocuments(products)
    }
  }

  async findMany(ids: Types.ObjectId[]): Promise<Product[]> {
    const products = await this.productModel.find({
      _id: { $in: ids }
    }).populate('owner').exec();

    return Product.fromDocuments(products);
  }
}
