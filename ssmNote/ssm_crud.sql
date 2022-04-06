CREATE DATABASE ssm_crud

CREATE TABLE IF NOT EXISTS `ssm_crud`.`tbl_emp`(  
  `emp_id` INT(11) NOT NULL AUTO_INCREMENT,
  `emp_name` VARCHAR(255) NOT NULL,
  `gender` CHAR(1),
  `email` VARCHAR(255),
  `d_id` INT(11),
  PRIMARY KEY (`emp_id`)
);
SELECT * FROM tbl_emp;


CREATE TABLE IF NOT EXISTS `ssm_crud`.`tbl_dept`(  
  `dept_id` INT(11) NOT NULL AUTO_INCREMENT,
  `dept_name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`dept_id`)
);
SELECT * FROM tbl_dept;
DELETE * FROM tbl_dept;

ALTER TABLE `ssm_crud`.`tbl_emp`  
  ADD CONSTRAINT `fk_emp_dept` FOREIGN KEY (`d_id`) REFERENCES `ssm_crud`.`tbl_dept`(`dept_id`);

#drop database `ssm-crud`;
