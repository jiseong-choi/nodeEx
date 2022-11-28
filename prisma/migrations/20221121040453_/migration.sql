/*
  Warnings:

  - The primary key for the `Portfolio` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to alter the column `id` on the `Portfolio` table. The data in that column could be lost. The data in that column will be cast from `BigInt` to `Int`.

*/
-- DropIndex
DROP INDEX `Portfolio_name_key` ON `Portfolio`;

-- AlterTable
ALTER TABLE `Portfolio` DROP PRIMARY KEY,
    MODIFY `id` INTEGER NOT NULL AUTO_INCREMENT,
    ADD PRIMARY KEY (`id`);
