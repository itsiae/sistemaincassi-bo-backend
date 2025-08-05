import { captureLambdaHandler } from '@aws-lambda-powertools/tracer/middleware';

export const _captureLambdaHandler = () => ({
  before: async (request) => {
    if (request.event.tracer) {
      const __captureLambdaHandler = captureLambdaHandler(request.event.tracer)

      if (!__captureLambdaHandler.before)
        return

      await __captureLambdaHandler.before(request)
      request.event.logger.info('CaptureLambdaHandler middleware initialized')
    }
  },

  after: async (request) => {
    if (request.event.tracer) {

      const __captureLambdaHandler = captureLambdaHandler(request.event.tracer)

      if (!__captureLambdaHandler.after)
        return

      await __captureLambdaHandler.after(request)
    }
  },
  
  onError: async (request) => {
    if (request.event.tracer) {
      const __captureLambdaHandler = captureLambdaHandler(request.event.tracer)

      if (!__captureLambdaHandler.onError)
        return

      await __captureLambdaHandler.onError(request)
    }
  },
})
