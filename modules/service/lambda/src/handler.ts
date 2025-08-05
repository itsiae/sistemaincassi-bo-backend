import { APIGatewayProxyResult } from 'aws-lambda'
import { _APIGatewayProxyEvent } from './lib/interfaces/api-gateway-proxy-event'

export const baseHandler = async (event: _APIGatewayProxyEvent, context): Promise<APIGatewayProxyResult> => {
  event.logger.info(`Handler invoked for path: ${event.path}`)

  const parentSegment = event.tracer.getSegment()!
  const subsegment = parentSegment.addNewSubsegment('### baseHandler')
  event.tracer.setSegment(subsegment)

  let result: APIGatewayProxyResult | undefined

  if (event.handler) {
    event.logger.info('Executing handler', { handler: event.handler.name })
    const _result = event.handler(event, context)
    
    const __result = _result instanceof Promise ? await _result : _result
    
    result = { ...__result }
    event.logger.info('Handler execution completed', { result })
  } else {
    event.logger.warn('No handler found for the requested path, returning 404')

    result = {
      statusCode: 404,
      body: JSON.stringify({
        message: 'Not Found',
        event: event.path,
      }),
    }
  }

  subsegment.close()
  event.tracer.setSegment(parentSegment)
  return result!
}
