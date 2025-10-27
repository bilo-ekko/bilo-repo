import { Controller, Get, Query } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('/health')
  health() {
    return { ok: true, service: 'calculation-service' };
  }

  // example domain-y endpoint (stub): GET /calculation/echo?value=123
  @Get('/calculation/echo')
  echo(@Query('value') value?: string) {
    return { value: value ?? null };
  }
}
