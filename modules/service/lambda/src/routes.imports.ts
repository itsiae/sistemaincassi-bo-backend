import type { _APIGatewayProxyEvent } from "./lib/interfaces/api-gateway-proxy-event";
import healthCheckHandler from "./api/health";
import type { LambdaHandler } from "./lib/interfaces/lambda-handler";

export const _routes: {
  [key: string]: LambdaHandler
} = {
  '/health': healthCheckHandler,
};
