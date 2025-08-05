FROM node:20

WORKDIR /app

COPY package.json package-lock.json .

RUN npm install -g serverless@3 serverless-offline

RUN npm ci

COPY . .

RUN npm run build

EXPOSE 3000

CMD ["sls", "offline", "--host", "0.0.0.0"]
