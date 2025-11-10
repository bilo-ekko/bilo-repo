import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, { cors: true });
  const port = process.env.PORT ?? 4002;
  await app.listen(port);
  console.log(
    `🌍 Impact Calculation Service is running on: http://localhost:${port}`,
  );
}
bootstrap();
