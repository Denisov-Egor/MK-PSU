-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Выпускники учебного заведения
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Выпускники учебного заведения
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Выпускники учебного заведения` DEFAULT CHARACTER SET utf8 ;
USE `Выпускники учебного заведения` ;

-- -----------------------------------------------------
-- Table `Выпускники учебного заведения`.`Трудоустройство`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Выпускники учебного заведения`.`Трудоустройство` (
  `Код_организации` INT NOT NULL AUTO_INCREMENT,
  `Наименование` VARCHAR(45) NOT NULL,
  `Должность` VARCHAR(45) NULL,
  `Дата` VARCHAR(45) NULL,
  `Контактная информация` DATETIME NULL,
  PRIMARY KEY (`Код_организации`),
  UNIQUE INDEX `Код_организации_UNIQUE` (`Код_организации` ASC) VISIBLE,
  CONSTRAINT `fk_graduates_employment`
    FOREIGN KEY ()
    REFERENCES `Выпускники учебного заведения`.`Трудоустройство` ()
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Выпускники учебного заведения`.`Выпускник`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Выпускники учебного заведения`.`Выпускник` (
  `Код_выпускника` INT NOT NULL AUTO_INCREMENT,
  `ФИО` VARCHAR(45) NOT NULL,
  `Год поступления` INT NULL,
  `Год выпуска` INT NULL,
  `Код_учебного_заведения` INT NULL DEFAULT внешний ключ,
  `Код_организации` INT NULL DEFAULT внешний ключ,
  `Адрес` VARCHAR(45) NULL,
  `Телефон` VARCHAR(45) NULL,
  PRIMARY KEY (`Код_выпускника`),
  UNIQUE INDEX `Код_выпускника_UNIQUE` (`Код_выпускника` ASC) VISIBLE,
  CONSTRAINT `fk_graduates_institution`
    FOREIGN KEY (`Код_выпускника`)
    REFERENCES `Выпускники учебного заведения`.`Трудоустройство` (`Код_организации`)
    ON DELETE SET NULL
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Выпускники учебного заведения`.`Учебное заведение`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Выпускники учебного заведения`.`Учебное заведение` (
  `Код_учебного_заведения` INT NOT NULL AUTO_INCREMENT,
  `Наименование` VARCHAR(45) NOT NULL,
  `Направление учебного заведения` VARCHAR(45) NULL,
  `Дата поступления` DATETIME NULL,
  PRIMARY KEY (`Код_учебного_заведения`),
  UNIQUE INDEX `Код_учебного_заведения_UNIQUE` (`Код_учебного_заведения` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Выпускники учебного заведения`.`ЦТ`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Выпускники учебного заведения`.`ЦТ` (
  `Код_выпускника` INT NOT NULL AUTO_INCREMENT,
  `Название предмета` VARCHAR(45) NOT NULL,
  `Количество баллов` INT NOT NULL,
  `Преподаватель` VARCHAR(45) NULL,
  PRIMARY KEY (`Код_выпускника`, `Количество баллов`),
  UNIQUE INDEX `Код_выпускника_UNIQUE` (`Код_выпускника` ASC) VISIBLE,
  CONSTRAINT `fk_ct_graduate`
    FOREIGN KEY (`Код_выпускника`)
    REFERENCES `Выпускники учебного заведения`.`Выпускник` (`Код_выпускника`)
    ON DELETE CASCADE
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
