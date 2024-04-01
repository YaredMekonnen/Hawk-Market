import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { CreateUserDto } from '../dto/create-user.dto';
import { UpdateUserDto } from '../dto/update-user.dto';
import { InjectModel } from '@nestjs/mongoose';
import { User } from '../schema/user.schema';
import { Model, Types } from 'mongoose';
import { IUser } from '../interface/user.interface';
import { CloudinaryService } from 'src/cloudinary/cloudinary.service';
import { Product } from 'src/product/schema/product.schema';
import { hashPassword } from 'src/utils/auth/password_utils';

@Injectable()
export class UserService {
  constructor(
    @InjectModel(User.name) private userModel: Model<User>,
    private readonly cloundinaryService: CloudinaryService,
) {}

  async create(createUserDto: CreateUserDto): Promise<User> {
    const createdUser = await this.userModel.create({
      ...createUserDto,
      password: await hashPassword(createUserDto.password)
    });

    if (!createdUser) {
      throw new InternalServerErrorException('Something Wrong');
    }

    return createdUser;
  }

  async findAll(): Promise<User[]> {
    const  users = await this.userModel.find();

    if (!users) {
      throw new NotFoundException('No User Found');
    }

    return users;
  }

  async findOne(id: string): Promise<User> {

    const user = await this.userModel.findById(id);

    if (!user) {
      throw new NotFoundException('User Not Found');
    }

    return user;
  }

  async findOneByEmail(email: string): Promise<User | null> {
    const user = await this.userModel.findOne({
      email,
    });

    if (!user) {
      throw new NotFoundException('User Not Found');
    }

    return user;
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

    return updatedUser;
  }

  async remove(id: string): Promise<IUser> {
    const user = await this.userModel.findByIdAndDelete(id);

    if (!user) {
      throw new NotFoundException('User Not Found');
    }

    return user;
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
    let user: IUser;

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
    let user: User;
    try {
      user = await this.userModel.findById({
        userId
      });
    } catch (err) {
      throw new BadRequestException('Something Went wrong');
    }

    if (!user) {
      throw new NotFoundException('User Not Found');
    }

    //check if bookmark already exists
    const isBookmarked = user.bookmarks.find((bookmark) => bookmark.toString() === productId);

    if (isBookmarked) {
      const updatedUser = this.userModel.findByIdAndUpdate(userId, {
          $pull: {
            bookmarks: new Types.ObjectId(productId)
          }
        },
        { new: true }
      );

      if (!updatedUser) {
        throw new BadRequestException('Something Went wrong');
      }

      return updatedUser;
    } else {

      const updatedUser = await this.userModel.findByIdAndUpdate(userId, {
          $push: {
            bookmarks: new Types.ObjectId(productId)
          }
        },
        { new: true }
      );

      return updatedUser;
    }
  }

  async findBookmark(userId: string): Promise<Product[]> {
    let user: User;
    try {
      user = await this.userModel.findById(userId).populate('bookmarks');
      return user.bookmarks;
    } catch (err) {
      throw new BadRequestException('Something Went wrong');
    }
  }
}
