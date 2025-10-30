import { Controller, Get, Post, Param, Body } from '@nestjs/common';
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
      service: 'api-gateway',
      stack: 'TypeScript (NestJS)',
    };
  }

  @Get('/services')
  getServices() {
    return this.appService.getServiceList();
  }

  // Auth Service Routes (Port 3001)
  @Post('/auth/login')
  login(@Body() body: any) {
    return this.appService.proxyToService('auth-service', 'auth/login', body);
  }

  @Post('/auth/register')
  register(@Body() body: any) {
    return this.appService.proxyToService(
      'auth-service',
      'auth/register',
      body,
    );
  }

  // Sessions Service Routes (Port 3003)
  @Post('/sessions/create')
  createSession(@Body() body: any) {
    return this.appService.proxyToService(
      'sessions-service',
      'sessions/create',
      body,
    );
  }

  // Projects Service Routes (Port 3004)
  @Get('/projects')
  getProjects() {
    return this.appService.proxyToService('projects-service', 'projects');
  }

  @Post('/projects')
  createProject(@Body() body: any) {
    return this.appService.proxyToService('projects-service', 'projects', body);
  }

  // Equivalents Service Routes (Port 3005)
  @Get('/equivalents/:type')
  getEquivalents(@Param('type') type: string) {
    return this.appService.proxyToService(
      'equivalents-service',
      `equivalents/${type}`,
    );
  }

  // Transactions Service Routes (Port 3100)
  @Post('/transactions')
  createTransaction(@Body() body: any) {
    return this.appService.proxyToService(
      'transactions-service',
      'transactions',
      body,
    );
  }

  @Get('/transactions/:id')
  getTransaction(@Param('id') id: string) {
    return this.appService.proxyToService(
      'transactions-service',
      `transactions/${id}`,
    );
  }

  // Funds Service Routes (Port 3101)
  @Post('/funds/aggregate')
  aggregateFunds(@Body() body: any) {
    return this.appService.proxyToService(
      'funds-service',
      'funds/aggregate',
      body,
    );
  }

  // Payments Service Routes (Port 3102)
  @Post('/payments')
  createPayment(@Body() body: any) {
    return this.appService.proxyToService('payments-service', 'payments', body);
  }

  @Get('/payments/:id')
  getPayment(@Param('id') id: string) {
    return this.appService.proxyToService('payments-service', `payments/${id}`);
  }

  // Portfolio Service Routes (Port 3200)
  @Get('/portfolios/:id')
  getPortfolio(@Param('id') id: string) {
    return this.appService.proxyToService(
      'portfolio-service',
      `portfolios/${id}`,
    );
  }

  @Get('/portfolios/:id/report')
  getPortfolioReport(@Param('id') id: string) {
    return this.appService.proxyToService(
      'portfolio-service',
      `portfolios/${id}/report`,
    );
  }

  // Reporting Service Routes (Port 3201)
  @Get('/analytics/reports')
  getAnalyticsReports() {
    return this.appService.proxyToService(
      'reporting-service',
      'analytics/reports',
    );
  }

  // Messaging Service Routes (Port 3009)
  @Post('/messages')
  sendMessage(@Body() body: any) {
    return this.appService.proxyToService(
      'messaging-service',
      'messages',
      body,
    );
  }
}
