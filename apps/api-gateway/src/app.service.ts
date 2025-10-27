import { Injectable, HttpException, HttpStatus } from '@nestjs/common';

export interface ServiceConfig {
  name: string;
  baseUrl: string;
  language: string;
  purpose: string;
}

@Injectable()
export class AppService {
  private readonly services: Record<string, ServiceConfig> = {
    'auth-service': {
      name: 'Auth Service',
      baseUrl: 'http://localhost:3001',
      language: 'TypeScript (NestJS)',
      purpose: 'AuthN/Z, JWT/OAuth2, API keys, user/org models',
    },
    'calculation-service': {
      name: 'Calculation Service',
      baseUrl: 'http://localhost:3002',
      language: 'TypeScript (NestJS)',
      purpose: 'Carbon tracking and calculations',
    },
    'sessions-service': {
      name: 'Sessions Service',
      baseUrl: 'http://localhost:3003',
      language: 'TypeScript (NestJS)',
      purpose: 'User sessions, state management, session data',
    },
    'projects-service': {
      name: 'Projects Service',
      baseUrl: 'http://localhost:3004',
      language: 'TypeScript (NestJS)',
      purpose: 'Project metadata provider / CMS-like CRUD',
    },
    'equivalents-service': {
      name: 'Equivalents Service',
      baseUrl: 'http://localhost:3005',
      language: 'TypeScript (NestJS)',
      purpose: 'Numeric conversions and logic-heavy lookups',
    },
    'messaging-service': {
      name: 'Messaging Service',
      baseUrl: 'http://localhost:3009',
      language: 'TypeScript (NestJS)',
      purpose: 'Async processing, Kafka/Rabbit/SNS workers, pub/sub',
    },
    'transactions-service': {
      name: 'Transactions Service',
      baseUrl: 'http://localhost:3100',
      language: 'Go (Fiber)',
      purpose: 'High-volume financial events, idempotency, reversals',
    },
    'funds-service': {
      name: 'Funds Service',
      baseUrl: 'http://localhost:3101',
      language: 'Go',
      purpose: 'Internal aggregations, reconciliation flows',
    },
    'payments-service': {
      name: 'Payments Service',
      baseUrl: 'http://localhost:3102',
      language: 'Go',
      purpose: 'PSP integrations (Stripe/Adyen), low-latency parallel calls',
    },
    'portfolio-service': {
      name: 'Portfolio Service',
      baseUrl: 'http://localhost:3200',
      language: 'C# (.NET Core)',
      purpose: 'Portfolio aggregation, reporting, typed DTOs',
    },
    'analytics-service': {
      name: 'Analytics Service',
      baseUrl: 'http://localhost:3201',
      language: 'C# (.NET Core)',
      purpose: 'Heavy reporting, aggregates, data pipelines',
    },
  };

  getHello(): string {
    return 'API Gateway - Microservices Architecture';
  }

  getServiceList() {
    return {
      gateway: 'http://localhost:3000',
      services: this.services,
      architecture: {
        typescript: Object.values(this.services).filter(s => s.language.includes('TypeScript')).length,
        go: Object.values(this.services).filter(s => s.language.includes('Go')).length,
        dotnet: Object.values(this.services).filter(s => s.language.includes('.NET')).length,
      },
    };
  }

  async proxyToService(serviceName: string, path: string, body?: any): Promise<any> {
    const service = this.services[serviceName];
    
    if (!service) {
      throw new HttpException(
        `Service ${serviceName} not found`,
        HttpStatus.NOT_FOUND,
      );
    }

    // TODO: Implement actual HTTP proxy logic using HttpService or axios
    // For now, return a placeholder response
    return {
      message: `Proxying to ${service.name}`,
      service: serviceName,
      url: `${service.baseUrl}/${path}`,
      method: body ? 'POST' : 'GET',
      timestamp: new Date().toISOString(),
    };
  }
}
