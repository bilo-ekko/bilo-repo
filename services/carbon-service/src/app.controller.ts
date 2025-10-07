import { Controller, Get, Query } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('/health')
  health() {
    return { ok: true, service: 'carbon-service' };
  }

  // example domain-y endpoint (stub): GET /carbon/echo?value=123
  @Get('/carbon/echo')
  echo(@Query('value') value?: string) {
    return { value: value ?? null };
  }
}
