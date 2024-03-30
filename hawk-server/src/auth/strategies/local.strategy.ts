import { Strategy } from "passport-local";

import { PassportStrategy } from "@nestjs/passport";
import { AuthService } from "../service/auth.service";
import { Injectable } from "@nestjs/common";

@Injectable()
export class LocalStrategy extends PassportStrategy(Strategy) {
    constructor(private authService: AuthService) {
        super({
            usernameField: 'email',
            passwordField: 'password'
        });
    }

    async validate(email: string, password: string) {
        return await this.authService.validateUser({ email, password });
    }
}