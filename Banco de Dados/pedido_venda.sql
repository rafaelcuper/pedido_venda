# Host: localhost  (Version 5.7.18-log)
# Date: 2021-08-26 04:34:10
# Generator: MySQL-Front 6.1  (Build 1.20)


#
# Structure for table "cliente"
#

DROP TABLE IF EXISTS `cliente`;
CREATE TABLE `cliente` (
  `codigo_cliente` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(500) DEFAULT NULL,
  `cidade` varchar(255) DEFAULT NULL,
  `uf` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`codigo_cliente`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;

#
# Data for table "cliente"
#

INSERT INTO `cliente` VALUES (1,'Rafael Cupertino dos Santos','Maceió','AL'),(2,'José da Silva','Maceió','AL'),(3,'Talia Toledo','Maceió','AL'),(4,'Clara Toledo','Maceió','AL'),(5,'João Batista','Maceió','AL'),(6,'Edi Sara Heck','Maceió','AL'),(7,'Lori Noemia','Maceió','AL'),(8,'Maria José','Maceió','AL'),(9,'Fabio Santos','Maceió','AL'),(10,'Elisabete da Costa Rios','Maceió','AL'),(11,'Miriam Perdigão Aragão','Maceió','AL'),(12,'Leandro Nascimento Botelho','Maceió','AL'),(13,'Gastão Rosário Dâmaso','Maceió','AL'),(14,'Lorena Ouro Hipólito','Maceió','AL'),(15,'Petra Rufino Canedo','Maceió','AL'),(16,'Angélico Lampreia Aguiar','Maceió','AL'),(17,'Joseph Miranda Damásio','Maceió','AL'),(18,'Heloísa Manso Jardim','Maceió','AL'),(19,'Haniela Cerveira Lucena','Maceió','AL'),(20,'Rayane Torreiro Ruas','Maceió','AL');

#
# Structure for table "pedido"
#

DROP TABLE IF EXISTS `pedido`;
CREATE TABLE `pedido` (
  `numero_pedido` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `data_emissao` date DEFAULT NULL,
  `codigo_cliente` int(11) DEFAULT NULL,
  `valor_total` float(10,2) DEFAULT NULL,
  PRIMARY KEY (`numero_pedido`),
  KEY `fk_pedido_cliente` (`codigo_cliente`),
  CONSTRAINT `fk_pedido_cliente` FOREIGN KEY (`codigo_cliente`) REFERENCES `cliente` (`codigo_cliente`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

#
# Data for table "pedido"
#

INSERT INTO `pedido` VALUES (1,'2021-08-26',1,414.00),(2,'2021-08-26',2,118.00),(3,'2021-08-26',2,713.00);

#
# Structure for table "produtos"
#

DROP TABLE IF EXISTS `produtos`;
CREATE TABLE `produtos` (
  `codigo_produto` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `descricao` varchar(500) DEFAULT NULL,
  `preco_venda` float(10,2) DEFAULT NULL,
  PRIMARY KEY (`codigo_produto`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

#
# Data for table "produtos"
#

INSERT INTO `produtos` VALUES (1,'Notebook',200.00),(2,'Celular',159.90),(3,'Air Fryer',50.00),(4,'Fone de Ouvido Bluetooth',30.00),(5,'Sofá-cama',49.00),(6,'Máscara Contra COVID',55.00),(7,'Cinta Modeladora',78.00),(8,'Cadeira de Escritório',32.00),(9,'Tripé para Celular',45.00),(10,'Ração para Animais de Estimação',256.00),(11,'Tapetes de Yoga',23.00),(12,'Painel Solar',523.00),(13,'Aspirador de Pó Portátil',342.00),(14,'Cílios Postiços',524.00),(15,'Capinha de Celular',23.00),(16,'Canguru para Bebês',324.00),(17,'Lâmpadas inteligentes',434.00),(18,'Sucrilhos ',33.00),(19,'Durex ',54.00),(20,'Jet-ski',465.00),(21,'Leite Ninho',21.00);

#
# Structure for table "pedido_produto"
#

DROP TABLE IF EXISTS `pedido_produto`;
CREATE TABLE `pedido_produto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `numero_pedido` int(11) unsigned NOT NULL,
  `codigo_produto` int(11) unsigned NOT NULL,
  `quantidade` double DEFAULT NULL,
  `valor_unitario` double DEFAULT NULL,
  `valor_total` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_pedido` (`numero_pedido`),
  KEY `fk_produto` (`codigo_produto`),
  CONSTRAINT `fk_pedido` FOREIGN KEY (`numero_pedido`) REFERENCES `pedido` (`numero_pedido`) ON UPDATE NO ACTION,
  CONSTRAINT `fk_produto` FOREIGN KEY (`codigo_produto`) REFERENCES `produtos` (`codigo_produto`) ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;

#
# Data for table "pedido_produto"
#

INSERT INTO `pedido_produto` VALUES (19,1,7,1,78,78),(20,1,6,1,55,55),(21,1,8,1,32,32),(22,1,5,1,49,49),(23,1,1,1,200,200),(24,2,18,1,33,33),(25,2,6,1,55,55),(26,2,4,1,30,30),(27,3,10,1,256,256),(28,3,15,1,23,23),(29,3,17,1,434,434);
