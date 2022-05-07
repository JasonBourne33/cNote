CREATE DATABASE seckill;
CREATE TABLE t_user(
	`id` BIGINT(20) NOT NULL COMMENT '用户ID,手机号码',
	`nickname` VARCHAR(255) NOT NULL,
	`password` VARCHAR(32) DEFAULT NULL COMMENT 'MD5(MD5(pass明文+固定salt)+salt)',
	`salt` VARCHAR(10) DEFAULT NULL,
	`head` VARCHAR(128) DEFAULT NULL COMMENT '头像',
	`register_date` DATETIME DEFAULT NULL COMMENT '注册时间',
	`last_login_date` DATETIME DEFAULT NULL COMMENT '最后一次登录事件',
	`login_count` INT(11) DEFAULT '0' COMMENT '登录次数',
	PRIMARY KEY(`id`)
)
COMMENT '用户表';
INSERT INTO `t_user` (`id`, `nickname`, `password`, `salt`, `head`, `register_date`, `last_login_date`, `login_count`) VALUES('18012345678','admin','b7797cce01b4b131b433b6acf4add449','1a2b3c4d',NULL,NULL,NULL,'0');
SELECT * FROM t_user;

CREATE TABLE t_goods(
	id BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '商品ID',
	goods_name VARCHAR(16) DEFAULT NULL COMMENT '商品名称',
	goods_title VARCHAR(64) DEFAULT NULL COMMENT '商品标题',
	goods_img VARCHAR(64) DEFAULT NULL COMMENT '商品图片',
	goods_detail LONGTEXT COMMENT '商品详情',
	goods_price DECIMAL(10,2) DEFAULT '0.00' COMMENT '商品价格',
	goods_stock INT(11) DEFAULT '0' COMMENT '商品库存，-1表示没有限制',
	PRIMARY KEY(id)
)
COMMENT '商品表';
INSERT INTO t_goods VALUE(1,'IPHONE12 64GB','IPHONE12 64GB','/img/iphone12.png','IPHONE12 64GB','6299.00',1000);
INSERT INTO t_goods VALUE(2,'IPHONE12 PRO 128GB','IPHONE12 PRO 128GB','/img/iphone12pro.png','IPHONE12 64GB','9299.00',900);
# drop table t_goods;
SELECT * FROM t_goods;

CREATE TABLE `t_order` (
	`id` BIGINT(20) NOT NULL  AUTO_INCREMENT COMMENT '订单ID',
	`user_id` BIGINT(20) DEFAULT NULL COMMENT '用户ID',
	`goods_id` BIGINT(20) DEFAULT NULL COMMENT '商品ID',
	`delivery_addr_id` BIGINT(20) DEFAULT NULL  COMMENT '收获地址ID',
	`goods_name` VARCHAR(16) DEFAULT NULL  COMMENT '商品名字',
	`goods_count` INT(20) DEFAULT '0'  COMMENT '商品数量',
	`goods_price` DECIMAL(10,2) DEFAULT '0.00'  COMMENT '商品价格',
	`order_channel` TINYINT(4) DEFAULT '0'  COMMENT '1 pc,2 android, 3 ios',
	`status` TINYINT(4) DEFAULT '0'  COMMENT '订单状态，0新建未支付，1已支付，2已发货，3已收货，4已退货，5已完成',
	`create_date` DATETIME DEFAULT NULL  COMMENT '订单创建时间',
	`pay_date` DATETIME DEFAULT NULL  COMMENT '支付时间',
	PRIMARY KEY(`id`)
)ENGINE = INNODB AUTO_INCREMENT=12 DEFAULT CHARSET = utf8mb4;
COMMENT '订单表';


CREATE TABLE `t_seckill_goods`(
	`id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '秒杀商品ID',
	`goods_id` BIGINT(20) NOT NULL COMMENT '商品ID',
	`seckill_price` DECIMAL(10,2) NOT NULL COMMENT '秒杀家',
	`stock_count` INT(10) NOT NULL  COMMENT '库存数量',
	`start_date` DATETIME NOT NULL  COMMENT '秒杀开始时间',
	`end_date` DATETIME NOT NULL COMMENT '秒杀结束时间',
	PRIMARY KEY(`id`)
)ENGINE = INNODB AUTO_INCREMENT=3 DEFAULT CHARSET = utf8mb4
COMMENT '秒杀商品表';
INSERT INTO t_seckill_goods VALUE(1,1,'629',10,'2022-05-7 17:00:00','2022-05-07 18:00:00');
INSERT INTO t_seckill_goods VALUE(2,2,'929',9,'2022-11-01 08:00:00','2022-11-01 09:00:00');
SELECT * FROM t_seckill_goods;

# drop table `t_seckill_goods`;


CREATE TABLE `t_seckill_order` (
	`id` BIGINT(20) NOT NULL AUTO_INCREMENT COMMENT '秒杀订单ID',
	`user_id` BIGINT(20) NOT NULL  COMMENT '用户ID',
	`order_id` BIGINT(20) NOT NULL  COMMENT '订单ID',
	`goods_id` BIGINT(20) NOT NULL  COMMENT '商品ID',
	PRIMARY KEY(`id`)
)ENGINE = INNODB AUTO_INCREMENT=3 DEFAULT CHARSET = utf8mb4
COMMENT '秒杀订单表';


-- 添加索引，讲到时在加
ALTER TABLE `seckill`.`t_seckill_order` 
ADD UNIQUE INDEX `seckill_uid_gid`(user_id, goods_id) USING BTREE COMMENT '用户ID+商品ID成为唯一索引，';
