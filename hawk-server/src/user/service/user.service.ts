import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { CreateUserDto } from '../dto/create-user.dto';
import { UpdateUserDto } from '../dto/update-user.dto';
import { InjectModel } from '@nestjs/mongoose';
import { User } from '../schema/user.schema';
import { Model } from 'mongoose';
import { IUser } from '../interface/user.interface';

@Injectable()
export class UserService {
  constructor(@InjectModel(User.name) private userModel: Model<IUser>) {}
  async create(createUserDto: CreateUserDto): Promise<IUser> {
    let createdUser: IUser;

    try {
      createdUser = await new this.userModel(createUserDto).save();
    } catch (err) {
      throw err;
    }

    if (!createdUser) {
      throw new BadRequestException('Something Wrong');
    }

    return createdUser;
  }

  async findAll(): Promise<IUser[]> {
    let users: IUser[];

    try {
      users = await this.userModel.find();
    } catch (err) {
      throw err;
    }

    if (!users) {
      throw new NotFoundException('No User Found');
    }

    return users;
  }

  async findOne(id: number): Promise<IUser> {
    let user: IUser;

    try {
      user = await this.userModel.findById(id);
    } catch (err) {
      throw new BadRequestException('Something Went wrong');
    }

    if (!user) {
      throw new NotFoundException('User Not Found');
    }
    return user;
  }

  async update(id: number, updateUserDto: UpdateUserDto): Promise<IUser> {
    let updatedUser: IUser;
    try {
      await this.findOne(id);
      this.userModel.findByIdAndUpdate(id, updateUserDto, { new: true });
    } catch (err) {
      throw err;
    }

    return updatedUser;
  }

  async remove(id: number): Promise<IUser> {
    let user: IUser;
    try {
      await this.findOne(id);
      this.userModel.deleteOne((user) => user.id == id);
    } catch (err) {
      throw err;
    }
    return user;
  }

  async checkUser(email: string): Promise<boolean> {
    let user: IUser;

    try {
      user = await this.userModel.findOne({
        email,
      });
    } catch (err) {
      throw new BadRequestException('Something Went wrong');
    }

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
}
