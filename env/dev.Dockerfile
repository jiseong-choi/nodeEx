FROM --platform=linux/amd64 mhart/alpine-node:16
WORKDIR /app
COPY package.json ./
COPY /env/.env.dev ./.env
COPY /dist ./dist
COPY /prisma ./prisma

RUN apk add --no-cache git
RUN apk add --no-cache dumb-init
RUN yarn
RUN npx prisma generate
COPY . .

EXPOSE 8000
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["node", "dist/index.js"]