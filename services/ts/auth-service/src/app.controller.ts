import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';
import {
  helloFromSharedUtils,
  createSuccessResponse,
} from '@bilo-repo/ts-shared-utils';
import type { ServiceResponse } from '@bilo-repo/ts-shared-utils';

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
      service: 'auth-service',
      stack: 'TypeScript (NestJS)',
    };
  }

  @Get('/shared-utils-demo')
  getSharedUtilsDemo(): ServiceResponse<{ message: string }> {
    const message = helloFromSharedUtils('auth-service');
    return createSuccessResponse({ message });
  }
}
