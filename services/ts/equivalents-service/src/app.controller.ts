import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  @Get('/health')
  getHealth(): { ok: boolean; service: string; stack: string } {
    return {
      ok: true,
      service: 'equivalents-service',
      stack: 'TypeScript (NestJS)',
    };
  }
}
