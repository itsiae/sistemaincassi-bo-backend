export const importEnvironmentsMiddleware = () => ({
  before: async (request) => {
    const requiredVars = ['NAMESPACE', 'LOG_LEVEL', 'SERVICE_NAME']
    for (const key of requiredVars) {
      if (!process.env[key]) {
        throw new Error(`Missing env var: ${key}`)
      }
    }

    request.internal.env = {
      namespace: process.env.NAMESPACE,
      logLevel: process.env.LOG_LEVEL,
      serviceName: process.env.SERVICE_NAME,
    }
  }
})
