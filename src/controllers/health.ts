import { ControllerAPI, ExpressController } from "@fuseble.inc/node";
import database from "database";

export const healthCheckAPI: ControllerAPI = {
    tags: ['HEALTH_CHECK'],
    summary: '서버 상태 조회 API',
    path: '/healthcheck',
    method: 'GET',
};

export const healthCheck: ExpressController = async (req, res, next) => {
    const version = await database.version.findMany({
        where: { isMain: true },
    });
    res.status(200).json({ message: 'OK', version });
}