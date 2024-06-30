import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { CreateProductDto } from '../dto/create-product.dto';
import { UpdateProductDto } from '../dto/update-product.dto';
import { InjectModel } from '@nestjs/mongoose';
import { ProductDocument } from '../schema/product.schema';
import { Model, Types, now } from 'mongoose';
import { Product } from '../entity/product.entity';
import { CloudinaryService } from 'src/cloudinary/cloudinary.service';
import { Story } from '../entity/story.entity';
import { User } from 'src/user/entity/user.entity';

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

    if (photos.length === 0) {
      throw new BadRequestException('At least one photo is required');
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

  async findAll(skip: number, limit: number, search: string, user: User): Promise<Product[]> {
    const products = await this.productModel.find(
      search !== '' ? { name: { $regex: search, $options: 'i' } } : {}
    ).skip(skip || 0)
    .limit(limit || 10)
    .sort({ createdAt: -1 })
    .populate('owner')
    .exec();

    return Product.fromDocumentsWithBookmark(products, user)
  }

  async findOne(id: string, user: User): Promise<Product> {
    const product = await this.productModel.findById(id).populate('owner');

    if (!product) {
      throw new NotFoundException('Product not found');
    }

    return Product.fromDocumentWithBookmark(product, user);
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

  async getPosted(userId: string, skip: number, limit: number, search: string): Promise<Product[]> {

    const products = await this.productModel.find(
      { owner: new Types.ObjectId(userId) }
    ).skip(skip || 0)
    .limit(limit || 10)
    .populate('owner')
    .exec();

    return Product.fromDocuments(products)
  }

  async findMany(ids: Types.ObjectId[]): Promise<Product[]> {
    const products = await this.productModel.find({
      _id: { $in: ids }
    }).populate('owner').exec();

    return Product.fromDocuments(products);
  }

  async createStory(id: string){
    const updatedProduct = await this.productModel
      .findByIdAndUpdate(id, {
        story: true,
        storyDate: now()
      })
      .populate('owner');

    if (!updatedProduct)
      throw new NotFoundException("Post not found");
    

    return Story.fromDocument(updatedProduct);
  }

  async findAllStory(skip: number, limit: number): Promise<Story[]> {
    const now = new Date();
    const twentyFourHoursAgo = new Date(now.getTime() - (24 * 60 * 60 * 1000));

    const products = await this.productModel.find({
      story: true,
      storyDate: { $gte: twentyFourHoursAgo }
    })
    .skip(skip || 0)
    .limit(limit || 10)
    .sort({ storyDate: -1 })
    .populate('owner')
    .exec();

    return Product.fromDocuments(products);
  }

  async findUserStories(userId: string, skip: number, limit: number): Promise<Story[]> {
    const now = new Date();

    const products = await this.productModel.find({
      story: true,
      owner: new Types.ObjectId(userId)
    })
    .skip(skip || 0)
    .limit(limit || 10)
    .populate('owner')
    .exec();

    return Product.fromDocuments(products);
  }

  async removeStory(id: string) {
    const deletedData = this.productModel.findByIdAndUpdate(id,{
      story: false
    });

    if(!deletedData)
      throw new NotFoundException("Product not found")

    return {
      deleted: true
    }
  }
}
