import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  await app.listen(process.env.PORT ?? 3005);
  console.log(`🔢 Equivalents Service is running on: http://localhost:3005`);
}
bootstrap();
