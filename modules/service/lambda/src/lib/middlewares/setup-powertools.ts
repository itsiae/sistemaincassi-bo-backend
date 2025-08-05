import { Logger } from '@aws-lambda-powertools/logger'
import { Tracer } from '@aws-lambda-powertools/tracer'

export const setupPowertoolsMiddleware = () => ({
  before: async (request) => {
    const { namespace, logLevel, serviceName } = request.internal.env

    const logger = new Logger({
      serviceName,
      logLevel,
    })

    const tracer = new Tracer({
      serviceName,
    })

    if (request.context && request.context.awsRequestId) {
      logger.appendKeys({ awsRequestId: request.context.awsRequestId })
    }

    logger.info('Powertools Logger and Tracer initialized')
    
    request.event.logger = logger
    request.event.tracer = tracer
  }
})
