import { APIGatewayProxyResult, Context } from "aws-lambda";
import { _APIGatewayProxyEvent } from "./api-gateway-proxy-event";

export type LambdaHandler = (event: _APIGatewayProxyEvent, context: Context) => APIGatewayProxyResult | Promise<APIGatewayProxyResult>
