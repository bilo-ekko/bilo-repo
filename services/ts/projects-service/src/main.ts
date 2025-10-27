import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, { cors: true });
  await app.listen(process.env.PORT ?? 3004);
  console.log(`📁 Projects Service is running on: http://localhost:3004`);
}
bootstrap();
