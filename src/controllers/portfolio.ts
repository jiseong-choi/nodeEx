import { ControllerAPI, ExpressController, Jsonwebtoken } from "@fuseble.inc/node";
import database from "database";
import { Authorization, jsonWebTokenMiddleware } from "middlewares";

export const getPortfoliosAPI: ControllerAPI = {
    tags: ['PORTFOLIO'],
    summary: '포트폴리오 목록 조회 API',
    path: '/portfolios',
    method: 'GET',
};

export const getPortfolios: ExpressController = async (req, res, next) => {
    const Portfolios = await database.portfolio.findMany();
    if(!Portfolios) {
        res.status(404).json({ message: 'Portfolios not found' });
    } else {
    res.status(200).json({ message: 'OK', Portfolios });
    }
}

export const postPortfolioAPI: ControllerAPI = {
    tags: ['PORTFOLIO'],
    summary: '포트폴리오 생성 API',
    path: '/portfolio',
    method: 'POST',
    body: [
        { key: 'name', type: 'string', example: 'Developer Transfer' },
        { key: 'description', type: 'string', example: '해외인력 소싱 플랫폼' },
        { key: 'image', type: 'string', example: 'https://www.developertransfer.com/images/logo.png' },
    ],
    auth: 'jwt',
    middlewares: [jsonWebTokenMiddleware, Authorization.ADMIN],
};

export const postPortfolio: ExpressController = async (req, res, next) => {
    const { name, description, img } = req.body;
    const Portfolio = await database.portfolio.create({
        data: {
            name,
            description,
            img,
        },
    });
    if(!Portfolio) {
        res.status(404).json({ message: 'Portfolio not found' });
    } else {
    res.status(200).json({ message: 'OK', Portfolio });
    }
}

export const getMainPortfoliosAPI: ControllerAPI = {
    tags: ['PORTFOLIO'],
    summary: '메인 포트폴리오 목록 조회 API',
    path: '/portfolios/main',
    method: 'GET',
};

export const getMainPortfolios: ExpressController = async (req, res, next) => {
    const Portfolios = await database.portfolio.findMany({
        where: {
            isMain: true,
        },
    });
    if(!Portfolios) {
        res.status(404).json({ message: 'Portfolios not found' });
    } else {
    res.status(200).json({ message: 'OK', Portfolios });
    }
}

export const patchMainPortfolioAPI: ControllerAPI = {
    tags: ['PORTFOLIO'],
    summary: '메인 포트폴리오로 수정 API',
    path: '/portfolio/main',
    method: 'PATCH',
    body: [
        { key: 'id', type: 'number', example: 1 },
        { key: 'isMain', type: 'boolean', example: true}
    ],
    auth: 'jwt',
    middlewares: [jsonWebTokenMiddleware, Authorization.ADMIN],
};

export const patchMainPortfolio: ExpressController = async (req, res, next) => {
    const { id,isMain } = req.body;
    const Portfolio = await database.portfolio.update({
        where: {
            id,
        },
        data: {
            isMain
        },
    });
    if(!Portfolio) {
        res.status(404).json({ message: 'Portfolio not found' });
    } else {
    res.status(200).json({ message: 'OK', Portfolio });
    }
}

