import { InitApp, type OpenAPIOptions } from '@fuseble.inc/node';

import config from 'config/index';
import controllers from 'controllers';

import path from 'path';

const openAPIOptions: OpenAPIOptions = {
  title: 'Chris Inc.',
  version: '0.0.1',
  urls: (config.SWAGGER_URLS || '')?.split(','),
};

const initApp = new InitApp({
  controllers,
  openAPI: {
    path: path.join(__dirname, config.SWAGGER_PATH),
    options: openAPIOptions,
    endPoint: '/api-docs',
  },
});

export default initApp;
