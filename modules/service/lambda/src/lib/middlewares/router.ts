import { _routes } from "../../routes.imports"

export const routerMiddleware = () => ({
  before: async (request) => {
    const method = request.event.httpMethod.toLowerCase()
    request.event.logger.debug('Routing request', { path: request.event.path, method })
    
    for (const [_path, _lambda] of Object.entries(_routes)) {
        const defaultMatch = !_path.includes('.') && _path === request.event.path
        const methodMatch = _path === `${request.event.path}.${method}`

        if (!defaultMatch && !methodMatch)
          continue

        request.event.logger.debug(`Routing ${request.event.path} to path ${_path} with handler ${_lambda.name}`)
        request.event.handler = _lambda
        return
    }
  }
})
