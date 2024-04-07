import { InternalServerErrorException } from '@nestjs/common';
import * as nodemailer from 'nodemailer'

export const sendOtp = async (email: string, otp: string) => {
  try {
    const transporter = nodemailer.createTransport({
      service: "gmail",
      host: "smtp.gmail.com",
      auth: {
        user: "leulabay4@gmail.com",
        pass: "edsuehmegmfjqmrv",
      },
    });
  
    const info = await transporter.sendMail({
      from: "leulabay4@gmail.com",
      to: email,
      subject: "Reset password from Hawk App",
      text: `Your OTP: ${otp}`,
    });
  } catch(error) {
    throw new InternalServerErrorException("Something went wrong when sending otp");
  }
}