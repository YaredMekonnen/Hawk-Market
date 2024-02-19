// cloudinary.service.ts

import { Injectable } from '@nestjs/common';
import { v2 as cloudinary } from 'cloudinary';

@Injectable()
export class CloudinaryService {
  constructor() {
    cloudinary.config({
      cloud_name: 'dsk2pubrq',
      api_key: '464395915488132',
      api_secret: 'kxDYMElByleHqI9jrqyBXKetios'
    });
  }

  upload(file: any): Promise<any> {
    return new Promise((resolve, reject) => {
      cloudinary.uploader.upload_stream({ resource_type: 'auto' }, (error, result) => {
        if (error) {
          reject(error);
        } else {
          resolve(result.secure_url);
        }
      }).end(file.buffer);
    });
  }
}
