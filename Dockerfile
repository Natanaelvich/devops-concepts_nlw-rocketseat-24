FROM node:20 AS base

FROM base AS dependencies

WORKDIR /usr/src/app

COPY package.json yarn.lock ./

RUN yarn install --frozen-lockfile

FROM base AS build

WORKDIR /usr/src/app

COPY . .
COPY --from=dependencies /usr/src/app/node_modules ./node_modules

RUN yarn build

FROM node:20-alpine3.19 AS deploy

WORKDIR /usr/src/app

RUN npm i -g prisma

COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/prisma ./prisma

RUN yarn prisma generate

EXPOSE 	3333

CMD [ "yarn", "start" ]