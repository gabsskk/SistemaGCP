-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema sgcapprin
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema sgcapprin
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `sgcapprin` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `sgcapprin` ;

-- -----------------------------------------------------
-- Table `sgcapprin`.`categoria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sgcapprin`.`categoria` (
  `idCategoria` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idCategoria`))
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `sgcapprin`.`empresa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sgcapprin`.`empresa` (
  `idEmpresa` INT NOT NULL AUTO_INCREMENT,
  `cnpj` VARCHAR(14) NOT NULL,
  `nome` VARCHAR(70) NOT NULL,
  PRIMARY KEY (`idEmpresa`),
  UNIQUE INDEX `cnpj_UNIQUE` (`cnpj` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 48
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `sgcapprin`.`status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sgcapprin`.`status` (
  `idStatus` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`idStatus`))
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `sgcapprin`.`pasta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sgcapprin`.`pasta` (
  `idPasta` INT NOT NULL AUTO_INCREMENT,
  `dataAbertura` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dataArquivoMorto` DATETIME NULL DEFAULT NULL,
  `Categoria_idCategoria` INT NOT NULL,
  `Empresa_idEmpresa` INT NOT NULL,
  `Status_idStatus` INT NOT NULL DEFAULT '1',
  `dataEntrega` DATETIME NULL DEFAULT NULL,
  `observacao` VARCHAR(100) NULL DEFAULT NULL,
  `dataValidade` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`idPasta`, `Categoria_idCategoria`, `Empresa_idEmpresa`, `Status_idStatus`),
  INDEX `fk_Pasta_Categoria_idx` (`Categoria_idCategoria` ASC) VISIBLE,
  INDEX `fk_Pasta_Empresa1_idx` (`Empresa_idEmpresa` ASC) VISIBLE,
  INDEX `fk_Pasta_Status1_idx` (`Status_idStatus` ASC) VISIBLE,
  CONSTRAINT `fk_Pasta_Categoria`
    FOREIGN KEY (`Categoria_idCategoria`)
    REFERENCES `sgcapprin`.`categoria` (`idCategoria`),
  CONSTRAINT `fk_Pasta_Empresa1`
    FOREIGN KEY (`Empresa_idEmpresa`)
    REFERENCES `sgcapprin`.`empresa` (`idEmpresa`),
  CONSTRAINT `fk_Pasta_Status1`
    FOREIGN KEY (`Status_idStatus`)
    REFERENCES `sgcapprin`.`status` (`idStatus`))
ENGINE = InnoDB
AUTO_INCREMENT = 1377
DEFAULT CHARACTER SET = utf8mb3;

USE `sgcapprin` ;

-- -----------------------------------------------------
-- procedure GerarPastasAleatorias
-- -----------------------------------------------------

DELIMITER $$
USE `sgcapprin`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GerarPastasAleatorias`()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE random_empresa INT;
    DECLARE random_categoria INT;
    DECLARE random_status INT;
    DECLARE data_abertura DATE;
    DECLARE data_arquivo DATE;
    DECLARE data_entrega DATE;
    DECLARE data_valid DATE;

    WHILE i <= 976 DO
        SET random_empresa = FLOOR(1 + (RAND() * 47));
        SET random_categoria = FLOOR(1 + (RAND() * 9));
        SET random_status = FLOOR(1 + (RAND() * 4));
        
        SET data_abertura = DATE_ADD('2016-01-01', INTERVAL FLOOR(RAND() * 3600) DAY);
        
        IF random_status = 2 THEN
            SET data_arquivo = DATE_ADD(data_abertura, INTERVAL FLOOR(30 + RAND() * 400) DAY);
            SET data_entrega = NULL;
            SET data_valid = NULL;
        ELSEIF random_status = 4 THEN
            SET data_arquivo = DATE_ADD(data_abertura, INTERVAL FLOOR(30 + RAND() * 200) DAY);
            SET data_entrega = DATE_ADD(data_arquivo, INTERVAL FLOOR(5 + RAND() * 30) DAY);
            SET data_valid = NULL;
        ELSEIF random_status = 3 THEN
            SET data_arquivo = DATE_ADD(data_abertura, INTERVAL FLOOR(30 + RAND() * 100) DAY);
            SET data_entrega = NULL;
            SET data_valid = '2025-10-01'; 
        ELSE
            SET data_arquivo = NULL;
            SET data_entrega = NULL;
            SET data_valid = NULL;
        END IF;

        INSERT INTO pasta (idPasta, dataAbertura, dataArquivoMorto, Categoria_idCategoria, Empresa_idEmpresa, Status_idStatus, dataEntrega, dataValidade, observacao)
        VALUES (400 + i, data_abertura, data_arquivo, random_categoria, random_empresa, random_status, data_entrega, data_valid, 
                IF(random_status=3, 'Pasta vencida aguardando retirada', NULL));

        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GerarPastasPorcentagemExata
-- -----------------------------------------------------

DELIMITER $$
USE `sgcapprin`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GerarPastasPorcentagemExata`()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE random_empresa INT;
    DECLARE random_categoria INT;
    DECLARE random_status INT;
    DECLARE data_abertura DATE;
    DECLARE data_arquivo DATE;
    DECLARE data_entrega DATE;
    DECLARE data_valid DATE;
    DECLARE sorteio_status DECIMAL(5,2);
    DECLARE sorteio_cat DECIMAL(5,2);

    TRUNCATE TABLE pasta;

    WHILE i <= 976 DO
        SET random_empresa = FLOOR(1 + (RAND() * 47));

        SET sorteio_status = RAND() * 100;
        IF sorteio_status <= 52.72 THEN
            SET random_status = 1; 
        ELSEIF sorteio_status <= 65.96 THEN
            SET random_status = 2; 
        ELSEIF sorteio_status <= 88.00 THEN
            SET random_status = 4; 
        ELSE
            SET random_status = 3; 
        END IF;

        SET sorteio_cat = RAND() * 100;
        IF sorteio_cat <= 15.0 THEN
            SET random_categoria = 1;
        ELSEIF sorteio_cat <= 30.0 THEN
            SET random_categoria = 2;
        ELSEIF sorteio_cat <= 45.0 THEN
            SET random_categoria = 3;
        ELSEIF sorteio_cat <= 58.0 THEN
            SET random_categoria = 4;
        ELSEIF sorteio_cat <= 70.0 THEN
            SET random_categoria = 5;
        ELSEIF sorteio_cat <= 80.0 THEN
            SET random_categoria = 6;
        ELSEIF sorteio_cat <= 89.0 THEN
            SET random_categoria = 7;
        ELSEIF sorteio_cat <= 95.0 THEN
            SET random_categoria = 8;
        ELSE
            SET random_categoria = 9;
        END IF;

        SET data_abertura = DATE_ADD('2016-01-01', INTERVAL FLOOR(RAND() * 3650) DAY);
        
        IF random_status = 2 THEN
            SET data_arquivo = DATE_ADD(data_abertura, INTERVAL FLOOR(15 + RAND() * 120) DAY);
            SET data_entrega = NULL;
            SET data_valid = NULL;
        ELSEIF random_status = 4 THEN
            SET data_arquivo = DATE_ADD(data_abertura, INTERVAL FLOOR(15 + RAND() * 90) DAY);
            SET data_entrega = DATE_ADD(data_arquivo, INTERVAL FLOOR(5 + RAND() * 30) DAY);
            SET data_valid = NULL;
        ELSEIF random_status = 3 THEN
            SET data_arquivo = DATE_ADD(data_abertura, INTERVAL FLOOR(20 + RAND() * 80) DAY);
            SET data_entrega = NULL;
            SET data_valid = '2025-10-01'; 
        ELSE
            SET data_arquivo = NULL;
            SET data_entrega = NULL;
            SET data_valid = NULL;
        END IF;

        INSERT INTO pasta (idPasta, dataAbertura, dataArquivoMorto, Categoria_idCategoria, Empresa_idEmpresa, Status_idStatus, dataEntrega, dataValidade, observacao)
        VALUES (400 + i, data_abertura, data_arquivo, random_categoria, random_empresa, random_status, data_entrega, data_valid, 
                IF(random_status=3, 'Pasta com prazo expirado, pronta para devolução', NULL));

        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GerarPastasRealistas
-- -----------------------------------------------------

DELIMITER $$
USE `sgcapprin`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GerarPastasRealistas`()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE random_empresa INT;
    DECLARE random_categoria INT;
    DECLARE random_status INT;
    DECLARE data_abertura DATE;
    DECLARE data_arquivo DATE;
    DECLARE data_entrega DATE;
    DECLARE data_valid DATE;
    DECLARE peso_cat INT;
    DECLARE peso_emp INT;

    -- Limpa a tabela de pastas antes de popular a nova massa orgânica
    TRUNCATE TABLE pasta;

    WHILE i <= 976 DO
        -- Distribuição realista de empresas (algumas concentram muitas pastas, outras poucas)
        SET peso_emp = FLOOR(RAND() * 100);
        IF peso_emp < 40 THEN
            -- 40% das pastas concentradas nas primeiras 10 empresas (grandes clientes)
            SET random_empresa = FLOOR(1 + (RAND() * 10));
        ELSEIF peso_emp < 75 THEN
            -- 35% nas empresas de 11 a 30
            SET random_empresa = FLOOR(11 + (RAND() * 20));
        ELSE
            -- 25% espalhadas nas empresas restantes (clientes menores)
            SET random_empresa = FLOOR(31 + (RAND() * 17));
        END IF;

        -- Distribuição realista de categorias (algumas categorias são muito mais comuns)
        SET peso_cat = FLOOR(RAND() * 100);
        IF peso_cat < 35 THEN
            SET random_categoria = 1; -- Categoria principal de maior fluxo
        ELSEIF peso_cat < 60 THEN
            SET random_categoria = FLOOR(2 + (RAND() * 2)); -- Categorias 2 e 3 intermediárias
        ELSE
            SET random_categoria = FLOOR(4 + (RAND() * 6)); -- Restante das categorias com fluxo menor
        END IF;

        -- Distribuição realista de status (Maioria Arq. Morto ou Aberta, menor parte disponível/entregue)
        SET random_status = FLOOR(RAND() * 100);
        IF random_status < 45 THEN
            SET random_status = 2; -- Arquivo Morto (45%)
        ELSEIF random_status < 75 THEN
            SET random_status = 1; -- Aberta (30%)
        ELSEIF random_status < 90 THEN
            SET random_status = 4; -- Entregue (15%)
        ELSE
            SET random_status = 3; -- Disponível para Entrega / Vencidas (10%)
        END IF;
        
        -- Gera data de abertura orgânica (últimos 5 anos)
        SET data_abertura = DATE_ADD('2021-01-01', INTERVAL FLOOR(RAND() * 1800) DAY);
        
        -- Atribuição de datas conforme o status realista sorteado
        IF random_status = 2 THEN
            SET data_arquivo = DATE_ADD(data_abertura, INTERVAL FLOOR(20 + RAND() * 150) DAY);
            SET data_entrega = NULL;
            SET data_valid = NULL;
        ELSEIF random_status = 4 THEN
            SET data_arquivo = DATE_ADD(data_abertura, INTERVAL FLOOR(20 + RAND() * 100) DAY);
            SET data_entrega = DATE_ADD(data_arquivo, INTERVAL FLOOR(5 + RAND() * 40) DAY);
            SET data_valid = NULL;
        ELSEIF random_status = 3 THEN
            SET data_arquivo = DATE_ADD(data_abertura, INTERVAL FLOOR(30 + RAND() * 90) DAY);
            SET data_entrega = NULL;
            SET data_valid = '2025-10-01'; -- Vencida para acionar o indicador
        ELSE
            SET data_arquivo = NULL;
            SET data_entrega = NULL;
            SET data_valid = NULL;
        END IF;

        -- Insere a pasta com ID sequencial a partir de 401
        INSERT INTO pasta (idPasta, dataAbertura, dataArquivoMorto, Categoria_idCategoria, Empresa_idEmpresa, Status_idStatus, dataEntrega, dataValidade, observacao)
        VALUES (400 + i, data_abertura, data_arquivo, random_categoria, random_empresa, random_status, data_entrega, data_valid, 
                IF(random_status=3, 'Pasta com prazo expirado, pronta para devolução', NULL));

        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
