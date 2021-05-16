-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema baseball
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema baseball
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `baseball` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `baseball` ;

-- -----------------------------------------------------
-- Table `baseball`.`game`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baseball`.`game`;
CREATE TABLE IF NOT EXISTS `baseball`.`game` (
    `id` INT AUTO_INCREMENT,
    `choice_team_name` VARCHAR(45) NULL,
    PRIMARY KEY (`id`))
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `baseball`.`inning`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baseball`.`inning`;
CREATE TABLE IF NOT EXISTS `baseball`.`inning` (
    `id` INT AUTO_INCREMENT,
    `round` INT NOT NULL,
    `first_base` TINYINT(1) NOT NULL,
    `second_base` TINYINT(1) NOT NULL,
    `third_base` TINYINT(1) NOT NULL,
    `game` INT NOT NULL,
    `game_key` INT,
    PRIMARY KEY (`id`),
    INDEX `fk_inning_match1_idx` (`game` ASC) VISIBLE,
    CONSTRAINT `fk_inning_match1`
    FOREIGN KEY (`game`)
    REFERENCES `baseball`.`game` (`id`))
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `baseball`.`team`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baseball`.`team`;
CREATE TABLE IF NOT EXISTS `baseball`.`team` (
    `id` INT AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL,
    `type` VARCHAR(45) NOT NULL,
    `game` INT NOT NULL,
    `game_key` INT,
    PRIMARY KEY (`id`),
    INDEX `fk_team_game1_idx` (`game` ASC) VISIBLE,
    CONSTRAINT `fk_team_game1`
    FOREIGN KEY (`game`)
    REFERENCES `baseball`.`game` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `baseball`.`member`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baseball`.`member`;
CREATE TABLE IF NOT EXISTS `baseball`.`member` (
    `id` INT AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL,
    `avg` DECIMAL(4,3) NOT NULL,
    `team` INT NOT NULL,
    `team_key` INT,
    PRIMARY KEY (`id`),
    INDEX `fk_member_team1_idx` (`team` ASC) VISIBLE,
    CONSTRAINT `fk_member_team1`
    FOREIGN KEY (`team`)
    REFERENCES `baseball`.`team` (`id`))
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `baseball`.`hitter_history`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baseball`.`hitter_history`;
CREATE TABLE IF NOT EXISTS `baseball`.`hitter_history` (
    `id` INT AUTO_INCREMENT,
    `tpa` INT NOT NULL,
    `hits` INT NOT NULL,
    `out` INT NOT NULL,
    `member_id` INT NOT NULL,
    `inning` INT NOT NULL,
    `inning_key` INT,
    PRIMARY KEY (`id`),
    INDEX `fk_hitter_history_member1_idx` (`member_id` ASC) VISIBLE,
    INDEX `fk_hitter_history_inning1_idx` (`inning` ASC) VISIBLE,
    CONSTRAINT `fk_hitter_history_inning1`
    FOREIGN KEY (`inning`)
    REFERENCES `baseball`.`inning` (`id`),
    CONSTRAINT `fk_hitter_history_member1`
    FOREIGN KEY (`member_id`)
    REFERENCES `baseball`.`member` (`id`))
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `baseball`.`pitcher_history`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baseball`.`pitcher_history`;
CREATE TABLE IF NOT EXISTS `baseball`.`pitcher_history` (
    `id` INT AUTO_INCREMENT,
    `pit` INT NOT NULL,
    `strike` INT NOT NULL,
    `ball` INT NOT NULL,
    `out` INT NOT NULL,
    `member_id` INT NOT NULL,
    `inning` INT NOT NULL,
    `inning_key` INT,
    PRIMARY KEY (`id`),
    INDEX `fk_pitcher_history_member1_idx` (`member_id` ASC) VISIBLE,
    INDEX `fk_pitcher_history_inning1_idx` (`inning` ASC) VISIBLE,
    CONSTRAINT `fk_pitcher_history_inning1`
    FOREIGN KEY (`inning`)
    REFERENCES `baseball`.`inning` (`id`),
    CONSTRAINT `fk_pitcher_history_member1`
    FOREIGN KEY (`member_id`)
    REFERENCES `baseball`.`member` (`id`))
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `baseball`.`score_history`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baseball`.`score_history`;
CREATE TABLE IF NOT EXISTS `baseball`.`score_history` (
    `id` INT AUTO_INCREMENT,
    `inning_score` INT NOT NULL,
    `team_id` INT NOT NULL,
    `inning` INT NOT NULL,
    `inning_key` INT NULL,
    PRIMARY KEY (`id`),
    INDEX `fk_score_history_team1_idx` (`team_id` ASC) VISIBLE,
    INDEX `fk_score_history_inning1_idx` (`inning` ASC) VISIBLE,
    CONSTRAINT `fk_score_history_inning1`
    FOREIGN KEY (`inning`)
    REFERENCES `baseball`.`inning` (`id`),
    CONSTRAINT `fk_score_history_team1`
    FOREIGN KEY (`team_id`)
    REFERENCES `baseball`.`team` (`id`))
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `baseball`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baseball`.`user`;
CREATE TABLE IF NOT EXISTS `baseball`.`user` (
    `id` INT AUTO_INCREMENT,
    `user_id` VARCHAR(45) NOT NULL,
    `email` VARCHAR(45) NOT NULL,
    `name` VARCHAR(45) NULL,
    `token` VARCHAR(255) NULL,
    `game_id` INT NULL,
    PRIMARY KEY (`id`),
    INDEX `fk_user_game1_idx` (`game_id` ASC) VISIBLE,
    CONSTRAINT `fk_user_game1`
    FOREIGN KEY (`game_id`)
    REFERENCES `baseball`.`game` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    ENGINE = InnoDB
    DEFAULT CHARACTER SET = utf8mb4
    COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
