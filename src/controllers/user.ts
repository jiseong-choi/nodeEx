import { ControllerAPI, ExpressController } from '@fuseble.inc/node';
import { Prisma, PrismaClient } from '@prisma/client';
import database from 'database';

export const getUserAPI: ControllerAPI = {
    tags: ['USER'],
    summary: '사용자 조회 API',
    path: '/user',
    method: 'GET'
}

export const getUser: ExpressController = async (req, res, next) => {
    const { id } = req.params;
    const user = await database.user.findUnique({ where: { id } });
    if (!user) {
        res.status(404).json({ message: 'User not found' });
    } else {
        res.status(200).json(user);
    }
}

export const getUsersAPI: ControllerAPI = {
    tags: ['USER'],
    summary: '사용자 목록 조회 API',
    path: '/users',
    method: 'GET',
};

export const getUsers: ExpressController = async (req, res, next) => {
    const users = await database.user.findMany();
    res.status(200).json(users);
};


