import { ControllerAPI, ExpressController } from '@fuseble.inc/node';
import { Prisma, PrismaClient } from '@prisma/client';
import database from 'database';

export const createUserAPI: ControllerAPI = {
    tags: ['USER'],
    summary: '사용자 생성 API',
    path: '/user',
    method: 'POST',
    body: [
        { key: 'name', type: 'string', example: 'chris' },
        { key: 'email', type: 'string', example: 'chris@chris-choi.dev' },
        { key: 'password', type: 'string', example: '테스트비밀번호' },
    ],
};

export const createUser: ExpressController = async (req, res, next) => {
    const { name, email, password } = req.body;

    const existUser = await database.user.findUnique({
        where: { email },
    })

    if (existUser) {
        res.status(409).json({ error: '이미 존재하는 이메일입니다.' });
    } else {
        const user = await database.user.create({
            data: {
                name,
                email,
                password
            },
        });

        res.status(201).json(user);
    }
};

export const getUserAPI: ControllerAPI = {
    tags: ['USER'],
    summary: '사용자 조회 API',
    path: '/users',
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
    path: '/user',
    method: 'GET',
};

export const getUsers: ExpressController = async (req, res, next) => {
    const users = await database.user.findMany();
    res.status(200).json(users);
};


