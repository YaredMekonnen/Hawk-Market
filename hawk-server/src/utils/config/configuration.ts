export default () => ({
    port: parseInt(process.env.PORT, 10) || 3000,
    databaseUrl: `${process.env.DB_URL}/${process.env.DB_NAME}`,
    jwtSecretKey: process.env.JWT_SECRET,
    jwtExpirationTime: process.env.JWT_EXPIRATION_TIME,
  });
