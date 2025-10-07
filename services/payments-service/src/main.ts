import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, { cors: true });
  const port = process.env.PORT || 3003; // unique port for payments-service
  await app.listen(port);

  console.log(`payments-service listening on ${port}`);
}

bootstrap();
