import { ControllerAPI, ExpressController, jsonwebtoken, Jsonwebtoken } from "@fuseble.inc/node";
import database from "database";
import bcrypt from "bcryptjs";
import config from "config";

export const signUpAPI: ControllerAPI = {
    tags: ['AUTH'],
    summary: '사용자 생성 API',
    path: '/auth/signup',
    method: 'POST',
    body: [
        { key: 'name', type: 'string', example: 'chris' },
        { key: 'email', type: 'string', example: 'chris@chris-choi.dev' },
        { key: 'password', type: 'string', example: '테스트비밀번호' },
    ],
};

export const signUp: ExpressController = async (req, res, next) => {
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

export const signInAPI: ControllerAPI = {
    tags: ['AUTH'],
    summary: '사용자 로그인 API',
    path: '/auth/signin',
    method: 'POST',
    body: [
        { key: 'email', type: 'string', example: 'chris@chris-choi.dev' },
        { key: 'password', type: 'string', example: '테스트비밀번호' },
    ],
};

export const signIn: ExpressController = async (req, res, next) => {
    const { email, password } = req.body;

    const user = await database.user.findUnique({
        where: { email },
    });

    if (!user) {
        res.status(404).json({ error: '존재하지 않는 이메일입니다.' });
    } else {
        const isValidPassword = await bcrypt.compare(password, user.password);
        if (!isValidPassword) {
            res.status(401).json({ error: '비밀번호가 일치하지 않습니다.' });
        } else {
            const jsonwebtoken = new Jsonwebtoken(config.JWT_KEY);
            const siginedPayLoad = jsonwebtoken.signJwt<{ id: string }>({ id: user.id });
            res.status(200).json({ token: siginedPayLoad, user });
        }
    }
}
