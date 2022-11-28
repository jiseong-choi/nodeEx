import { userInfo } from 'os';
import * as user from './user'
import * as auth from './auth'
import * as health from './health';
import * as portfolio from './portfolio';

const controllers = {
  ...health,
  ...user,
  ...auth,
  ...portfolio,
};

export default controllers;
