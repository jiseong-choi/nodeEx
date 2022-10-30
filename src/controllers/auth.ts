import { ControllerAPI, ExpressController } from "@fuseble.inc/node";
import database from "database";
import bcrypt from 'bcryptjs'

export const signUpAPI: ControllerAPI = {
    tags: ['AUTH'],
    summary: '사용자 생성 API',
    path: '/user',
    method: 'POST',
    body: [
        { key: 'name', type: 'string', example: 'chris' },
        { key: 'email', type: 'string', example: 'chris@chris-choi.dev' },
        { key: 'password', type: 'string', example: '테스트비밀번호' },
    ],
};

export const signUpUser: ExpressController = async (req, res, next) => {
    const { name, email, password } = req.body;

    const existUser = await database.user.findUnique({
        where: { email },
    })

    const hashedPassword = await bcrypt.hash(password, 10);

    if (existUser) {
        res.status(409).json({ error: '이미 존재하는 이메일입니다.' });
    } else {
        const user = await database.user.create({
            data: {
                name,
                email,
                password: hashedPassword,
            },
        });

        res.status(201).json(user);
    }
};