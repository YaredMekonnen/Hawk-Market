import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { CreateUserDto } from '../dto/create-user.dto';
import { UpdateUserDto } from '../dto/update-user.dto';
import { InjectModel } from '@nestjs/mongoose';
import { UserDocument } from '../schema/user.schema';
import { Model, Types } from 'mongoose';
import { User } from '../entity/user.entity';
import { CloudinaryService } from 'src/cloudinary/cloudinary.service';
import { hashPassword } from 'src/utils/auth/password_utils';
import { Product } from 'src/product/entity/product.entity';
import { ProductService } from 'src/product/service/product.service';

@Injectable()
export class UserService {
  constructor(
    @InjectModel(UserDocument.name) private userModel: Model<UserDocument>,
    private readonly cloundinaryService: CloudinaryService,
    private readonly productService: ProductService,
) {}

  async create(createUserDto: CreateUserDto): Promise<User> {
    const createdUserDoc = await this.userModel.create({
      ...createUserDto,
      password: await hashPassword(createUserDto.password)
    });

    if (!createdUserDoc) {
      throw new InternalServerErrorException('Something Wrong');
    }

    return User.fromDocument(createdUserDoc);
  }

  async findAll(): Promise<User[]> {
    const  userDocs = await this.userModel.find();

    if (!userDocs) {
      throw new NotFoundException('No User Found');
    }

    return User.fromDocuments(userDocs);
  }

  async findOne(id: string): Promise<User> {

    const user = await this.userModel.findById(id);

    if (!user) {
      throw new NotFoundException('User Not Found');
    }

    return User.fromDocument(user);
  }

  async findOneByEmail(email: string): Promise<UserDocument | null> {
    const userDoc = await this.userModel.findOne({
      email,
    });

    if (!userDoc) {
      throw new NotFoundException('User Not Found');
    }

    return userDoc;
  }

  async update(id: string, profilePhoto: Express.Multer.File = null, updateUserDto: UpdateUserDto): Promise<User> {
    let profilePhotoUrl: string;

    if (profilePhoto){
      profilePhotoUrl = await this.cloundinaryService.upload(profilePhoto)
    }

    const updatedUser = profilePhotoUrl ? await this.userModel.findByIdAndUpdate(id, {
      ...updateUserDto,
      profileUrl: profilePhotoUrl
    }, { new: true })
    : await this.userModel.findByIdAndUpdate(id, updateUserDto, { new: true });

    if (!updatedUser){
      throw new NotFoundException('User Not Found');
    }

    return User.fromDocument(updatedUser);
  }

  async remove(id: string): Promise<User> {
    const user = await this.userModel.findByIdAndDelete(id);

    if (!user) {
      throw new NotFoundException('User Not Found');
    }

    return User.fromDocument(user);
  }

  async checkUser(email: string): Promise<boolean> {
    const user = await this.userModel.findOne({
      email,
    });

    if (user) {
      return true;
    }
    return false;
  }

  async checkUserPassword(email: string, password: string): Promise<boolean> {
    let user: User;

    try {
      user = await this.userModel.findOne({
        email,
        password, 
      });
    } catch (err) {
      throw new BadRequestException('Something Went wrong');
    }

    if (user) {
      return true;
    }
    return false;
  }

  async bookmark(productId: string, userId: string): Promise<User> {
    let user = await this.userModel.findById(userId);

    if (!user) {
      throw new NotFoundException('User Not Found');
    }

    //check if bookmark already exists
    const isBookmarked = user.bookmarks.find((bookmark) => bookmark.toString() === productId);

    if (isBookmarked) {
      const updatedUser = await this.userModel.findByIdAndUpdate(userId, {
          $pull: {
            bookmarks: new Types.ObjectId(productId)
          }
        },
        { new: true }
      );

      if (!updatedUser) {
        throw new BadRequestException('Something Went wrong');
      }

      return User.fromDocument(updatedUser);
    } else {

      const updatedUser = await this.userModel.findByIdAndUpdate(userId, {
          $addToSet: {
            bookmarks: new Types.ObjectId(productId)
          }
        },
        { new: true }
      );

      return User.fromDocument(updatedUser);
    }
  }

  async findBookmark(userId: string) {
    let user = await this.userModel.findById(userId);
    
    return this.productService.findMany(user.bookmarks);
  }
}
