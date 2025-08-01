import middy from '@middy/core'
import { importEnvironmentsMiddleware } from './lib/middlewares/import-environment'
import { setupPowertoolsMiddleware } from './lib/middlewares/setup-powertools'
import { _APIGatewayProxyEvent } from './lib/interfaces/api-gateway-proxy-event'
import { routerMiddleware } from './lib/middlewares/router'
import httpEventNormalizer from '@middy/http-event-normalizer'
import { _captureLambdaHandler } from './lib/middlewares/_captureLambdaHandler'
import httpJsonBodyParser from '@middy/http-json-body-parser'
import { baseHandler } from './handler'

export const handler = middy<_APIGatewayProxyEvent>()
  .use(importEnvironmentsMiddleware())
  .use(setupPowertoolsMiddleware())
  .use(_captureLambdaHandler())
  .use(routerMiddleware())
  .use(httpEventNormalizer())
  .use(httpJsonBodyParser())
  .handler(baseHandler)
