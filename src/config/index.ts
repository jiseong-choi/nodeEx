import path from 'path';
import { ParseEnv } from '@fuseble.inc/node';

type ENV = {
  NODE_ENV: string;
  PORT: number;
  DATABASE_URL: string;
  CLIENT_URL: string;
  SWAGGER_PATH: string;
  SWAGGER_URLS: string;
  JWT_KEY: string;
  PASSWORD_SALT_ROUND: number;
  SOCIAL_SALT_ROUND: number;
};

const parseEnv = new ParseEnv({ options: { path: path.join(__dirname, '../../.env') } }, [
  'NODE_ENV',
  'PORT',
  'DATABASE_URL',
  'CLIENT_URL',
  'SWAGGER_PATH',
  'SWAGGER_URLS',
  'JWT_KEY',
  'PASSWORD_SALT_ROUND',
  'SOCIAL_SALT_ROUND',
]);

const config = parseEnv.result as ENV;

console.log('💙 Config Loading...', config);

export default config;
