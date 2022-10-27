import { ControllerAPI, createPrismaController, ExpressController } from '@fuseble.inc/node';
import { Prisma, PrismaClient } from '@prisma/client';

export const getUserAPI: ControllerAPI = {
    tags: ['USER'],
    summary: 'User API',
    path: '/@id',
    method: 'GET'
}

export const getUser = createPrismaController<PrismaClient.findUnique>(Prisma, getUserAPI, {
    table: 'User',
    actions: ['findUnique'],
    options: {
        where: {
            id: 1,
        },
    },
});
