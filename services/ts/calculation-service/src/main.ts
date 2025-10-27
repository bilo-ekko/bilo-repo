import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, { cors: true });
  const port = process.env.PORT || 3002; // unique port for calculation-service
  await app.listen(port);

  console.log(`🧮 Calculation Service is running on: http://localhost:${port}`);
}
bootstrap();
