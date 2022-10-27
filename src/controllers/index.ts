import { userInfo } from 'os';
import * as test from './test';
import * as user from './user'

const controllers = {
  ...test,
  ...user,
};

export default controllers;
