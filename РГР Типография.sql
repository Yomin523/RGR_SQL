-- Создание БД 
DROP DATABASE TEPOGRAPHY;
CREATE DATABASE TEPOGRAPHY;
USE TEPOGRAPHY;
DROP TABLE IF EXISTS materials, services, positions, warehouse, employee;

    CREATE TABLE `materials` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `material_name` varchar(100) NOT NULL,
        `material_type` varchar(100) NOT NULL,
        PRIMARY KEY (`id`)
    );

    CREATE TABLE `employee` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `position_id` INT NOT NULL,
        `name` varchar(150) NOT NULL,
        `age` smallint NOT NULL,
        `email` varchar(30) NOT NULL,
        PRIMARY KEY (`id`)
    );

    CREATE TABLE `services` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `warehouse_id` INT NOT NULL,
        `service_name` varchar(100) NOT NULL,
        `service_type` varchar(50) NOT NULL,
        `price` INT NOT NULL,
        PRIMARY KEY (`id`)
    );


    CREATE TABLE `positions` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `position_name` varchar(100) NOT NULL,
        PRIMARY KEY (`id`)
    );

    CREATE TABLE `warehouse` (
        `id` INT NOT NULL AUTO_INCREMENT,
        `employee_id` INT NOT NULL,
        `materials_id` INT NOT NULL,
        `quantity` INT NOT NULL,
        `unit` varchar(5) NOT NULL,
        PRIMARY KEY (`id`)
    );


    ALTER TABLE `services` ADD CONSTRAINT `services_fk0` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse`(`id`);
    
    ALTER TABLE `warehouse` ADD CONSTRAINT `warehouse_fk0` FOREIGN KEY (`employee_id`) REFERENCES `employee`(`id`);
    
    ALTER TABLE `warehouse` ADD CONSTRAINT `warehouse_fk1` FOREIGN KEY (`materials_id`) REFERENCES `materials`(`id`);
    
    ALTER TABLE `employee` ADD CONSTRAINT `employee_fk0` FOREIGN KEY (`position_id`) REFERENCES `positions`(`id`);
    


-- Внесение данных
INSERT INTO materials(material_name, material_type) 
VALUES	("Баннерная ткань 320 гр./кв.м.", "Баннерная ткань"),                   
        ("Баннерная ткань 440 гр./кв.м.", "Баннерная ткань"),                    
        ("Баннерная ткань 510 гр./кв.м.", "Баннерная ткань"),   
        ("Баннерная сетка", "Баннерная сетка"),                            
        ("Самоклеющаяся пленка", "Баннерная пленка"),
        ("Самоклеющаяся перфорированная пленка", "Баннерная пленка"),
        ("Люверсы 10 мм", "Люверсы"),
        ("Люверсы 12 мм", "Люверсы"),
        ("100 г/м2 глян. (640*900)", "Бумага"),
        ("105 г/м2 глян. (70*100)", "Бумага");
        
        
INSERT INTO positions(position_name)
VALUES  ("Операторов резальных машин"),
        ("Корректор"),
        ("Работник допечатной подготовки"),
        ("Фальцовщик"),
        ("Переплетчик"),
        ("Верстальщик"),
        ("Кладовщик"),
        ("Печатник"),
        ("Брошюровщик"),
        ("Дизайнер-шрифта");
        
        
INSERT INTO employee(position_id, name, age, email) 
VALUES	(1, "Медведева Диана Михайловна", 22, "dshjs23@mail.ru"),
        (2, "Миронов Артём Даниэльевич", 20, "saaa23@gmail.com"),
        (3, "Гусев Виктор Романович", 32, "dasd54@mail.ru"),
        (4, "Овчинникова Варвара Кирилловна", 34, "213fds@gmail.com"),
        (5, "Дубровин Виталий Святославович", 26, "dobovu54@gmail.com"),
        (6, "Сергеева Диана Владимировна", 27, "caaca32@mail.ru"),
        (7, "Чумакова Анна Матвеевна", 45, "trtr21trt@gmail.com"),
        (8, "Семенов Алексей Маркович", 40, "fdg545gf@mail.ru"),
        (9, "Лебедев Георгий Дмитриевич", 36, "gfd3gf@gmail.com"),
        (10, "Морозова Варвара Степановна", 35, "dw123qwe@gmail.com");
        

INSERT INTO warehouse(employee_id, materials_id, quantity, unit)
VALUES  (3, 2, 16, "кв.м."),
        (3, 4, 9, "кв.м."),
        (3, 5, 10, "кв.м."),
        (5, 3, 10, "кв.м."),
        (5, 7, 10, "шт"),
        (5, 8, 10, "шт"),
        (7, 5, 23, "шт"),
        (7, 3, 15, "шт"),
        (7, 1, 100, "шт"),
        (7, 9, 100, "шт");


INSERT INTO services(warehouse_id, service_name, service_type, price)
VALUES 	(1, "Печать с шириной печатного поля до 1600мм", "Широкоформатная печать", 350),
        (1, "Печать визиток", "Визитки", 300),
        (1, "Календарь трио-стандарт", "Календари", 140),
        (2, "Календарь шорт", "Календари", 92),
        (2, "Флаер А4", "Флаера", 350),
        (2, "Листовка формата А6", "Листовки", 5),
        (3, "Листовка формата А5", "Листовки", 8),
        (3, "Буклет А4", "Буклеты", 5),
        (3, "Буклет А3", "Буклеты", 7),
        (4, "Визитки с теснением", "Визитки", 28);
        
        
-- ТРИГГЕРЫ
-- INSERT
DROP TRIGGER IF EXISTS employee_insert;
DELIMITER //
CREATE TRIGGER employee_insert BEFORE INSERT ON employee
FOR EACH ROW 
BEGIN
IF ((SELECT COUNT(positions.id) FROM positions WHERE positions.id = NEW.position_id) = 0)
    THEN 
        SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'No such position_id.';
END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS services_insert;
DELIMITER //
CREATE TRIGGER services_insert BEFORE INSERT ON services
FOR EACH ROW 
BEGIN
IF ((SELECT COUNT(warehouse.id) FROM warehouse WHERE warehouse.id = NEW.warehouse_id) = 0)
    THEN 
        SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'No such warehouse_id.';
END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS warehouse_insert;
DELIMITER //
CREATE TRIGGER warehouse_insert BEFORE INSERT ON warehouse
FOR EACH ROW 
BEGIN
IF ((SELECT COUNT(employee.id) FROM employee WHERE employee.id = NEW.employee_id) = 0)
    THEN 
        SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'No such employee_id.';
END IF;
IF ((SELECT COUNT(materials.id) FROM materials WHERE materials.id = NEW.materials_id) = 0)
    THEN 
        SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'No such materials_id.';
END IF;
END //
DELIMITER ;


-- UPDATE
DROP TRIGGER IF EXISTS employee_update;
DELIMITER //
CREATE TRIGGER employee_update BEFORE UPDATE ON employee
FOR EACH ROW 
BEGIN
IF ((SELECT COUNT(positions.id) FROM positions WHERE positions.id = NEW.position_id) = 0)
    THEN 
        SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'No such position_id.';
END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS services_update;
DELIMITER //
CREATE TRIGGER services_update BEFORE UPDATE ON services
FOR EACH ROW 
BEGIN
IF ((SELECT COUNT(warehouse.id) FROM warehouse WHERE warehouse.id = NEW.warehouse_id) = 0)
    THEN 
        SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'No such warehouse_id.';
END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS warehouse_update;
DELIMITER //
CREATE TRIGGER warehouse_update BEFORE UPDATE ON warehouse
FOR EACH ROW 
BEGIN
IF ((SELECT COUNT(employee.id) FROM employee WHERE employee.id = NEW.employee_id) = 0)
    THEN 
        SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'No such employee_id.';
END IF;
IF ((SELECT COUNT(materials.id) FROM materials WHERE materials.id = NEW.materials_id) = 0)
    THEN 
        SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'No such materials_id.';
END IF;
END //
DELIMITER ;


-- DELETE
DROP TRIGGER IF EXISTS employee_delete;
DELIMITER //
CREATE TRIGGER employee_delete BEFORE DELETE ON employee
FOR EACH ROW 
BEGIN
IF ((SELECT COUNT(warehouse.employee_id) FROM warehouse WHERE warehouse.employee_id = OLD.id) = 0)
    THEN 
        SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'You cannot delete this employee. Because it is in the table warehouse. Remove it from warehouse table first.';
END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS materials_delete;
DELIMITER //
CREATE TRIGGER materials_delete BEFORE DELETE ON materials
FOR EACH ROW 
BEGIN
IF ((SELECT COUNT(warehouse.materials_id) FROM warehouse WHERE warehouse.materials_id = OLD.id) = 0)
    THEN 
        SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'You cannot delete this material. Because it has a warehouse attached to it.';
END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS positions_delete;
DELIMITER //
CREATE TRIGGER positions_delete BEFORE DELETE ON positions
FOR EACH ROW 
BEGIN
IF ((SELECT COUNT(employee.position_id) FROM employee WHERE employee.position_id = OLD.id) = 0)
    THEN 
        SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'You cannot delete this position. Because some employees are attached to it.';
END IF;
END //
DELIMITER ;