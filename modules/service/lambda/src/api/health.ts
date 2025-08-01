import { APIGatewayProxyResult } from "aws-lambda"
import type { _APIGatewayProxyEvent } from "../lib/interfaces/api-gateway-proxy-event"

export default function healthCheckHandler(event: _APIGatewayProxyEvent, context): APIGatewayProxyResult {
  event.logger.info("Health check invoked")

  return {
    statusCode: 200,
    body: JSON.stringify({ message: "Service healthy" }),
  }
}
