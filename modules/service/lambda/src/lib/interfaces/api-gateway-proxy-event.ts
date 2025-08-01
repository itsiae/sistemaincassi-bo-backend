import type { Logger } from '@aws-lambda-powertools/logger'
import type { Tracer } from '@aws-lambda-powertools/tracer'
import type { APIGatewayProxyEvent } from 'aws-lambda'
import { LambdaHandler } from './lambda-handler'

export interface _APIGatewayProxyEvent extends APIGatewayProxyEvent {
  logger: Logger
  tracer: Tracer
  handler?: LambdaHandler
}
