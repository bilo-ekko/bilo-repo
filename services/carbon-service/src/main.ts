import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, { cors: true });
  const port = process.env.PORT || 3002; // unique port for carbon-service
  await app.listen(port);

  console.log(`carbon-service listening on ${port}`);
}
bootstrap();
