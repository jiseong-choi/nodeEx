import { userInfo } from 'os';
import * as user from './user'
import * as auth from './auth'
import * as health from './health';

const controllers = {
  ...health,
  ...user,
  ...auth,
};

export default controllers;
