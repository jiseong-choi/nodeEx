-- CreateTable
CREATE TABLE `Portfolio` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `description` VARCHAR(191) NOT NULL DEFAULT '',
    `img` VARCHAR(191) NOT NULL DEFAULT '',

    UNIQUE INDEX `Portfolio_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
