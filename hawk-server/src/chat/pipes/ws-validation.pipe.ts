import { ArgumentMetadata, HttpException, ValidationPipe, ValidationPipeOptions } from "@nestjs/common";
import { WsException } from "@nestjs/websockets";


export class WSValidationPipe extends ValidationPipe {
    constructor(options?: ValidationPipeOptions) {
      super(options);
    }
  
    async transform(value: any, metadata: ArgumentMetadata) {
      try {
        if (metadata.type === 'body') {
            const jsonValue = JSON.parse(value);
            return jsonValue;
        }
        return await super.transform(value, metadata);
      } catch (e: any) {
        if (e instanceof HttpException) {
          throw new WsException(e.getResponse());
        }
  
        throw e;
      }
    }
  }