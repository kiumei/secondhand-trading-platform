/*
 Navicat MySQL Dump SQL

 Source Server         : 连接1
 Source Server Type    : MySQL
 Source Server Version : 80044 (8.0.44)
 Source Host           : localhost:3306
 Source Schema         : secondhand

 Target Server Type    : MySQL
 Target Server Version : 80044 (8.0.44)
 File Encoding         : 65001

 Date: 08/09/2026 21:26:58
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `cate_id` int NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `cate_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `parent_id` int NULL DEFAULT NULL COMMENT '父类为0表示一级分类',
  `sort` int NULL DEFAULT NULL,
  PRIMARY KEY (`cate_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (1, '教材教辅', 0, 1);
INSERT INTO `category` VALUES (2, '数码产品', 0, 2);
INSERT INTO `category` VALUES (3, '生活用品', 0, 3);
INSERT INTO `category` VALUES (4, '宿舍家具', 0, 4);
INSERT INTO `category` VALUES (5, '运动器材', 0, 5);
INSERT INTO `category` VALUES (6, '服饰鞋包', 0, 6);

-- ----------------------------
-- Table structure for evaluate
-- ----------------------------
DROP TABLE IF EXISTS `evaluate`;
CREATE TABLE `evaluate`  (
  `eva_id` int NOT NULL AUTO_INCREMENT COMMENT '自增',
  `order_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '手工生成流水号不自增',
  `score` smallint NOT NULL COMMENT '1-5星',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `eva_time` datetime NOT NULL,
  PRIMARY KEY (`eva_id`) USING BTREE,
  UNIQUE INDEX `order_id`(`order_id` ASC) USING BTREE,
  CONSTRAINT `FK_rel_orders_create_evaluate` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_evaluate_score` CHECK ((`score` >= 1) and (`score` <= 5))
) ENGINE = InnoDB AUTO_INCREMENT = 201 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of evaluate
-- ----------------------------
INSERT INTO `evaluate` VALUES (1, '170', 5, 'QxQ2AlUuHJ', '2004-04-04 20:42:16');
INSERT INTO `evaluate` VALUES (2, '196', 4, 'NaQfmMZTXN', '2016-06-07 23:47:23');
INSERT INTO `evaluate` VALUES (3, '130', 2, 'RnbAXYFv2J', '2001-07-30 09:08:59');
INSERT INTO `evaluate` VALUES (7, '192', 1, 'pdQ0vGCREi', '2023-10-23 11:17:38');
INSERT INTO `evaluate` VALUES (8, '178', 4, 'lNYjjhNOV1', '2020-02-03 14:05:34');
INSERT INTO `evaluate` VALUES (13, '34', 3, 'QewuguGQqU', '2018-07-25 08:29:04');
INSERT INTO `evaluate` VALUES (16, '17', 3, 'E2cIamNREV', '2012-01-26 09:10:18');
INSERT INTO `evaluate` VALUES (17, '27', 2, 'xKpsg43GV7', '2002-03-16 09:36:34');
INSERT INTO `evaluate` VALUES (24, '1', 2, 'KbtwwvN9Ca', '2004-08-07 07:14:31');
INSERT INTO `evaluate` VALUES (29, '57', 3, 'ztkxC8IAnU', '2021-01-30 22:01:02');
INSERT INTO `evaluate` VALUES (36, '174', 4, 'GXQeNA8ZeQ', '2009-04-12 21:11:41');
INSERT INTO `evaluate` VALUES (61, '114', 4, '9KHi6syLhI', '2020-12-23 11:45:26');
INSERT INTO `evaluate` VALUES (62, '89', 3, '83ZhkClN16', '2014-01-31 15:00:33');
INSERT INTO `evaluate` VALUES (63, '97', 1, 'D8jBeodmhK', '2007-07-22 21:43:36');
INSERT INTO `evaluate` VALUES (66, '172', 2, '0GbkJ8aH45', '2018-05-01 16:27:20');
INSERT INTO `evaluate` VALUES (87, '82', 1, 'k6CBZVOaM0', '2006-08-27 06:43:50');
INSERT INTO `evaluate` VALUES (103, '95', 3, 'RSUojPoYGK', '2013-05-06 07:06:14');
INSERT INTO `evaluate` VALUES (116, '96', 2, 'cYxpAJx5eu', '2002-05-08 02:02:24');
INSERT INTO `evaluate` VALUES (125, '183', 4, 'slmYxQtfRQ', '2000-10-23 14:25:47');
INSERT INTO `evaluate` VALUES (126, '59', 1, 'nwKGNhgetn', '2000-06-20 01:30:35');
INSERT INTO `evaluate` VALUES (134, '18', 4, 'R06c7hAuns', '2023-09-18 19:40:29');
INSERT INTO `evaluate` VALUES (145, '160', 5, 'NE39i20BiH', '2002-05-31 14:00:11');
INSERT INTO `evaluate` VALUES (154, '155', 4, 'po0QqtQTFR', '2014-11-27 11:48:38');
INSERT INTO `evaluate` VALUES (155, '16', 5, 'wRGpoTNIWK', '2000-10-02 14:51:59');
INSERT INTO `evaluate` VALUES (181, '189', 3, 'hO1XvYSW0q', '2021-06-28 05:47:36');
INSERT INTO `evaluate` VALUES (197, '48', 2, 'AcNFhtAX9q', '2006-05-19 15:48:12');
INSERT INTO `evaluate` VALUES (200, '13', 4, 'bcfSzlMPUV', '2003-01-30 17:03:00');

-- ----------------------------
-- Table structure for favorite
-- ----------------------------
DROP TABLE IF EXISTS `favorite`;
CREATE TABLE `favorite`  (
  `favorite_id` int NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `user_id` int NOT NULL COMMENT '收藏的用户ID',
  `goods_id` int NOT NULL COMMENT '被收藏的商品ID',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
  PRIMARY KEY (`favorite_id`) USING BTREE,
  UNIQUE INDEX `uk_user_goods`(`user_id` ASC, `goods_id` ASC) USING BTREE,
  INDEX `idx_user_time`(`user_id` ASC, `create_time` ASC) USING BTREE,
  INDEX `fk_favorite_goods`(`goods_id` ASC) USING BTREE,
  CONSTRAINT `fk_favorite_goods` FOREIGN KEY (`goods_id`) REFERENCES `goods` (`goods_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_favorite_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 256 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商品收藏表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of favorite
-- ----------------------------
INSERT INTO `favorite` VALUES (1, 10, 1, '2026-09-06 09:35:56');
INSERT INTO `favorite` VALUES (2, 9, 1, '2026-09-05 21:35:56');
INSERT INTO `favorite` VALUES (3, 8, 1, '2026-09-05 20:35:56');
INSERT INTO `favorite` VALUES (4, 7, 1, '2026-09-07 05:35:56');
INSERT INTO `favorite` VALUES (5, 6, 1, '2026-09-05 21:35:56');
INSERT INTO `favorite` VALUES (6, 5, 1, '2026-09-07 15:35:56');
INSERT INTO `favorite` VALUES (7, 4, 1, '2026-09-07 19:35:56');
INSERT INTO `favorite` VALUES (8, 3, 1, '2026-09-07 14:35:56');
INSERT INTO `favorite` VALUES (9, 2, 1, '2026-09-06 00:35:56');
INSERT INTO `favorite` VALUES (10, 1, 1, '2026-09-07 01:35:56');
INSERT INTO `favorite` VALUES (11, 10, 2, '2026-09-04 15:35:56');
INSERT INTO `favorite` VALUES (12, 9, 2, '2026-09-05 20:35:56');
INSERT INTO `favorite` VALUES (13, 8, 2, '2026-09-06 19:35:56');
INSERT INTO `favorite` VALUES (14, 7, 2, '2026-09-08 00:35:56');
INSERT INTO `favorite` VALUES (15, 6, 2, '2026-09-06 22:35:56');
INSERT INTO `favorite` VALUES (16, 5, 2, '2026-09-06 03:35:56');
INSERT INTO `favorite` VALUES (17, 4, 2, '2026-09-05 16:35:56');
INSERT INTO `favorite` VALUES (18, 3, 2, '2026-09-05 12:35:56');
INSERT INTO `favorite` VALUES (19, 2, 2, '2026-09-06 05:35:56');
INSERT INTO `favorite` VALUES (20, 1, 2, '2026-09-06 00:35:56');
INSERT INTO `favorite` VALUES (21, 10, 3, '2026-09-07 01:35:56');
INSERT INTO `favorite` VALUES (22, 9, 3, '2026-09-04 12:35:56');
INSERT INTO `favorite` VALUES (23, 8, 3, '2026-09-05 08:35:56');
INSERT INTO `favorite` VALUES (24, 7, 3, '2026-09-04 16:35:56');
INSERT INTO `favorite` VALUES (25, 6, 3, '2026-09-07 05:35:56');
INSERT INTO `favorite` VALUES (26, 5, 3, '2026-09-05 02:35:56');
INSERT INTO `favorite` VALUES (27, 4, 3, '2026-09-07 18:35:56');
INSERT INTO `favorite` VALUES (28, 3, 3, '2026-09-06 18:35:56');
INSERT INTO `favorite` VALUES (29, 2, 3, '2026-09-06 04:35:56');
INSERT INTO `favorite` VALUES (30, 1, 3, '2026-09-06 06:35:56');
INSERT INTO `favorite` VALUES (31, 10, 4, '2026-09-08 07:35:56');
INSERT INTO `favorite` VALUES (32, 9, 4, '2026-09-05 22:35:56');
INSERT INTO `favorite` VALUES (33, 8, 4, '2026-09-04 12:35:56');
INSERT INTO `favorite` VALUES (34, 7, 4, '2026-09-04 14:35:56');
INSERT INTO `favorite` VALUES (35, 6, 4, '2026-09-05 03:35:56');
INSERT INTO `favorite` VALUES (36, 5, 4, '2026-09-07 10:35:56');
INSERT INTO `favorite` VALUES (37, 4, 4, '2026-09-04 20:35:56');
INSERT INTO `favorite` VALUES (38, 3, 4, '2026-09-05 23:35:56');
INSERT INTO `favorite` VALUES (39, 2, 4, '2026-09-06 20:35:56');
INSERT INTO `favorite` VALUES (40, 1, 4, '2026-09-07 18:35:56');
INSERT INTO `favorite` VALUES (41, 10, 5, '2026-09-05 13:35:56');
INSERT INTO `favorite` VALUES (42, 9, 5, '2026-09-08 10:35:56');
INSERT INTO `favorite` VALUES (43, 8, 5, '2026-09-04 13:35:56');
INSERT INTO `favorite` VALUES (44, 7, 5, '2026-09-05 13:35:56');
INSERT INTO `favorite` VALUES (45, 6, 5, '2026-09-05 13:35:56');
INSERT INTO `favorite` VALUES (46, 5, 5, '2026-09-06 16:35:56');
INSERT INTO `favorite` VALUES (47, 4, 5, '2026-09-08 06:35:56');
INSERT INTO `favorite` VALUES (48, 3, 5, '2026-09-08 12:35:56');
INSERT INTO `favorite` VALUES (49, 2, 5, '2026-09-05 01:35:56');
INSERT INTO `favorite` VALUES (50, 1, 5, '2026-09-07 22:35:56');
INSERT INTO `favorite` VALUES (51, 10, 6, '2026-09-07 14:35:56');
INSERT INTO `favorite` VALUES (52, 9, 6, '2026-09-05 16:35:56');
INSERT INTO `favorite` VALUES (53, 8, 6, '2026-09-05 11:35:56');
INSERT INTO `favorite` VALUES (54, 7, 6, '2026-09-05 20:35:56');
INSERT INTO `favorite` VALUES (55, 6, 6, '2026-09-04 09:35:56');
INSERT INTO `favorite` VALUES (56, 5, 6, '2026-09-08 06:35:56');
INSERT INTO `favorite` VALUES (57, 4, 6, '2026-09-07 04:35:56');
INSERT INTO `favorite` VALUES (58, 3, 6, '2026-09-06 17:35:56');
INSERT INTO `favorite` VALUES (59, 2, 6, '2026-09-07 17:35:56');
INSERT INTO `favorite` VALUES (60, 1, 6, '2026-09-05 18:35:56');
INSERT INTO `favorite` VALUES (61, 10, 7, '2026-09-05 11:35:56');
INSERT INTO `favorite` VALUES (62, 9, 7, '2026-09-05 16:35:56');
INSERT INTO `favorite` VALUES (63, 8, 7, '2026-09-07 16:35:56');
INSERT INTO `favorite` VALUES (64, 7, 7, '2026-09-04 11:35:56');
INSERT INTO `favorite` VALUES (65, 6, 7, '2026-09-07 11:35:56');
INSERT INTO `favorite` VALUES (66, 5, 7, '2026-09-06 23:35:56');
INSERT INTO `favorite` VALUES (67, 4, 7, '2026-09-08 02:35:56');
INSERT INTO `favorite` VALUES (68, 3, 7, '2026-09-06 23:35:56');
INSERT INTO `favorite` VALUES (69, 2, 7, '2026-09-06 02:35:56');
INSERT INTO `favorite` VALUES (70, 1, 7, '2026-09-05 07:35:56');
INSERT INTO `favorite` VALUES (71, 10, 8, '2026-09-07 22:35:56');
INSERT INTO `favorite` VALUES (72, 9, 8, '2026-09-06 21:35:56');
INSERT INTO `favorite` VALUES (73, 8, 8, '2026-09-06 05:35:56');
INSERT INTO `favorite` VALUES (74, 7, 8, '2026-09-06 02:35:56');
INSERT INTO `favorite` VALUES (75, 6, 8, '2026-09-07 09:35:56');
INSERT INTO `favorite` VALUES (76, 5, 8, '2026-09-06 01:35:56');
INSERT INTO `favorite` VALUES (77, 4, 8, '2026-09-07 20:35:56');
INSERT INTO `favorite` VALUES (78, 3, 8, '2026-09-08 10:35:56');
INSERT INTO `favorite` VALUES (79, 2, 8, '2026-09-05 22:35:56');
INSERT INTO `favorite` VALUES (80, 1, 8, '2026-09-08 09:35:56');
INSERT INTO `favorite` VALUES (81, 10, 9, '2026-09-07 03:35:56');
INSERT INTO `favorite` VALUES (82, 9, 9, '2026-09-06 04:35:56');
INSERT INTO `favorite` VALUES (83, 8, 9, '2026-09-05 02:35:56');
INSERT INTO `favorite` VALUES (84, 7, 9, '2026-09-06 17:35:56');
INSERT INTO `favorite` VALUES (85, 6, 9, '2026-09-05 16:35:56');
INSERT INTO `favorite` VALUES (86, 5, 9, '2026-09-07 23:35:56');
INSERT INTO `favorite` VALUES (87, 4, 9, '2026-09-06 01:35:56');
INSERT INTO `favorite` VALUES (88, 3, 9, '2026-09-06 01:35:56');
INSERT INTO `favorite` VALUES (89, 2, 9, '2026-09-07 19:35:56');
INSERT INTO `favorite` VALUES (90, 1, 9, '2026-09-08 03:35:56');
INSERT INTO `favorite` VALUES (91, 10, 10, '2026-09-04 12:35:56');
INSERT INTO `favorite` VALUES (92, 9, 10, '2026-09-06 08:35:56');
INSERT INTO `favorite` VALUES (93, 8, 10, '2026-09-05 09:35:56');
INSERT INTO `favorite` VALUES (94, 7, 10, '2026-09-07 20:35:56');
INSERT INTO `favorite` VALUES (95, 6, 10, '2026-09-06 03:35:56');
INSERT INTO `favorite` VALUES (96, 5, 10, '2026-09-07 00:35:56');
INSERT INTO `favorite` VALUES (97, 4, 10, '2026-09-08 01:35:56');
INSERT INTO `favorite` VALUES (98, 3, 10, '2026-09-06 12:35:56');
INSERT INTO `favorite` VALUES (99, 2, 10, '2026-09-08 06:35:56');
INSERT INTO `favorite` VALUES (100, 1, 10, '2026-09-04 20:35:56');
INSERT INTO `favorite` VALUES (101, 10, 11, '2026-09-07 14:35:56');
INSERT INTO `favorite` VALUES (102, 9, 11, '2026-09-06 13:35:56');
INSERT INTO `favorite` VALUES (103, 8, 11, '2026-09-05 14:35:56');
INSERT INTO `favorite` VALUES (104, 7, 11, '2026-09-08 02:35:56');
INSERT INTO `favorite` VALUES (105, 6, 11, '2026-09-06 20:35:56');
INSERT INTO `favorite` VALUES (106, 5, 11, '2026-09-05 14:35:56');
INSERT INTO `favorite` VALUES (107, 4, 11, '2026-09-07 05:35:56');
INSERT INTO `favorite` VALUES (108, 3, 11, '2026-09-06 14:35:56');
INSERT INTO `favorite` VALUES (109, 2, 11, '2026-09-07 01:35:56');
INSERT INTO `favorite` VALUES (110, 1, 11, '2026-09-06 19:35:56');
INSERT INTO `favorite` VALUES (111, 10, 12, '2026-09-04 11:35:56');
INSERT INTO `favorite` VALUES (112, 9, 12, '2026-09-05 18:35:56');
INSERT INTO `favorite` VALUES (113, 8, 12, '2026-09-06 23:35:56');
INSERT INTO `favorite` VALUES (114, 7, 12, '2026-09-04 18:35:56');
INSERT INTO `favorite` VALUES (115, 6, 12, '2026-09-06 22:35:56');
INSERT INTO `favorite` VALUES (116, 5, 12, '2026-09-07 17:35:56');
INSERT INTO `favorite` VALUES (117, 4, 12, '2026-09-05 02:35:56');
INSERT INTO `favorite` VALUES (118, 3, 12, '2026-09-06 06:35:56');
INSERT INTO `favorite` VALUES (119, 2, 12, '2026-09-07 12:35:56');
INSERT INTO `favorite` VALUES (120, 1, 12, '2026-09-06 03:35:56');
INSERT INTO `favorite` VALUES (121, 10, 13, '2026-09-07 20:35:56');
INSERT INTO `favorite` VALUES (122, 9, 13, '2026-09-08 03:35:56');
INSERT INTO `favorite` VALUES (123, 8, 13, '2026-09-04 09:35:56');
INSERT INTO `favorite` VALUES (124, 7, 13, '2026-09-05 17:35:56');
INSERT INTO `favorite` VALUES (125, 6, 13, '2026-09-06 23:35:56');
INSERT INTO `favorite` VALUES (126, 5, 13, '2026-09-04 21:35:56');
INSERT INTO `favorite` VALUES (127, 4, 13, '2026-09-07 12:35:56');
INSERT INTO `favorite` VALUES (128, 3, 13, '2026-09-06 00:35:56');
INSERT INTO `favorite` VALUES (129, 2, 13, '2026-09-07 06:35:56');
INSERT INTO `favorite` VALUES (130, 1, 13, '2026-09-05 16:35:56');
INSERT INTO `favorite` VALUES (131, 10, 14, '2026-09-06 09:35:56');
INSERT INTO `favorite` VALUES (132, 9, 14, '2026-09-06 07:35:56');
INSERT INTO `favorite` VALUES (133, 8, 14, '2026-09-08 02:35:56');
INSERT INTO `favorite` VALUES (134, 7, 14, '2026-09-04 17:35:56');
INSERT INTO `favorite` VALUES (135, 6, 14, '2026-09-07 08:35:56');
INSERT INTO `favorite` VALUES (136, 5, 14, '2026-09-05 16:35:56');
INSERT INTO `favorite` VALUES (137, 4, 14, '2026-09-06 04:35:56');
INSERT INTO `favorite` VALUES (138, 3, 14, '2026-09-05 10:35:56');
INSERT INTO `favorite` VALUES (139, 2, 14, '2026-09-08 06:35:56');
INSERT INTO `favorite` VALUES (140, 1, 14, '2026-09-08 05:35:56');
INSERT INTO `favorite` VALUES (141, 10, 15, '2026-09-07 18:35:56');
INSERT INTO `favorite` VALUES (142, 9, 15, '2026-09-05 16:35:56');
INSERT INTO `favorite` VALUES (143, 8, 15, '2026-09-04 19:35:56');
INSERT INTO `favorite` VALUES (144, 7, 15, '2026-09-06 19:35:56');
INSERT INTO `favorite` VALUES (145, 6, 15, '2026-09-06 23:35:56');
INSERT INTO `favorite` VALUES (146, 5, 15, '2026-09-05 23:35:56');
INSERT INTO `favorite` VALUES (147, 4, 15, '2026-09-04 11:35:56');
INSERT INTO `favorite` VALUES (148, 3, 15, '2026-09-08 09:35:56');
INSERT INTO `favorite` VALUES (149, 2, 15, '2026-09-07 13:35:56');
INSERT INTO `favorite` VALUES (150, 1, 15, '2026-09-08 05:35:56');
INSERT INTO `favorite` VALUES (151, 10, 16, '2026-09-05 16:35:56');
INSERT INTO `favorite` VALUES (152, 9, 16, '2026-09-07 19:35:56');
INSERT INTO `favorite` VALUES (153, 8, 16, '2026-09-05 00:35:56');
INSERT INTO `favorite` VALUES (154, 7, 16, '2026-09-05 17:35:56');
INSERT INTO `favorite` VALUES (155, 6, 16, '2026-09-04 23:35:56');
INSERT INTO `favorite` VALUES (156, 5, 16, '2026-09-07 11:35:56');
INSERT INTO `favorite` VALUES (157, 4, 16, '2026-09-05 13:35:56');
INSERT INTO `favorite` VALUES (158, 3, 16, '2026-09-05 03:35:56');
INSERT INTO `favorite` VALUES (159, 2, 16, '2026-09-04 15:35:56');
INSERT INTO `favorite` VALUES (160, 1, 16, '2026-09-07 15:35:56');
INSERT INTO `favorite` VALUES (161, 10, 17, '2026-09-07 09:35:56');
INSERT INTO `favorite` VALUES (162, 9, 17, '2026-09-05 13:35:56');
INSERT INTO `favorite` VALUES (163, 8, 17, '2026-09-05 09:35:56');
INSERT INTO `favorite` VALUES (164, 7, 17, '2026-09-05 19:35:56');
INSERT INTO `favorite` VALUES (165, 6, 17, '2026-09-04 11:35:56');
INSERT INTO `favorite` VALUES (166, 5, 17, '2026-09-04 16:35:56');
INSERT INTO `favorite` VALUES (167, 4, 17, '2026-09-05 14:35:56');
INSERT INTO `favorite` VALUES (168, 3, 17, '2026-09-05 12:35:56');
INSERT INTO `favorite` VALUES (169, 2, 17, '2026-09-06 07:35:56');
INSERT INTO `favorite` VALUES (170, 1, 17, '2026-09-06 09:35:56');
INSERT INTO `favorite` VALUES (171, 10, 18, '2026-09-04 15:35:56');
INSERT INTO `favorite` VALUES (172, 9, 18, '2026-09-07 22:35:56');
INSERT INTO `favorite` VALUES (173, 8, 18, '2026-09-04 18:35:56');
INSERT INTO `favorite` VALUES (174, 7, 18, '2026-09-08 02:35:56');
INSERT INTO `favorite` VALUES (175, 6, 18, '2026-09-05 02:35:56');
INSERT INTO `favorite` VALUES (176, 5, 18, '2026-09-05 05:35:56');
INSERT INTO `favorite` VALUES (177, 4, 18, '2026-09-06 11:35:56');
INSERT INTO `favorite` VALUES (178, 3, 18, '2026-09-08 05:35:56');
INSERT INTO `favorite` VALUES (179, 2, 18, '2026-09-04 18:35:56');
INSERT INTO `favorite` VALUES (180, 1, 18, '2026-09-07 07:35:56');
INSERT INTO `favorite` VALUES (181, 10, 19, '2026-09-05 07:35:56');
INSERT INTO `favorite` VALUES (182, 9, 19, '2026-09-04 09:35:56');
INSERT INTO `favorite` VALUES (183, 8, 19, '2026-09-05 21:35:56');
INSERT INTO `favorite` VALUES (184, 7, 19, '2026-09-07 16:35:56');
INSERT INTO `favorite` VALUES (185, 6, 19, '2026-09-08 01:35:56');
INSERT INTO `favorite` VALUES (186, 5, 19, '2026-09-04 14:35:56');
INSERT INTO `favorite` VALUES (187, 4, 19, '2026-09-06 23:35:56');
INSERT INTO `favorite` VALUES (188, 3, 19, '2026-09-08 08:35:56');
INSERT INTO `favorite` VALUES (189, 2, 19, '2026-09-08 00:35:56');
INSERT INTO `favorite` VALUES (190, 1, 19, '2026-09-06 14:35:56');
INSERT INTO `favorite` VALUES (191, 10, 20, '2026-09-04 12:35:56');
INSERT INTO `favorite` VALUES (192, 9, 20, '2026-09-06 20:35:56');
INSERT INTO `favorite` VALUES (193, 8, 20, '2026-09-07 21:35:56');
INSERT INTO `favorite` VALUES (194, 7, 20, '2026-09-06 06:35:56');
INSERT INTO `favorite` VALUES (195, 6, 20, '2026-09-07 11:35:56');
INSERT INTO `favorite` VALUES (196, 5, 20, '2026-09-05 20:35:56');
INSERT INTO `favorite` VALUES (197, 4, 20, '2026-09-06 13:35:56');
INSERT INTO `favorite` VALUES (198, 3, 20, '2026-09-06 16:35:56');
INSERT INTO `favorite` VALUES (199, 2, 20, '2026-09-05 05:35:56');
INSERT INTO `favorite` VALUES (200, 1, 20, '2026-09-05 22:35:56');

-- ----------------------------
-- Table structure for goods
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods`  (
  `goods_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL COMMENT '自增主键',
  `cate_id` int NULL DEFAULT NULL COMMENT '自增主键',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `sell_price` decimal(10, 2) NOT NULL,
  `original_price` decimal(10, 2) NULL DEFAULT NULL,
  `trade_method` smallint NOT NULL COMMENT '1邮寄\r\n            2自提\r\n            3两者',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文本描述',
  `quality` smallint NULL DEFAULT NULL COMMENT '1-5表示新旧程度',
  `reject_reason` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `publish_time` datetime NULL DEFAULT NULL,
  `goods_status` smallint NOT NULL COMMENT '0待审核\r\n            1上架\r\n            2下架\r\n            3出售\r\n            4驳回',
  PRIMARY KEY (`goods_id`) USING BTREE,
  INDEX `FK_rel_user_publish_goods`(`user_id` ASC) USING BTREE,
  INDEX `idx_goods_status_cate_time`(`cate_id` ASC, `publish_time` ASC, `goods_status` ASC) USING BTREE,
  CONSTRAINT `FK_rel_category_include_goods` FOREIGN KEY (`cate_id`) REFERENCES `category` (`cate_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_rel_user_publish_goods` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_goods_original_price` CHECK (`original_price` >= 0),
  CONSTRAINT `chk_goods_sell_price` CHECK (`sell_price` >= 0),
  CONSTRAINT `chk_goods_status` CHECK (`goods_status` between 0 and 4)
) ENGINE = InnoDB AUTO_INCREMENT = 201 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goods
-- ----------------------------
INSERT INTO `goods` VALUES (1, 56, 3, 'Pluots core', 337.24, 99.21, 3, 'It can also manage cloud databases such as Amazon Redshift, Amazon RDS, Alibaba Cloud. Features in Navicat are sophisticated enough to provide professional developers for all their specific needs, yet easy to learn for users who are new to database server. Actually it is just in an                  ', 2, 'jrrUN6z8rr', '2016-03-14 12:15:15', 1);
INSERT INTO `goods` VALUES (2, 80, 2, 'Strawberry', 331.69, 365.84, 3, 'Navicat allows you to transfer data from one database and/or schema to another with detailed analytical process.', 4, NULL, '2005-11-11 18:54:52', 1);
INSERT INTO `goods` VALUES (3, 73, 6, 'Raspbjrry', 668.23, 997.77, 1, 'Champions keep playing until they get it right. Anyone who has ever made anything of importance was disciplined. The Information Pane shows the detailed object information, project activities, the DDL of database objects, object dependencies, membership of users/roles and preview.', 2, 'PwxnZe3qEw', '2011-07-26 08:43:22', 4);
INSERT INTO `goods` VALUES (4, 90, 1, 'Raspberry pro', 201.18, 760.13, 3, 'How we spend our days is, of course, how we spend our lives. Anyone who has ever made anything of importance was disciplined. Import Wizard allows you to import data to tables/collections from CSV, TXT, XML, DBF and more.', 1, '8HXB0SxJEo', '2021-04-20 15:26:46', 1);
INSERT INTO `goods` VALUES (5, 84, 2, 'Cherry core', 243.68, 635.29, 2, 'Always keep your eyes open. Keep watching. Because whatever you see can inspire you. You must be the change you wish to see in the world. The Information Pane shows the detailed object information, project activities, the DDL of database objects, object dependencies, membership of                   ', 1, 'X6hKxSfLAu', '2022-04-27 22:26:28', 3);
INSERT INTO `goods` VALUES (6, 4, 4, 'Cherry mini', 511.09, 182.78, 3, 'The repository database can be an existing MySQL, MariaDB, PostgreSQL, SQL Server, or Amazon RDS instance. All the Navicat Cloud objects are located under different projects. You can share the project to other Navicat Cloud accounts for collaboration.', 1, '7firezITiQ', '2021-05-08 08:05:58', 1);
INSERT INTO `goods` VALUES (7, 64, 3, 'Orange pro', 350.45, 403.05, 1, 'To get a secure connection, the first thing you need to do is to install OpenSSL Library and download Database Source.', 4, 'MsrBYjMV97', '2015-03-31 22:04:05', 1);
INSERT INTO `goods` VALUES (8, 69, 6, 'erape', 687.12, 615.68, 2, 'Secure SHell (SSH) is a program to log in into another computer over a network, execute commands on a remote server, and move files from one machine to another. Anyone who has never made a mistake has never tried anything new. A comfort zone is a beautiful place, but nothing ever grows there.', 2, 'UUtLeIxUCW', '2012-05-26 17:58:45', 1);
INSERT INTO `goods` VALUES (9, 77, 1, 'Grape', 981.73, 724.21, 1, 'Navicat provides a wide range advanced features, such as compelling code editing capabilities, smart code-completion, SQL formatting, and more.', 5, NULL, '2011-07-06 04:01:15', 3);
INSERT INTO `goods` VALUES (10, 51, 4, 'ambi-Orange', 378.22, 196.52, 1, 'I may not have gone where I intended to go, but I think I have ended up where I needed to be. Navicat Cloud could not connect and access your databases. By which it means, it could only store your connection settings, queries, model files, and virtual group; your database passwords                  ', 3, '3XTjG3nKZR', '2003-08-16 09:51:10', 1);
INSERT INTO `goods` VALUES (11, 19, 1, 'xMbngo', 990.77, 697.50, 3, 'It collects process metrics such as CPU load, RAM usage, and a variety of other resources over SSH/SNMP. To clear or reload various internal caches, flush tables, or acquire locks, control-click your connection in the Navigation pane and select Flush and choose the flush option. You                 ', 4, '8bnmmWJMqh', '2004-11-15 23:45:07', 1);
INSERT INTO `goods` VALUES (12, 7, 1, 'omni-Pluots', 335.51, 623.97, 3, 'To open a query using an external editor, control-click it and select Open with External Editor. You can set the file path of an external editor in Preferences. Actually it is just in an idea when feel oneself can achieve and cannot achieve. A man’s best friends are his ten fingers.', 3, 'NMBjxUtybD', '2007-01-27 14:49:33', 1);
INSERT INTO `goods` VALUES (13, 61, 6, 'Cherry air', 98.58, 228.64, 3, 'It wasn’t raining when Noah built the ark. Navicat is a multi-connections Database Administration tool allowing you to connect to MySQL, Oracle, PostgreSQL, SQLite, SQL Server, MariaDB and/or MongoDB databases, making database administration to multiple kinds of database so easy.', 4, 'OzQs3Ih9AC', '2022-06-04 02:20:53', 1);
INSERT INTO `goods` VALUES (14, 72, 1, 'Grdpe pro', 673.91, 770.50, 2, 'I destroy my enemies when I make them my friends. Flexible settings enable you to set up a custom key for comparison and synchronization. Monitored servers include MySQL, MariaDB and SQL Server, and compatible with cloud databases like Amazon RDS, Amazon Aurora, Oracle Cloud, Google                 ', 5, '0JYkhbOkAW', '2022-10-26 18:40:18', 3);
INSERT INTO `goods` VALUES (15, 10, 5, 'Orange', 914.86, 529.23, 3, 'SSH serves to prevent such vulnerabilities and allows you to access a remote server\'s shell without compromising security. Success consists of going from failure to failure without loss of enthusiasm.', 3, 'n2vbdzDA7t', '2017-10-07 07:40:37', 1);
INSERT INTO `goods` VALUES (16, 29, 2, 'Pluots', 19.14, 447.80, 3, 'Import Wizard allows you to import data to tables/collections from CSV, TXT, XML, DBF and more. Success consists of going from failure to failure without loss of enthusiasm.', 4, 'Jd3JXJVT8G', '2019-05-22 20:00:33', 1);
INSERT INTO `goods` VALUES (17, 41, 3, 'Rambucan premium', 496.58, 494.29, 2, 'To connect to a database or schema, simply double-click it in the pane. Navicat Monitor is a safe, simple and agentless remote server monitoring tool that is packed with powerful features to make your monitoring effective as possible.', 3, 'f07CtuC3R5', '2008-06-15 22:47:31', 3);
INSERT INTO `goods` VALUES (18, 94, 5, 'Kiwi', 68.49, 299.76, 3, 'The Navigation pane employs tree structure which allows you to take action upon the database and their objects through their pop-up menus quickly and easily. Such sessions are also susceptible to session hijacking, where a malicious user takes over your session once you have authenticated.', 4, 'y5HNxWpa7X', '2019-08-18 05:26:05', 3);
INSERT INTO `goods` VALUES (19, 20, 5, 'iApple', 878.74, 583.62, 1, 'I destroy my enemies when I make them my friends. SQL Editor allows you to create and edit SQL text, prepare and execute selected queries. How we spend our days is, of course, how we spend our lives. Export Wizard allows you to export data from tables, collections, views, or query                   ', 1, 'euk1bxABLU', '2002-09-20 09:37:59', 1);
INSERT INTO `goods` VALUES (20, 60, 3, 'Apple premium', 901.34, 11.98, 1, 'It wasn’t raining when Noah built the ark. Champions keep playing until they get it right. A query is used to extract data from the database in a readable format according to the user\'s request.', 2, 'Qz80pMHSTn', '2010-09-17 19:42:01', 1);
INSERT INTO `goods` VALUES (21, 74, 6, 'ambi-Plurts', 708.70, 304.59, 1, 'Sometimes you win, sometimes you learn. All journeys have secret destinations of which the traveler is unaware. After comparing data, the window shows the number of records that will be inserted, updated or deleted in the target.', 2, 'Enof2V7p1G', '2025-09-01 10:06:45', 1);
INSERT INTO `goods` VALUES (22, 53, 3, 'Raspberry', 942.02, 908.08, 1, 'The Synchronize to Database function will give you a full picture of all database differences. Navicat Monitor is a safe, simple and agentless remote server monitoring tool that is packed with powerful features to make your monitoring effective as possible. Navicat is a multi-connections            ', 2, 'ziDWSSAaxr', '2024-07-09 07:03:53', 1);
INSERT INTO `goods` VALUES (23, 62, 4, 'Raspbsrry', 661.91, 350.90, 1, 'It wasn’t raining when Noah built the ark. Always keep your eyes open. Keep watching. Because whatever you see can inspire you. It can also manage cloud databases such as Amazon Redshift, Amazon RDS, Alibaba Cloud. Features in Navicat are sophisticated enough to provide professional               ', 4, 'TDjeWIoT4I', '2017-08-22 18:56:48', 3);
INSERT INTO `goods` VALUES (24, 90, 5, 'Mango core', 824.24, 12.36, 2, 'A comfort zone is a beautiful place, but nothing ever grows there. Navicat Monitor requires a repository to store alerts and metrics for historical analysis.', 3, NULL, '2017-06-25 17:38:22', 1);
INSERT INTO `goods` VALUES (25, 6, 1, 'Kiwi', 774.87, 33.11, 2, 'In other words, Navicat provides the ability for data in different databases and/or schemas to be kept up-to-date so that each repository contains the same information. Secure SHell (SSH) is a program to log in into another computer over a network, execute commands on a remote server,               ', 3, 'cSNvTtn3QL', '2002-11-17 11:05:38', 3);
INSERT INTO `goods` VALUES (26, 1, 3, 'Cherwy', 974.63, 191.08, 2, 'After logged in the Navicat Cloud feature, the Navigation pane will be divided into Navicat Cloud and My Connections sections. You cannot save people, you can just love them.', 1, 'mKpg0noRZP', '2005-02-19 16:56:49', 3);
INSERT INTO `goods` VALUES (27, 9, 4, 'xRambutan', 987.42, 294.91, 2, 'Sometimes you win, sometimes you learn. Flexible settings enable you to set up a custom key for comparison and synchronization. Navicat Data Modeler is a powerful and cost-effective database design tool which helps you build high-quality conceptual, logical and physical data models.', 2, 'nxRHmZ5Ym1', '2005-10-18 04:43:02', 1);
INSERT INTO `goods` VALUES (28, 2, 1, 'iRambbtan', 408.53, 844.96, 2, 'The reason why a great man is great is that he resolves to be a great man. If the plan doesn’t work, change the plan, but never the goal. With its well-designed Graphical User Interface(GUI), Navicat lets you quickly and easily create, organize, access and share information in a                   ', 4, 'WZjsuSW6SV', '2000-07-11 19:49:50', 3);
INSERT INTO `goods` VALUES (29, 78, 6, 'Appre', 800.47, 125.04, 1, 'The Information Pane shows the detailed object information, project activities, the DDL of database objects, object dependencies, membership of users/roles and preview. Typically, it is employed as an encrypted version of Telnet.', 4, '1Gf3Z2Z8me', '2022-04-23 05:08:38', 1);
INSERT INTO `goods` VALUES (30, 80, 3, 'Orange', 932.46, 318.65, 1, 'Navicat Data Modeler enables you to build high-quality conceptual, logical and physical data models for a wide variety of audiences.', 1, '4q319tBsds', '2012-01-21 01:38:20', 1);
INSERT INTO `goods` VALUES (31, 86, 1, 'Apple', 148.09, 274.00, 1, 'If you wait, all that happens is you get older. It collects process metrics such as CPU load, RAM usage, and a variety of other resources over SSH/SNMP. In other words, Navicat provides the ability for data in different databases and/or schemas to be kept up-to-date so that each repository          ', 3, 'zTtqlnVmRO', '2020-02-15 02:46:12', 1);
INSERT INTO `goods` VALUES (32, 70, 4, 'tambutan', 11.20, 821.44, 2, 'What you get by achieving your goals is not as important as what you become by achieving your goals. Creativity is intelligence having fun. To connect to a database or schema, simply double-click it in the pane. Optimism is the one quality more associated with success and happiness than any other.', 3, '1PNVIIiRDP', '2009-04-25 03:34:47', 1);
INSERT INTO `goods` VALUES (33, 95, 2, 'ultra-Strawberry', 674.69, 559.76, 1, 'It provides strong authentication and secure encrypted communications between two hosts, known as SSH Port Forwarding (Tunneling), over an insecure network. Instead of wondering when your next vacation is, maybe you should set up a life you don’t need to escape from.', 2, 'HWpFfzAUVp', '2023-02-11 08:02:34', 1);
INSERT INTO `goods` VALUES (34, 31, 1, 'ziwi', 128.61, 571.60, 1, 'The Main Window consists of several toolbars and panes for you to work on connections, database objects and advanced tools. To start working with your server in Navicat, you should first establish a connection or several connections using the Connection window.', 4, 'Ig0h5s9IjH', '2013-09-10 22:37:21', 1);
INSERT INTO `goods` VALUES (35, 60, 5, 'Pluots', 789.41, 374.51, 1, 'If the plan doesn’t work, change the plan, but never the goal. A man’s best friends are his ten fingers. I will greet this day with love in my heart. Export Wizard allows you to export data from tables, collections, views, or query results to any available formats.', 2, 'qYXAufVGkn', '2010-04-16 07:05:37', 1);
INSERT INTO `goods` VALUES (36, 47, 3, 'xCgerry', 874.70, 214.97, 2, 'Anyone who has ever made anything of importance was disciplined. Navicat Data Modeler is a powerful and cost-effective database design tool which helps you build high-quality conceptual, logical and physical data models.', 4, 'naUEN3DqoD', '2025-02-09 08:27:02', 1);
INSERT INTO `goods` VALUES (37, 17, 2, 'Gvape', 715.54, 520.01, 3, 'To successfully establish a new connection to local/remote server - no matter via SSL or SSH, set the database login information in the General tab. Navicat allows you to transfer data from one database and/or schema to another with detailed analytical process.', 2, 'fCKe6VYHS3', '2026-07-17 16:19:15', 1);
INSERT INTO `goods` VALUES (38, 86, 2, 'Kiwi pro', 30.63, 48.91, 3, 'Navicat provides a wide range advanced features, such as compelling code editing capabilities, smart code-completion, SQL formatting, and more. Remember that failure is an event, not a person.', 4, 'ssz5wYNnsK', '2012-01-20 14:54:27', 4);
INSERT INTO `goods` VALUES (39, 91, 2, 'omni-Oranxe', 503.83, 770.32, 3, 'HTTP Tunneling is a method for connecting to a server that uses the same protocol (http://) and the same port (port 80) as a web server does. To open a query using an external editor, control-click it and select Open with External Editor. You can set the file path of an external editor              ', 3, '1fJLG2iRtM', '2013-10-03 06:03:29', 1);
INSERT INTO `goods` VALUES (40, 33, 3, 'ultra-Strawberry', 332.58, 417.85, 3, 'Export Wizard allows you to export data from tables, collections, views, or query results to any available formats. If the plan doesn’t work, change the plan, but never the goal. To open a query using an external editor, control-click it and select Open with External Editor. You                   ', 3, 'ijjAiXSvxR', '2004-06-03 19:50:20', 0);
INSERT INTO `goods` VALUES (41, 79, 5, 'Raspgerry', 175.78, 399.67, 2, 'It collects process metrics such as CPU load, RAM usage, and a variety of other resources over SSH/SNMP. In other words, Navicat provides the ability for data in different databases and/or schemas to be kept up-to-date so that each repository contains the same information.', 1, 'xuKgPAqqSt', '2021-11-10 00:57:50', 3);
INSERT INTO `goods` VALUES (42, 41, 2, 'Grape', 444.62, 839.46, 2, 'After logged in the Navicat Cloud feature, the Navigation pane will be divided into Navicat Cloud and My Connections sections. Navicat Cloud could not connect and access your databases. By which it means, it could only store your connection settings, queries, model files, and virtual                ', 5, '6CntnC5swG', '2001-07-18 04:17:37', 1);
INSERT INTO `goods` VALUES (43, 49, 6, 'Rambutan pi', 35.12, 786.93, 2, 'To clear or reload various internal caches, flush tables, or acquire locks, control-click your connection in the Navigation pane and select Flush and choose the flush option. You must have the reload privilege to use this feature. SSH serves to prevent such vulnerabilities and allows                ', 5, 'wjT41CwvgF', '2009-02-20 03:58:40', 1);
INSERT INTO `goods` VALUES (44, 6, 2, 'Orange', 372.47, 237.36, 1, 'Navicat Cloud provides a cloud service for synchronizing connections, queries, model files and virtual group information from Navicat, other Navicat family members, different machines and different platforms.', 2, '2dBjz8h6Ul', '2001-07-01 03:41:40', 3);
INSERT INTO `goods` VALUES (45, 95, 6, 'Kiwi premium', 973.29, 896.97, 1, 'The On Startup feature allows you to control what tabs appear when you launch Navicat. Difficult circumstances serve as a textbook of life for people.', 4, NULL, '2004-12-19 15:42:18', 0);
INSERT INTO `goods` VALUES (46, 64, 2, 'Oraage plus', 538.05, 117.92, 3, 'SQL Editor allows you to create and edit SQL text, prepare and execute selected queries. Always keep your eyes open. Keep watching. Because whatever you see can inspire you. Difficult circumstances serve as a textbook of life for people. Genius is an infinite capacity for taking pains.', 3, 'sbLcEH3cH4', '2004-05-25 05:54:57', 1);
INSERT INTO `goods` VALUES (47, 44, 3, 'Strawbetry', 226.23, 16.36, 1, 'Genius is an infinite capacity for taking pains. A man is not old until regrets take the place of dreams. Success consists of going from failure to failure without loss of enthusiasm.', 1, 'AytHoEFP1x', '2023-02-09 09:56:56', 3);
INSERT INTO `goods` VALUES (48, 30, 4, 'Grape', 145.17, 884.22, 2, 'Success consists of going from failure to failure without loss of enthusiasm. Champions keep playing until they get it right.', 4, '2iHGfIAQre', '2024-06-25 21:58:09', 4);
INSERT INTO `goods` VALUES (49, 86, 4, 'Apple', 687.23, 993.69, 3, 'If opportunity doesn’t knock, build a door. It can also manage cloud databases such as Amazon Redshift, Amazon RDS, Alibaba Cloud. Features in Navicat are sophisticated enough to provide professional developers for all their specific needs, yet easy to learn for users who are new                  ', 4, 'j2i9HZDIRl', '2026-03-14 01:30:22', 1);
INSERT INTO `goods` VALUES (50, 11, 5, 'Raspberry plus', 496.07, 613.29, 2, 'The Main Window consists of several toolbars and panes for you to work on connections, database objects and advanced tools.', 1, 'HMNCnixy40', '2024-02-01 15:32:49', 0);
INSERT INTO `goods` VALUES (51, 84, 4, 'frape', 936.69, 481.51, 2, 'I may not have gone where I intended to go, but I think I have ended up where I needed to be. If your Internet Service Provider (ISP) does not provide direct access to its server, Secure Tunneling Protocol (SSH) / HTTP is another solution. Actually it is just in an idea when feel                    ', 2, 'hD7mvCNZMA', '2004-08-26 18:35:56', 1);
INSERT INTO `goods` VALUES (52, 19, 2, 'ambi-Raspbercy', 445.55, 243.33, 2, 'Navicat 15 has added support for the system-wide dark mode. Navicat Data Modeler enables you to build high-quality conceptual, logical and physical data models for a wide variety of audiences. A man’s best friends are his ten fingers.', 1, NULL, '2001-05-02 18:53:06', 3);
INSERT INTO `goods` VALUES (53, 74, 5, 'omni-fango', 822.44, 219.87, 1, 'It wasn’t raining when Noah built the ark. Navicat Data Modeler is a powerful and cost-effective database design tool which helps you build high-quality conceptual, logical and physical data models. The Synchronize to Database function will give you a full picture of all database differences.', 4, 'Sg7fHORGcF', '2026-04-16 06:03:41', 3);
INSERT INTO `goods` VALUES (54, 58, 3, 'Cheiry se', 252.88, 884.42, 3, 'A man is not old until regrets take the place of dreams. It wasn’t raining when Noah built the ark. Anyone who has never made a mistake has never tried anything new. It is used while your ISPs do not allow direct connections, but allows establishing HTTP connections.', 2, 'xpQ7DprRLK', '2023-11-13 01:39:11', 1);
INSERT INTO `goods` VALUES (55, 68, 6, 'Cherry pi', 140.85, 859.74, 1, 'After comparing data, the window shows the number of records that will be inserted, updated or deleted in the target. It can also manage cloud databases such as Amazon Redshift, Amazon RDS, Alibaba Cloud. Features in Navicat are sophisticated enough to provide professional developers                ', 2, 'Bg5QqqkRDG', '2011-11-19 14:55:53', 0);
INSERT INTO `goods` VALUES (56, 7, 5, 'Pluots', 635.95, 68.90, 2, 'Secure SHell (SSH) is a program to log in into another computer over a network, execute commands on a remote server, and move files from one machine to another.', 4, 'Nj7M5pGMwc', '2023-06-22 20:42:42', 1);
INSERT INTO `goods` VALUES (57, 19, 1, 'Raspberry air', 741.09, 999.21, 2, 'If your Internet Service Provider (ISP) does not provide direct access to its server, Secure Tunneling Protocol (SSH) / HTTP is another solution. Optimism is the one quality more associated with success and happiness than any other.', 2, 'q4wzk96HI9', '2001-03-24 01:28:16', 3);
INSERT INTO `goods` VALUES (58, 67, 3, 'Pluots mini', 981.68, 797.88, 1, 'Export Wizard allows you to export data from tables, collections, views, or query results to any available formats. After comparing data, the window shows the number of records that will be inserted, updated or deleted in the target.', 2, 'wBo7Rf29BJ', '2006-12-29 22:00:46', 4);
INSERT INTO `goods` VALUES (59, 7, 2, 'Grape', 241.16, 657.19, 2, 'If the plan doesn’t work, change the plan, but never the goal. You will succeed because most people are lazy. To get a secure connection, the first thing you need to do is to install OpenSSL Library and download Database Source.', 5, 'Vesb1wDW69', '2023-06-10 03:17:29', 3);
INSERT INTO `goods` VALUES (60, 22, 4, 'Rambutan elite', 744.31, 161.96, 3, 'Navicat Data Modeler is a powerful and cost-effective database design tool which helps you build high-quality conceptual, logical and physical data models. If opportunity doesn’t knock, build a door. SSH serves to prevent such vulnerabilities and allows you to access a remote server\'s             ', 3, 'mhpOVDjdWG', '2004-12-04 00:03:18', 1);
INSERT INTO `goods` VALUES (61, 82, 6, 'Mango', 584.24, 658.50, 2, 'Anyone who has ever made anything of importance was disciplined. Navicat Monitor is a safe, simple and agentless remote server monitoring tool that is packed with powerful features to make your monitoring effective as possible. Navicat provides a wide range advanced features, such                   ', 3, 'ubDjzKQQlb', '2013-04-06 11:39:23', 1);
INSERT INTO `goods` VALUES (62, 3, 4, 'xrape', 86.25, 504.06, 2, 'Typically, it is employed as an encrypted version of Telnet. It wasn’t raining when Noah built the ark. Navicat is a multi-connections Database Administration tool allowing you to connect to MySQL, Oracle, PostgreSQL, SQLite, SQL Server, MariaDB and/or MongoDB databases, making                    ', 3, '8jiNZznTtr', '2003-10-11 19:10:05', 1);
INSERT INTO `goods` VALUES (63, 35, 1, 'Strawbervy', 572.20, 123.74, 3, 'Navicat Cloud provides a cloud service for synchronizing connections, queries, model files and virtual group information from Navicat, other Navicat family members, different machines and different platforms.', 4, 'bc2vDarMKB', '2004-12-15 19:56:02', 1);
INSERT INTO `goods` VALUES (64, 4, 6, 'Pluots', 893.94, 586.30, 2, 'There is no way to happiness. Happiness is the way. There is no way to happiness. Happiness is the way. With its well-designed Graphical User Interface(GUI), Navicat lets you quickly and easily create, organize, access and share information in a secure and easy way. The Information                  ', 5, 'rECLGvBj2R', '2000-09-18 04:29:02', 1);
INSERT INTO `goods` VALUES (65, 45, 5, 'Mango premium', 823.80, 979.88, 2, 'To clear or reload various internal caches, flush tables, or acquire locks, control-click your connection in the Navigation pane and select Flush and choose the flush option. You must have the reload privilege to use this feature.', 2, '7lCwzCrz2J', '2008-01-01 20:54:28', 1);
INSERT INTO `goods` VALUES (66, 10, 2, 'Raspberky', 290.73, 272.29, 1, 'In a Telnet session, all communications, including username and password, are transmitted in plain-text, allowing anyone to listen-in on your session and steal passwords and other information. Secure Sockets Layer(SSL) is a protocol for transmitting private documents via the Internet.', 4, 'KLOUqge66F', '2002-06-11 08:11:25', 1);
INSERT INTO `goods` VALUES (67, 88, 6, 'Cherry plus', 148.68, 706.20, 2, 'There is no way to happiness. Happiness is the way. Navicat Data Modeler enables you to build high-quality conceptual, logical and physical data models for a wide variety of audiences. To connect to a database or schema, simply double-click it in the pane. The repository database                    ', 5, '6xzFsQcBS6', '2015-01-15 23:55:42', 1);
INSERT INTO `goods` VALUES (68, 35, 4, 'Strawbrrry', 323.41, 88.41, 2, 'It wasn’t raining when Noah built the ark. A comfort zone is a beautiful place, but nothing ever grows there. Monitored servers include MySQL, MariaDB and SQL Server, and compatible with cloud databases like Amazon RDS, Amazon Aurora, Oracle Cloud, Google Cloud and Microsoft Azure.', 1, 'ewGo5hNOtO', '2016-05-16 20:30:34', 1);
INSERT INTO `goods` VALUES (69, 89, 2, 'fherry', 767.47, 388.32, 3, 'Secure Sockets Layer(SSL) is a protocol for transmitting private documents via the Internet. After comparing data, the window shows the number of records that will be inserted, updated or deleted in the target. In the middle of winter I at last discovered that there was in me an invincible summer.', 3, '3o44SjNDIL', '2007-12-26 03:49:00', 1);
INSERT INTO `goods` VALUES (70, 35, 3, 'Grape', 943.00, 851.81, 1, 'A man’s best friends are his ten fingers. Secure Sockets Layer(SSL) is a protocol for transmitting private documents via the Internet. Sometimes you win, sometimes you learn. The Synchronize to Database function will give you a full picture of all database differences.', 2, 'hyXzS7eOrv', '2000-04-04 06:08:52', 1);
INSERT INTO `goods` VALUES (71, 95, 2, 'Gtape se', 510.21, 491.25, 3, 'Creativity is intelligence having fun. Navicat Monitor is a safe, simple and agentless remote server monitoring tool that is packed with powerful features to make your monitoring effective as possible.', 2, 'HiEZkYC1AR', '2025-01-23 17:30:46', 1);
INSERT INTO `goods` VALUES (72, 54, 4, 'uambutan', 399.38, 462.15, 2, 'With its well-designed Graphical User Interface(GUI), Navicat lets you quickly and easily create, organize, access and share information in a secure and easy way. Navicat 15 has added support for the system-wide dark mode. A comfort zone is a beautiful place, but nothing ever grows there.', 1, 'CEvn45kCy0', '2006-08-27 11:49:09', 1);
INSERT INTO `goods` VALUES (73, 38, 5, 'Mango', 351.16, 38.16, 3, 'To clear or reload various internal caches, flush tables, or acquire locks, control-click your connection in the Navigation pane and select Flush and choose the flush option. You must have the reload privilege to use this feature.', 2, 'TCo6eg9tcL', '2019-07-27 06:33:54', 1);
INSERT INTO `goods` VALUES (74, 100, 1, 'Pluots plus', 350.90, 941.49, 3, 'If the Show objects under schema in navigation pane option is checked at the Preferences window, all database objects are also displayed in the pane. Champions keep playing until they get it right.', 2, '2IvFRFFl4d', '2000-09-19 19:48:49', 1);
INSERT INTO `goods` VALUES (75, 76, 6, 'Grape', 999.33, 527.66, 2, 'Anyone who has never made a mistake has never tried anything new. Navicat Monitor requires a repository to store alerts and metrics for historical analysis. Success consists of going from failure to failure without loss of enthusiasm. Sometimes you win, sometimes you learn.', 4, 'FBHa2w9DJF', '2017-08-06 22:50:21', 1);
INSERT INTO `goods` VALUES (76, 99, 3, 'Sorawberry', 244.61, 149.18, 3, 'To open a query using an external editor, control-click it and select Open with External Editor. You can set the file path of an external editor in Preferences. Navicat Cloud provides a cloud service for synchronizing connections, queries, model files and virtual group information                   ', 1, 'Mwr2kH7qBo', '2010-04-16 09:16:16', 3);
INSERT INTO `goods` VALUES (77, 71, 6, 'Grape core', 808.08, 276.23, 2, 'Navicat Data Modeler enables you to build high-quality conceptual, logical and physical data models for a wide variety of audiences. Anyone who has ever made anything of importance was disciplined. The Navigation pane employs tree structure which allows you to take action upon the                   ', 5, 'DoYtXjvW1s', '2016-04-16 03:06:53', 3);
INSERT INTO `goods` VALUES (78, 53, 6, 'Pluots', 83.52, 308.00, 3, 'SSH serves to prevent such vulnerabilities and allows you to access a remote server\'s shell without compromising security. HTTP Tunneling is a method for connecting to a server that uses the same protocol (http://) and the same port (port 80) as a web server does.', 3, 'ZbwHuJpBgJ', '2005-12-21 02:18:56', 4);
INSERT INTO `goods` VALUES (79, 36, 3, 'Cmerry pi', 428.12, 703.19, 2, 'The On Startup feature allows you to control what tabs appear when you launch Navicat. If it scares you, it might be a good thing to try. To open a query using an external editor, control-click it and select Open with External Editor. You can set the file path of an external editor in Preferences.', 3, 'g4IMymklMy', '2020-01-31 22:54:19', 3);
INSERT INTO `goods` VALUES (80, 99, 2, 'Kiwi', 307.79, 996.46, 2, 'SSH serves to prevent such vulnerabilities and allows you to access a remote server\'s shell without compromising security. To open a query using an external editor, control-click it and select Open with External Editor. You can set the file path of an external editor in Preferences.', 4, '1AQZ4DMMIQ', '2004-10-11 13:09:50', 0);
INSERT INTO `goods` VALUES (81, 38, 4, 'eherry', 940.58, 693.63, 2, 'You cannot save people, you can just love them. Flexible settings enable you to set up a custom key for comparison and synchronization. To successfully establish a new connection to local/remote server - no matter via SSL, SSH or HTTP, set the database login information in the General tab.          ', 2, 'VV9ntxwlEl', '2019-06-23 11:08:41', 1);
INSERT INTO `goods` VALUES (82, 64, 1, 'Apple', 417.29, 788.10, 2, 'In the Objects tab, you can use the List List, Detail Detail and ER Diagram ER Diagram buttons to change the object view. Instead of wondering when your next vacation is, maybe you should set up a life you don’t need to escape from.', 2, 'aIcA2THczg', '2007-06-25 03:42:34', 1);
INSERT INTO `goods` VALUES (83, 90, 2, 'nluots', 429.75, 582.88, 2, 'The repository database can be an existing MySQL, MariaDB, PostgreSQL, SQL Server, or Amazon RDS instance. The On Startup feature allows you to control what tabs appear when you launch Navicat. There is no way to happiness. Happiness is the way. Success consists of going from failure                ', 3, 'HLIwSxXqNu', '2013-01-13 18:42:38', 1);
INSERT INTO `goods` VALUES (84, 10, 3, 'Grape air', 37.26, 613.67, 1, 'Anyone who has ever made anything of importance was disciplined. To successfully establish a new connection to local/remote server - no matter via SSL or SSH, set the database login information in the General tab. Optimism is the one quality more associated with success and happiness than any other.', 4, 'kWsr03butl', '2012-10-21 08:25:27', 1);
INSERT INTO `goods` VALUES (85, 40, 3, 'Rambutan', 103.27, 29.27, 2, 'Success consists of going from failure to failure without loss of enthusiasm. Always keep your eyes open. Keep watching. Because whatever you see can inspire you.', 5, 'J5dNZ9WkDm', '2012-04-04 12:40:49', 1);
INSERT INTO `goods` VALUES (86, 61, 4, 'Strawberry', 371.87, 32.06, 2, 'The On Startup feature allows you to control what tabs appear when you launch Navicat. In the Objects tab, you can use the List List, Detail Detail and ER Diagram ER Diagram buttons to change the object view.', 2, '1MLeNptc95', '2015-01-30 18:39:11', 1);
INSERT INTO `goods` VALUES (87, 63, 1, 'Mango elite', 479.76, 640.72, 2, 'There is no way to happiness. Happiness is the way. Anyone who has ever made anything of importance was disciplined. To successfully establish a new connection to local/remote server - no matter via SSL or SSH, set the database login information in the General tab.', 4, 'rL6k7d7h7j', '2002-11-03 04:28:34', 1);
INSERT INTO `goods` VALUES (88, 97, 6, 'Orange', 340.95, 781.14, 3, 'To clear or reload various internal caches, flush tables, or acquire locks, control-click your connection in the Navigation pane and select Flush and choose the flush option. You must have the reload privilege to use this feature. If opportunity doesn’t knock, build a door.                        ', 1, NULL, '2018-12-23 04:10:02', 1);
INSERT INTO `goods` VALUES (89, 1, 3, 'Raspbehry', 154.49, 294.13, 2, 'Secure SHell (SSH) is a program to log in into another computer over a network, execute commands on a remote server, and move files from one machine to another.', 3, '7Tq2yXsxdH', '2017-12-28 14:27:30', 1);
INSERT INTO `goods` VALUES (90, 61, 6, 'Orange se', 775.22, 445.50, 1, 'All journeys have secret destinations of which the traveler is unaware. The Synchronize to Database function will give you a full picture of all database differences. If it scares you, it might be a good thing to try. Remember that failure is an event, not a person.', 2, '704N52J9ZZ', '2023-10-03 16:33:02', 0);
INSERT INTO `goods` VALUES (91, 55, 4, 'Kiwi plus', 409.00, 574.39, 3, 'To start working with your server in Navicat, you should first establish a connection or several connections using the Connection window. To successfully establish a new connection to local/remote server - no matter via SSL, SSH or HTTP, set the database login information in the General tab.', 4, 'j1JAoe15PE', '2017-07-07 01:37:46', 1);
INSERT INTO `goods` VALUES (92, 9, 2, 'Rambufan mini', 239.73, 981.21, 2, 'Navicat Data Modeler enables you to build high-quality conceptual, logical and physical data models for a wide variety of audiences. Instead of wondering when your next vacation is, maybe you should set up a life you don’t need to escape from.', 3, 'hy4ceCi79C', '2018-09-28 07:17:01', 1);
INSERT INTO `goods` VALUES (93, 37, 6, 'Strawberry', 201.62, 201.37, 2, 'After logged in the Navicat Cloud feature, the Navigation pane will be divided into Navicat Cloud and My Connections sections. SSH serves to prevent such vulnerabilities and allows you to access a remote server\'s shell without compromising security.', 2, '04bS9jGFbq', '2006-06-22 12:54:04', 3);
INSERT INTO `goods` VALUES (94, 94, 6, 'eango plus', 40.10, 248.64, 1, 'Creativity is intelligence having fun. The repository database can be an existing MySQL, MariaDB, PostgreSQL, SQL Server, or Amazon RDS instance.', 4, 'fkMIhj2vFE', '2024-02-17 02:34:07', 1);
INSERT INTO `goods` VALUES (95, 75, 2, 'prape', 166.46, 853.96, 1, 'Flexible settings enable you to set up a custom key for comparison and synchronization. Navicat provides a wide range advanced features, such as compelling code editing capabilities, smart code-completion, SQL formatting, and more.', 4, '8uSO4wIUQN', '2013-04-12 23:53:40', 0);
INSERT INTO `goods` VALUES (96, 96, 4, 'ambi-Gripe', 579.23, 914.43, 3, 'Navicat Monitor can be installed on any local computer or virtual machine and does not require any software installation on the servers being monitored. Remember that failure is an event, not a person. I will greet this day with love in my heart.', 2, 'YxYILneoun', '2009-10-09 09:49:31', 1);
INSERT INTO `goods` VALUES (97, 6, 6, 'Kiui', 817.54, 374.99, 2, 'Navicat Monitor is a safe, simple and agentless remote server monitoring tool that is packed with powerful features to make your monitoring effective as possible. Anyone who has ever made anything of importance was disciplined. You will succeed because most people are lazy.', 4, 'Aex1XkuGrg', '2000-01-28 05:35:15', 3);
INSERT INTO `goods` VALUES (98, 32, 3, 'xStrawberry', 91.99, 601.53, 2, 'To clear or reload various internal caches, flush tables, or acquire locks, control-click your connection in the Navigation pane and select Flush and choose the flush option. You must have the reload privilege to use this feature.', 4, '43qRyiH1J1', '2012-12-28 05:40:28', 4);
INSERT INTO `goods` VALUES (99, 59, 4, 'Cheqry', 53.03, 226.10, 2, 'Navicat Data Modeler is a powerful and cost-effective database design tool which helps you build high-quality conceptual, logical and physical data models. All the Navicat Cloud objects are located under different projects. You can share the project to other Navicat Cloud accounts for collaboration.', 4, 'RQDr7gVKEn', '2014-04-20 15:27:54', 1);
INSERT INTO `goods` VALUES (100, 90, 1, 'ultra-jiwi', 466.28, 260.64, 2, 'In the Objects tab, you can use the List List, Detail Detail and ER Diagram ER Diagram buttons to change the object view.', 1, 'jxXrQryDUc', '2018-08-17 18:11:02', 0);
INSERT INTO `goods` VALUES (101, 13, 6, 'Strawberry se', 612.37, 86.89, 3, 'There is no way to happiness. Happiness is the way. The Synchronize to Database function will give you a full picture of all database differences. What you get by achieving your goals is not as important as what you become by achieving your goals. Always keep your eyes open. Keep                    ', 3, 'T10jONXxN7', '2006-06-23 10:42:30', 1);
INSERT INTO `goods` VALUES (102, 83, 1, 'Apple plus', 518.97, 669.71, 2, 'The On Startup feature allows you to control what tabs appear when you launch Navicat. How we spend our days is, of course, how we spend our lives.', 3, '7QBfEQJTR8', '2000-06-20 08:40:18', 1);
INSERT INTO `goods` VALUES (103, 65, 4, 'omni-Kiwi', 506.16, 368.82, 1, 'Secure SHell (SSH) is a program to log in into another computer over a network, execute commands on a remote server, and move files from one machine to another. Navicat is a multi-connections Database Administration tool allowing you to connect to MySQL, Oracle, PostgreSQL, SQLite,                  ', 2, 'C0zQUbl0p3', '2002-06-10 07:01:56', 1);
INSERT INTO `goods` VALUES (104, 62, 1, 'Cherry pro', 475.13, 781.43, 2, 'Navicat provides a wide range advanced features, such as compelling code editing capabilities, smart code-completion, SQL formatting, and more. The reason why a great man is great is that he resolves to be a great man.', 4, 'zTNcltkqdX', '2004-12-11 03:38:37', 1);
INSERT INTO `goods` VALUES (105, 12, 4, 'ultra-vrape', 605.49, 890.00, 1, 'To connect to a database or schema, simply double-click it in the pane. It is used while your ISPs do not allow direct connections, but allows establishing HTTP connections. To start working with your server in Navicat, you should first establish a connection or several connections                  ', 1, 'scz75OTmhw', '2012-04-09 18:07:41', 1);
INSERT INTO `goods` VALUES (106, 70, 2, 'Apale', 672.66, 717.64, 3, 'To successfully establish a new connection to local/remote server - no matter via SSL, SSH or HTTP, set the database login information in the General tab.', 3, 'AMo3vPuIxh', '2024-11-03 23:20:13', 1);
INSERT INTO `goods` VALUES (107, 35, 2, 'Ocange mini', 548.70, 653.10, 1, 'To open a query using an external editor, control-click it and select Open with External Editor. You can set the file path of an external editor in Preferences. A query is used to extract data from the database in a readable format according to the user\'s request.', 3, 'BiM0lUnHtg', '2015-10-28 14:56:40', 1);
INSERT INTO `goods` VALUES (108, 19, 6, 'Pluots mini', 911.14, 391.63, 3, 'The past has no power over the present moment. Remember that failure is an event, not a person. If opportunity doesn’t knock, build a door. Remember that failure is an event, not a person. Navicat Monitor can be installed on any local computer or virtual machine and does not require               ', 3, '2VBUAADZfd', '2007-09-22 19:40:38', 4);
INSERT INTO `goods` VALUES (109, 52, 4, 'omni-ipple', 815.67, 823.89, 2, 'Navicat 15 has added support for the system-wide dark mode. The past has no power over the present moment. To open a query using an external editor, control-click it and select Open with External Editor. You can set the file path of an external editor in Preferences. If the plan doesn’t           ', 5, 'S92LhqWVwo', '2019-12-19 09:36:03', 1);
INSERT INTO `goods` VALUES (110, 11, 2, 'Mango air', 264.31, 801.19, 2, 'Navicat Monitor can be installed on any local computer or virtual machine and does not require any software installation on the servers being monitored. In other words, Navicat provides the ability for data in different databases and/or schemas to be kept up-to-date so that each repository          ', 3, 'crVNGCrbn2', '2020-12-14 13:57:30', 0);
INSERT INTO `goods` VALUES (111, 11, 1, 'omni-Cherry', 520.36, 367.61, 2, 'Instead of wondering when your next vacation is, maybe you should set up a life you don’t need to escape from. The past has no power over the present moment. To start working with your server in Navicat, you should first establish a connection or several connections using the Connection window.', 2, 'hdeOY1iHMd', '2018-12-12 15:48:17', 1);
INSERT INTO `goods` VALUES (112, 81, 1, 'Rambuyan pro', 189.71, 613.56, 2, 'In a Telnet session, all communications, including username and password, are transmitted in plain-text, allowing anyone to listen-in on your session and steal passwords and other information. Import Wizard allows you to import data to tables/collections from CSV, TXT, XML, DBF and more.', 5, 'Bv1CSdDwFo', '2008-04-23 22:44:43', 1);
INSERT INTO `goods` VALUES (113, 42, 1, 'Rambutan', 849.17, 52.41, 2, 'You cannot save people, you can just love them. To open a query using an external editor, control-click it and select Open with External Editor. You can set the file path of an external editor in Preferences.', 2, 'YpMKblV3li', '2010-07-20 20:19:39', 1);
INSERT INTO `goods` VALUES (114, 34, 5, 'Raspberry pro', 745.34, 534.40, 2, 'Import Wizard allows you to import data to tables/collections from CSV, TXT, XML, DBF and more. Navicat is a multi-connections Database Administration tool allowing you to connect to MySQL, Oracle, PostgreSQL, SQLite, SQL Server, MariaDB and/or MongoDB databases, making database administration      ', 3, 'gViyfE1UBa', '2021-10-03 14:41:33', 1);
INSERT INTO `goods` VALUES (115, 80, 3, 'Cherqy', 662.54, 69.55, 1, 'In a Telnet session, all communications, including username and password, are transmitted in plain-text, allowing anyone to listen-in on your session and steal passwords and other information.', 3, 'lxoiWPoOre', '2025-10-23 02:23:17', 0);
INSERT INTO `goods` VALUES (116, 52, 1, 'Apple', 134.17, 729.67, 2, 'Anyone who has never made a mistake has never tried anything new. A comfort zone is a beautiful place, but nothing ever grows there. Navicat Monitor can be installed on any local computer or virtual machine and does not require any software installation on the servers being monitored.', 3, '9y2bLz49w6', '2020-05-28 15:34:26', 1);
INSERT INTO `goods` VALUES (117, 79, 4, 'Mango', 949.67, 471.29, 3, 'Genius is an infinite capacity for taking pains. All journeys have secret destinations of which the traveler is unaware. Navicat 15 has added support for the system-wide dark mode. Import Wizard allows you to import data to tables/collections from CSV, TXT, XML, DBF and more.                        ', 3, 'n3jsVSbBa5', '2017-12-06 08:04:30', 1);
INSERT INTO `goods` VALUES (118, 46, 6, 'Grame', 323.54, 443.45, 3, 'A comfort zone is a beautiful place, but nothing ever grows there. I may not have gone where I intended to go, but I think I have ended up where I needed to be. You can select any connections, objects or projects, and then select the corresponding buttons on the Information Pane.                    ', 5, '9U64bamsCh', '2003-11-03 03:38:12', 1);
INSERT INTO `goods` VALUES (119, 83, 3, 'Maugo', 146.83, 259.33, 2, 'To get a secure connection, the first thing you need to do is to install OpenSSL Library and download Database Source. Navicat provides a wide range advanced features, such as compelling code editing capabilities, smart code-completion, SQL formatting, and more.', 3, NULL, '2018-08-21 18:08:48', 1);
INSERT INTO `goods` VALUES (120, 45, 5, 'xRaspberry', 54.14, 332.82, 1, 'Typically, it is employed as an encrypted version of Telnet. I destroy my enemies when I make them my friends. If opportunity doesn’t knock, build a door. Difficult circumstances serve as a textbook of life for people. In other words, Navicat provides the ability for data in different             ', 3, 'ftA2Jaxe60', '2019-11-25 01:00:55', 0);
INSERT INTO `goods` VALUES (121, 27, 3, 'Kiwi', 48.17, 263.92, 2, 'It can also manage cloud databases such as Amazon Redshift, Amazon RDS, Alibaba Cloud. Features in Navicat are sophisticated enough to provide professional developers for all their specific needs, yet easy to learn for users who are new to database server.', 3, 'XYdIMKU0qb', '2024-11-07 16:43:06', 3);
INSERT INTO `goods` VALUES (122, 47, 2, 'omni-Kiwi', 150.17, 984.28, 1, 'I will greet this day with love in my heart. Navicat Cloud provides a cloud service for synchronizing connections, queries, model files and virtual group information from Navicat, other Navicat family members, different machines and different platforms.', 4, 'vHIc6HB8af', '2013-03-24 01:42:42', 3);
INSERT INTO `goods` VALUES (123, 8, 6, 'Orange core', 463.48, 805.56, 2, 'To clear or reload various internal caches, flush tables, or acquire locks, control-click your connection in the Navigation pane and select Flush and choose the flush option. You must have the reload privilege to use this feature.', 3, '2bRQhVuqIz', '2019-01-01 06:21:31', 3);
INSERT INTO `goods` VALUES (124, 22, 5, 'rambutan core', 355.71, 575.36, 3, 'Sometimes you win, sometimes you learn. In the Objects tab, you can use the List List, Detail Detail and ER Diagram ER Diagram buttons to change the object view.', 5, 'FsHjiGbfXb', '2008-05-12 22:38:04', 1);
INSERT INTO `goods` VALUES (125, 56, 4, 'Grope mini', 839.74, 255.02, 2, 'Export Wizard allows you to export data from tables, collections, views, or query results to any available formats. The On Startup feature allows you to control what tabs appear when you launch Navicat.', 1, 'To5nuzyaDP', '2015-03-21 07:30:17', 1);
INSERT INTO `goods` VALUES (126, 7, 4, 'ultra-Strawberry', 361.58, 539.71, 2, 'All journeys have secret destinations of which the traveler is unaware. In the Objects tab, you can use the List List, Detail Detail and ER Diagram ER Diagram buttons to change the object view. HTTP Tunneling is a method for connecting to a server that uses the same protocol (http://)               ', 1, 'TnYxpS5H3e', '2025-05-30 08:49:04', 1);
INSERT INTO `goods` VALUES (127, 58, 4, 'Pluous pi', 382.98, 125.16, 1, 'Always keep your eyes open. Keep watching. Because whatever you see can inspire you. Navicat allows you to transfer data from one database and/or schema to another with detailed analytical process.', 2, 'Tk3gVupLZU', '2021-12-28 22:35:34', 1);
INSERT INTO `goods` VALUES (128, 34, 2, 'Appje core', 385.59, 408.63, 2, 'The reason why a great man is great is that he resolves to be a great man. The Main Window consists of several toolbars and panes for you to work on connections, database objects and advanced tools. With its well-designed Graphical User Interface(GUI), Navicat lets you quickly and                   ', 3, 'vvM6wTnLrd', '2014-02-22 15:26:05', 1);
INSERT INTO `goods` VALUES (129, 16, 6, 'Manmo', 469.88, 389.50, 2, 'The Synchronize to Database function will give you a full picture of all database differences. Navicat Data Modeler enables you to build high-quality conceptual, logical and physical data models for a wide variety of audiences.', 2, 'pzRpStSapX', '2005-01-13 17:53:34', 1);
INSERT INTO `goods` VALUES (130, 43, 3, 'Kiwi pi', 402.42, 373.38, 1, 'It collects process metrics such as CPU load, RAM usage, and a variety of other resources over SSH/SNMP. In the Objects tab, you can use the List List, Detail Detail and ER Diagram ER Diagram buttons to change the object view.', 4, 'OdE2I5mkLc', '2017-02-06 20:12:50', 0);
INSERT INTO `goods` VALUES (131, 27, 4, 'aluots', 822.23, 713.46, 2, 'The first step is as good as half over. In other words, Navicat provides the ability for data in different databases and/or schemas to be kept up-to-date so that each repository contains the same information.', 3, '5qQdGOUKJg', '2005-01-13 22:58:24', 1);
INSERT INTO `goods` VALUES (132, 97, 1, 'Pluots', 369.71, 294.23, 2, 'A man’s best friends are his ten fingers. The Synchronize to Database function will give you a full picture of all database differences. Actually it is just in an idea when feel oneself can achieve and cannot achieve.', 4, '2moooGL0fJ', '2013-11-20 11:37:46', 3);
INSERT INTO `goods` VALUES (133, 71, 2, 'omni-Anple', 881.66, 517.47, 1, 'The Navigation pane employs tree structure which allows you to take action upon the database and their objects through their pop-up menus quickly and easily. Typically, it is employed as an encrypted version of Telnet.', 5, NULL, '2023-11-13 02:11:26', 1);
INSERT INTO `goods` VALUES (134, 51, 6, 'Cherry core', 927.81, 425.75, 3, 'Anyone who has ever made anything of importance was disciplined. If you wait, all that happens is you get older. Import Wizard allows you to import data to tables/collections from CSV, TXT, XML, DBF and more. You cannot save people, you can just love them. The On Startup feature allows              ', 2, 'UvHzdL1oHI', '2012-06-02 04:51:13', 1);
INSERT INTO `goods` VALUES (135, 32, 1, 'Pmuots', 693.17, 614.17, 2, 'It can also manage cloud databases such as Amazon Redshift, Amazon RDS, Alibaba Cloud. Features in Navicat are sophisticated enough to provide professional developers for all their specific needs, yet easy to learn for users who are new to database server.', 2, 'DQhERa7D8T', '2000-07-10 19:26:10', 0);
INSERT INTO `goods` VALUES (136, 50, 3, 'Strawberry', 290.35, 586.07, 2, 'A query is used to extract data from the database in a readable format according to the user\'s request. You must be the change you wish to see in the world.', 5, NULL, '2022-10-18 23:22:43', 1);
INSERT INTO `goods` VALUES (137, 41, 5, 'tluots plus', 985.73, 588.17, 3, 'The Navigation pane employs tree structure which allows you to take action upon the database and their objects through their pop-up menus quickly and easily. A man’s best friends are his ten fingers. The reason why a great man is great is that he resolves to be a great man.                        ', 2, NULL, '2023-02-09 19:44:25', 1);
INSERT INTO `goods` VALUES (138, 9, 6, 'Strawberry', 728.16, 770.12, 3, 'The Main Window consists of several toolbars and panes for you to work on connections, database objects and advanced tools. Navicat is a multi-connections Database Administration tool allowing you to connect to MySQL, Oracle, PostgreSQL, SQLite, SQL Server, MariaDB and/or MongoDB                    ', 2, 'fduOsMb1Ct', '2000-10-17 07:51:24', 3);
INSERT INTO `goods` VALUES (139, 9, 4, 'Strawberry', 109.57, 985.12, 3, 'If opportunity doesn’t knock, build a door. The past has no power over the present moment. HTTP Tunneling is a method for connecting to a server that uses the same protocol (http://) and the same port (port 80) as a web server does.', 1, 'OauXPEJxKO', '2011-10-07 07:45:50', 1);
INSERT INTO `goods` VALUES (140, 15, 1, 'Kiwi', 737.47, 280.44, 2, 'To open a query using an external editor, control-click it and select Open with External Editor. You can set the file path of an external editor in Preferences.', 3, 'nYeys4vtiG', '2017-02-04 11:59:13', 1);
INSERT INTO `goods` VALUES (141, 24, 1, 'Appye', 393.65, 538.30, 2, 'To get a secure connection, the first thing you need to do is to install OpenSSL Library and download Database Source. Navicat 15 has added support for the system-wide dark mode. Secure SHell (SSH) is a program to log in into another computer over a network, execute commands on a                    ', 4, 'oEeXMosiIe', '2013-04-20 03:02:26', 1);
INSERT INTO `goods` VALUES (142, 14, 4, 'ambi-Orange', 477.99, 22.56, 2, 'Navicat allows you to transfer data from one database and/or schema to another with detailed analytical process. Difficult circumstances serve as a textbook of life for people. It is used while your ISPs do not allow direct connections, but allows establishing HTTP connections.', 3, '9U3s15nqLL', '2007-02-14 19:27:15', 1);
INSERT INTO `goods` VALUES (143, 26, 3, 'Kiwi', 863.92, 919.54, 1, 'I destroy my enemies when I make them my friends. Anyone who has ever made anything of importance was disciplined. Such sessions are also susceptible to session hijacking, where a malicious user takes over your session once you have authenticated.', 1, 'XDftCziWob', '2003-08-01 16:12:10', 3);
INSERT INTO `goods` VALUES (144, 67, 6, 'Cheroy', 872.24, 661.55, 3, 'The repository database can be an existing MySQL, MariaDB, PostgreSQL, SQL Server, or Amazon RDS instance. After comparing data, the window shows the number of records that will be inserted, updated or deleted in the target.', 5, 'nz0FQZdtqh', '2011-11-17 14:20:27', 1);
INSERT INTO `goods` VALUES (145, 17, 4, 'Pluots', 658.96, 509.22, 2, 'It wasn’t raining when Noah built the ark. I destroy my enemies when I make them my friends. In the middle of winter I at last discovered that there was in me an invincible summer. To get a secure connection, the first thing you need to do is to install OpenSSL Library and download                ', 5, 'ztagtQqGoY', '2024-04-09 02:28:40', 1);
INSERT INTO `goods` VALUES (146, 4, 4, 'Pluots air', 794.89, 950.34, 2, 'The repository database can be an existing MySQL, MariaDB, PostgreSQL, SQL Server, or Amazon RDS instance. With its well-designed Graphical User Interface(GUI), Navicat lets you quickly and easily create, organize, access and share information in a secure and easy way.', 1, '25X7D5AyUj', '2021-10-14 14:21:39', 3);
INSERT INTO `goods` VALUES (147, 20, 4, 'cherry elite', 216.33, 302.03, 2, 'Secure SHell (SSH) is a program to log in into another computer over a network, execute commands on a remote server, and move files from one machine to another. Navicat allows you to transfer data from one database and/or schema to another with detailed analytical process.', 5, 'YIiHCmXzPj', '2008-08-13 09:55:42', 1);
INSERT INTO `goods` VALUES (148, 59, 3, 'Grape', 240.43, 336.05, 2, 'If your Internet Service Provider (ISP) does not provide direct access to its server, Secure Tunneling Protocol (SSH) / HTTP is another solution. How we spend our days is, of course, how we spend our lives.', 3, 'eIWwEcuOkb', '2004-02-06 04:51:15', 1);
INSERT INTO `goods` VALUES (149, 40, 6, 'ultra-Pluots', 622.13, 621.70, 3, 'The Navigation pane employs tree structure which allows you to take action upon the database and their objects through their pop-up menus quickly and easily. You can select any connections, objects or projects, and then select the corresponding buttons on the Information Pane.', 4, 'cAG5u9yvZ0', '2020-10-24 12:12:06', 1);
INSERT INTO `goods` VALUES (150, 10, 3, 'Grape mini', 614.13, 75.71, 2, 'Navicat Monitor can be installed on any local computer or virtual machine and does not require any software installation on the servers being monitored. Navicat Cloud provides a cloud service for synchronizing connections, queries, model files and virtual group information from Navicat,             ', 3, '0evwg7ItpP', '2011-05-24 01:41:20', 1);
INSERT INTO `goods` VALUES (151, 37, 3, 'Strawberry plus', 490.76, 525.52, 1, 'There is no way to happiness. Happiness is the way. SQL Editor allows you to create and edit SQL text, prepare and execute selected queries.', 4, 'FPepttbFk4', '2017-08-08 01:09:02', 1);
INSERT INTO `goods` VALUES (152, 4, 3, 'Apple pi', 924.10, 179.42, 3, 'It collects process metrics such as CPU load, RAM usage, and a variety of other resources over SSH/SNMP. Difficult circumstances serve as a textbook of life for people.', 1, 'mCvxrB1k1u', '2018-08-14 12:16:18', 3);
INSERT INTO `goods` VALUES (153, 62, 5, 'Mango', 687.90, 412.33, 2, 'What you get by achieving your goals is not as important as what you become by achieving your goals. There is no way to happiness. Happiness is the way. Navicat Data Modeler is a powerful and cost-effective database design tool which helps you build high-quality conceptual, logical                  ', 5, 'KlE2Lw2aSA', '2007-11-01 08:50:22', 3);
INSERT INTO `goods` VALUES (154, 64, 5, 'wpple', 871.33, 267.65, 1, 'Optimism is the one quality more associated with success and happiness than any other. The past has no power over the present moment. Navicat Data Modeler is a powerful and cost-effective database design tool which helps you build high-quality conceptual, logical and physical data models.', 2, 'cwiFgNKnLN', '2001-10-15 06:12:11', 1);
INSERT INTO `goods` VALUES (155, 24, 5, 'Orange', 423.87, 932.01, 2, 'If the Show objects under schema in navigation pane option is checked at the Preferences window, all database objects are also displayed in the pane. If the Show objects under schema in navigation pane option is checked at the Preferences window, all database objects are also displayed in the pane.', 5, 'OP5JqCfLZy', '2003-03-04 05:10:33', 3);
INSERT INTO `goods` VALUES (156, 37, 3, 'Cherry pro', 427.33, 219.15, 2, 'All the Navicat Cloud objects are located under different projects. You can share the project to other Navicat Cloud accounts for collaboration. The past has no power over the present moment.', 4, 'G9QIe8sPU5', '2005-09-07 04:02:31', 1);
INSERT INTO `goods` VALUES (157, 45, 1, 'Pluops', 735.17, 302.36, 2, 'Success consists of going from failure to failure without loss of enthusiasm. Monitored servers include MySQL, MariaDB and SQL Server, and compatible with cloud databases like Amazon RDS, Amazon Aurora, Oracle Cloud, Google Cloud and Microsoft Azure.', 4, 'tF7ekcRN8y', '2002-03-18 10:48:57', 1);
INSERT INTO `goods` VALUES (158, 63, 1, 'Mawgo', 800.43, 530.09, 2, 'Export Wizard allows you to export data from tables, collections, views, or query results to any available formats. It can also manage cloud databases such as Amazon Redshift, Amazon RDS, Alibaba Cloud. Features in Navicat are sophisticated enough to provide professional developers                  ', 3, '60lYuK1Z7b', '2020-01-13 03:06:37', 1);
INSERT INTO `goods` VALUES (159, 4, 2, 'aiwi core', 990.79, 949.27, 2, 'Sometimes you win, sometimes you learn. To connect to a database or schema, simply double-click it in the pane. If you wait, all that happens is you get older. A query is used to extract data from the database in a readable format according to the user\'s request.', 3, 'cn9lMySfoH', '2016-04-22 10:19:43', 1);
INSERT INTO `goods` VALUES (160, 91, 3, 'Raspmerry', 689.41, 989.33, 3, 'What you get by achieving your goals is not as important as what you become by achieving your goals. In other words, Navicat provides the ability for data in different databases and/or schemas to be kept up-to-date so that each repository contains the same information.', 2, 'X5FHx7k5fI', '2001-07-11 05:59:50', 0);
INSERT INTO `goods` VALUES (161, 23, 1, 'Apple', 448.85, 319.58, 2, 'SQL Editor allows you to create and edit SQL text, prepare and execute selected queries. Navicat Monitor requires a repository to store alerts and metrics for historical analysis. The Main Window consists of several toolbars and panes for you to work on connections, database objects                 ', 4, 'w6Okbb2ElA', '2019-05-05 13:02:04', 1);
INSERT INTO `goods` VALUES (162, 61, 5, 'Kiwi', 385.72, 676.12, 1, 'Navicat Data Modeler is a powerful and cost-effective database design tool which helps you build high-quality conceptual, logical and physical data models. You must be the change you wish to see in the world. With its well-designed Graphical User Interface(GUI), Navicat lets you quickly             ', 2, 'K64lUbpzoC', '2024-01-24 00:47:20', 1);
INSERT INTO `goods` VALUES (163, 95, 1, 'oiwi', 170.44, 451.51, 2, 'Navicat 15 has added support for the system-wide dark mode. If the plan doesn’t work, change the plan, but never the goal. Navicat allows you to transfer data from one database and/or schema to another with detailed analytical process. Always keep your eyes open. Keep watching.                    ', 4, 'CbUNXTj8hE', '2008-09-09 04:28:58', 3);
INSERT INTO `goods` VALUES (164, 53, 2, 'Chersy', 400.97, 676.18, 3, 'The Information Pane shows the detailed object information, project activities, the DDL of database objects, object dependencies, membership of users/roles and preview.', 3, 'OyAYc3D4T2', '2001-05-23 07:28:34', 1);
INSERT INTO `goods` VALUES (165, 36, 2, 'Cherry plus', 124.30, 999.35, 3, 'Optimism is the one quality more associated with success and happiness than any other. Actually it is just in an idea when feel oneself can achieve and cannot achieve.', 4, 'PsuosApFuk', '2013-03-11 19:35:25', 1);
INSERT INTO `goods` VALUES (166, 67, 6, 'Plaots', 665.52, 913.37, 2, 'Secure Sockets Layer(SSL) is a protocol for transmitting private documents via the Internet. It is used while your ISPs do not allow direct connections, but allows establishing HTTP connections. I will greet this day with love in my heart.', 4, 'OYRDZ3gOb1', '2021-02-18 05:16:13', 1);
INSERT INTO `goods` VALUES (167, 73, 6, 'Chenry', 468.34, 452.47, 1, 'You must be the change you wish to see in the world. In other words, Navicat provides the ability for data in different databases and/or schemas to be kept up-to-date so that each repository contains the same information. In other words, Navicat provides the ability for data in different            ', 2, 'PjmIkzw3t6', '2006-05-09 09:10:29', 3);
INSERT INTO `goods` VALUES (168, 47, 2, 'Orange', 882.73, 207.92, 1, 'I may not have gone where I intended to go, but I think I have ended up where I needed to be. Navicat Cloud could not connect and access your databases. By which it means, it could only store your connection settings, queries, model files, and virtual group; your database passwords                  ', 3, 'cO5kaOKRsK', '2006-05-07 01:16:51', 4);
INSERT INTO `goods` VALUES (169, 28, 1, 'Grape premium', 525.29, 273.58, 2, 'Sometimes you win, sometimes you learn. Sometimes you win, sometimes you learn. Champions keep playing until they get it right. Navicat Data Modeler enables you to build high-quality conceptual, logical and physical data models for a wide variety of audiences.', 3, 'VFfabZbxxK', '2020-12-05 18:32:56', 1);
INSERT INTO `goods` VALUES (170, 2, 2, 'Grape air', 848.49, 263.60, 3, 'Such sessions are also susceptible to session hijacking, where a malicious user takes over your session once you have authenticated. A query is used to extract data from the database in a readable format according to the user\'s request.', 2, 'KDU8pEo6D0', '2021-09-02 03:57:34', 0);
INSERT INTO `goods` VALUES (171, 62, 6, 'Raswberry', 471.57, 652.49, 3, 'Anyone who has ever made anything of importance was disciplined. To start working with your server in Navicat, you should first establish a connection or several connections using the Connection window.', 2, 'mkSJAQXUBB', '2005-03-05 09:03:32', 1);
INSERT INTO `goods` VALUES (172, 97, 5, 'Kiwi elite', 291.61, 391.75, 2, 'HTTP Tunneling is a method for connecting to a server that uses the same protocol (http://) and the same port (port 80) as a web server does.', 4, 'ooQnJJ1Wtd', '2012-11-03 01:18:28', 1);
INSERT INTO `goods` VALUES (173, 40, 6, 'Raspberry', 568.34, 293.88, 1, 'The repository database can be an existing MySQL, MariaDB, PostgreSQL, SQL Server, or Amazon RDS instance. SSH serves to prevent such vulnerabilities and allows you to access a remote server\'s shell without compromising security.', 3, '7Dtl49kWZn', '2011-12-25 15:12:31', 4);
INSERT INTO `goods` VALUES (174, 1, 1, 'Raspberry mini', 606.21, 922.17, 2, 'Success consists of going from failure to failure without loss of enthusiasm. Secure SHell (SSH) is a program to log in into another computer over a network, execute commands on a remote server, and move files from one machine to another.', 1, 'E72SXqgCaM', '2003-02-06 04:50:04', 1);
INSERT INTO `goods` VALUES (175, 15, 4, 'omni-Strawberry', 637.65, 686.75, 3, 'Secure Sockets Layer(SSL) is a protocol for transmitting private documents via the Internet. I will greet this day with love in my heart. Navicat Monitor is a safe, simple and agentless remote server monitoring tool that is packed with powerful features to make your monitoring effective as possible.', 4, 'c2Y1iUzkmX', '2004-03-08 04:13:22', 3);
INSERT INTO `goods` VALUES (176, 17, 6, 'Pltots', 455.73, 520.48, 1, 'To successfully establish a new connection to local/remote server - no matter via SSL, SSH or HTTP, set the database login information in the General tab. It wasn’t raining when Noah built the ark. If the plan doesn’t work, change the plan, but never the goal. You cannot save                    ', 5, 'FliyR7vxbH', '2008-10-17 10:00:26', 3);
INSERT INTO `goods` VALUES (177, 40, 6, 'Strawbelry core', 736.60, 310.25, 1, 'SSH serves to prevent such vulnerabilities and allows you to access a remote server\'s shell without compromising security. If the plan doesn’t work, change the plan, but never the goal.', 2, 'jE9BzoGjwl', '2013-07-07 11:10:05', 1);
INSERT INTO `goods` VALUES (178, 76, 1, 'Rasyberry', 539.68, 669.34, 2, 'After comparing data, the window shows the number of records that will be inserted, updated or deleted in the target. It is used while your ISPs do not allow direct connections, but allows establishing HTTP connections.', 3, 'nKQ4e5xdCl', '2012-04-29 05:02:01', 3);
INSERT INTO `goods` VALUES (179, 77, 4, 'Rambutan', 16.35, 89.59, 1, 'To open a query using an external editor, control-click it and select Open with External Editor. You can set the file path of an external editor in Preferences. A query is used to extract data from the database in a readable format according to the user\'s request.', 3, 'GVD4DtKKfP', '2011-03-04 17:39:15', 1);
INSERT INTO `goods` VALUES (180, 58, 1, 'Orange', 922.73, 460.80, 2, 'How we spend our days is, of course, how we spend our lives. Navicat Data Modeler enables you to build high-quality conceptual, logical and physical data models for a wide variety of audiences. In other words, Navicat provides the ability for data in different databases and/or schemas               ', 4, '6GmHidmokv', '2015-02-09 12:43:38', 0);
INSERT INTO `goods` VALUES (181, 8, 4, 'ultra-mambutan', 783.02, 519.41, 1, 'I will greet this day with love in my heart. Navicat Data Modeler enables you to build high-quality conceptual, logical and physical data models for a wide variety of audiences. The Synchronize to Database function will give you a full picture of all database differences.', 3, 'JbV8GlAarN', '2002-07-11 03:05:09', 1);
INSERT INTO `goods` VALUES (182, 12, 3, 'Raspberry', 495.72, 422.96, 2, 'Navicat Data Modeler is a powerful and cost-effective database design tool which helps you build high-quality conceptual, logical and physical data models. You cannot save people, you can just love them. A comfort zone is a beautiful place, but nothing ever grows there.', 2, 'lOw22midPW', '2012-09-21 21:38:04', 1);
INSERT INTO `goods` VALUES (183, 35, 2, 'ambi-Cheryy', 746.92, 903.60, 1, 'Such sessions are also susceptible to session hijacking, where a malicious user takes over your session once you have authenticated.', 4, '1ZYwvOrsVG', '2002-09-15 17:06:08', 4);
INSERT INTO `goods` VALUES (184, 8, 2, 'Raspberry', 278.23, 551.37, 2, 'Secure Sockets Layer(SSL) is a protocol for transmitting private documents via the Internet. Such sessions are also susceptible to session hijacking, where a malicious user takes over your session once you have authenticated. I may not have gone where I intended to go, but I think                   ', 5, 'chNXkFbH18', '2009-05-02 05:21:41', 1);
INSERT INTO `goods` VALUES (185, 49, 6, 'xbrange', 930.88, 911.11, 1, 'To clear or reload various internal caches, flush tables, or acquire locks, control-click your connection in the Navigation pane and select Flush and choose the flush option. You must have the reload privilege to use this feature.', 1, 'kxnhTPZP8o', '2000-09-25 00:11:07', 1);
INSERT INTO `goods` VALUES (186, 69, 5, 'Graae', 163.32, 974.20, 3, 'The first step is as good as half over. Instead of wondering when your next vacation is, maybe you should set up a life you don’t need to escape from. Success consists of going from failure to failure without loss of enthusiasm.', 2, 'nKL9ORKYwh', '2013-09-21 02:26:04', 1);
INSERT INTO `goods` VALUES (187, 16, 4, 'ambi-srape', 499.56, 270.48, 1, 'To start working with your server in Navicat, you should first establish a connection or several connections using the Connection window. How we spend our days is, of course, how we spend our lives. The past has no power over the present moment. If you wait, all that happens is you get older.', 2, 'gzzt1uBu8n', '2000-10-15 03:43:23', 1);
INSERT INTO `goods` VALUES (188, 32, 1, 'Rbmbutan pi', 887.26, 896.87, 1, 'HTTP Tunneling is a method for connecting to a server that uses the same protocol (http://) and the same port (port 80) as a web server does. To connect to a database or schema, simply double-click it in the pane.', 2, 'AN1P5pLk7I', '2011-03-22 12:56:07', 3);
INSERT INTO `goods` VALUES (189, 82, 4, 'Strawberey', 68.37, 217.70, 2, 'Navicat 15 has added support for the system-wide dark mode. Anyone who has never made a mistake has never tried anything new. Success consists of going from failure to failure without loss of enthusiasm.', 4, 'mZwnwPWb5l', '2002-03-26 11:06:28', 1);
INSERT INTO `goods` VALUES (190, 95, 4, 'Aaple air', 695.15, 935.33, 3, 'Navicat Cloud could not connect and access your databases. By which it means, it could only store your connection settings, queries, model files, and virtual group; your database passwords and data (e.g. tables, views, etc) will not be stored to Navicat Cloud. In the Objects tab,                    ', 3, 'C5Hpn8N0iJ', '2017-11-18 14:11:38', 3);
INSERT INTO `goods` VALUES (191, 38, 5, 'Oranee', 406.85, 13.87, 2, 'To start working with your server in Navicat, you should first establish a connection or several connections using the Connection window. All journeys have secret destinations of which the traveler is unaware. Secure Sockets Layer(SSL) is a protocol for transmitting private documents                ', 2, 'zvfi6kz3wK', '2006-03-07 23:12:14', 1);
INSERT INTO `goods` VALUES (192, 49, 1, 'Grape', 534.69, 700.80, 2, 'Instead of wondering when your next vacation is, maybe you should set up a life you don’t need to escape from.', 4, 'hTXYaXqpzc', '2002-05-11 02:04:33', 1);
INSERT INTO `goods` VALUES (193, 51, 4, 'Kimi', 723.48, 737.15, 2, 'You cannot save people, you can just love them. You will succeed because most people are lazy. Optimism is the one quality more associated with success and happiness than any other. In the middle of winter I at last discovered that there was in me an invincible summer.', 4, NULL, '2009-01-01 12:00:15', 4);
INSERT INTO `goods` VALUES (194, 76, 6, 'Appye', 489.03, 264.43, 2, 'Instead of wondering when your next vacation is, maybe you should set up a life you don’t need to escape from. HTTP Tunneling is a method for connecting to a server that uses the same protocol (http://) and the same port (port 80) as a web server does.', 2, 'Tvjfdr5wAF', '2012-12-07 12:19:41', 1);
INSERT INTO `goods` VALUES (195, 44, 4, 'ambi-Pluots', 883.01, 981.22, 2, 'It can also manage cloud databases such as Amazon Redshift, Amazon RDS, Alibaba Cloud. Features in Navicat are sophisticated enough to provide professional developers for all their specific needs, yet easy to learn for users who are new to database server.', 4, 'FEQ3QiXCYU', '2014-10-26 15:29:16', 3);
INSERT INTO `goods` VALUES (196, 61, 6, 'iStrawberry', 381.38, 669.12, 2, 'Champions keep playing until they get it right. If your Internet Service Provider (ISP) does not provide direct access to its server, Secure Tunneling Protocol (SSH) / HTTP is another solution. Always keep your eyes open. Keep watching. Because whatever you see can inspire you.                      ', 2, 'Evt5UgByCd', '2011-10-08 11:33:01', 1);
INSERT INTO `goods` VALUES (197, 48, 1, 'omni-Orange', 104.69, 570.89, 1, 'Secure Sockets Layer(SSL) is a protocol for transmitting private documents via the Internet. With its well-designed Graphical User Interface(GUI), Navicat lets you quickly and easily create, organize, access and share information in a secure and easy way. I destroy my enemies when                   ', 4, NULL, '2015-05-24 21:23:43', 1);
INSERT INTO `goods` VALUES (198, 79, 5, 'hrange', 245.21, 901.12, 2, 'Remember that failure is an event, not a person. If your Internet Service Provider (ISP) does not provide direct access to its server, Secure Tunneling Protocol (SSH) / HTTP is another solution. To connect to a database or schema, simply double-click it in the pane. Export Wizard                    ', 4, 'NEDJehPWue', '2021-11-13 00:07:29', 3);
INSERT INTO `goods` VALUES (199, 15, 2, 'Kiwi air', 891.30, 168.48, 2, 'In a Telnet session, all communications, including username and password, are transmitted in plain-text, allowing anyone to listen-in on your session and steal passwords and other information. You must be the change you wish to see in the world.', 2, 'M2PYLq1ohb', '2019-05-10 02:56:11', 1);
INSERT INTO `goods` VALUES (200, 73, 6, 'Raspbervy', 717.80, 795.89, 2, 'The Synchronize to Database function will give you a full picture of all database differences. Optimism is the one quality more associated with success and happiness than any other.', 3, 'CGRZtxdOQI', '2000-07-19 10:42:54', 3);

-- ----------------------------
-- Table structure for goods_image
-- ----------------------------
DROP TABLE IF EXISTS `goods_image`;
CREATE TABLE `goods_image`  (
  `img_id` int NOT NULL AUTO_INCREMENT COMMENT '图片主键',
  `goods_id` int NOT NULL COMMENT '关联的商品ID',
  `img_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '图片地址',
  `sort_order` int NOT NULL DEFAULT 1 COMMENT '图片顺序（1为第一张/封面）',
  PRIMARY KEY (`img_id`) USING BTREE,
  INDEX `idx_goods_id`(`goods_id` ASC) USING BTREE,
  CONSTRAINT `FK_goods_image_goods` FOREIGN KEY (`goods_id`) REFERENCES `goods` (`goods_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 256 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商品图片表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goods_image
-- ----------------------------
INSERT INTO `goods_image` VALUES (1, 26, 'https://picsum.photos/seed/26/300/300', 1);
INSERT INTO `goods_image` VALUES (2, 89, 'https://picsum.photos/seed/89/300/300', 1);
INSERT INTO `goods_image` VALUES (3, 174, 'https://picsum.photos/seed/174/300/300', 1);
INSERT INTO `goods_image` VALUES (4, 28, 'https://picsum.photos/seed/28/300/300', 1);
INSERT INTO `goods_image` VALUES (5, 170, 'https://picsum.photos/seed/170/300/300', 1);
INSERT INTO `goods_image` VALUES (6, 62, 'https://picsum.photos/seed/62/300/300', 1);
INSERT INTO `goods_image` VALUES (7, 6, 'https://picsum.photos/seed/6/300/300', 1);
INSERT INTO `goods_image` VALUES (8, 64, 'https://picsum.photos/seed/64/300/300', 1);
INSERT INTO `goods_image` VALUES (9, 146, 'https://picsum.photos/seed/146/300/300', 1);
INSERT INTO `goods_image` VALUES (10, 152, 'https://picsum.photos/seed/152/300/300', 1);
INSERT INTO `goods_image` VALUES (11, 159, 'https://picsum.photos/seed/159/300/300', 1);
INSERT INTO `goods_image` VALUES (12, 25, 'https://picsum.photos/seed/25/300/300', 1);
INSERT INTO `goods_image` VALUES (13, 44, 'https://picsum.photos/seed/44/300/300', 1);
INSERT INTO `goods_image` VALUES (14, 97, 'https://picsum.photos/seed/97/300/300', 1);
INSERT INTO `goods_image` VALUES (15, 12, 'https://picsum.photos/seed/12/300/300', 1);
INSERT INTO `goods_image` VALUES (16, 56, 'https://picsum.photos/seed/56/300/300', 1);
INSERT INTO `goods_image` VALUES (17, 59, 'https://picsum.photos/seed/59/300/300', 1);
INSERT INTO `goods_image` VALUES (18, 126, 'https://picsum.photos/seed/126/300/300', 1);
INSERT INTO `goods_image` VALUES (19, 123, 'https://picsum.photos/seed/123/300/300', 1);
INSERT INTO `goods_image` VALUES (20, 181, 'https://picsum.photos/seed/181/300/300', 1);
INSERT INTO `goods_image` VALUES (21, 184, 'https://picsum.photos/seed/184/300/300', 1);
INSERT INTO `goods_image` VALUES (22, 27, 'https://picsum.photos/seed/27/300/300', 1);
INSERT INTO `goods_image` VALUES (23, 92, 'https://picsum.photos/seed/92/300/300', 1);
INSERT INTO `goods_image` VALUES (24, 138, 'https://picsum.photos/seed/138/300/300', 1);
INSERT INTO `goods_image` VALUES (25, 139, 'https://picsum.photos/seed/139/300/300', 1);
INSERT INTO `goods_image` VALUES (26, 15, 'https://picsum.photos/seed/15/300/300', 1);
INSERT INTO `goods_image` VALUES (27, 66, 'https://picsum.photos/seed/66/300/300', 1);
INSERT INTO `goods_image` VALUES (28, 84, 'https://picsum.photos/seed/84/300/300', 1);
INSERT INTO `goods_image` VALUES (29, 150, 'https://picsum.photos/seed/150/300/300', 1);
INSERT INTO `goods_image` VALUES (30, 50, 'https://picsum.photos/seed/50/300/300', 1);
INSERT INTO `goods_image` VALUES (31, 110, 'https://picsum.photos/seed/110/300/300', 1);
INSERT INTO `goods_image` VALUES (32, 111, 'https://picsum.photos/seed/111/300/300', 1);
INSERT INTO `goods_image` VALUES (33, 105, 'https://picsum.photos/seed/105/300/300', 1);
INSERT INTO `goods_image` VALUES (34, 182, 'https://picsum.photos/seed/182/300/300', 1);
INSERT INTO `goods_image` VALUES (35, 101, 'https://picsum.photos/seed/101/300/300', 1);
INSERT INTO `goods_image` VALUES (36, 142, 'https://picsum.photos/seed/142/300/300', 1);
INSERT INTO `goods_image` VALUES (37, 140, 'https://picsum.photos/seed/140/300/300', 1);
INSERT INTO `goods_image` VALUES (38, 175, 'https://picsum.photos/seed/175/300/300', 1);
INSERT INTO `goods_image` VALUES (39, 199, 'https://picsum.photos/seed/199/300/300', 1);
INSERT INTO `goods_image` VALUES (40, 129, 'https://picsum.photos/seed/129/300/300', 1);
INSERT INTO `goods_image` VALUES (41, 187, 'https://picsum.photos/seed/187/300/300', 1);
INSERT INTO `goods_image` VALUES (42, 37, 'https://picsum.photos/seed/37/300/300', 1);
INSERT INTO `goods_image` VALUES (43, 145, 'https://picsum.photos/seed/145/300/300', 1);
INSERT INTO `goods_image` VALUES (44, 176, 'https://picsum.photos/seed/176/300/300', 1);
INSERT INTO `goods_image` VALUES (45, 11, 'https://picsum.photos/seed/11/300/300', 1);
INSERT INTO `goods_image` VALUES (46, 52, 'https://picsum.photos/seed/52/300/300', 1);
INSERT INTO `goods_image` VALUES (47, 57, 'https://picsum.photos/seed/57/300/300', 1);
INSERT INTO `goods_image` VALUES (48, 108, 'https://picsum.photos/seed/108/300/300', 1);
INSERT INTO `goods_image` VALUES (49, 19, 'https://picsum.photos/seed/19/300/300', 1);
INSERT INTO `goods_image` VALUES (50, 147, 'https://picsum.photos/seed/147/300/300', 1);
INSERT INTO `goods_image` VALUES (51, 60, 'https://picsum.photos/seed/60/300/300', 1);
INSERT INTO `goods_image` VALUES (52, 124, 'https://picsum.photos/seed/124/300/300', 1);
INSERT INTO `goods_image` VALUES (53, 161, 'https://picsum.photos/seed/161/300/300', 1);
INSERT INTO `goods_image` VALUES (54, 141, 'https://picsum.photos/seed/141/300/300', 1);
INSERT INTO `goods_image` VALUES (55, 155, 'https://picsum.photos/seed/155/300/300', 1);
INSERT INTO `goods_image` VALUES (56, 143, 'https://picsum.photos/seed/143/300/300', 1);
INSERT INTO `goods_image` VALUES (57, 121, 'https://picsum.photos/seed/121/300/300', 1);
INSERT INTO `goods_image` VALUES (58, 131, 'https://picsum.photos/seed/131/300/300', 1);
INSERT INTO `goods_image` VALUES (59, 169, 'https://picsum.photos/seed/169/300/300', 1);
INSERT INTO `goods_image` VALUES (60, 16, 'https://picsum.photos/seed/16/300/300', 1);
INSERT INTO `goods_image` VALUES (61, 48, 'https://picsum.photos/seed/48/300/300', 1);
INSERT INTO `goods_image` VALUES (62, 34, 'https://picsum.photos/seed/34/300/300', 1);
INSERT INTO `goods_image` VALUES (63, 98, 'https://picsum.photos/seed/98/300/300', 1);
INSERT INTO `goods_image` VALUES (64, 135, 'https://picsum.photos/seed/135/300/300', 1);
INSERT INTO `goods_image` VALUES (65, 188, 'https://picsum.photos/seed/188/300/300', 1);
INSERT INTO `goods_image` VALUES (66, 40, 'https://picsum.photos/seed/40/300/300', 1);
INSERT INTO `goods_image` VALUES (67, 114, 'https://picsum.photos/seed/114/300/300', 1);
INSERT INTO `goods_image` VALUES (68, 128, 'https://picsum.photos/seed/128/300/300', 1);
INSERT INTO `goods_image` VALUES (69, 63, 'https://picsum.photos/seed/63/300/300', 1);
INSERT INTO `goods_image` VALUES (70, 68, 'https://picsum.photos/seed/68/300/300', 1);
INSERT INTO `goods_image` VALUES (71, 70, 'https://picsum.photos/seed/70/300/300', 1);
INSERT INTO `goods_image` VALUES (72, 107, 'https://picsum.photos/seed/107/300/300', 1);
INSERT INTO `goods_image` VALUES (73, 183, 'https://picsum.photos/seed/183/300/300', 1);
INSERT INTO `goods_image` VALUES (74, 79, 'https://picsum.photos/seed/79/300/300', 1);
INSERT INTO `goods_image` VALUES (75, 165, 'https://picsum.photos/seed/165/300/300', 1);
INSERT INTO `goods_image` VALUES (76, 93, 'https://picsum.photos/seed/93/300/300', 1);
INSERT INTO `goods_image` VALUES (77, 151, 'https://picsum.photos/seed/151/300/300', 1);
INSERT INTO `goods_image` VALUES (78, 156, 'https://picsum.photos/seed/156/300/300', 1);
INSERT INTO `goods_image` VALUES (79, 73, 'https://picsum.photos/seed/73/300/300', 1);
INSERT INTO `goods_image` VALUES (80, 81, 'https://picsum.photos/seed/81/300/300', 1);
INSERT INTO `goods_image` VALUES (81, 191, 'https://picsum.photos/seed/191/300/300', 1);
INSERT INTO `goods_image` VALUES (82, 85, 'https://picsum.photos/seed/85/300/300', 1);
INSERT INTO `goods_image` VALUES (83, 149, 'https://picsum.photos/seed/149/300/300', 1);
INSERT INTO `goods_image` VALUES (84, 173, 'https://picsum.photos/seed/173/300/300', 1);
INSERT INTO `goods_image` VALUES (85, 177, 'https://picsum.photos/seed/177/300/300', 1);
INSERT INTO `goods_image` VALUES (86, 17, 'https://picsum.photos/seed/17/300/300', 1);
INSERT INTO `goods_image` VALUES (87, 42, 'https://picsum.photos/seed/42/300/300', 1);
INSERT INTO `goods_image` VALUES (88, 137, 'https://picsum.photos/seed/137/300/300', 1);
INSERT INTO `goods_image` VALUES (89, 113, 'https://picsum.photos/seed/113/300/300', 1);
INSERT INTO `goods_image` VALUES (90, 130, 'https://picsum.photos/seed/130/300/300', 1);
INSERT INTO `goods_image` VALUES (91, 47, 'https://picsum.photos/seed/47/300/300', 1);
INSERT INTO `goods_image` VALUES (92, 195, 'https://picsum.photos/seed/195/300/300', 1);
INSERT INTO `goods_image` VALUES (93, 65, 'https://picsum.photos/seed/65/300/300', 1);
INSERT INTO `goods_image` VALUES (94, 120, 'https://picsum.photos/seed/120/300/300', 1);
INSERT INTO `goods_image` VALUES (95, 157, 'https://picsum.photos/seed/157/300/300', 1);
INSERT INTO `goods_image` VALUES (96, 118, 'https://picsum.photos/seed/118/300/300', 1);
INSERT INTO `goods_image` VALUES (97, 36, 'https://picsum.photos/seed/36/300/300', 1);
INSERT INTO `goods_image` VALUES (98, 122, 'https://picsum.photos/seed/122/300/300', 1);
INSERT INTO `goods_image` VALUES (99, 168, 'https://picsum.photos/seed/168/300/300', 1);
INSERT INTO `goods_image` VALUES (100, 197, 'https://picsum.photos/seed/197/300/300', 1);
INSERT INTO `goods_image` VALUES (101, 43, 'https://picsum.photos/seed/43/300/300', 1);
INSERT INTO `goods_image` VALUES (102, 185, 'https://picsum.photos/seed/185/300/300', 1);
INSERT INTO `goods_image` VALUES (103, 192, 'https://picsum.photos/seed/192/300/300', 1);
INSERT INTO `goods_image` VALUES (104, 136, 'https://picsum.photos/seed/136/300/300', 1);
INSERT INTO `goods_image` VALUES (105, 10, 'https://picsum.photos/seed/10/300/300', 1);
INSERT INTO `goods_image` VALUES (106, 134, 'https://picsum.photos/seed/134/300/300', 1);
INSERT INTO `goods_image` VALUES (107, 193, 'https://picsum.photos/seed/193/300/300', 1);
INSERT INTO `goods_image` VALUES (108, 109, 'https://picsum.photos/seed/109/300/300', 1);
INSERT INTO `goods_image` VALUES (109, 116, 'https://picsum.photos/seed/116/300/300', 1);
INSERT INTO `goods_image` VALUES (110, 22, 'https://picsum.photos/seed/22/300/300', 1);
INSERT INTO `goods_image` VALUES (111, 78, 'https://picsum.photos/seed/78/300/300', 1);
INSERT INTO `goods_image` VALUES (112, 164, 'https://picsum.photos/seed/164/300/300', 1);
INSERT INTO `goods_image` VALUES (113, 72, 'https://picsum.photos/seed/72/300/300', 1);
INSERT INTO `goods_image` VALUES (114, 91, 'https://picsum.photos/seed/91/300/300', 1);
INSERT INTO `goods_image` VALUES (115, 1, 'https://picsum.photos/seed/1/300/300', 1);
INSERT INTO `goods_image` VALUES (116, 125, 'https://picsum.photos/seed/125/300/300', 1);
INSERT INTO `goods_image` VALUES (117, 54, 'https://picsum.photos/seed/54/300/300', 1);
INSERT INTO `goods_image` VALUES (118, 127, 'https://picsum.photos/seed/127/300/300', 1);
INSERT INTO `goods_image` VALUES (119, 180, 'https://picsum.photos/seed/180/300/300', 1);
INSERT INTO `goods_image` VALUES (120, 99, 'https://picsum.photos/seed/99/300/300', 1);
INSERT INTO `goods_image` VALUES (121, 148, 'https://picsum.photos/seed/148/300/300', 1);
INSERT INTO `goods_image` VALUES (122, 20, 'https://picsum.photos/seed/20/300/300', 1);
INSERT INTO `goods_image` VALUES (123, 35, 'https://picsum.photos/seed/35/300/300', 1);
INSERT INTO `goods_image` VALUES (124, 13, 'https://picsum.photos/seed/13/300/300', 1);
INSERT INTO `goods_image` VALUES (125, 86, 'https://picsum.photos/seed/86/300/300', 1);
INSERT INTO `goods_image` VALUES (126, 90, 'https://picsum.photos/seed/90/300/300', 1);
INSERT INTO `goods_image` VALUES (127, 162, 'https://picsum.photos/seed/162/300/300', 1);
INSERT INTO `goods_image` VALUES (128, 196, 'https://picsum.photos/seed/196/300/300', 1);
INSERT INTO `goods_image` VALUES (129, 23, 'https://picsum.photos/seed/23/300/300', 1);
INSERT INTO `goods_image` VALUES (130, 104, 'https://picsum.photos/seed/104/300/300', 1);
INSERT INTO `goods_image` VALUES (131, 153, 'https://picsum.photos/seed/153/300/300', 1);
INSERT INTO `goods_image` VALUES (132, 171, 'https://picsum.photos/seed/171/300/300', 1);
INSERT INTO `goods_image` VALUES (133, 87, 'https://picsum.photos/seed/87/300/300', 1);
INSERT INTO `goods_image` VALUES (134, 158, 'https://picsum.photos/seed/158/300/300', 1);
INSERT INTO `goods_image` VALUES (135, 7, 'https://picsum.photos/seed/7/300/300', 1);
INSERT INTO `goods_image` VALUES (136, 46, 'https://picsum.photos/seed/46/300/300', 1);
INSERT INTO `goods_image` VALUES (137, 82, 'https://picsum.photos/seed/82/300/300', 1);
INSERT INTO `goods_image` VALUES (138, 154, 'https://picsum.photos/seed/154/300/300', 1);
INSERT INTO `goods_image` VALUES (139, 103, 'https://picsum.photos/seed/103/300/300', 1);
INSERT INTO `goods_image` VALUES (140, 58, 'https://picsum.photos/seed/58/300/300', 1);
INSERT INTO `goods_image` VALUES (141, 144, 'https://picsum.photos/seed/144/300/300', 1);
INSERT INTO `goods_image` VALUES (142, 166, 'https://picsum.photos/seed/166/300/300', 1);
INSERT INTO `goods_image` VALUES (143, 55, 'https://picsum.photos/seed/55/300/300', 1);
INSERT INTO `goods_image` VALUES (144, 8, 'https://picsum.photos/seed/8/300/300', 1);
INSERT INTO `goods_image` VALUES (145, 186, 'https://picsum.photos/seed/186/300/300', 1);
INSERT INTO `goods_image` VALUES (146, 32, 'https://picsum.photos/seed/32/300/300', 1);
INSERT INTO `goods_image` VALUES (147, 106, 'https://picsum.photos/seed/106/300/300', 1);
INSERT INTO `goods_image` VALUES (148, 77, 'https://picsum.photos/seed/77/300/300', 1);
INSERT INTO `goods_image` VALUES (149, 133, 'https://picsum.photos/seed/133/300/300', 1);
INSERT INTO `goods_image` VALUES (150, 14, 'https://picsum.photos/seed/14/300/300', 1);
INSERT INTO `goods_image` VALUES (151, 3, 'https://picsum.photos/seed/3/300/300', 1);
INSERT INTO `goods_image` VALUES (152, 167, 'https://picsum.photos/seed/167/300/300', 1);
INSERT INTO `goods_image` VALUES (153, 200, 'https://picsum.photos/seed/200/300/300', 1);
INSERT INTO `goods_image` VALUES (154, 21, 'https://picsum.photos/seed/21/300/300', 1);
INSERT INTO `goods_image` VALUES (155, 53, 'https://picsum.photos/seed/53/300/300', 1);
INSERT INTO `goods_image` VALUES (156, 95, 'https://picsum.photos/seed/95/300/300', 1);
INSERT INTO `goods_image` VALUES (157, 75, 'https://picsum.photos/seed/75/300/300', 1);
INSERT INTO `goods_image` VALUES (158, 178, 'https://picsum.photos/seed/178/300/300', 1);
INSERT INTO `goods_image` VALUES (159, 194, 'https://picsum.photos/seed/194/300/300', 1);
INSERT INTO `goods_image` VALUES (160, 9, 'https://picsum.photos/seed/9/300/300', 1);
INSERT INTO `goods_image` VALUES (161, 179, 'https://picsum.photos/seed/179/300/300', 1);
INSERT INTO `goods_image` VALUES (162, 29, 'https://picsum.photos/seed/29/300/300', 1);
INSERT INTO `goods_image` VALUES (163, 41, 'https://picsum.photos/seed/41/300/300', 1);
INSERT INTO `goods_image` VALUES (164, 117, 'https://picsum.photos/seed/117/300/300', 1);
INSERT INTO `goods_image` VALUES (165, 198, 'https://picsum.photos/seed/198/300/300', 1);
INSERT INTO `goods_image` VALUES (166, 2, 'https://picsum.photos/seed/2/300/300', 1);
INSERT INTO `goods_image` VALUES (167, 30, 'https://picsum.photos/seed/30/300/300', 1);
INSERT INTO `goods_image` VALUES (168, 115, 'https://picsum.photos/seed/115/300/300', 1);
INSERT INTO `goods_image` VALUES (169, 112, 'https://picsum.photos/seed/112/300/300', 1);
INSERT INTO `goods_image` VALUES (170, 61, 'https://picsum.photos/seed/61/300/300', 1);
INSERT INTO `goods_image` VALUES (171, 189, 'https://picsum.photos/seed/189/300/300', 1);
INSERT INTO `goods_image` VALUES (172, 102, 'https://picsum.photos/seed/102/300/300', 1);
INSERT INTO `goods_image` VALUES (173, 119, 'https://picsum.photos/seed/119/300/300', 1);
INSERT INTO `goods_image` VALUES (174, 5, 'https://picsum.photos/seed/5/300/300', 1);
INSERT INTO `goods_image` VALUES (175, 51, 'https://picsum.photos/seed/51/300/300', 1);
INSERT INTO `goods_image` VALUES (176, 31, 'https://picsum.photos/seed/31/300/300', 1);
INSERT INTO `goods_image` VALUES (177, 38, 'https://picsum.photos/seed/38/300/300', 1);
INSERT INTO `goods_image` VALUES (178, 49, 'https://picsum.photos/seed/49/300/300', 1);
INSERT INTO `goods_image` VALUES (179, 67, 'https://picsum.photos/seed/67/300/300', 1);
INSERT INTO `goods_image` VALUES (180, 69, 'https://picsum.photos/seed/69/300/300', 1);
INSERT INTO `goods_image` VALUES (181, 4, 'https://picsum.photos/seed/4/300/300', 1);
INSERT INTO `goods_image` VALUES (182, 24, 'https://picsum.photos/seed/24/300/300', 1);
INSERT INTO `goods_image` VALUES (183, 83, 'https://picsum.photos/seed/83/300/300', 1);
INSERT INTO `goods_image` VALUES (184, 100, 'https://picsum.photos/seed/100/300/300', 1);
INSERT INTO `goods_image` VALUES (185, 39, 'https://picsum.photos/seed/39/300/300', 1);
INSERT INTO `goods_image` VALUES (186, 160, 'https://picsum.photos/seed/160/300/300', 1);
INSERT INTO `goods_image` VALUES (187, 18, 'https://picsum.photos/seed/18/300/300', 1);
INSERT INTO `goods_image` VALUES (188, 94, 'https://picsum.photos/seed/94/300/300', 1);
INSERT INTO `goods_image` VALUES (189, 33, 'https://picsum.photos/seed/33/300/300', 1);
INSERT INTO `goods_image` VALUES (190, 45, 'https://picsum.photos/seed/45/300/300', 1);
INSERT INTO `goods_image` VALUES (191, 71, 'https://picsum.photos/seed/71/300/300', 1);
INSERT INTO `goods_image` VALUES (192, 163, 'https://picsum.photos/seed/163/300/300', 1);
INSERT INTO `goods_image` VALUES (193, 190, 'https://picsum.photos/seed/190/300/300', 1);
INSERT INTO `goods_image` VALUES (194, 96, 'https://picsum.photos/seed/96/300/300', 1);
INSERT INTO `goods_image` VALUES (195, 88, 'https://picsum.photos/seed/88/300/300', 1);
INSERT INTO `goods_image` VALUES (196, 132, 'https://picsum.photos/seed/132/300/300', 1);
INSERT INTO `goods_image` VALUES (197, 172, 'https://picsum.photos/seed/172/300/300', 1);
INSERT INTO `goods_image` VALUES (198, 76, 'https://picsum.photos/seed/76/300/300', 1);
INSERT INTO `goods_image` VALUES (199, 80, 'https://picsum.photos/seed/80/300/300', 1);
INSERT INTO `goods_image` VALUES (200, 74, 'https://picsum.photos/seed/74/300/300', 1);

-- ----------------------------
-- Table structure for message
-- ----------------------------
DROP TABLE IF EXISTS `message`;
CREATE TABLE `message`  (
  `msg_id` int NOT NULL AUTO_INCREMENT,
  `send_user_id` int NOT NULL,
  `receive_user_id` int NOT NULL,
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `is_read` smallint NOT NULL COMMENT '0未读\r\n            1已读',
  `send_time` datetime NOT NULL,
  PRIMARY KEY (`msg_id`) USING BTREE,
  INDEX `FK_rel_user_receive_msg`(`receive_user_id` ASC) USING BTREE,
  INDEX `FK_rel_user_send_msg`(`send_user_id` ASC) USING BTREE,
  CONSTRAINT `FK_rel_user_receive_msg` FOREIGN KEY (`receive_user_id`) REFERENCES `sys_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_rel_user_send_msg` FOREIGN KEY (`send_user_id`) REFERENCES `sys_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 301 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of message
-- ----------------------------
INSERT INTO `message` VALUES (1, 53, 53, 'iMhIlYOTjL', 1, '2003-02-16 12:08:39');
INSERT INTO `message` VALUES (2, 3, 3, 'UMzeKnbeDK', 0, '2016-11-04 13:31:09');
INSERT INTO `message` VALUES (3, 76, 76, 'PAjjFnby9C', 1, '2010-03-24 10:33:12');
INSERT INTO `message` VALUES (4, 6, 6, 'jgv3cBmBBS', 0, '2003-01-19 00:00:45');
INSERT INTO `message` VALUES (5, 28, 28, 'jummIBCQ1h', 0, '2016-05-19 01:45:53');
INSERT INTO `message` VALUES (6, 62, 62, 'B4ww0vqizx', 1, '2014-06-17 08:33:19');
INSERT INTO `message` VALUES (7, 61, 61, 'xGGCYQuZ8X', 0, '2019-10-01 09:11:36');
INSERT INTO `message` VALUES (8, 73, 73, 'LRgdRTHhB0', 0, '2015-06-22 15:33:18');
INSERT INTO `message` VALUES (9, 97, 97, 'paKiu7cYcg', 0, '2007-05-17 01:04:12');
INSERT INTO `message` VALUES (10, 43, 43, 'fpelluo7du', 0, '2009-11-29 00:43:29');
INSERT INTO `message` VALUES (11, 1, 1, 'ZZYYbT4IqV', 1, '2023-01-04 18:55:08');
INSERT INTO `message` VALUES (12, 1, 1, 'Mm24GzWOdJ', 1, '2024-08-14 09:07:24');
INSERT INTO `message` VALUES (13, 39, 39, '0uTqoOfOuO', 0, '2002-04-11 10:58:10');
INSERT INTO `message` VALUES (14, 80, 80, 'SVmwYYGNAl', 0, '2009-09-28 11:00:11');
INSERT INTO `message` VALUES (15, 40, 40, 'sltGe21gPy', 0, '2005-05-21 18:57:23');
INSERT INTO `message` VALUES (16, 10, 10, 'inmKUgvTU7', 0, '2018-12-17 07:49:06');
INSERT INTO `message` VALUES (17, 35, 35, 'DwJZl4x06i', 1, '2004-02-13 01:23:57');
INSERT INTO `message` VALUES (18, 80, 80, 'oxwuzWCC2G', 0, '2023-06-20 13:42:48');
INSERT INTO `message` VALUES (19, 40, 40, 'g9fgkhvBDB', 0, '2015-12-19 10:23:59');
INSERT INTO `message` VALUES (20, 19, 19, 'JMr0wEbysb', 0, '2004-07-23 11:44:46');
INSERT INTO `message` VALUES (21, 75, 75, 'vRPEjSaKLR', 1, '2006-01-27 15:08:07');
INSERT INTO `message` VALUES (22, 19, 19, 'dOiWI6HmWq', 0, '2020-05-31 22:54:13');
INSERT INTO `message` VALUES (23, 41, 41, 'rjMwP9oIIE', 1, '2014-07-04 19:02:22');
INSERT INTO `message` VALUES (24, 20, 20, 'BivSxo7rrB', 1, '2024-12-26 21:13:56');
INSERT INTO `message` VALUES (25, 9, 9, 'x8n7pu9AP6', 1, '2009-11-26 08:55:55');
INSERT INTO `message` VALUES (26, 39, 39, 'Kx8imzoMHY', 0, '2014-02-07 22:46:33');
INSERT INTO `message` VALUES (27, 72, 72, 'ekOZUTB0UL', 1, '2002-06-15 21:13:05');
INSERT INTO `message` VALUES (28, 66, 66, 'Q0lIZ6mBwW', 0, '2009-03-18 12:53:48');
INSERT INTO `message` VALUES (29, 90, 90, 'vj8HTbe8Zk', 1, '2001-01-09 01:39:55');
INSERT INTO `message` VALUES (30, 96, 96, 'lBdg6srHxO', 1, '2014-04-27 06:37:40');
INSERT INTO `message` VALUES (31, 71, 71, 'p4G7aXzxNM', 0, '2011-05-03 02:58:22');
INSERT INTO `message` VALUES (32, 16, 16, 'BRnlR7mhqS', 1, '2019-03-05 01:24:17');
INSERT INTO `message` VALUES (33, 8, 8, 'YBdzoG8S7G', 0, '2006-12-25 01:31:49');
INSERT INTO `message` VALUES (34, 67, 67, 'z2qCtgzo0i', 1, '2022-10-30 12:28:09');
INSERT INTO `message` VALUES (35, 32, 32, '8nmvStUjPU', 0, '2017-07-10 05:43:58');
INSERT INTO `message` VALUES (36, 38, 38, 'A1RxWNIFnG', 1, '2024-11-29 06:45:26');
INSERT INTO `message` VALUES (37, 33, 33, 'JekOn0UR35', 0, '2004-08-15 02:27:37');
INSERT INTO `message` VALUES (38, 59, 59, 'ZN6wQPZKOK', 1, '2019-10-31 14:52:42');
INSERT INTO `message` VALUES (39, 6, 6, 'QkEb05cnmu', 1, '2025-01-17 14:02:51');
INSERT INTO `message` VALUES (40, 74, 74, 'UjsFMRoOZL', 1, '2023-01-28 19:08:47');
INSERT INTO `message` VALUES (41, 93, 93, 'Qu6kJEcKyi', 0, '2020-12-02 13:48:39');
INSERT INTO `message` VALUES (42, 69, 69, 'gVoZiegWs9', 1, '2017-06-18 00:51:17');
INSERT INTO `message` VALUES (43, 21, 21, 'feCpHexCIN', 1, '2007-09-29 00:17:44');
INSERT INTO `message` VALUES (44, 52, 52, '5VJbvfWZJh', 1, '2025-12-19 07:09:48');
INSERT INTO `message` VALUES (45, 65, 65, 'DMRBe85yPR', 0, '2003-09-13 13:05:56');
INSERT INTO `message` VALUES (46, 58, 58, '8PWBA8P28M', 1, '2009-03-18 23:03:24');
INSERT INTO `message` VALUES (47, 31, 31, 'Obdfp1Axik', 1, '2002-08-05 16:03:58');
INSERT INTO `message` VALUES (48, 55, 55, 'aCvLmactyo', 1, '2011-12-24 20:00:36');
INSERT INTO `message` VALUES (49, 55, 55, 'S9t2E6zVkI', 0, '2009-04-23 22:17:02');
INSERT INTO `message` VALUES (50, 10, 10, 'jK1WvQ7v5k', 1, '2017-08-02 16:47:14');
INSERT INTO `message` VALUES (51, 95, 95, '7nBq78gDj7', 0, '2003-10-11 23:23:50');
INSERT INTO `message` VALUES (52, 1, 1, 'ClRynKLoVv', 1, '2002-09-26 21:49:04');
INSERT INTO `message` VALUES (53, 12, 12, '99FQfNjWdl', 1, '2016-12-10 04:01:26');
INSERT INTO `message` VALUES (54, 32, 32, 'jkGfiOWmAK', 0, '2011-01-29 06:30:05');
INSERT INTO `message` VALUES (55, 6, 6, 'ZLyAEOULwB', 1, '2006-03-28 10:09:20');
INSERT INTO `message` VALUES (56, 50, 50, 'V2kPZN08tQ', 1, '2009-05-22 02:03:05');
INSERT INTO `message` VALUES (57, 42, 42, 'u9T9WJlMqp', 1, '2009-03-15 17:24:40');
INSERT INTO `message` VALUES (58, 68, 68, 'k6ZYPaz5qx', 0, '2006-02-19 14:59:29');
INSERT INTO `message` VALUES (59, 99, 99, 'sAA5tpOc3s', 1, '2001-07-25 00:21:30');
INSERT INTO `message` VALUES (60, 80, 80, 'pTDde9RmVx', 0, '2013-07-12 17:54:18');
INSERT INTO `message` VALUES (61, 44, 44, 'tVXU8bsnII', 1, '2025-03-25 19:43:18');
INSERT INTO `message` VALUES (62, 72, 72, '6zZgnqxghO', 0, '2024-04-11 01:18:32');
INSERT INTO `message` VALUES (63, 61, 61, 'UnxqAnalh3', 0, '2006-08-30 16:54:04');
INSERT INTO `message` VALUES (64, 14, 14, '1nvhoPQKEx', 1, '2014-03-04 19:33:26');
INSERT INTO `message` VALUES (65, 53, 53, 'Dwf2owDjnX', 0, '2005-10-31 00:32:03');
INSERT INTO `message` VALUES (66, 23, 23, 'IxKyUc3CR4', 1, '2012-02-26 05:07:39');
INSERT INTO `message` VALUES (67, 63, 63, 'JxrCc83GVa', 0, '2018-02-04 08:57:10');
INSERT INTO `message` VALUES (68, 45, 45, 'Bi6Gu5QroC', 0, '2013-10-11 08:41:34');
INSERT INTO `message` VALUES (69, 82, 82, 'wkEOpUsZcp', 1, '2006-06-08 17:36:21');
INSERT INTO `message` VALUES (70, 56, 56, '5HY7rhLURR', 1, '2005-12-07 14:17:42');
INSERT INTO `message` VALUES (71, 47, 47, 'hM5HUo5V8k', 1, '2002-03-19 07:13:41');
INSERT INTO `message` VALUES (72, 25, 25, 'TIHuIPPTvJ', 0, '2004-08-21 05:06:51');
INSERT INTO `message` VALUES (73, 27, 27, 'UMWa8HuTcj', 1, '2015-01-08 18:17:23');
INSERT INTO `message` VALUES (74, 69, 69, 'rfMZ3EA4WS', 0, '2008-09-19 09:44:39');
INSERT INTO `message` VALUES (75, 32, 32, 'V9UEukMbeb', 0, '2010-02-22 05:57:40');
INSERT INTO `message` VALUES (76, 63, 63, 'LCIS4Aj2mK', 0, '2021-03-09 09:16:44');
INSERT INTO `message` VALUES (77, 83, 83, 'OH5Yl8NvMa', 0, '2023-04-10 06:57:19');
INSERT INTO `message` VALUES (78, 20, 20, 'rvWTxOqeNi', 0, '2023-10-04 11:03:34');
INSERT INTO `message` VALUES (79, 69, 69, 'JcZGXHz4vX', 0, '2016-04-02 11:57:25');
INSERT INTO `message` VALUES (80, 78, 78, 'SEk9x6PBMw', 1, '2008-02-05 12:57:02');
INSERT INTO `message` VALUES (81, 41, 41, '8neODvDCos', 0, '2002-08-07 11:58:03');
INSERT INTO `message` VALUES (82, 28, 28, '8DYu81wRFz', 1, '2002-12-10 06:53:16');
INSERT INTO `message` VALUES (83, 17, 17, 'XtV56vrZTF', 1, '2003-10-17 16:12:12');
INSERT INTO `message` VALUES (84, 99, 99, 'BcoI7UJH7Z', 1, '2019-08-31 12:27:13');
INSERT INTO `message` VALUES (85, 94, 94, 'dH6Yu2xrlc', 0, '2008-07-21 11:25:25');
INSERT INTO `message` VALUES (86, 12, 12, 'LbFynJTQsP', 1, '2026-03-15 07:19:29');
INSERT INTO `message` VALUES (87, 68, 68, 'EW7QoSP6hB', 0, '2008-07-13 22:58:51');
INSERT INTO `message` VALUES (88, 29, 29, 'ClTd6J4eqA', 0, '2014-03-09 12:51:17');
INSERT INTO `message` VALUES (89, 21, 21, 'UEik69itWy', 0, '2021-04-23 23:06:02');
INSERT INTO `message` VALUES (90, 100, 100, 'ODWVcatmPw', 0, '2024-01-19 01:41:18');
INSERT INTO `message` VALUES (91, 61, 61, '2CP48W3xUp', 1, '2005-01-13 03:41:32');
INSERT INTO `message` VALUES (92, 65, 65, '0IqVeYm33C', 0, '2023-12-15 16:47:31');
INSERT INTO `message` VALUES (93, 29, 29, 'abkKU8ocB0', 1, '2014-04-11 02:28:15');
INSERT INTO `message` VALUES (94, 87, 87, 'HxAK3SWLWE', 1, '2014-07-07 17:01:58');
INSERT INTO `message` VALUES (95, 31, 31, '5Y4Uq1JCJL', 0, '2003-06-09 17:43:51');
INSERT INTO `message` VALUES (96, 97, 97, '82oaaLOxIk', 0, '2012-12-02 10:25:27');
INSERT INTO `message` VALUES (97, 40, 40, 'QyDv0QKwd0', 1, '2011-02-02 14:27:47');
INSERT INTO `message` VALUES (98, 50, 50, 'ayTtoetEp5', 1, '2008-06-17 04:52:27');
INSERT INTO `message` VALUES (99, 7, 7, 'kjoLaicOJ5', 0, '2017-11-06 12:28:52');
INSERT INTO `message` VALUES (100, 62, 62, 'H6Ojn52QJ5', 0, '2021-12-02 03:02:57');
INSERT INTO `message` VALUES (101, 66, 66, 'QbAvN4nacR', 0, '2025-02-20 16:41:33');
INSERT INTO `message` VALUES (102, 51, 51, '0CCSLfYoAu', 1, '2017-06-20 03:37:35');
INSERT INTO `message` VALUES (103, 33, 33, 'iImtp8w8d7', 1, '2011-01-17 18:40:36');
INSERT INTO `message` VALUES (104, 65, 65, 'WQAIsZ44tv', 0, '2009-12-01 07:58:57');
INSERT INTO `message` VALUES (105, 65, 65, 'SJaCgdOr2u', 1, '2026-04-29 02:30:54');
INSERT INTO `message` VALUES (106, 83, 83, '6aFkhT1c36', 0, '2006-05-16 09:42:50');
INSERT INTO `message` VALUES (107, 10, 10, 'hMBP0VMbyh', 1, '2008-04-24 01:58:44');
INSERT INTO `message` VALUES (108, 40, 40, 'X2QyFuNGQS', 0, '2003-02-17 08:24:56');
INSERT INTO `message` VALUES (109, 36, 36, 'mSzB0UZ1uz', 0, '2013-04-05 22:53:31');
INSERT INTO `message` VALUES (110, 91, 91, 'e5XE71Orcw', 1, '2020-10-31 16:15:37');
INSERT INTO `message` VALUES (111, 67, 67, '0vlluuwRDs', 1, '2021-10-27 05:42:09');
INSERT INTO `message` VALUES (112, 31, 31, 'YChQp20bGf', 1, '2020-11-17 23:23:27');
INSERT INTO `message` VALUES (113, 53, 53, 'MTHdWFWULF', 1, '2020-04-06 18:12:46');
INSERT INTO `message` VALUES (114, 89, 89, 'uEXSNKTun7', 1, '2008-10-08 06:09:16');
INSERT INTO `message` VALUES (115, 88, 88, 'gq8EMCDlds', 1, '2026-06-24 09:55:29');
INSERT INTO `message` VALUES (116, 36, 36, 'XnMdq4P9tq', 0, '2000-06-09 04:50:58');
INSERT INTO `message` VALUES (117, 15, 15, 'DFk4i7ttPq', 0, '2021-12-21 07:13:45');
INSERT INTO `message` VALUES (118, 94, 94, 'gA5hA0luT0', 0, '2012-07-09 07:26:21');
INSERT INTO `message` VALUES (119, 8, 8, 'cePC6jhztZ', 1, '2003-09-11 01:07:35');
INSERT INTO `message` VALUES (120, 16, 16, 'r4NHFxUBEq', 1, '2000-03-08 09:57:43');
INSERT INTO `message` VALUES (121, 73, 73, 'YnSLfuG0Js', 1, '2017-03-21 19:58:12');
INSERT INTO `message` VALUES (122, 80, 80, 'uIZQcRjRoG', 1, '2026-05-06 21:15:09');
INSERT INTO `message` VALUES (123, 57, 57, 'wx61IJw8om', 1, '2022-12-03 10:45:47');
INSERT INTO `message` VALUES (124, 73, 73, 'UF5WeMnviJ', 1, '2009-12-25 16:29:13');
INSERT INTO `message` VALUES (125, 5, 5, 'IiUPpcyIei', 1, '2007-10-29 07:19:25');
INSERT INTO `message` VALUES (126, 79, 79, '5WUSrSAzmE', 1, '2011-12-18 08:51:33');
INSERT INTO `message` VALUES (127, 63, 63, '0L4lUlZOrq', 0, '2020-02-20 08:54:14');
INSERT INTO `message` VALUES (128, 83, 83, 'ZdBMgl0foS', 1, '2021-06-27 22:35:32');
INSERT INTO `message` VALUES (129, 78, 78, 'FNmwjkZ67J', 1, '2025-07-10 12:27:10');
INSERT INTO `message` VALUES (130, 40, 40, 'HqMjtzhPU5', 1, '2006-09-01 23:03:31');
INSERT INTO `message` VALUES (131, 33, 33, 'cv45zu4Ph3', 0, '2004-10-23 09:55:40');
INSERT INTO `message` VALUES (132, 91, 91, 'riRDtJFHzO', 0, '2020-05-30 18:48:36');
INSERT INTO `message` VALUES (133, 4, 4, '73b2c4KCOv', 1, '2001-12-09 17:03:11');
INSERT INTO `message` VALUES (134, 68, 68, 'mUQfVHUvQK', 1, '2009-11-22 05:07:19');
INSERT INTO `message` VALUES (135, 27, 27, 'noORlkYjcJ', 1, '2014-03-14 06:21:29');
INSERT INTO `message` VALUES (136, 16, 16, 'izoJtdhody', 1, '2018-07-12 03:16:11');
INSERT INTO `message` VALUES (137, 13, 13, 'cAlFERCeOG', 1, '2008-08-17 12:28:47');
INSERT INTO `message` VALUES (138, 47, 47, 'XmlkiMC6cp', 0, '2001-04-06 05:00:00');
INSERT INTO `message` VALUES (139, 42, 42, 'LKLDG4ERE2', 1, '2008-09-17 20:57:05');
INSERT INTO `message` VALUES (140, 17, 17, '7Yb2SW2X9G', 0, '2019-08-11 09:48:41');
INSERT INTO `message` VALUES (141, 27, 27, 'ww4BZzoanh', 0, '2023-11-28 15:46:59');
INSERT INTO `message` VALUES (142, 46, 46, 'HNHmXNiBdm', 1, '2015-10-14 13:32:06');
INSERT INTO `message` VALUES (143, 93, 93, 'vsHzxeQEaH', 1, '2019-10-01 04:33:30');
INSERT INTO `message` VALUES (144, 100, 100, 'NMkRS1cnPU', 1, '2016-09-15 12:18:04');
INSERT INTO `message` VALUES (145, 25, 25, 'Hukx9zgMzz', 0, '2000-09-27 20:35:33');
INSERT INTO `message` VALUES (146, 95, 95, '2Z0sXf7Qej', 0, '2019-07-17 04:06:06');
INSERT INTO `message` VALUES (147, 90, 90, 'dBVAILYt8F', 0, '2012-10-24 06:19:26');
INSERT INTO `message` VALUES (148, 7, 7, '99pzN5l5Uk', 1, '2006-02-11 23:31:11');
INSERT INTO `message` VALUES (149, 54, 54, 'Fe8srETE1z', 0, '2001-05-17 21:11:59');
INSERT INTO `message` VALUES (150, 39, 39, 'UzKcJfhegm', 0, '2010-10-28 21:41:18');
INSERT INTO `message` VALUES (151, 62, 62, '2X4b5VNzsW', 1, '2021-11-16 02:55:12');
INSERT INTO `message` VALUES (152, 69, 69, 'qOaPrRlYY3', 1, '2023-11-07 00:42:53');
INSERT INTO `message` VALUES (153, 89, 89, 'vxNbrhH3hZ', 0, '2003-06-07 19:55:32');
INSERT INTO `message` VALUES (154, 19, 19, 'HLKHEmZX65', 1, '2003-05-16 16:26:32');
INSERT INTO `message` VALUES (155, 15, 15, '71uW9hTfRi', 0, '2017-03-06 21:12:56');
INSERT INTO `message` VALUES (156, 96, 96, '88UjCL0FVY', 1, '2004-05-31 19:39:35');
INSERT INTO `message` VALUES (157, 62, 62, 'ejOFCMQibX', 0, '2009-05-13 14:30:49');
INSERT INTO `message` VALUES (158, 45, 45, 'jm1rv4WaE4', 1, '2017-06-28 11:45:10');
INSERT INTO `message` VALUES (159, 44, 44, 'Pq0ne41w6b', 1, '2014-09-18 16:13:38');
INSERT INTO `message` VALUES (160, 97, 97, 'FRF85xvtKc', 1, '2000-09-14 17:17:43');
INSERT INTO `message` VALUES (161, 20, 20, 'MPiEsZ2C1P', 0, '2014-10-08 00:43:32');
INSERT INTO `message` VALUES (162, 84, 84, 'ajoTPhRig4', 1, '2021-11-10 02:17:22');
INSERT INTO `message` VALUES (163, 67, 67, 'MX5AQ4uifP', 0, '2007-11-25 13:43:49');
INSERT INTO `message` VALUES (164, 41, 41, 'CCO0IeWaaj', 0, '2019-08-11 06:42:13');
INSERT INTO `message` VALUES (165, 13, 13, '91TFjAFbMD', 0, '2007-10-14 11:46:29');
INSERT INTO `message` VALUES (166, 89, 89, 'Pf43lh6Fir', 0, '2018-02-19 02:28:12');
INSERT INTO `message` VALUES (167, 31, 31, 'nU5V2V2hUl', 0, '2007-11-28 01:53:09');
INSERT INTO `message` VALUES (168, 39, 39, 'OzISgfDr0Y', 1, '2010-12-03 04:42:26');
INSERT INTO `message` VALUES (169, 21, 21, '8cT7Hrkn6t', 0, '2017-09-12 23:54:32');
INSERT INTO `message` VALUES (170, 74, 74, 'xXPnIHZ6R3', 0, '2004-03-14 14:40:16');
INSERT INTO `message` VALUES (171, 89, 89, 'TZQXSvd8DB', 1, '2022-11-02 11:37:12');
INSERT INTO `message` VALUES (172, 84, 84, '1YMuaLLTzs', 1, '2003-10-18 10:27:57');
INSERT INTO `message` VALUES (173, 67, 67, 'IUsBru3GVD', 0, '2003-05-07 15:21:02');
INSERT INTO `message` VALUES (174, 41, 41, 'WgDeyaxgNO', 0, '2004-02-10 11:09:38');
INSERT INTO `message` VALUES (175, 25, 25, 'AvbUS3JQIs', 1, '2014-10-16 06:19:42');
INSERT INTO `message` VALUES (176, 65, 65, 'AKqx55heRe', 0, '2004-10-28 10:59:58');
INSERT INTO `message` VALUES (177, 48, 48, 'FKGDMewyUc', 1, '2013-01-07 05:32:31');
INSERT INTO `message` VALUES (178, 78, 78, '8I26QWEoAW', 0, '2020-06-21 19:08:57');
INSERT INTO `message` VALUES (179, 5, 5, 'ukJxfSX4j9', 1, '2014-03-29 01:34:56');
INSERT INTO `message` VALUES (180, 36, 36, 'KzTXkOeBXo', 0, '2024-09-01 04:37:18');
INSERT INTO `message` VALUES (181, 60, 60, 'u8xNdVTRzF', 0, '2018-05-08 07:46:40');
INSERT INTO `message` VALUES (182, 77, 77, 'oo511kPbRe', 0, '2008-02-07 11:20:37');
INSERT INTO `message` VALUES (183, 92, 92, 'aKHwwo5epq', 0, '2005-02-12 10:20:53');
INSERT INTO `message` VALUES (184, 76, 76, 'HZ2PHqM7k2', 0, '2004-09-27 15:29:48');
INSERT INTO `message` VALUES (185, 79, 79, 'OcXNc0Pok9', 1, '2012-07-05 09:29:08');
INSERT INTO `message` VALUES (186, 53, 53, 'ksGR02o4i6', 1, '2000-08-02 18:36:38');
INSERT INTO `message` VALUES (187, 92, 92, 'qOAFAg8k1r', 1, '2023-11-15 14:03:07');
INSERT INTO `message` VALUES (188, 4, 4, 'pLWCK2pjfI', 1, '2015-05-14 02:21:21');
INSERT INTO `message` VALUES (189, 71, 71, 'Wif9lMbOyJ', 0, '2000-09-15 20:00:21');
INSERT INTO `message` VALUES (190, 29, 29, '1pSJlbU36V', 0, '2001-08-08 11:23:44');
INSERT INTO `message` VALUES (191, 55, 55, 'cmFUbE8gzO', 0, '2023-08-13 18:36:53');
INSERT INTO `message` VALUES (192, 70, 70, '3koPONtEFf', 0, '2011-06-16 01:30:33');
INSERT INTO `message` VALUES (193, 29, 29, 'c8Zdn93nEQ', 1, '2019-06-17 15:21:10');
INSERT INTO `message` VALUES (194, 29, 29, 'aKI51BGZpS', 0, '2013-07-26 07:06:03');
INSERT INTO `message` VALUES (195, 71, 71, 'pRhgHK7zlF', 1, '2008-02-01 02:47:53');
INSERT INTO `message` VALUES (196, 51, 51, 'wu2J6SHyOt', 0, '2014-04-18 04:33:52');
INSERT INTO `message` VALUES (197, 16, 16, 'M3VvnuOyO8', 1, '2009-10-03 07:28:13');
INSERT INTO `message` VALUES (198, 47, 47, 'EqW3th89A8', 0, '2008-08-09 04:17:42');
INSERT INTO `message` VALUES (199, 51, 51, 'i0jpjVRB3e', 1, '2000-04-15 13:41:49');
INSERT INTO `message` VALUES (200, 11, 11, 'vmMpTmjvAV', 0, '2018-07-29 14:18:33');
INSERT INTO `message` VALUES (201, 95, 95, 'M8NUkOPI5n', 0, '2008-09-23 04:05:42');
INSERT INTO `message` VALUES (202, 42, 42, '4bpVtei0GT', 1, '2025-08-27 14:46:04');
INSERT INTO `message` VALUES (203, 26, 26, 'QhRiHypftd', 1, '2017-07-22 23:38:36');
INSERT INTO `message` VALUES (204, 28, 28, 'gGyOrxj0HP', 0, '2018-09-13 15:31:35');
INSERT INTO `message` VALUES (205, 84, 84, '2GS6AaG9XP', 1, '2020-04-09 03:55:15');
INSERT INTO `message` VALUES (206, 16, 16, 'YRwolCDkLL', 0, '2006-06-11 02:54:41');
INSERT INTO `message` VALUES (207, 34, 34, 'U1xTDVBrlY', 0, '2001-06-23 01:22:08');
INSERT INTO `message` VALUES (208, 36, 36, 'asU1yNurck', 0, '2023-07-18 07:49:10');
INSERT INTO `message` VALUES (209, 68, 68, 'rohJ96NAPV', 0, '2006-02-18 02:42:27');
INSERT INTO `message` VALUES (210, 72, 72, 'khmLWN3LqB', 1, '2011-09-30 19:46:56');
INSERT INTO `message` VALUES (211, 96, 96, 'n49olTJN4Z', 1, '2018-08-07 08:30:05');
INSERT INTO `message` VALUES (212, 81, 81, '0wLaSGoqAA', 0, '2009-11-18 01:54:54');
INSERT INTO `message` VALUES (213, 44, 44, 'OSOlcmYEX8', 0, '2005-04-27 16:06:50');
INSERT INTO `message` VALUES (214, 86, 86, 'Xo5GquwagQ', 1, '2024-05-27 04:17:33');
INSERT INTO `message` VALUES (215, 90, 90, 'rzq3jKpGMP', 1, '2010-01-15 01:34:19');
INSERT INTO `message` VALUES (216, 98, 98, 'vJxVZ5dFZU', 0, '2012-11-05 19:21:57');
INSERT INTO `message` VALUES (217, 84, 84, 'kNgug1d81c', 0, '2002-12-20 19:50:52');
INSERT INTO `message` VALUES (218, 73, 73, 'T3cxRAk68I', 1, '2011-07-14 13:13:56');
INSERT INTO `message` VALUES (219, 76, 76, 'NBr1rK0yrR', 1, '2005-02-02 22:15:40');
INSERT INTO `message` VALUES (220, 87, 87, '9LHsHToj9f', 1, '2021-12-24 14:30:01');
INSERT INTO `message` VALUES (221, 94, 94, 'Ptw4RBAMbr', 1, '2026-07-18 16:03:41');
INSERT INTO `message` VALUES (222, 46, 46, 'dVQP6SWUbh', 0, '2014-06-24 20:41:32');
INSERT INTO `message` VALUES (223, 33, 33, '2dClFahNIb', 1, '2019-12-29 15:21:19');
INSERT INTO `message` VALUES (224, 33, 33, 'G91UtQhLCO', 0, '2002-04-13 10:10:43');
INSERT INTO `message` VALUES (225, 49, 49, 'yxFS3Lm6Bz', 1, '2020-08-10 18:39:57');
INSERT INTO `message` VALUES (226, 5, 5, 'GIXUPSU02M', 1, '2010-09-11 23:34:24');
INSERT INTO `message` VALUES (227, 52, 52, 'E9pumfNnJF', 1, '2003-05-18 07:22:34');
INSERT INTO `message` VALUES (228, 23, 23, 'qqSSZOdQFH', 0, '2013-05-06 23:49:35');
INSERT INTO `message` VALUES (229, 27, 27, '8n3c72X6TW', 1, '2019-07-02 03:57:34');
INSERT INTO `message` VALUES (230, 16, 16, 'yZyCyZUCQu', 0, '2005-09-07 09:51:52');
INSERT INTO `message` VALUES (231, 52, 52, 'q94mdWh9Pp', 1, '2016-07-21 01:13:10');
INSERT INTO `message` VALUES (232, 4, 4, 'Ha4f808i2G', 0, '2012-03-17 12:30:55');
INSERT INTO `message` VALUES (233, 91, 91, 'jCf88EJNa5', 0, '2023-04-23 03:35:03');
INSERT INTO `message` VALUES (234, 89, 89, 'bBI7KfszWb', 1, '2012-03-15 01:55:20');
INSERT INTO `message` VALUES (235, 75, 75, 'dNGtTfjxE5', 0, '2011-12-15 09:47:48');
INSERT INTO `message` VALUES (236, 88, 88, 'wAlOZ5mbWy', 0, '2000-09-26 00:49:29');
INSERT INTO `message` VALUES (237, 62, 62, 'uhL3WsdgkF', 1, '2010-07-23 17:09:02');
INSERT INTO `message` VALUES (238, 86, 86, 'GeQAqpkFnA', 0, '2006-09-20 14:16:45');
INSERT INTO `message` VALUES (239, 1, 1, 'OOQmkUx5JK', 1, '2002-10-16 02:04:20');
INSERT INTO `message` VALUES (240, 28, 28, 'RpY43AdHzX', 1, '2016-07-05 18:05:54');
INSERT INTO `message` VALUES (241, 16, 16, 'PDCvW1aoFU', 1, '2007-11-06 01:59:02');
INSERT INTO `message` VALUES (242, 2, 2, 'FTKfMPPPUt', 1, '2006-07-26 18:58:38');
INSERT INTO `message` VALUES (243, 95, 95, 'LgyLsrHaq3', 0, '2010-10-15 23:26:38');
INSERT INTO `message` VALUES (244, 96, 96, 'X1zxC412p4', 0, '2025-09-18 01:05:45');
INSERT INTO `message` VALUES (245, 68, 68, '8Yx23ZeJlt', 1, '2016-02-15 12:58:35');
INSERT INTO `message` VALUES (246, 66, 66, 'EIxKDzuKJI', 0, '2022-09-16 06:07:01');
INSERT INTO `message` VALUES (247, 23, 23, '7dH9nJEtz2', 1, '2001-03-25 15:01:57');
INSERT INTO `message` VALUES (248, 81, 81, 'y5oi3FoKhc', 0, '2018-08-20 05:24:06');
INSERT INTO `message` VALUES (249, 50, 50, 'HiMYjSPPV4', 0, '2025-12-04 11:48:43');
INSERT INTO `message` VALUES (250, 97, 97, 'MOoMQrp0Nb', 0, '2014-03-13 05:13:30');
INSERT INTO `message` VALUES (251, 19, 19, '5Q7OSUhBge', 0, '2026-05-15 15:19:36');
INSERT INTO `message` VALUES (252, 3, 3, '6gehrH07gb', 0, '2009-07-07 22:55:48');
INSERT INTO `message` VALUES (253, 96, 96, 'xJKyTnCwnL', 1, '2004-06-18 05:33:58');
INSERT INTO `message` VALUES (254, 31, 31, 'eDUU053a30', 0, '2026-07-03 14:47:57');
INSERT INTO `message` VALUES (255, 67, 67, 'IefhAQLWR1', 1, '2021-12-09 17:04:54');
INSERT INTO `message` VALUES (256, 3, 3, 'ZR0n51szQE', 0, '2024-09-15 22:05:13');
INSERT INTO `message` VALUES (257, 96, 96, '9njM9FIUqV', 1, '2006-02-25 09:53:59');
INSERT INTO `message` VALUES (258, 12, 12, 'DgejEoaOzg', 1, '2015-10-04 03:36:50');
INSERT INTO `message` VALUES (259, 15, 15, 'nI4xL0UQWx', 0, '2024-03-23 03:26:11');
INSERT INTO `message` VALUES (260, 71, 71, '2dLzoLsXiQ', 1, '2019-09-21 16:07:04');
INSERT INTO `message` VALUES (261, 59, 59, 'BWIhurZA88', 1, '2026-09-03 05:38:36');
INSERT INTO `message` VALUES (262, 10, 10, 'u6URul6lJK', 1, '2021-10-19 19:41:16');
INSERT INTO `message` VALUES (263, 24, 24, 'twLCSVe14f', 0, '2003-02-22 04:36:22');
INSERT INTO `message` VALUES (264, 82, 82, 'PAfA5TKO0W', 0, '2017-02-10 07:23:06');
INSERT INTO `message` VALUES (265, 23, 23, 'hIRpNwOXYZ', 0, '2003-03-10 23:32:34');
INSERT INTO `message` VALUES (266, 84, 84, 'JCFfc1TJfq', 0, '2016-02-16 12:43:26');
INSERT INTO `message` VALUES (267, 82, 82, 'v0O2pGMAyL', 0, '2024-06-11 06:52:53');
INSERT INTO `message` VALUES (268, 86, 86, 'ykFNYrME0e', 0, '2024-10-08 22:19:09');
INSERT INTO `message` VALUES (269, 51, 51, 'dcMbSqx3Bs', 0, '2021-03-13 14:57:46');
INSERT INTO `message` VALUES (270, 44, 44, 'xnazK37tDj', 0, '2002-04-20 22:47:16');
INSERT INTO `message` VALUES (271, 56, 56, 'TcJWjOYOmp', 0, '2012-08-17 00:13:26');
INSERT INTO `message` VALUES (272, 54, 54, '3BfmguxLv0', 0, '2020-04-10 04:02:59');
INSERT INTO `message` VALUES (273, 12, 12, '6ccR7qlO8N', 0, '2005-08-16 04:32:26');
INSERT INTO `message` VALUES (274, 26, 26, 'kBzqVOC0AP', 0, '2020-08-12 20:36:58');
INSERT INTO `message` VALUES (275, 87, 87, '0eyuaUdJ2g', 0, '2000-06-18 08:37:40');
INSERT INTO `message` VALUES (276, 97, 97, 'KkYj0DHizn', 0, '2022-01-07 18:01:30');
INSERT INTO `message` VALUES (277, 17, 17, 'FZw3nBtlgr', 1, '2012-01-30 03:05:58');
INSERT INTO `message` VALUES (278, 44, 44, 'h6zP9T3bcN', 0, '2003-11-29 03:31:52');
INSERT INTO `message` VALUES (279, 40, 40, 'D8Bk2iuuy2', 0, '2019-10-01 01:02:39');
INSERT INTO `message` VALUES (280, 75, 75, 'TFaXiEDxqw', 1, '2006-02-25 22:17:56');
INSERT INTO `message` VALUES (281, 47, 47, 'BL8PufaqVx', 1, '2000-12-30 14:59:46');
INSERT INTO `message` VALUES (282, 67, 67, 'ZRlNq4uHv9', 1, '2024-05-06 17:00:18');
INSERT INTO `message` VALUES (283, 95, 95, 'jMlVKYUatQ', 0, '2009-02-11 13:35:04');
INSERT INTO `message` VALUES (284, 67, 67, 'TeaEzfc1Cf', 1, '2012-12-10 17:34:50');
INSERT INTO `message` VALUES (285, 29, 29, '51C53Lf4hz', 0, '2007-11-03 22:16:58');
INSERT INTO `message` VALUES (286, 25, 25, 'EaJwP4l3kg', 1, '2016-08-29 10:38:20');
INSERT INTO `message` VALUES (287, 15, 15, '6YLGaMEDha', 0, '2001-11-14 05:10:47');
INSERT INTO `message` VALUES (288, 25, 25, 'JnK0lDYIpc', 0, '2011-07-08 05:52:45');
INSERT INTO `message` VALUES (289, 96, 96, 'WS5i6Hrvuq', 0, '2019-03-15 17:03:04');
INSERT INTO `message` VALUES (290, 45, 45, 'AkTmQZAKW9', 0, '2013-12-21 06:58:10');
INSERT INTO `message` VALUES (291, 95, 95, 'S88fQdBndZ', 0, '2007-07-28 06:26:19');
INSERT INTO `message` VALUES (292, 76, 76, '1GcuxOC3uo', 0, '2021-12-30 10:17:56');
INSERT INTO `message` VALUES (293, 97, 97, 'I9f0Qr3tLR', 0, '2018-09-27 18:40:08');
INSERT INTO `message` VALUES (294, 29, 29, 'h3qRwcwFR0', 0, '2005-10-17 16:38:12');
INSERT INTO `message` VALUES (295, 48, 48, 'cU0tEaZxTv', 1, '2021-01-22 09:47:35');
INSERT INTO `message` VALUES (296, 49, 49, 'CTB0Pxlzku', 1, '2024-04-21 03:00:19');
INSERT INTO `message` VALUES (297, 51, 51, '5swPQtdKa8', 1, '2001-05-09 20:44:11');
INSERT INTO `message` VALUES (298, 35, 35, 'J6o65p6FxN', 1, '2000-06-02 14:27:27');
INSERT INTO `message` VALUES (299, 95, 95, 'e6MvXUaHd0', 0, '2022-12-27 09:42:05');
INSERT INTO `message` VALUES (300, 18, 18, 'Y9qwWQW8mO', 0, '2014-08-22 01:36:29');

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `order_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '手工生成流水号不自增',
  `seller_id` int NOT NULL,
  `shipping_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '收货地址（交易快照，下单后不变）',
  `goods_id` int NOT NULL,
  `buyer_id` int NOT NULL,
  `order_price` decimal(10, 2) NOT NULL,
  `pay_status` smallint NOT NULL COMMENT '0未支付\r\n            1支付',
  `order_status` smallint NOT NULL COMMENT '0待付款\r\n            1代发货\r\n            2待收货\r\n            3完成\r\n            4取消\r\n            5售后',
  `pay_time` datetime NULL DEFAULT NULL,
  `finish_time` datetime NULL DEFAULT NULL,
  `create_time` datetime NOT NULL,
  PRIMARY KEY (`order_id`) USING BTREE,
  INDEX `FK_rel_goods_create_order`(`goods_id` ASC) USING BTREE,
  INDEX `idx_order_buyer_time`(`buyer_id` ASC, `create_time` ASC) USING BTREE,
  INDEX `idx_order_seller_time`(`seller_id` ASC, `create_time` ASC) USING BTREE,
  CONSTRAINT `FK_rel_goods_create_order` FOREIGN KEY (`goods_id`) REFERENCES `goods` (`goods_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_rel_user_buy_order` FOREIGN KEY (`buyer_id`) REFERENCES `sys_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_rel_user_sell_order` FOREIGN KEY (`seller_id`) REFERENCES `sys_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_order_price` CHECK (`order_price` >= 0),
  CONSTRAINT `chk_order_status` CHECK (`order_status` between 0 and 5),
  CONSTRAINT `chk_pay_status` CHECK (`pay_status` in (0,1))
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES ('1', 21, '南昌大学前湖校区6栋18室', 17, 21, 641.12, 1, 3, '2024-01-01 11:55:48', '2021-10-25 23:33:10', '2010-04-13 04:34:33');
INSERT INTO `orders` VALUES ('10', 26, '南昌大学前湖校区3栋18室', 97, 26, 815.61, 1, 3, '2000-05-09 10:32:43', '2009-03-25 19:36:38', '2003-11-13 12:51:44');
INSERT INTO `orders` VALUES ('100', 28, '南昌大学前湖校区5栋9室', 68, 28, 378.39, 1, 0, '2023-02-17 04:35:53', '2010-04-01 11:06:51', '2012-05-10 18:41:31');
INSERT INTO `orders` VALUES ('101', 11, '南昌大学前湖校区4栋4室', 83, 11, 798.46, 1, 0, '2016-09-15 11:10:50', '2003-08-15 18:43:25', '2010-01-15 16:26:30');
INSERT INTO `orders` VALUES ('102', 75, '南昌大学前湖校区4栋5室', 144, 75, 493.38, 0, 1, '2010-03-02 03:31:41', '2025-01-25 19:18:19', '2005-10-28 22:32:23');
INSERT INTO `orders` VALUES ('103', 16, '南昌大学前湖校区1栋18室', 197, 16, 187.91, 0, 2, '2003-06-13 12:17:22', '2012-10-03 19:46:31', '2009-05-04 04:29:15');
INSERT INTO `orders` VALUES ('104', 37, '南昌大学前湖校区6栋14室', 93, 37, 59.39, 0, 1, '2023-09-16 03:48:49', '2026-06-11 15:50:30', '2013-08-06 01:52:15');
INSERT INTO `orders` VALUES ('105', 54, '南昌大学前湖校区7栋2室', 81, 54, 515.09, 1, 2, '2016-11-24 04:13:38', '2024-04-04 01:10:28', '2000-06-15 05:11:33');
INSERT INTO `orders` VALUES ('106', 19, '南昌大学前湖校区4栋15室', 14, 19, 362.52, 1, 2, '2005-08-02 17:18:09', '2021-11-16 14:56:21', '2003-09-05 18:25:11');
INSERT INTO `orders` VALUES ('107', 64, '南昌大学前湖校区1栋6室', 165, 64, 278.10, 1, 4, '2007-06-15 06:20:10', '2014-07-04 04:34:09', '2014-09-06 19:39:56');
INSERT INTO `orders` VALUES ('108', 10, '南昌大学前湖校区3栋13室', 152, 10, 478.22, 1, 1, '2019-11-22 13:45:15', '2003-06-15 02:38:29', '2012-12-08 23:13:12');
INSERT INTO `orders` VALUES ('109', 74, '南昌大学前湖校区3栋10室', 189, 74, 206.04, 1, 4, '2002-08-31 17:55:54', '2008-01-04 11:26:25', '2003-04-23 02:51:12');
INSERT INTO `orders` VALUES ('11', 47, '南昌大学前湖校区8栋19室', 18, 47, 965.94, 1, 5, '2002-08-14 10:40:04', '2024-09-05 06:13:59', '2020-05-08 17:14:35');
INSERT INTO `orders` VALUES ('110', 5, '南昌大学前湖校区6栋8室', 47, 5, 866.19, 1, 3, '2026-03-30 01:01:55', '2007-08-11 10:20:17', '2026-03-19 06:26:00');
INSERT INTO `orders` VALUES ('111', 79, '南昌大学前湖校区8栋5室', 84, 79, 16.38, 1, 2, '2015-05-16 14:44:26', '2008-07-13 05:10:21', '2020-03-17 21:25:44');
INSERT INTO `orders` VALUES ('112', 41, '南昌大学前湖校区2栋16室', 175, 41, 71.53, 0, 4, '2014-07-25 14:30:45', '2010-07-09 11:37:13', '2006-04-18 22:02:10');
INSERT INTO `orders` VALUES ('113', 21, '南昌大学前湖校区6栋9室', 128, 21, 990.65, 0, 4, '2025-06-17 20:03:46', '2017-12-07 00:00:31', '2010-07-03 15:09:31');
INSERT INTO `orders` VALUES ('114', 32, '南昌大学前湖校区1栋13室', 52, 32, 254.26, 0, 3, '2014-06-24 05:13:27', '2023-01-26 10:22:49', '2014-04-11 07:03:43');
INSERT INTO `orders` VALUES ('115', 54, '南昌大学前湖校区7栋9室', 88, 54, 700.93, 1, 1, '2007-07-02 00:35:04', '2020-04-05 13:38:01', '2001-01-13 11:32:42');
INSERT INTO `orders` VALUES ('116', 38, '南昌大学前湖校区7栋17室', 196, 38, 506.38, 1, 5, '2008-03-30 06:44:11', '2014-07-24 03:27:23', '2022-06-02 11:00:50');
INSERT INTO `orders` VALUES ('117', 54, '南昌大学前湖校区7栋18室', 137, 54, 725.27, 0, 1, '2022-07-26 07:03:54', '2001-04-24 21:14:25', '2022-06-05 01:19:50');
INSERT INTO `orders` VALUES ('118', 18, '南昌大学前湖校区3栋18室', 177, 18, 691.79, 0, 2, '2002-05-07 11:45:00', '2023-12-24 13:58:39', '2020-09-21 01:05:07');
INSERT INTO `orders` VALUES ('119', 95, '南昌大学前湖校区8栋13室', 72, 95, 64.57, 1, 0, '2001-01-21 04:59:49', '2010-05-04 19:07:06', '2010-04-11 04:47:59');
INSERT INTO `orders` VALUES ('12', 53, '南昌大学前湖校区6栋18室', 177, 53, 685.87, 0, 2, '2014-10-02 19:14:10', '2003-04-30 13:57:55', '2008-03-26 21:40:13');
INSERT INTO `orders` VALUES ('120', 46, '南昌大学前湖校区7栋4室', 83, 46, 308.92, 1, 0, '2011-12-22 10:39:30', '2009-06-23 14:55:20', '2016-03-19 12:38:03');
INSERT INTO `orders` VALUES ('121', 31, '南昌大学前湖校区8栋1室', 20, 31, 164.52, 1, 2, '2022-02-02 20:28:19', '2025-09-22 14:06:24', '2002-06-05 15:10:15');
INSERT INTO `orders` VALUES ('122', 24, '南昌大学前湖校区1栋3室', 162, 24, 458.76, 0, 1, '2020-11-30 20:45:14', '2011-12-30 04:55:08', '2012-06-04 18:25:31');
INSERT INTO `orders` VALUES ('123', 6, '南昌大学前湖校区7栋11室', 30, 6, 968.25, 0, 2, '2001-09-03 05:47:54', '2018-02-13 18:00:43', '2013-04-21 10:40:11');
INSERT INTO `orders` VALUES ('124', 37, '南昌大学前湖校区6栋4室', 103, 37, 823.66, 1, 1, '2007-01-28 15:33:52', '2017-09-07 19:26:03', '2018-01-09 02:06:48');
INSERT INTO `orders` VALUES ('125', 40, '南昌大学前湖校区1栋17室', 36, 40, 197.88, 0, 0, '2007-09-20 20:06:34', '2018-06-02 00:56:52', '2000-02-20 22:24:51');
INSERT INTO `orders` VALUES ('126', 23, '南昌大学前湖校区8栋6室', 185, 23, 10.09, 0, 2, '2011-09-19 00:18:10', '2006-09-05 07:05:51', '2004-02-20 06:41:35');
INSERT INTO `orders` VALUES ('127', 58, '南昌大学前湖校区3栋6室', 165, 58, 591.90, 1, 4, '2008-08-31 11:13:18', '2005-11-13 06:52:19', '2009-02-10 18:24:57');
INSERT INTO `orders` VALUES ('128', 38, '南昌大学前湖校区7栋15室', 14, 38, 824.34, 1, 1, '2007-10-23 10:31:13', '2012-09-25 16:59:50', '2006-06-26 12:50:58');
INSERT INTO `orders` VALUES ('129', 97, '南昌大学前湖校区2栋5室', 44, 97, 847.65, 0, 4, '2012-01-02 12:08:06', '2002-05-20 00:45:11', '2022-11-03 10:33:02');
INSERT INTO `orders` VALUES ('13', 91, '南昌大学前湖校区4栋7室', 146, 91, 159.73, 1, 3, '2026-04-28 19:31:20', '2013-03-03 18:21:47', '2011-02-22 01:38:08');
INSERT INTO `orders` VALUES ('130', 10, '南昌大学前湖校区3栋14室', 93, 10, 386.25, 1, 3, '2021-04-19 01:23:39', '2008-05-01 20:05:04', '2017-08-25 09:02:41');
INSERT INTO `orders` VALUES ('131', 22, '南昌大学前湖校区7栋13室', 112, 22, 38.31, 0, 2, '2005-06-30 12:04:05', '2016-09-21 16:56:13', '2009-02-26 17:45:28');
INSERT INTO `orders` VALUES ('132', 50, '南昌大学前湖校区3栋13室', 112, 50, 409.39, 1, 4, '2000-09-21 03:15:23', '2020-08-25 10:28:23', '2026-08-19 16:49:06');
INSERT INTO `orders` VALUES ('133', 53, '南昌大学前湖校区6栋14室', 13, 53, 602.37, 1, 2, '2025-05-27 12:20:44', '2011-05-21 02:45:23', '2002-02-26 17:39:06');
INSERT INTO `orders` VALUES ('134', 37, '南昌大学前湖校区6栋12室', 111, 37, 810.03, 1, 2, '2013-03-03 15:30:23', '2016-05-06 16:39:06', '2006-10-06 06:54:31');
INSERT INTO `orders` VALUES ('135', 45, '南昌大学前湖校区6栋1室', 20, 45, 915.45, 1, 5, '2023-06-13 05:45:55', '2008-02-03 15:51:40', '2007-05-20 00:58:18');
INSERT INTO `orders` VALUES ('136', 15, '南昌大学前湖校区8栋12室', 51, 15, 578.60, 1, 2, '2000-09-25 10:29:56', '2025-07-27 13:11:15', '2017-01-06 02:08:28');
INSERT INTO `orders` VALUES ('137', 59, '南昌大学前湖校区4栋18室', 157, 59, 972.29, 0, 5, '2020-10-03 01:59:12', '2020-11-28 05:53:05', '2008-03-10 12:14:21');
INSERT INTO `orders` VALUES ('138', 10, '南昌大学前湖校区3栋3室', 102, 10, 213.71, 1, 5, '2021-01-20 02:48:58', '2005-10-30 20:36:32', '2010-08-29 23:50:16');
INSERT INTO `orders` VALUES ('139', 20, '南昌大学前湖校区5栋1室', 60, 20, 365.51, 1, 4, '2006-09-21 21:52:28', '2025-05-05 23:14:23', '2014-11-13 07:42:36');
INSERT INTO `orders` VALUES ('14', 31, '南昌大学前湖校区8栋4室', 43, 31, 259.45, 1, 2, '2018-03-10 21:53:17', '2017-12-14 18:55:29', '2004-02-11 12:15:26');
INSERT INTO `orders` VALUES ('140', 100, '南昌大学前湖校区5栋1室', 20, 100, 463.43, 0, 0, '2007-04-20 21:26:49', '2021-10-05 19:55:41', '2015-03-31 06:16:51');
INSERT INTO `orders` VALUES ('141', 27, '南昌大学前湖校区4栋10室', 189, 27, 950.54, 1, 2, '2003-03-08 23:59:32', '2010-08-17 02:45:35', '2026-06-17 19:47:54');
INSERT INTO `orders` VALUES ('142', 48, '南昌大学前湖校区1栋12室', 191, 48, 856.38, 1, 2, '2007-06-26 14:19:51', '2022-05-27 22:04:47', '2023-11-03 15:59:01');
INSERT INTO `orders` VALUES ('143', 67, '南昌大学前湖校区4栋6室', 185, 67, 850.93, 0, 5, '2026-01-30 22:18:54', '2024-01-12 16:29:04', '2024-09-29 03:55:28');
INSERT INTO `orders` VALUES ('144', 80, '南昌大学前湖校区1栋20室', 79, 80, 26.92, 1, 3, '2024-04-12 05:31:35', '2018-01-23 22:16:59', '2015-11-08 16:16:04');
INSERT INTO `orders` VALUES ('145', 84, '南昌大学前湖校区5栋16室', 35, 84, 47.87, 1, 5, '2003-07-29 20:15:59', '2006-05-18 16:20:21', '2005-06-18 05:42:05');
INSERT INTO `orders` VALUES ('146', 28, '南昌大学前湖校区5栋13室', 92, 28, 945.58, 1, 4, '2011-07-23 13:52:36', '2025-03-03 21:12:15', '2018-11-07 00:25:38');
INSERT INTO `orders` VALUES ('147', 26, '南昌大学前湖校区3栋19室', 178, 26, 173.43, 0, 4, '2015-04-24 03:17:05', '2020-05-27 16:48:03', '2018-01-21 08:21:45');
INSERT INTO `orders` VALUES ('148', 45, '南昌大学前湖校区6栋19室', 138, 45, 963.11, 1, 3, '2016-11-11 13:02:16', '2005-11-24 13:05:53', '2017-03-24 01:31:15');
INSERT INTO `orders` VALUES ('149', 39, '南昌大学前湖校区8栋12室', 91, 39, 258.43, 1, 0, '2014-05-27 16:53:47', '2006-03-25 08:31:08', '2010-12-18 04:15:37');
INSERT INTO `orders` VALUES ('15', 80, '南昌大学前湖校区1栋20室', 19, 80, 17.02, 0, 1, '2023-03-31 03:38:45', '2024-08-06 04:02:24', '2025-04-29 14:40:35');
INSERT INTO `orders` VALUES ('150', 32, '南昌大学前湖校区1栋15室', 114, 32, 242.83, 1, 2, '2025-06-11 08:10:55', '2004-09-22 10:00:26', '2000-06-11 01:53:15');
INSERT INTO `orders` VALUES ('151', 11, '南昌大学前湖校区4栋20室', 39, 11, 505.55, 1, 5, '2013-08-09 22:32:44', '2017-02-03 03:15:21', '2014-08-04 18:23:27');
INSERT INTO `orders` VALUES ('152', 11, '南昌大学前湖校区4栋20室', 139, 11, 160.26, 0, 1, '2009-02-09 19:16:17', '2005-10-10 21:43:53', '2004-03-06 02:39:33');
INSERT INTO `orders` VALUES ('153', 23, '南昌大学前湖校区8栋7室', 166, 23, 938.39, 0, 2, '2023-04-24 03:02:43', '2012-09-10 08:38:48', '2010-05-29 11:54:05');
INSERT INTO `orders` VALUES ('154', 87, '南昌大学前湖校区8栋17室', 196, 87, 485.53, 1, 4, '2009-06-05 07:10:30', '2008-03-01 09:32:29', '2019-07-15 22:46:05');
INSERT INTO `orders` VALUES ('155', 28, '南昌大学前湖校区5栋13室', 132, 28, 266.25, 0, 3, '2004-04-01 01:17:14', '2015-05-28 22:32:09', '2015-02-20 05:58:53');
INSERT INTO `orders` VALUES ('156', 52, '南昌大学前湖校区5栋14室', 33, 52, 215.49, 1, 2, '2002-10-31 04:07:52', '2019-03-14 06:40:18', '2015-07-15 06:57:07');
INSERT INTO `orders` VALUES ('157', 95, '南昌大学前湖校区8栋14室', 53, 95, 845.81, 0, 0, '2004-08-22 11:37:07', '2018-04-14 14:55:34', '2011-01-25 09:05:33');
INSERT INTO `orders` VALUES ('158', 63, '南昌大学前湖校区8栋15室', 14, 63, 590.32, 0, 3, '2012-12-04 22:32:50', '2024-01-12 22:08:34', '2008-03-11 22:28:10');
INSERT INTO `orders` VALUES ('159', 88, '南昌大学前湖校区1栋2室', 121, 88, 229.93, 1, 3, '2007-07-04 23:18:24', '2019-02-11 05:08:02', '2006-05-20 20:39:51');
INSERT INTO `orders` VALUES ('16', 22, '南昌大学前湖校区7栋14室', 153, 22, 836.35, 0, 3, '2015-09-01 01:51:20', '2008-05-13 10:31:19', '2013-12-05 03:13:01');
INSERT INTO `orders` VALUES ('160', 81, '南昌大学前湖校区2栋18室', 77, 81, 801.42, 0, 3, '2020-06-25 07:01:43', '2012-08-27 22:33:04', '2007-11-14 07:57:22');
INSERT INTO `orders` VALUES ('161', 7, '南昌大学前湖校区8栋20室', 179, 7, 533.01, 0, 1, '2006-08-04 10:08:25', '2023-07-01 16:51:23', '2010-05-12 14:29:40');
INSERT INTO `orders` VALUES ('162', 3, '南昌大学前湖校区4栋7室', 86, 3, 141.07, 0, 1, '2008-12-05 13:09:27', '2026-03-24 15:33:03', '2010-06-28 15:16:27');
INSERT INTO `orders` VALUES ('163', 33, '南昌大学前湖校区2栋13室', 52, 33, 874.63, 0, 2, '2000-05-19 22:59:10', '2006-01-04 06:36:32', '2015-05-24 10:29:14');
INSERT INTO `orders` VALUES ('164', 23, '南昌大学前湖校区8栋15室', 174, 23, 326.37, 0, 1, '2026-05-28 09:03:55', '2013-03-12 01:25:52', '2017-08-17 15:47:18');
INSERT INTO `orders` VALUES ('165', 29, '南昌大学前湖校区6栋16室', 155, 29, 50.33, 1, 3, '2009-02-12 12:14:04', '2002-03-06 04:53:36', '2026-07-11 03:15:44');
INSERT INTO `orders` VALUES ('166', 32, '南昌大学前湖校区1栋6室', 25, 32, 327.56, 0, 3, '2023-05-22 20:50:54', '2012-08-03 13:02:28', '2016-01-22 16:34:17');
INSERT INTO `orders` VALUES ('167', 38, '南昌大学前湖校区7栋6室', 145, 38, 619.94, 0, 2, '2026-08-26 19:14:45', '2001-07-23 12:06:40', '2007-05-18 03:31:29');
INSERT INTO `orders` VALUES ('168', 10, '南昌大学前湖校区3栋5室', 44, 10, 687.05, 1, 4, '2024-08-07 05:31:36', '2021-08-06 03:29:44', '2007-02-06 18:10:59');
INSERT INTO `orders` VALUES ('169', 82, '南昌大学前湖校区3栋6室', 125, 82, 362.60, 1, 2, '2006-06-23 22:36:36', '2001-12-30 22:55:34', '2017-03-16 15:55:25');
INSERT INTO `orders` VALUES ('17', 21, '南昌大学前湖校区6栋5室', 44, 21, 290.18, 0, 3, '2025-10-05 22:29:56', '2021-09-28 17:41:14', '2000-09-12 12:23:14');
INSERT INTO `orders` VALUES ('170', 7, '南昌大学前湖校区8栋17室', 176, 7, 958.59, 1, 3, '2008-10-29 17:42:52', '2001-06-29 05:28:32', '2021-11-18 19:16:59');
INSERT INTO `orders` VALUES ('171', 16, '南昌大学前湖校区1栋13室', 152, 16, 491.38, 1, 3, '2008-12-20 04:28:36', '2025-11-10 17:46:45', '2024-06-19 18:27:09');
INSERT INTO `orders` VALUES ('172', 14, '南昌大学前湖校区7栋4室', 23, 14, 197.72, 1, 3, '2009-10-07 18:40:07', '2001-05-07 08:44:24', '2019-09-24 10:06:32');
INSERT INTO `orders` VALUES ('173', 50, '南昌大学前湖校区3栋2室', 41, 50, 967.26, 1, 3, '2002-12-11 20:33:27', '2020-01-03 07:18:46', '2016-01-11 20:21:44');
INSERT INTO `orders` VALUES ('174', 16, '南昌大学前湖校区1栋11室', 190, 16, 745.60, 0, 3, '2016-05-12 17:22:35', '2003-03-29 07:37:36', '2006-06-26 05:02:59');
INSERT INTO `orders` VALUES ('175', 41, '南昌大学前湖校区2栋6室', 85, 41, 340.92, 0, 4, '2006-08-10 08:35:29', '2012-02-17 11:30:54', '2000-05-28 12:51:45');
INSERT INTO `orders` VALUES ('176', 23, '南昌大学前湖校区8栋6室', 185, 23, 581.08, 1, 4, '2024-04-06 22:29:56', '2000-09-20 11:07:10', '2017-04-14 06:10:01');
INSERT INTO `orders` VALUES ('177', 88, '南昌大学前湖校区1栋14室', 53, 88, 468.83, 1, 0, '2016-12-16 03:29:40', '2013-04-30 02:20:33', '2001-04-24 17:51:49');
INSERT INTO `orders` VALUES ('178', 29, '南昌大学前湖校区6栋16室', 175, 29, 175.72, 0, 3, '2014-09-18 05:19:58', '2023-10-01 09:11:30', '2012-11-17 01:28:38');
INSERT INTO `orders` VALUES ('179', 17, '南昌大学前湖校区2栋2室', 81, 17, 633.52, 0, 5, '2004-11-18 14:12:01', '2013-02-07 17:29:04', '2016-11-07 01:08:17');
INSERT INTO `orders` VALUES ('18', 72, '南昌大学前湖校区1栋4室', 143, 72, 966.31, 1, 3, '2010-10-04 13:52:55', '2012-10-16 06:46:09', '2024-03-23 08:45:49');
INSERT INTO `orders` VALUES ('180', 67, '南昌大学前湖校区4栋5室', 84, 67, 337.33, 1, 5, '2011-11-05 12:23:32', '2000-09-08 09:40:14', '2019-10-23 00:40:56');
INSERT INTO `orders` VALUES ('181', 100, '南昌大学前湖校区5栋10室', 69, 100, 420.72, 0, 5, '2010-12-31 11:29:32', '2007-04-15 23:35:53', '2020-08-12 11:08:35');
INSERT INTO `orders` VALUES ('182', 50, '南昌大学前湖校区3栋5室', 104, 50, 313.48, 1, 1, '2025-08-12 03:44:16', '2000-02-02 02:52:52', '2020-02-11 12:53:22');
INSERT INTO `orders` VALUES ('183', 51, '南昌大学前湖校区4栋16室', 195, 51, 744.89, 0, 3, '2021-10-23 18:24:16', '2003-11-29 15:18:45', '2015-07-17 01:13:13');
INSERT INTO `orders` VALUES ('184', 66, '南昌大学前湖校区3栋16室', 35, 66, 359.64, 1, 5, '2024-04-23 04:45:22', '2000-01-09 09:38:57', '2012-10-13 19:07:14');
INSERT INTO `orders` VALUES ('185', 71, '南昌大学前湖校区8栋20室', 139, 71, 572.70, 0, 4, '2016-11-18 02:13:46', '2001-08-23 09:44:26', '2016-09-02 06:48:48');
INSERT INTO `orders` VALUES ('186', 23, '南昌大学前湖校区8栋4室', 143, 23, 73.52, 0, 2, '2025-10-30 20:38:03', '2025-01-16 18:25:14', '2017-09-07 23:51:12');
INSERT INTO `orders` VALUES ('187', 57, '南昌大学前湖校区2栋10室', 89, 57, 490.33, 1, 0, '2007-04-04 01:21:24', '2026-09-04 21:49:58', '2019-02-06 23:50:56');
INSERT INTO `orders` VALUES ('188', 70, '南昌大学前湖校区7栋7室', 6, 70, 961.78, 1, 1, '2016-11-14 18:51:17', '2000-07-11 14:53:50', '2020-06-28 10:07:47');
INSERT INTO `orders` VALUES ('189', 49, '南昌大学前湖校区2栋8室', 167, 49, 619.67, 1, 3, '2015-04-29 14:56:08', '2000-12-20 22:57:52', '2004-12-21 08:42:55');
INSERT INTO `orders` VALUES ('19', 68, '南昌大学前湖校区5栋6室', 105, 68, 406.29, 0, 1, '2014-03-15 03:57:17', '2017-12-10 19:30:11', '2018-08-17 22:56:38');
INSERT INTO `orders` VALUES ('190', 26, '南昌大学前湖校区3栋17室', 56, 26, 402.74, 1, 2, '2011-10-26 05:43:02', '2015-08-19 16:51:11', '2015-08-06 06:24:59');
INSERT INTO `orders` VALUES ('191', 91, '南昌大学前湖校区4栋14室', 73, 91, 917.61, 1, 1, '2020-10-14 10:28:27', '2011-03-08 01:02:50', '2000-05-12 18:47:00');
INSERT INTO `orders` VALUES ('192', 92, '南昌大学前湖校区5栋17室', 76, 92, 46.76, 1, 3, '2005-05-16 20:55:59', '2011-10-08 20:38:27', '2000-01-23 19:58:35');
INSERT INTO `orders` VALUES ('193', 68, '南昌大学前湖校区5栋2室', 61, 68, 784.43, 1, 4, '2002-10-09 08:37:57', '2008-03-18 16:13:07', '2004-09-06 11:32:37');
INSERT INTO `orders` VALUES ('194', 79, '南昌大学前湖校区8栋12室', 111, 79, 259.20, 1, 5, '2026-01-22 06:33:30', '2014-07-29 17:38:47', '2012-02-15 21:51:00');
INSERT INTO `orders` VALUES ('195', 81, '南昌大学前湖校区2栋6室', 185, 81, 417.00, 0, 4, '2001-02-12 06:53:58', '2016-07-15 07:49:01', '2019-01-06 03:46:42');
INSERT INTO `orders` VALUES ('196', 59, '南昌大学前湖校区4栋20室', 59, 59, 97.16, 1, 3, '2023-10-26 09:44:15', '2025-10-13 00:22:10', '2025-07-09 19:49:58');
INSERT INTO `orders` VALUES ('197', 43, '南昌大学前湖校区4栋9室', 68, 43, 128.55, 0, 1, '2007-09-09 23:11:54', '2020-10-16 21:11:48', '2026-05-02 02:56:34');
INSERT INTO `orders` VALUES ('198', 34, '南昌大学前湖校区3栋14室', 113, 34, 805.56, 0, 1, '2020-10-11 22:42:13', '2015-03-25 23:26:51', '2011-07-12 06:24:26');
INSERT INTO `orders` VALUES ('199', 100, '南昌大学前湖校区5栋20室', 79, 100, 69.01, 1, 1, '2018-11-21 18:29:04', '2021-03-14 23:12:56', '2016-11-01 04:58:17');
INSERT INTO `orders` VALUES ('2', 58, '南昌大学前湖校区3栋7室', 126, 58, 475.97, 0, 4, '2013-12-03 15:08:24', '2003-05-29 00:11:23', '2012-02-28 20:40:08');
INSERT INTO `orders` VALUES ('20', 59, '南昌大学前湖校区4栋5室', 84, 59, 701.90, 0, 2, '2022-07-22 06:13:57', '2016-11-13 18:30:48', '2014-10-28 17:24:04');
INSERT INTO `orders` VALUES ('200', 31, '南昌大学前湖校区8栋1室', 60, 31, 417.76, 1, 1, '2016-03-25 10:32:46', '2010-02-10 16:56:04', '2001-03-24 02:33:16');
INSERT INTO `orders` VALUES ('21', 95, '南昌大学前湖校区8栋13室', 92, 95, 916.00, 1, 2, '2008-03-26 07:28:53', '2016-09-12 05:24:33', '2019-09-12 10:45:02');
INSERT INTO `orders` VALUES ('22', 33, '南昌大学前湖校区2栋6室', 105, 33, 115.19, 1, 0, '2018-10-09 14:13:43', '2003-07-06 16:27:58', '2008-11-07 08:08:32');
INSERT INTO `orders` VALUES ('23', 89, '南昌大学前湖校区2栋7室', 186, 89, 607.33, 1, 2, '2009-07-04 20:41:38', '2010-09-02 01:08:41', '2006-07-16 00:31:20');
INSERT INTO `orders` VALUES ('24', 98, '南昌大学前湖校区3栋16室', 155, 98, 883.29, 1, 0, '2009-02-26 18:26:35', '2025-08-10 11:49:35', '2018-06-16 02:28:27');
INSERT INTO `orders` VALUES ('25', 62, '南昌大学前湖校区7栋4室', 163, 62, 733.95, 1, 2, '2011-12-29 20:24:50', '2014-08-11 09:10:42', '2007-03-31 10:28:05');
INSERT INTO `orders` VALUES ('26', 24, '南昌大学前湖校区1栋13室', 52, 24, 508.15, 0, 4, '2022-03-09 04:18:33', '2007-06-02 10:02:04', '2025-11-05 04:55:09');
INSERT INTO `orders` VALUES ('27', 21, '南昌大学前湖校区6栋19室', 18, 21, 217.79, 1, 3, '2014-08-12 04:24:00', '2000-09-09 15:00:42', '2003-07-03 22:11:36');
INSERT INTO `orders` VALUES ('28', 58, '南昌大学前湖校区3栋10室', 189, 58, 158.80, 0, 2, '2012-11-13 21:08:56', '2014-01-01 14:50:53', '2010-10-06 00:00:40');
INSERT INTO `orders` VALUES ('29', 98, '南昌大学前湖校区3栋4室', 123, 98, 935.63, 0, 0, '2010-04-14 09:14:08', '2015-08-01 19:50:26', '2006-10-11 19:14:10');
INSERT INTO `orders` VALUES ('3', 28, '南昌大学前湖校区5栋2室', 161, 28, 225.46, 1, 2, '2014-12-12 15:44:32', '2025-08-31 03:42:27', '2023-01-08 02:05:08');
INSERT INTO `orders` VALUES ('30', 84, '南昌大学前湖校区5栋3室', 142, 84, 946.31, 1, 4, '2003-01-17 23:57:36', '2001-08-21 03:34:51', '2000-04-23 16:27:33');
INSERT INTO `orders` VALUES ('31', 50, '南昌大学前湖校区3栋6室', 65, 50, 768.07, 0, 0, '2009-12-25 13:26:00', '2015-12-02 11:41:56', '2012-10-31 23:54:17');
INSERT INTO `orders` VALUES ('32', 71, '南昌大学前湖校区8栋5室', 4, 71, 222.46, 0, 4, '2017-01-07 14:38:38', '2018-09-07 19:45:41', '2021-06-09 19:13:25');
INSERT INTO `orders` VALUES ('33', 60, '南昌大学前湖校区5栋7室', 126, 60, 896.37, 0, 5, '2019-06-11 03:47:48', '2000-07-03 01:49:35', '2022-01-19 01:46:55');
INSERT INTO `orders` VALUES ('34', 15, '南昌大学前湖校区8栋3室', 122, 15, 828.80, 0, 3, '2008-03-29 14:42:29', '2000-03-30 06:55:54', '2025-08-11 15:34:18');
INSERT INTO `orders` VALUES ('35', 49, '南昌大学前湖校区2栋12室', 151, 49, 275.70, 0, 2, '2014-05-31 12:24:46', '2022-07-11 16:35:58', '2008-03-23 10:19:30');
INSERT INTO `orders` VALUES ('36', 30, '南昌大学前湖校区7栋16室', 15, 30, 156.98, 1, 4, '2017-05-30 18:09:20', '2021-08-13 09:41:27', '2003-05-05 17:38:56');
INSERT INTO `orders` VALUES ('37', 30, '南昌大学前湖校区7栋7室', 166, 30, 75.75, 1, 4, '2013-06-13 19:44:30', '2012-06-01 19:48:14', '2019-09-24 19:06:19');
INSERT INTO `orders` VALUES ('38', 9, '南昌大学前湖校区2栋9室', 188, 9, 201.72, 0, 4, '2019-04-01 17:13:59', '2010-10-15 09:53:26', '2001-05-07 13:34:31');
INSERT INTO `orders` VALUES ('39', 87, '南昌大学前湖校区8栋9室', 148, 87, 190.62, 0, 1, '2003-01-11 13:35:44', '2016-04-19 12:29:06', '2024-08-05 12:00:52');
INSERT INTO `orders` VALUES ('4', 86, '南昌大学前湖校区7栋2室', 81, 86, 789.97, 0, 1, '2009-11-04 06:54:07', '2012-05-04 00:02:11', '2005-01-17 19:21:27');
INSERT INTO `orders` VALUES ('40', 33, '南昌大学前湖校区2栋9室', 28, 33, 876.32, 1, 3, '2002-01-05 17:08:21', '2017-12-04 15:09:59', '2005-11-26 18:05:55');
INSERT INTO `orders` VALUES ('41', 26, '南昌大学前湖校区3栋2室', 161, 26, 616.80, 1, 4, '2006-07-20 20:45:40', '2004-09-01 12:37:57', '2022-10-31 06:56:36');
INSERT INTO `orders` VALUES ('42', 1, '南昌大学前湖校区2栋15室', 114, 1, 497.55, 0, 4, '2022-03-01 09:21:44', '2003-12-02 21:46:36', '2010-04-29 17:45:17');
INSERT INTO `orders` VALUES ('43', 62, '南昌大学前湖校区7栋14室', 133, 62, 972.25, 0, 4, '2026-07-24 11:43:28', '2011-04-07 20:27:53', '2017-12-02 17:23:57');
INSERT INTO `orders` VALUES ('44', 5, '南昌大学前湖校区6栋1室', 140, 5, 545.47, 0, 1, '2008-05-01 17:44:13', '2007-12-29 18:43:27', '2007-11-21 17:46:51');
INSERT INTO `orders` VALUES ('45', 65, '南昌大学前湖校区2栋8室', 107, 65, 225.07, 0, 5, '2024-05-01 09:24:33', '2007-06-21 22:37:14', '2024-12-05 08:01:44');
INSERT INTO `orders` VALUES ('46', 13, '南昌大学前湖校区6栋7室', 26, 13, 610.64, 1, 3, '2017-12-19 12:31:00', '2014-12-29 16:30:12', '2010-03-01 19:22:47');
INSERT INTO `orders` VALUES ('47', 73, '南昌大学前湖校区2栋11室', 30, 73, 528.58, 1, 5, '2002-10-21 07:32:17', '2020-04-12 10:21:21', '2024-01-27 19:00:01');
INSERT INTO `orders` VALUES ('48', 24, '南昌大学前湖校区1栋1室', 200, 24, 475.82, 1, 3, '2003-06-07 21:46:29', '2014-01-03 05:56:03', '2025-06-06 16:48:39');
INSERT INTO `orders` VALUES ('49', 88, '南昌大学前湖校区1栋4室', 163, 88, 294.60, 0, 2, '2005-01-12 10:35:19', '2014-10-29 13:28:33', '2024-06-19 21:05:05');
INSERT INTO `orders` VALUES ('5', 67, '南昌大学前湖校区4栋18室', 77, 67, 183.59, 1, 4, '2020-11-12 05:55:32', '2015-08-01 18:51:07', '2006-12-27 17:27:28');
INSERT INTO `orders` VALUES ('50', 18, '南昌大学前湖校区3栋7室', 186, 18, 93.66, 1, 2, '2017-01-11 13:47:24', '2008-02-28 02:11:25', '2010-12-22 16:10:38');
INSERT INTO `orders` VALUES ('51', 68, '南昌大学前湖校区5栋4室', 123, 68, 998.81, 1, 3, '2024-10-14 18:54:57', '2010-06-25 02:04:20', '2024-08-19 00:40:01');
INSERT INTO `orders` VALUES ('52', 89, '南昌大学前湖校区2栋14室', 93, 89, 804.54, 0, 2, '2004-01-26 18:23:33', '2021-11-22 14:00:47', '2014-07-27 12:07:17');
INSERT INTO `orders` VALUES ('53', 92, '南昌大学前湖校区5栋19室', 118, 92, 676.33, 0, 2, '2005-05-31 01:39:30', '2020-04-05 07:26:06', '2015-01-08 14:50:31');
INSERT INTO `orders` VALUES ('54', 23, '南昌大学前湖校区8栋8室', 187, 23, 314.53, 1, 2, '2011-07-12 04:43:17', '2004-04-08 09:58:07', '2007-05-27 02:51:38');
INSERT INTO `orders` VALUES ('55', 84, '南昌大学前湖校区5栋18室', 97, 84, 952.79, 0, 4, '2013-10-22 06:25:35', '2009-12-16 15:58:32', '2008-01-03 22:37:18');
INSERT INTO `orders` VALUES ('56', 39, '南昌大学前湖校区8栋14室', 53, 39, 852.34, 0, 1, '2014-06-30 19:58:14', '2005-07-12 09:38:57', '2020-09-11 15:47:49');
INSERT INTO `orders` VALUES ('57', 74, '南昌大学前湖校区3栋9室', 188, 74, 587.61, 1, 3, '2013-03-10 05:37:05', '2014-02-26 13:58:34', '2010-04-30 02:30:01');
INSERT INTO `orders` VALUES ('58', 19, '南昌大学前湖校区4栋9室', 68, 19, 895.41, 0, 4, '2012-03-11 04:44:22', '2004-04-05 11:24:53', '2022-08-02 11:43:14');
INSERT INTO `orders` VALUES ('59', 74, '南昌大学前湖校区3栋19室', 198, 74, 139.98, 1, 3, '2011-06-02 21:45:12', '2005-06-30 13:13:26', '2025-10-12 21:57:58');
INSERT INTO `orders` VALUES ('6', 24, '南昌大学前湖校区1栋14室', 53, 24, 17.04, 0, 3, '2018-09-24 01:09:18', '2003-06-26 22:34:57', '2005-10-14 15:35:25');
INSERT INTO `orders` VALUES ('60', 29, '南昌大学前湖校区6栋10室', 29, 29, 403.24, 0, 0, '2017-04-02 03:13:32', '2012-03-08 16:01:52', '2008-01-04 14:38:31');
INSERT INTO `orders` VALUES ('61', 13, '南昌大学前湖校区6栋13室', 172, 13, 321.81, 1, 0, '2025-08-14 10:36:21', '2012-08-10 10:12:56', '2012-07-14 16:07:13');
INSERT INTO `orders` VALUES ('62', 73, '南昌大学前湖校区2栋13室', 112, 73, 346.50, 0, 1, '2019-04-08 15:22:46', '2008-03-23 10:47:13', '2023-08-27 14:18:51');
INSERT INTO `orders` VALUES ('63', 76, '南昌大学前湖校区5栋16室', 175, 76, 169.30, 0, 2, '2020-10-10 20:45:08', '2002-09-13 08:28:26', '2015-05-18 19:53:55');
INSERT INTO `orders` VALUES ('64', 76, '南昌大学前湖校区5栋8室', 67, 76, 867.80, 1, 4, '2025-11-25 08:25:59', '2005-07-19 11:18:42', '2012-10-01 13:12:53');
INSERT INTO `orders` VALUES ('65', 24, '南昌大学前湖校区1栋10室', 89, 24, 591.96, 0, 1, '2009-06-28 05:54:59', '2005-03-03 17:41:02', '2022-06-25 07:27:14');
INSERT INTO `orders` VALUES ('66', 85, '南昌大学前湖校区6栋3室', 162, 85, 630.26, 0, 5, '2019-11-14 06:52:49', '2009-09-27 00:44:19', '2012-09-09 03:49:48');
INSERT INTO `orders` VALUES ('67', 12, '南昌大学前湖校区5栋19室', 118, 12, 880.93, 1, 0, '2003-01-04 19:17:28', '2018-04-26 17:12:25', '2008-10-30 18:58:05');
INSERT INTO `orders` VALUES ('68', 97, '南昌大学前湖校区2栋19室', 178, 97, 151.12, 0, 3, '2018-08-24 02:54:08', '2009-07-05 15:05:53', '2004-12-20 06:01:04');
INSERT INTO `orders` VALUES ('69', 95, '南昌大学前湖校区8栋4室', 163, 95, 964.52, 0, 3, '2019-03-30 07:31:51', '2007-04-13 05:59:14', '2014-08-04 23:35:23');
INSERT INTO `orders` VALUES ('7', 56, '南昌大学前湖校区1栋4室', 23, 56, 448.67, 1, 0, '2005-01-30 07:02:29', '2002-06-12 12:33:33', '2018-04-05 16:41:50');
INSERT INTO `orders` VALUES ('70', 96, '南昌大学前湖校区1栋11室', 70, 96, 878.42, 0, 0, '2002-10-28 15:30:10', '2014-07-12 02:16:23', '2006-07-15 23:02:28');
INSERT INTO `orders` VALUES ('71', 22, '南昌大学前湖校区7栋7室', 46, 22, 398.02, 1, 4, '2001-12-26 01:59:13', '2021-12-07 14:08:55', '2010-06-19 07:23:06');
INSERT INTO `orders` VALUES ('72', 93, '南昌大学前湖校区6栋7室', 166, 93, 472.58, 0, 5, '2025-11-15 14:57:41', '2005-11-23 12:50:43', '2006-04-13 16:02:32');
INSERT INTO `orders` VALUES ('73', 61, '南昌大学前湖校区6栋13室', 152, 61, 72.87, 0, 4, '2018-01-13 06:34:55', '2012-05-11 01:07:52', '2023-09-17 01:31:33');
INSERT INTO `orders` VALUES ('74', 43, '南昌大学前湖校区4栋7室', 66, 43, 780.74, 0, 4, '2001-07-16 06:43:15', '2015-03-16 16:03:57', '2004-09-11 10:57:08');
INSERT INTO `orders` VALUES ('75', 29, '南昌大学前湖校区6栋8室', 167, 29, 722.81, 0, 2, '2016-08-01 17:15:01', '2025-11-09 01:08:09', '2003-09-21 06:33:53');
INSERT INTO `orders` VALUES ('76', 24, '南昌大学前湖校区1栋12室', 11, 24, 36.61, 1, 1, '2025-04-24 00:04:06', '2007-04-24 15:40:39', '2007-04-04 10:41:33');
INSERT INTO `orders` VALUES ('77', 37, '南昌大学前湖校区6栋9室', 8, 37, 58.07, 1, 4, '2004-03-20 18:42:35', '2016-01-10 19:37:12', '2010-09-04 05:05:28');
INSERT INTO `orders` VALUES ('78', 65, '南昌大学前湖校区2栋4室', 63, 65, 268.73, 1, 2, '2026-08-02 23:49:55', '2025-07-15 02:24:34', '2013-05-26 17:22:41');
INSERT INTO `orders` VALUES ('79', 66, '南昌大学前湖校区3栋4室', 123, 66, 919.82, 0, 3, '2021-04-25 15:38:17', '2024-02-03 12:45:33', '2026-02-28 05:29:21');
INSERT INTO `orders` VALUES ('8', 85, '南昌大学前湖校区6栋1室', 200, 85, 773.90, 1, 1, '2022-06-13 12:28:26', '2010-05-01 19:15:00', '2026-09-08 23:04:49');
INSERT INTO `orders` VALUES ('80', 94, '南昌大学前湖校区7栋7室', 166, 94, 625.20, 0, 2, '2023-02-26 22:32:57', '2012-12-02 04:53:35', '2010-05-20 05:09:38');
INSERT INTO `orders` VALUES ('81', 83, '南昌大学前湖校区4栋11室', 150, 83, 578.81, 0, 0, '2005-08-10 03:33:25', '2007-05-27 09:07:37', '2020-02-28 09:47:39');
INSERT INTO `orders` VALUES ('82', 61, '南昌大学前湖校区6栋18室', 57, 61, 222.21, 1, 3, '2018-01-16 19:36:50', '2012-02-01 05:57:16', '2021-09-30 06:45:16');
INSERT INTO `orders` VALUES ('83', 43, '南昌大学前湖校区4栋11室', 10, 43, 732.18, 0, 2, '2014-05-31 22:53:09', '2017-08-16 12:16:31', '2003-03-24 04:18:47');
INSERT INTO `orders` VALUES ('84', 79, '南昌大学前湖校区8栋16室', 75, 79, 560.38, 0, 2, '2004-06-06 01:19:03', '2006-02-28 02:36:26', '2011-12-15 22:35:54');
INSERT INTO `orders` VALUES ('85', 30, '南昌大学前湖校区7栋10室', 69, 30, 831.88, 0, 4, '2014-12-23 09:17:27', '2020-01-28 01:31:39', '2019-05-03 03:59:53');
INSERT INTO `orders` VALUES ('86', 30, '南昌大学前湖校区7栋8室', 147, 30, 46.21, 0, 1, '2018-12-10 22:48:46', '2007-02-20 05:15:45', '2010-02-01 01:21:17');
INSERT INTO `orders` VALUES ('87', 52, '南昌大学前湖校区5栋12室', 191, 52, 429.93, 0, 4, '2011-01-15 17:58:55', '2012-09-10 08:39:57', '2018-11-05 15:37:10');
INSERT INTO `orders` VALUES ('88', 60, '南昌大学前湖校区5栋12室', 91, 60, 826.94, 0, 1, '2005-12-29 02:40:17', '2010-12-14 05:41:45', '2018-11-04 06:29:43');
INSERT INTO `orders` VALUES ('89', 85, '南昌大学前湖校区6栋6室', 5, 85, 36.48, 0, 3, '2021-10-08 05:19:56', '2025-08-07 13:21:30', '2001-06-13 20:18:45');
INSERT INTO `orders` VALUES ('9', 1, '南昌大学前湖校区2栋14室', 13, 1, 130.16, 1, 5, '2026-04-01 00:11:17', '2019-06-07 18:28:47', '2005-07-03 18:39:51');
INSERT INTO `orders` VALUES ('90', 69, '南昌大学前湖校区6栋19室', 158, 69, 558.59, 0, 1, '2006-12-29 09:09:10', '2004-02-26 03:42:28', '2019-04-20 06:04:44');
INSERT INTO `orders` VALUES ('91', 65, '南昌大学前湖校区2栋17室', 136, 65, 307.46, 0, 0, '2015-11-08 18:24:54', '2002-08-20 02:07:26', '2012-06-17 07:37:01');
INSERT INTO `orders` VALUES ('92', 24, '南昌大学前湖校区1栋18室', 197, 24, 135.52, 1, 5, '2019-06-30 18:40:28', '2004-11-03 11:26:03', '2009-05-10 02:32:20');
INSERT INTO `orders` VALUES ('93', 30, '南昌大学前湖校区7栋3室', 102, 30, 220.04, 1, 5, '2002-07-26 12:25:48', '2023-05-07 04:57:18', '2005-07-14 16:12:23');
INSERT INTO `orders` VALUES ('94', 44, '南昌大学前湖校区5栋13室', 72, 44, 87.45, 1, 4, '2006-02-14 00:25:17', '2019-03-09 08:02:05', '2007-04-21 12:58:30');
INSERT INTO `orders` VALUES ('95', 10, '南昌大学前湖校区3栋9室', 68, 10, 558.60, 0, 3, '2021-09-24 20:30:06', '2024-11-14 13:04:06', '2024-09-17 12:30:21');
INSERT INTO `orders` VALUES ('96', 80, '南昌大学前湖校区1栋10室', 9, 80, 163.98, 1, 3, '2006-02-17 18:26:40', '2010-12-17 04:54:52', '2017-01-19 02:00:29');
INSERT INTO `orders` VALUES ('97', 6, '南昌大学前湖校区7栋5室', 44, 6, 474.58, 1, 3, '2022-09-13 03:29:23', '2012-12-09 11:31:21', '2012-07-04 14:06:42');
INSERT INTO `orders` VALUES ('98', 66, '南昌大学前湖校区3栋4室', 23, 66, 86.80, 0, 1, '2019-07-16 19:20:51', '2014-09-05 20:27:11', '2004-01-29 09:26:29');
INSERT INTO `orders` VALUES ('99', 4, '南昌大学前湖校区5栋5室', 24, 4, 912.10, 0, 1, '2013-04-04 22:32:55', '2019-07-21 00:25:33', '2006-04-15 03:16:27');

-- ----------------------------
-- Table structure for report
-- ----------------------------
DROP TABLE IF EXISTS `report`;
CREATE TABLE `report`  (
  `report_id` int NOT NULL AUTO_INCREMENT COMMENT '自增',
  `user_id` int NOT NULL COMMENT '自增主键',
  `goods_id` int NOT NULL COMMENT '被举报商品ID',
  `report_type` smallint NOT NULL COMMENT '1:假冒伪劣, 2:欺诈行为, 3:辱骂骚扰, 4:违规违禁品, 5:其他',
  `report_content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `proof_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `handle_status` smallint NOT NULL COMMENT '0:待处理, 1:已处理',
  `result` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `report_time` datetime NOT NULL,
  PRIMARY KEY (`report_id`) USING BTREE,
  INDEX `FK_rel_user_create_report`(`user_id` ASC) USING BTREE,
  INDEX `FK_rel_report_goods`(`goods_id` ASC) USING BTREE,
  CONSTRAINT `FK_rel_user_create_report` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_rel_report_goods` FOREIGN KEY (`goods_id`) REFERENCES `goods` (`goods_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_handle_status` CHECK (`handle_status` in (0,1)),
  CONSTRAINT `chk_report_type` CHECK (`report_type` between 1 and 5)
) ENGINE = InnoDB AUTO_INCREMENT = 201 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of report
-- ----------------------------
INSERT INTO `report` VALUES (1, 96, 81, 3, 'LZ0HOpzZkQ', 'https://picsumKphotos/seed/report_353/300/300', 0, '3wAmoqfrbt', '2024-07-16 02:05:29');
INSERT INTO `report` VALUES (2, 17, 114, 3, 'SU6M3lQO64', NULL, 1, 'Kk20cBDlbx', '2021-06-25 04:22:16');
INSERT INTO `report` VALUES (3, 73, 167, 2, 'jAICbVfz8q', NULL, 1, 'fvGawVa8Zj', '2020-04-13 21:13:10');
INSERT INTO `report` VALUES (4, 36, 66, 4, 'PrluFptscB', NULL, 0, 'mZRg6Jxm4j', '2026-06-17 09:15:55');
INSERT INTO `report` VALUES (5, 14, 191, 2, 'qRLkyB6Ofm', NULL, 1, 'ScUIIdzJZg', '2021-08-29 04:29:16');
INSERT INTO `report` VALUES (6, 33, 193, 5, 'AJd1S4bPav', NULL, 0, 'L5sBU9Setn', '2014-06-11 08:17:03');
INSERT INTO `report` VALUES (7, 69, 174, 4, 'DGxBzGDGOG', NULL, 1, 'c1iPL1xQo3', '2025-10-25 11:26:07');
INSERT INTO `report` VALUES (8, 95, 144, 2, 'bQkQHCiqoS', NULL, 1, 'MrjXpV92iD', '2021-04-05 18:56:06');
INSERT INTO `report` VALUES (9, 75, 104, 4, 'RZaJfwTCXK', NULL, 0, 'mpYWfSaHSG', '2010-11-04 01:39:12');
INSERT INTO `report` VALUES (10, 9, 54, 2, 'GIB9WHPfrW', NULL, 1, 'R6ENGA5OIf', '2014-07-28 10:37:28');
INSERT INTO `report` VALUES (11, 51, 144, 2, 'OG5gbnLr6d', 'https://picsumKphotos/seed/report_9541/300/300', 1, 'FfXoO2Pcem', '2000-05-23 16:40:12');
INSERT INTO `report` VALUES (12, 97, 158, 3, '3osJjLkPTQ', NULL, 1, 'ByrFtoKpVz', '2026-04-27 00:28:36');
INSERT INTO `report` VALUES (13, 5, 3, 4, 'Bl6cAWdF6C', NULL, 0, 'gCMxoq1SLu', '2009-01-01 16:08:22');
INSERT INTO `report` VALUES (14, 64, 8, 4, 'venTdCTsBr', NULL, 0, '66U0gFYmVe', '2016-12-27 09:55:40');
INSERT INTO `report` VALUES (15, 81, 162, 2, 'OYreoks1OK', NULL, 1, 'ITTiVL5fHK', '2023-01-06 00:12:55');
INSERT INTO `report` VALUES (16, 44, 102, 4, 'WUKZoc5l2c', NULL, 0, 'YBcI9tQ0yB', '2015-09-20 00:22:34');
INSERT INTO `report` VALUES (17, 93, 159, 1, 'Hw1PHLKjDP', 'https://picsum|photos/seed/report_4828/300/300', 0, 'Rx7tIKx6IL', '2003-12-13 15:47:28');
INSERT INTO `report` VALUES (18, 93, 120, 3, 'K1U6Nxodao', 'https://picsumxphotos/seed/report_024/300/300', 1, 'cLGhnufq1M', '2001-06-23 03:01:58');
INSERT INTO `report` VALUES (19, 18, 144, 2, 'qvEbFlln36', NULL, 1, 'BuUGVJbNUf', '2001-01-18 01:29:19');
INSERT INTO `report` VALUES (20, 47, 54, 4, 'xxZyn8fNRr', 'https://picsumhphotos/seed/report_55/300/300', 0, 'T4uceS9HZI', '2019-04-02 18:47:19');
INSERT INTO `report` VALUES (21, 90, 54, 3, 'GVQ2tzRsCp', NULL, 0, 'XXHjf5I4MN', '2008-03-02 16:49:28');
INSERT INTO `report` VALUES (22, 66, 81, 2, '1fNTDXo6B7', 'https://picsumhphotos/seed/report_716/300/300', 1, 'bYJ1JiFbl2', '2007-10-30 01:49:46');
INSERT INTO `report` VALUES (23, 98, 154, 2, 'eChsTYgc6x', NULL, 1, 'AKMApzeJIp', '2007-08-30 06:39:39');
INSERT INTO `report` VALUES (24, 37, 132, 4, 'dJLIm1sQyR', 'https://picsum6photos/seed/report_57452/300/300', 1, 'F4qFA0zuqn', '2020-09-27 18:28:36');
INSERT INTO `report` VALUES (25, 31, 97, 2, 'EnoD4sEZzv', NULL, 1, '59ZntjpVDR', '2009-12-25 17:33:48');
INSERT INTO `report` VALUES (26, 93, 133, 4, 'NNubEvlREo', 'https://picsum}photos/seed/report_145/300/300', 0, 'sXrHrsKwEe', '2007-08-07 01:25:23');
INSERT INTO `report` VALUES (27, 73, 176, 1, 'e0vkALcW98', NULL, 0, 'Ons0s5j7CP', '2009-08-20 04:36:24');
INSERT INTO `report` VALUES (28, 65, 79, 4, 'ZvTuHdiuQc', NULL, 0, '8oD8A3FD5c', '2011-01-18 00:42:27');
INSERT INTO `report` VALUES (29, 81, 22, 2, 'JQJZM35a1e', NULL, 1, 'oLJXGdkLMK', '2001-02-28 23:00:43');
INSERT INTO `report` VALUES (30, 72, 192, 1, 'F3iL3V2QbS', NULL, 1, 'oiIcPhGS5h', '2008-08-25 02:08:06');
INSERT INTO `report` VALUES (31, 34, 24, 5, 'C1gz8xLRt4', 'https://picsum0photos/seed/report_00756/300/300', 0, 'BmhzbdMrPh', '2019-12-17 00:19:08');
INSERT INTO `report` VALUES (32, 42, 87, 3, '5hGx5cYFwg', NULL, 1, 'Nb3AVvUSkw', '2007-08-14 06:55:21');
INSERT INTO `report` VALUES (33, 91, 140, 4, 'PyHSygk8if', NULL, 1, 'Kx8AiuB4eY', '2016-12-05 06:12:16');
INSERT INTO `report` VALUES (34, 98, 172, 1, 'YZIVnRSfWc', NULL, 0, 'lhaBAXqpRz', '2014-11-16 13:18:59');
INSERT INTO `report` VALUES (35, 39, 111, 2, '4GWwkVV0ri', NULL, 0, 'cB3ncZHxfw', '2015-02-07 10:26:40');
INSERT INTO `report` VALUES (36, 69, 149, 2, 'HNgaPm56Ej', 'https://picsumEphotos/seed/report_834/300/300', 0, 'sfUXofGo44', '2010-04-23 00:38:16');
INSERT INTO `report` VALUES (37, 99, 17, 1, '5MUnRtrPyo', NULL, 1, 'dDI6MVxMSG', '2018-11-30 13:42:41');
INSERT INTO `report` VALUES (38, 93, 80, 5, 'y82lEaK1xi', NULL, 1, 'zoDgEVdbGU', '2007-07-27 10:19:46');
INSERT INTO `report` VALUES (39, 54, 45, 4, 'auCyGwPAXg', NULL, 1, 'D9cdxvMddp', '2019-03-02 01:41:49');
INSERT INTO `report` VALUES (40, 23, 160, 4, 'wM0Ng1IUEC', NULL, 1, 'yUE2gM4cGO', '2015-02-17 00:56:04');
INSERT INTO `report` VALUES (41, 49, 74, 5, 'qGKfotPIMP', 'https://picsum:photos/seed/report_7/300/300', 1, 'bjhSX0VQgs', '2007-03-05 08:01:00');
INSERT INTO `report` VALUES (42, 92, 42, 1, 'RHKWO58TQ1', NULL, 1, 'tW1WCrAugY', '2001-02-17 18:18:17');
INSERT INTO `report` VALUES (43, 30, 77, 4, 'KLvaFBzvFs', 'https://picsumXphotos/seed/report_116/300/300', 1, 'Mbz3vdKnuR', '2009-02-01 11:29:42');
INSERT INTO `report` VALUES (44, 95, 128, 2, 'F7Nqs70Akk', 'https://picsum!photos/seed/report_180/300/300', 1, 'bpQz0vxJpF', '2011-03-01 12:25:31');
INSERT INTO `report` VALUES (45, 29, 178, 5, 'dN1foTb5P3', NULL, 1, 'W8IFZxYU9a', '2002-03-21 08:07:04');
INSERT INTO `report` VALUES (46, 78, 79, 4, '2HzB47kyrk', 'https://picsumMphotos/seed/report_60/300/300', 1, 'YxdWPoVUgj', '2009-12-22 16:25:07');
INSERT INTO `report` VALUES (47, 58, 6, 1, 'pqDYZ6tGtm', NULL, 1, 'RQw655My92', '2006-12-05 21:38:52');
INSERT INTO `report` VALUES (48, 46, 141, 1, 'Ct1mVGcrZS', 'https://picsum/photos/seed/report_0094/300/300', 0, 'gyYlyiosAX', '2001-11-27 13:03:12');
INSERT INTO `report` VALUES (49, 17, 133, 3, 'cacQxKeqs8', NULL, 1, '70bYTLFf2t', '2004-08-18 22:53:08');
INSERT INTO `report` VALUES (50, 1, 30, 2, '8Hw5obcQJW', NULL, 0, 'UX2bJuONd2', '2020-01-28 18:28:03');
INSERT INTO `report` VALUES (51, 80, 115, 1, 'GljTSNVdNK', NULL, 1, 'F0RtSr1IMg', '2024-01-15 21:15:06');
INSERT INTO `report` VALUES (52, 71, 62, 2, 'jSkJ3oMflG', NULL, 1, 'C2I2Jrkvav', '2026-03-01 03:51:47');
INSERT INTO `report` VALUES (53, 77, 170, 1, 'qsVudwQ3A4', NULL, 0, 'yu5kvgSv68', '2023-12-03 22:59:00');
INSERT INTO `report` VALUES (54, 80, 55, 4, 'dlsPjDx10R', NULL, 0, 'O0Sbmc1rQ3', '2018-06-26 18:02:04');
INSERT INTO `report` VALUES (55, 39, 113, 4, '4W4dGpIS38', NULL, 1, 'ffn1f8ZgPE', '2017-10-24 17:07:15');
INSERT INTO `report` VALUES (56, 70, 15, 4, 'KXOFUqSy7V', NULL, 0, 'OCOajkkpeU', '2022-06-28 20:18:54');
INSERT INTO `report` VALUES (57, 1, 94, 5, 'sRLhpSuixb', NULL, 1, 'iU7hbwCGum', '2024-09-27 03:49:01');
INSERT INTO `report` VALUES (58, 20, 160, 2, 'JxqwR8tmnK', NULL, 0, 'M2ioStFqUu', '2016-09-09 17:01:00');
INSERT INTO `report` VALUES (59, 86, 155, 1, 'cKSmt8NdKY', NULL, 1, 'GtGBHtuAyE', '2025-12-18 15:05:44');
INSERT INTO `report` VALUES (60, 29, 184, 3, 'gPVIt1jLsW', NULL, 1, 'HJnaXi67QZ', '2018-09-09 21:28:11');
INSERT INTO `report` VALUES (61, 36, 191, 3, 'OP1dMJ4ONJ', NULL, 1, 'oCT4mZSBKd', '2016-03-23 11:32:00');
INSERT INTO `report` VALUES (62, 73, 52, 5, 'xVnE5mr43g', NULL, 0, 'GDgQJwUO2r', '2015-12-03 15:13:26');
INSERT INTO `report` VALUES (63, 62, 163, 1, 'Um5FlxU38C', NULL, 1, '2xwgq2SrM7', '2022-10-02 01:17:47');
INSERT INTO `report` VALUES (64, 9, 158, 2, 'zRMjOUbnY0', 'https://picsumjphotos/seed/report_1581/300/300', 1, 'qn1e8pReit', '2011-02-20 14:03:30');
INSERT INTO `report` VALUES (65, 38, 69, 2, 'HW58Z5A7Pz', NULL, 1, 'zShkL8aTh8', '2025-02-22 13:03:36');
INSERT INTO `report` VALUES (66, 94, 168, 4, 'nFPSt3xtA2', NULL, 1, 'p2GdcLHyS3', '2006-09-28 16:51:59');
INSERT INTO `report` VALUES (67, 13, 167, 2, 'fwpSf07xho', NULL, 1, '3C93U2QeOM', '2012-10-12 12:21:40');
INSERT INTO `report` VALUES (68, 71, 125, 1, 'wlasnRjUH4', NULL, 1, 'vxSvEMcEPE', '2008-06-30 00:16:05');
INSERT INTO `report` VALUES (69, 68, 188, 3, 'lQnTfgBcUG', 'https://picsumcphotos/seed/report_8/300/300', 1, 'uen2rleG7B', '2003-10-07 20:49:32');
INSERT INTO `report` VALUES (70, 47, 33, 1, 'u3fz6b5Vam', NULL, 1, '4S7guykbEY', '2023-05-13 03:12:02');
INSERT INTO `report` VALUES (71, 57, 134, 3, 'Bz2hEaz1Us', 'https://picsumvphotos/seed/report_061/300/300', 0, 'KWMNHiBLmq', '2022-09-23 06:42:07');
INSERT INTO `report` VALUES (72, 65, 94, 2, 'RbxMTKVNz6', NULL, 0, 'RqwRaCfuEt', '2012-04-02 16:09:13');
INSERT INTO `report` VALUES (73, 6, 180, 3, 'P0WQkEc3Np', NULL, 0, 'UuEBeq3zsT', '2019-10-17 09:54:29');
INSERT INTO `report` VALUES (74, 50, 150, 5, 'bmkIQUW0Ho', NULL, 1, 'yrFYa5N46t', '2019-04-01 18:25:50');
INSERT INTO `report` VALUES (75, 28, 184, 4, '2ENKqjxctM', NULL, 1, 'bz8k5RyRCd', '2024-05-22 23:52:43');
INSERT INTO `report` VALUES (76, 49, 45, 2, 'JiW3IDeI1O', 'https://picsumkphotos/seed/report_3814/300/300', 0, 'KH6IyABLbk', '2015-02-28 12:07:04');
INSERT INTO `report` VALUES (77, 46, 23, 3, 'Ogw8mXsEpM', NULL, 0, 'GnMZUFedTY', '2019-05-27 18:09:21');
INSERT INTO `report` VALUES (78, 88, 54, 4, 'APrdue4XHs', 'https://picsumqphotos/seed/report_7/300/300', 0, 'k0NFSciVgb', '2012-11-14 11:11:31');
INSERT INTO `report` VALUES (79, 31, 146, 3, 'Hu9uo4NUQ9', NULL, 1, '78zEF4tWDL', '2011-10-12 22:13:01');
INSERT INTO `report` VALUES (80, 83, 118, 3, 'Coap4iq513', NULL, 0, '5Iqq6F3J3b', '2008-02-17 21:58:24');
INSERT INTO `report` VALUES (81, 85, 196, 2, 'KrKQ4izi3a', NULL, 1, 'ejHWRKvVWM', '2020-11-10 17:56:34');
INSERT INTO `report` VALUES (82, 36, 19, 1, 'At9ytPwmEc', NULL, 1, 'N7am7c3PYm', '2014-03-28 01:08:53');
INSERT INTO `report` VALUES (83, 85, 171, 4, '1yT9LpUGkZ', 'https://picsum0photos/seed/report_07/300/300', 1, 'ztF6VvFyVH', '2020-11-01 02:47:30');
INSERT INTO `report` VALUES (84, 93, 120, 4, 'zJFbzaR1wy', NULL, 1, 'PGaCFC4dDk', '2008-08-01 13:25:52');
INSERT INTO `report` VALUES (85, 34, 116, 4, 'fIQKyaJ72H', NULL, 1, 'RymMLpnSNI', '2008-10-13 13:05:10');
INSERT INTO `report` VALUES (86, 7, 92, 4, 'YudT6sUHSY', NULL, 1, 'ny698VLIsB', '2018-09-10 23:34:20');
INSERT INTO `report` VALUES (87, 35, 131, 3, 'Bgj1xlpeKY', NULL, 1, '8QaIeJBeK9', '2012-06-06 09:07:37');
INSERT INTO `report` VALUES (88, 95, 29, 4, 'cTnHbuF0RY', NULL, 1, 'BtLcaAEBMF', '2002-07-25 08:32:15');
INSERT INTO `report` VALUES (89, 68, 44, 1, 'uTF8rNba0m', NULL, 1, 'jbENjRyfvf', '2000-04-20 08:45:05');
INSERT INTO `report` VALUES (90, 96, 39, 4, 'skhUf21xsV', NULL, 0, 'VEYsZvIOYR', '2004-11-26 07:42:19');
INSERT INTO `report` VALUES (91, 20, 20, 3, 'iAQXA40SJU', NULL, 1, 'fSYsgMvpUt', '2004-06-30 10:02:40');
INSERT INTO `report` VALUES (92, 79, 26, 4, 'Hw0AeAwWf0', NULL, 1, 'GCfIUegdFh', '2013-08-30 10:16:10');
INSERT INTO `report` VALUES (93, 86, 86, 3, 'KuZuYs6IAz', NULL, 1, 'ulnu9LYJdn', '2024-12-05 14:45:49');
INSERT INTO `report` VALUES (94, 90, 162, 4, '9P3LjKmlN1', NULL, 1, 'QZRBKgjBgc', '2008-02-25 07:17:51');
INSERT INTO `report` VALUES (95, 74, 175, 2, 'fivwvtIiOR', 'https://picsumWphotos/seed/report_2/300/300', 1, 'Mu6cyqkNCc', '2014-12-17 22:05:55');
INSERT INTO `report` VALUES (96, 8, 152, 1, 'uUPoZ5690a', NULL, 1, 'YeXBzZu1u1', '2017-11-15 18:48:52');
INSERT INTO `report` VALUES (97, 67, 59, 3, '2cnHzGoer6', NULL, 1, 'NXfjACl2QP', '2010-06-30 20:42:55');
INSERT INTO `report` VALUES (98, 16, 40, 1, 'ROaF3BGOqP', NULL, 1, 'RbjBEPIVci', '2014-06-18 17:02:53');
INSERT INTO `report` VALUES (99, 63, 160, 2, 'MM4xVYgynU', NULL, 0, 'KbDWFoWbSh', '2017-04-11 10:06:07');
INSERT INTO `report` VALUES (100, 29, 38, 5, 'l9xirnvi2l', NULL, 0, 'yChmkIKlH4', '2014-12-20 06:25:39');
INSERT INTO `report` VALUES (101, 21, 167, 2, '23y7FUrxAt', NULL, 1, 'c2ERn28Lrb', '2012-12-29 11:46:50');
INSERT INTO `report` VALUES (102, 78, 62, 4, 'HZFFGjfxqE', 'https://picsumBphotos/seed/report_63493/300/300', 0, 'MoEKlRAnpp', '2011-08-07 13:35:10');
INSERT INTO `report` VALUES (103, 16, 109, 5, 'KVfmTE5iFV', NULL, 1, '6G6pXNRKY1', '2000-02-24 13:10:23');
INSERT INTO `report` VALUES (104, 59, 101, 1, '62KcwOnoRF', NULL, 0, 'rcRfFjQciL', '2021-06-12 06:00:32');
INSERT INTO `report` VALUES (105, 96, 75, 3, 'ZuKL5U7imN', NULL, 0, '3sFPKXbONB', '2011-05-29 11:35:20');
INSERT INTO `report` VALUES (106, 99, 181, 3, 'IDY5TBoMwN', 'https://picsumqphotos/seed/report_9/300/300', 1, 'i0BTHaPDqq', '2020-04-11 18:17:59');
INSERT INTO `report` VALUES (107, 87, 48, 4, 'NioGbT6QAJ', NULL, 1, 'p2Z2TB0w0y', '2007-04-21 17:44:43');
INSERT INTO `report` VALUES (108, 64, 47, 5, 'CW9Gn1KSly', NULL, 1, 'HUxQGV8HA9', '2011-01-27 23:36:10');
INSERT INTO `report` VALUES (109, 57, 68, 2, '2UWlrHIRqo', NULL, 1, 'GUMgE8muUb', '2025-08-25 13:49:07');
INSERT INTO `report` VALUES (110, 88, 29, 2, 'lpoQBpixCQ', 'https://picsumJphotos/seed/report_2287/300/300', 0, 'fEeDh8GYaH', '2001-05-02 18:03:36');
INSERT INTO `report` VALUES (111, 95, 85, 1, 'uu72D5Vxp5', NULL, 0, 'eCRD2sPMSh', '2010-10-02 13:01:43');
INSERT INTO `report` VALUES (112, 36, 77, 3, 'R3JFrFMehd', NULL, 1, 'VsbuOwbAw0', '2008-08-15 08:10:28');
INSERT INTO `report` VALUES (113, 50, 117, 2, 'g5i87hvN2F', NULL, 0, '8Ofq3CCU5H', '2013-01-27 17:03:44');
INSERT INTO `report` VALUES (114, 91, 133, 4, 'XMgWQpkk2Q', NULL, 0, 'yydnUG3pgO', '2004-11-29 21:42:51');
INSERT INTO `report` VALUES (115, 8, 77, 3, 'BLebOAOt8e', NULL, 0, 'ZW6kZjHGcz', '2010-11-11 15:25:02');
INSERT INTO `report` VALUES (116, 99, 125, 4, 'Xf9XD3iGFa', NULL, 0, 'UQOGnAN9P2', '2001-08-21 07:21:00');
INSERT INTO `report` VALUES (117, 24, 182, 3, 'Si2BcBBBmN', NULL, 1, 'hModOdnnKU', '2018-08-22 23:34:29');
INSERT INTO `report` VALUES (118, 63, 1, 4, 'nrQEnXNCs4', NULL, 0, 'cpgtCvuanL', '2006-12-19 02:10:49');
INSERT INTO `report` VALUES (119, 39, 152, 1, 'uRyDVTZcVz', NULL, 1, 'ahMPtxdBlB', '2002-11-01 06:39:12');
INSERT INTO `report` VALUES (120, 75, 70, 3, 'iwCO9oKa6w', 'https://picsumLphotos/seed/report_5099/300/300', 1, 'M8B4hZNTKl', '2011-07-20 07:17:35');
INSERT INTO `report` VALUES (121, 7, 195, 4, '57j5StA5Sa', NULL, 1, 'o43BuQXLEt', '2022-11-07 01:30:02');
INSERT INTO `report` VALUES (122, 16, 63, 5, 'qffRaE0meK', 'https://picsum;photos/seed/report_92011/300/300', 0, 'MomI30WvEU', '2009-10-26 17:46:14');
INSERT INTO `report` VALUES (123, 55, 88, 2, '4gXWU3rEeb', NULL, 0, 'FfOPQ3zFwh', '2003-09-07 11:21:40');
INSERT INTO `report` VALUES (124, 89, 184, 2, 'QkxjlhYZTn', NULL, 0, '9AIVY8ICGL', '2011-03-02 22:31:04');
INSERT INTO `report` VALUES (125, 68, 155, 5, 'S4KESUrO0f', NULL, 1, 'u8Bq6Mi4iK', '2015-01-10 01:36:59');
INSERT INTO `report` VALUES (126, 79, 110, 4, 'OpbiAoUKWw', NULL, 1, 'xu6fCTscw4', '2002-07-25 11:57:34');
INSERT INTO `report` VALUES (127, 87, 121, 2, 'uo1wMh8sf1', NULL, 0, 'n7uk9JxxeA', '2019-07-10 23:23:22');
INSERT INTO `report` VALUES (128, 36, 140, 4, 'WqFqm1gHDY', NULL, 0, 'Wg6KWochzZ', '2017-07-01 14:16:32');
INSERT INTO `report` VALUES (129, 96, 156, 4, 'uoVdyiz7lO', NULL, 1, 'VgOV1dDnlu', '2010-02-21 19:03:52');
INSERT INTO `report` VALUES (130, 55, 199, 2, 'mraYa20Lvu', NULL, 0, 'PSBb1mStP3', '2023-02-15 05:50:16');
INSERT INTO `report` VALUES (131, 72, 70, 3, 'dC1BmizmuW', NULL, 0, 'HvBseVUc24', '2010-10-19 04:27:21');
INSERT INTO `report` VALUES (132, 8, 167, 3, '54MULE86Ar', NULL, 0, 'WoMPnK1A9E', '2007-10-29 08:04:20');
INSERT INTO `report` VALUES (133, 28, 178, 3, 'U4I1inlgzM', NULL, 1, 'T568W1dayi', '2018-05-01 21:19:59');
INSERT INTO `report` VALUES (134, 37, 100, 5, 'dbVAg9nZ2p', NULL, 1, 'dAAmnvqhAO', '2003-08-25 19:45:07');
INSERT INTO `report` VALUES (135, 19, 74, 4, '9WRwjEWu78', NULL, 1, 'JqjPSFuJb0', '2011-03-29 06:09:28');
INSERT INTO `report` VALUES (136, 4, 130, 4, 'mMtJpg8wIB', NULL, 1, 'gc2WMryqM6', '2011-01-28 09:39:20');
INSERT INTO `report` VALUES (137, 34, 132, 5, 'KGdSfQjEUC', NULL, 1, 'LkZqsiT8eV', '2022-01-31 00:29:25');
INSERT INTO `report` VALUES (138, 56, 58, 2, 'InyjRLuthN', NULL, 0, 'LdSVLA8wUh', '2006-12-29 18:19:14');
INSERT INTO `report` VALUES (139, 36, 127, 5, '5OnkaBxj5p', NULL, 0, 'ghhvwWZjV1', '2005-11-04 09:11:42');
INSERT INTO `report` VALUES (140, 47, 186, 3, 'YslNqlGL9O', 'https://picsumJphotos/seed/report_4795/300/300', 1, 'mA4OpDRhqf', '2001-07-01 12:00:16');
INSERT INTO `report` VALUES (141, 54, 113, 4, 'gK6YS7ceeK', NULL, 1, 'Df5HmvaDdZ', '2007-06-23 06:40:20');
INSERT INTO `report` VALUES (142, 60, 169, 5, 'snYGr2o8ox', NULL, 0, 'GMgGeD6afP', '2001-05-10 16:05:54');
INSERT INTO `report` VALUES (143, 58, 97, 4, '57cPOZX5Wi', 'https://picsumnphotos/seed/report_4310/300/300', 0, 'JClzjHoZdN', '2024-03-28 02:25:34');
INSERT INTO `report` VALUES (144, 27, 72, 2, 'VBiD7gGZ4M', NULL, 1, 'QVQAO9L28F', '2018-12-11 04:36:18');
INSERT INTO `report` VALUES (145, 1, 30, 2, 'j7uEAgETK6', 'https://picsumxphotos/seed/report_225/300/300', 1, 'OpcpK2gb1e', '2007-03-13 20:13:39');
INSERT INTO `report` VALUES (146, 24, 77, 3, 'LpzcaOiE50', NULL, 0, '9tzDT3lE1D', '2001-03-18 15:48:56');
INSERT INTO `report` VALUES (147, 15, 27, 2, 'JdKqXlLYb2', NULL, 0, 'SKljIJVJ4r', '2011-11-18 21:12:57');
INSERT INTO `report` VALUES (148, 28, 92, 2, 'WM0nUsnqD1', NULL, 1, '9BVnFCq2ef', '2001-11-08 17:56:46');
INSERT INTO `report` VALUES (149, 21, 115, 5, 'nlNziP4uD6', NULL, 1, 'AJzdsaQNBH', '2013-02-14 20:47:53');
INSERT INTO `report` VALUES (150, 50, 86, 2, 'Rui3neA74I', NULL, 0, 'sPVPrwNhRa', '2008-04-04 17:59:38');
INSERT INTO `report` VALUES (151, 46, 124, 1, 'MiQat2LlyD', NULL, 0, 'tGhikRV1My', '2025-11-07 10:05:35');
INSERT INTO `report` VALUES (152, 36, 111, 3, 'O9y0xVSjBL', NULL, 1, 'rhIQv5245i', '2001-11-05 11:02:38');
INSERT INTO `report` VALUES (153, 1, 10, 4, '4qaJAZGtYH', NULL, 1, 'VkWQ74o7dM', '2023-09-04 17:59:38');
INSERT INTO `report` VALUES (154, 21, 91, 5, 'oG2P2EHoYf', NULL, 0, 'QIrDgfbx9c', '2014-09-18 19:42:30');
INSERT INTO `report` VALUES (155, 43, 166, 4, 'chXly3j7D0', 'https://picsumDphotos/seed/report_53/300/300', 1, 'eHyvlGDoCg', '2025-07-25 15:35:14');
INSERT INTO `report` VALUES (156, 33, 126, 2, 'Q5RIJZyuSR', NULL, 1, 'D88lQZnt5T', '2019-08-20 18:23:42');
INSERT INTO `report` VALUES (157, 71, 58, 4, 'kIJRxLy8ew', NULL, 1, 'StkaLSJCCj', '2017-11-06 13:09:11');
INSERT INTO `report` VALUES (158, 81, 153, 4, 's1Kk669j5Q', NULL, 0, '6g6u8jZbvD', '2015-10-03 23:20:13');
INSERT INTO `report` VALUES (159, 24, 92, 4, '15mjWn5m4B', NULL, 1, 'qcru2jrwYJ', '2025-12-12 15:43:55');
INSERT INTO `report` VALUES (160, 42, 46, 4, 'jgCGxPyh1r', 'https://picsum+photos/seed/report_8/300/300', 0, 'e9t7Y3NJiv', '2011-05-17 00:30:09');
INSERT INTO `report` VALUES (161, 46, 74, 5, 'kKx3qfUguu', 'https://picsum,photos/seed/report_6800/300/300', 0, 'SZdpvg4SAZ', '2016-06-26 21:36:34');
INSERT INTO `report` VALUES (162, 11, 31, 5, 't2B6FSQdUf', NULL, 0, 'Y9RnXdCH5C', '2005-07-13 10:20:18');
INSERT INTO `report` VALUES (163, 54, 47, 4, 'w8UOsmqlzr', NULL, 0, 'ebvMwTm99Y', '2006-07-05 16:37:53');
INSERT INTO `report` VALUES (164, 4, 18, 3, 'DSAmuxMsvY', NULL, 0, '5hHCgcAb7K', '2009-03-19 19:13:15');
INSERT INTO `report` VALUES (165, 37, 46, 3, 'Acijxm9nHp', NULL, 0, 'GxmIPgXOwJ', '2007-04-14 05:04:37');
INSERT INTO `report` VALUES (166, 11, 148, 2, 'EWgM4Zzu6w', NULL, 1, 'CZ4vjrpjvP', '2015-02-09 19:05:42');
INSERT INTO `report` VALUES (167, 1, 188, 3, 'PPEfM5dh3L', NULL, 0, 'b5qbf7pfve', '2021-09-27 10:56:51');
INSERT INTO `report` VALUES (168, 95, 95, 4, 'ZH0Hpiif34', NULL, 1, 'ZoFmNdFycP', '2004-04-01 04:24:56');
INSERT INTO `report` VALUES (169, 2, 67, 4, 'ECjQhDjXpL', NULL, 0, 'qigBqG4z3d', '2016-01-06 00:27:47');
INSERT INTO `report` VALUES (170, 99, 48, 1, 'U3EarSPuTS', NULL, 0, '4si1044itt', '2002-06-26 10:20:55');
INSERT INTO `report` VALUES (171, 20, 159, 2, 'jjut52BdtL', 'https://picsumbphotos/seed/report_37680/300/300', 1, 'UDGWO8XBbk', '2010-01-13 02:40:15');
INSERT INTO `report` VALUES (172, 69, 126, 2, '33W47032Zn', NULL, 1, 'qcv4oPxrt1', '2005-08-06 19:24:44');
INSERT INTO `report` VALUES (173, 68, 133, 2, 'hdHeJ02pdZ', NULL, 0, 'YpRQnlcaIp', '2023-02-20 13:43:12');
INSERT INTO `report` VALUES (174, 78, 143, 5, 'Xo9y3hzy4F', NULL, 1, 'qfq7ZH0BKu', '2002-01-14 21:16:02');
INSERT INTO `report` VALUES (175, 25, 82, 3, 'MnJflUFdX5', NULL, 0, 'yNqRZJ5zfO', '2019-04-11 01:30:05');
INSERT INTO `report` VALUES (176, 68, 181, 1, 'zKlGYkld3J', 'https://picsumQphotos/seed/report_502/300/300', 0, 'aGy3p152kK', '2019-12-02 16:05:52');
INSERT INTO `report` VALUES (177, 35, 6, 3, 'c2YHsaSkQQ', NULL, 0, 'KTCswVh17l', '2024-11-11 05:38:03');
INSERT INTO `report` VALUES (178, 39, 194, 2, 'IVHuTMpYA9', NULL, 0, 'FkgzOdYpVx', '2007-04-19 04:59:17');
INSERT INTO `report` VALUES (179, 7, 122, 5, 'timrpbBNlw', NULL, 0, 'CaFWK63cNk', '2017-01-25 22:26:26');
INSERT INTO `report` VALUES (180, 63, 67, 2, 'IMr3cx3iiK', NULL, 0, '025FK7ieaZ', '2020-03-21 01:05:16');
INSERT INTO `report` VALUES (181, 3, 109, 2, 'A73eT8BMsB', NULL, 1, 'Nu4q3sevPI', '2020-04-27 16:39:50');
INSERT INTO `report` VALUES (182, 13, 143, 1, 'ELiCeYTNkX', NULL, 1, 'ReN019IBPE', '2016-08-06 17:10:32');
INSERT INTO `report` VALUES (183, 9, 5, 4, 'N9ZOuQfGN9', 'https://picsumJphotos/seed/report_00/300/300', 0, 'gKTN9WGKlC', '2012-02-11 21:37:14');
INSERT INTO `report` VALUES (184, 98, 156, 1, 'FlUhxryp2i', NULL, 1, '6Z00fE9E8H', '2024-05-04 05:35:44');
INSERT INTO `report` VALUES (185, 41, 119, 3, 'fi8nHvynlP', NULL, 0, 'FPJTF4OsDT', '2009-11-26 01:05:23');
INSERT INTO `report` VALUES (186, 63, 55, 2, 'Lfq1Zg13G8', NULL, 0, 'WA7XerbjSN', '2014-11-28 13:00:45');
INSERT INTO `report` VALUES (187, 44, 65, 4, 'oanDemcIPV', NULL, 0, 'lpxzmHIFDW', '2020-10-11 17:47:57');
INSERT INTO `report` VALUES (188, 98, 16, 2, '3gkVkK76rL', NULL, 1, 'SFKcy9byiK', '2025-10-11 17:23:40');
INSERT INTO `report` VALUES (189, 94, 161, 1, 'BdXuA1AnWU', NULL, 1, 'gKxKxhRpIl', '2010-08-27 21:37:24');
INSERT INTO `report` VALUES (190, 29, 196, 1, 'VQB60Xb9zQ', 'https://picsumTphotos/seed/report_4/300/300', 1, 'qGtn0x2QhP', '2002-05-16 16:11:08');
INSERT INTO `report` VALUES (191, 21, 199, 4, 'xpE6E8I8ZK', 'https://picsum0photos/seed/report_86/300/300', 0, '1aNZUKovJI', '2019-01-26 18:59:36');
INSERT INTO `report` VALUES (192, 87, 71, 2, 'sdELUUhxAO', 'https://picsumaphotos/seed/report_1218/300/300', 0, 'qSCe1entDG', '2002-11-06 22:08:46');
INSERT INTO `report` VALUES (193, 76, 174, 3, 'kEQhuxsPxG', NULL, 1, 'GKRNrbARcd', '2015-10-06 01:41:56');
INSERT INTO `report` VALUES (194, 60, 146, 4, 'qr80phnHJ9', NULL, 1, '8L1syvAPcQ', '2017-12-31 13:55:38');
INSERT INTO `report` VALUES (195, 59, 192, 4, 'WNH4tWglXr', NULL, 1, 'n0L0QP1Tul', '2024-06-27 05:05:26');
INSERT INTO `report` VALUES (196, 46, 175, 5, 'swj5tDDwS3', 'https://picsum4photos/seed/report_97941/300/300', 0, 'rNYtfi9SPg', '2020-12-19 07:57:13');
INSERT INTO `report` VALUES (197, 72, 129, 2, 'y2bhXCDkEa', NULL, 0, '6si9bAgWeE', '2023-01-19 06:31:25');
INSERT INTO `report` VALUES (198, 11, 34, 4, 'AGvRTaq2ej', 'https://picsum0photos/seed/report_7/300/300', 0, 'asQ4Av4Tzb', '2005-12-05 07:24:19');
INSERT INTO `report` VALUES (199, 65, 119, 5, 'ByAEyofowl', NULL, 0, '5N10XwKL1d', '2020-05-02 22:24:45');
INSERT INTO `report` VALUES (200, 72, 85, 1, 'xKkAHt70Lx', NULL, 1, 'qinDkBGHT9', '2016-07-03 01:19:26');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` int NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `user_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `phone` char(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '加密存储\r\n            ',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `intro` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `role` smallint NOT NULL COMMENT '角色：0普通用户、1管理员',
  `status` smallint NOT NULL COMMENT '账号状态：0正常、1封禁',
  `register_time` datetime NULL DEFAULT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '收货地址',
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE INDEX `phone`(`phone` ASC) USING BTREE,
  CONSTRAINT `chk_user_role` CHECK (`role` in (0,1)),
  CONSTRAINT `chk_user_status` CHECK (`status` in (0,1))
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户用于二手交易，可以是卖家也可以是买家' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, '郝睿', '19028135411', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'vXqAma2Pqa', '5zodaJReTa', 1, 0, '2022-05-16 15:42:02', '南昌大学前湖校区2栋2室');
INSERT INTO `sys_user` VALUES (2, '向致远', '14572081876', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'cjMgatpt7E', 'aEYTgRSnJV', 1, 0, '2006-11-30 08:29:04', '南昌大学前湖校区3栋3室');
INSERT INTO `sys_user` VALUES (3, '武子韬', '15861176797', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'OCBRzL3C41', 'AR6hKR4t0i', 0, 0, '2022-03-22 10:08:02', '南昌大学前湖校区4栋4室');
INSERT INTO `sys_user` VALUES (4, '宋岚', '14103924816', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'LZQhoQKx5G', 'IIt7do45O8', 0, 0, '2015-07-03 09:55:07', '南昌大学前湖校区5栋5室');
INSERT INTO `sys_user` VALUES (5, '廖詩涵', '16924344849', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'DWAxCVdNrI', 'N39PZTcpCk', 0, 0, '2002-05-13 05:03:50', '南昌大学前湖校区6栋6室');
INSERT INTO `sys_user` VALUES (6, '余安琪', '14330596984', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'rp9meDQGRE', 'qfCupzBDKy', 0, 0, '2024-01-05 16:23:07', '南昌大学前湖校区7栋7室');
INSERT INTO `sys_user` VALUES (7, '戴云熙', '19256343272', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'ta2dLQtX5b', '5Rac659OFZ', 0, 0, '2025-07-23 06:06:28', '南昌大学前湖校区8栋8室');
INSERT INTO `sys_user` VALUES (8, '石云熙', '18137578405', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '9GkmVFiqpm', 'rIknPhX9Uz', 0, 0, '2011-09-20 12:05:44', '南昌大学前湖校区1栋9室');
INSERT INTO `sys_user` VALUES (9, '崔云熙', '18955248839', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'yAwFZRpnbH', '8FE7B1s63o', 0, 0, '2001-12-27 02:46:08', '南昌大学前湖校区2栋10室');
INSERT INTO `sys_user` VALUES (10, '龚子异', '16919068636', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'wDoIUctQPE', 'sujOQr3bW4', 0, 0, '2005-01-27 07:22:47', '南昌大学前湖校区3栋11室');
INSERT INTO `sys_user` VALUES (11, '张子异', '13410657358', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'ZfyJEFHxP4', 'uMp6bWrcJl', 0, 0, '2005-06-18 11:47:56', '南昌大学前湖校区4栋12室');
INSERT INTO `sys_user` VALUES (12, '陆云熙', '13116906669', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'OmScZ69Z4z', '8AtMuVtp5B', 0, 0, '2007-02-05 19:29:13', '南昌大学前湖校区5栋13室');
INSERT INTO `sys_user` VALUES (13, '侯秀英', '16895763309', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'TpLpkCYxMa', 'bxjFpszFJ5', 0, 0, '2024-10-03 06:24:09', '南昌大学前湖校区6栋14室');
INSERT INTO `sys_user` VALUES (14, '彭岚', '17623988031', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'YBhyf2Y6uX', 'nxSOLxJl2C', 0, 0, '2008-05-21 13:50:46', '南昌大学前湖校区7栋15室');
INSERT INTO `sys_user` VALUES (15, '邓致远', '18364022995', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'QVTOctR7zD', 'fFUya5m4JK', 0, 0, '2001-10-31 10:00:22', '南昌大学前湖校区8栋16室');
INSERT INTO `sys_user` VALUES (16, '苏宇宁', '19419828272', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'l64JS9EIwc', '1yV0jHQZmJ', 0, 0, '2004-06-16 18:30:49', '南昌大学前湖校区1栋17室');
INSERT INTO `sys_user` VALUES (17, '汪云熙', '17940699052', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '7JEebdfGLY', 'O59dhfmSMv', 0, 0, '2017-12-31 07:30:23', '南昌大学前湖校区2栋18室');
INSERT INTO `sys_user` VALUES (18, '钱宇宁', '17978205337', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'USulTEkaMt', '1owOP15rMZ', 0, 0, '2003-01-02 18:45:27', '南昌大学前湖校区3栋19室');
INSERT INTO `sys_user` VALUES (19, '秦杰宏', '14071283361', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'Y83REy9bbD', 'PTpxTsgVbD', 0, 0, '2011-06-08 03:29:42', '南昌大学前湖校区4栋20室');
INSERT INTO `sys_user` VALUES (20, '许杰宏', '14857388565', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '26sVtjCCz8', 'NvvcPzDPZj', 0, 0, '2014-11-26 11:09:04', '南昌大学前湖校区5栋1室');
INSERT INTO `sys_user` VALUES (21, '莫子韬', '16684392867', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'xzQUlk4Swk', 'ZoBPfljwDP', 0, 0, '2017-03-05 21:18:21', '南昌大学前湖校区6栋2室');
INSERT INTO `sys_user` VALUES (22, '孔岚', '19581107903', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'Ho9gFwWZ2M', 'E102VmPR9y', 0, 0, '2025-01-04 06:32:16', '南昌大学前湖校区7栋3室');
INSERT INTO `sys_user` VALUES (23, '谢璐', '16920040895', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'JejqRhygnU', 'CaWUwodlAO', 0, 0, '2023-12-31 12:51:25', '南昌大学前湖校区8栋4室');
INSERT INTO `sys_user` VALUES (24, '钟震南', '14472691284', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '7Zv6g5iGzC', 'ZuIS7DxQN9', 0, 0, '2017-12-01 21:11:26', '南昌大学前湖校区1栋5室');
INSERT INTO `sys_user` VALUES (25, '邵秀英', '15628893378', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'UHe2FJUzUx', 'owNNVUlF3K', 0, 0, '2015-08-12 06:43:15', '南昌大学前湖校区2栋6室');
INSERT INTO `sys_user` VALUES (26, '顾安琪', '17600117678', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'q39gjMzxRn', 'gkX5L3vejV', 0, 0, '2011-02-24 14:54:47', '南昌大学前湖校区3栋7室');
INSERT INTO `sys_user` VALUES (27, '苏璐', '15259350289', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 's1QJztFjUv', 'ObKAFWeqyj', 0, 0, '2026-07-19 18:44:32', '南昌大学前湖校区4栋8室');
INSERT INTO `sys_user` VALUES (28, '钟晓明', '16243631724', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '9igherLQad', 'aiJK9drqlf', 0, 0, '2004-05-18 08:16:53', '南昌大学前湖校区5栋9室');
INSERT INTO `sys_user` VALUES (29, '马詩涵', '16754469727', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'QrM4L1TrdB', 'JiuC0a2fXx', 0, 0, '2002-06-06 15:40:57', '南昌大学前湖校区6栋10室');
INSERT INTO `sys_user` VALUES (30, '刘震南', '18490237100', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'pMwTjdwleL', 'xz2z2d35VR', 0, 0, '2021-06-06 22:25:14', '南昌大学前湖校区7栋11室');
INSERT INTO `sys_user` VALUES (31, '陶睿', '18823985756', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'UDZnEU7fov', 'TKnxAfzN5n', 0, 0, '2004-04-26 23:10:10', '南昌大学前湖校区8栋12室');
INSERT INTO `sys_user` VALUES (32, '董云熙', '13894278475', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '2YgHm2RGBt', 'MsKZkdjQaz', 0, 0, '2017-03-08 12:40:05', '南昌大学前湖校区1栋13室');
INSERT INTO `sys_user` VALUES (33, '赵岚', '18913744650', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'qwOVrLKyNj', 'UPJ29vYx5C', 0, 0, '2005-12-27 08:30:16', '南昌大学前湖校区2栋14室');
INSERT INTO `sys_user` VALUES (34, '薛致远', '16648826621', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'VYDkdi6Or6', 'DVJNFQC0LK', 0, 0, '2000-03-23 07:19:06', '南昌大学前湖校区3栋15室');
INSERT INTO `sys_user` VALUES (35, '邱致远', '14670549845', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'wKyqiEbK0V', 'eELeqfpcAx', 0, 0, '2020-08-01 01:42:00', '南昌大学前湖校区4栋16室');
INSERT INTO `sys_user` VALUES (36, '常璐', '19213131977', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'PzKUdsdDq2', 'nyvLYFLJ0j', 0, 0, '2001-02-22 10:25:04', '南昌大学前湖校区5栋17室');
INSERT INTO `sys_user` VALUES (37, '阎致远', '18343472150', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'b8EbhyxcxM', '8ummozcCrf', 0, 0, '2024-03-08 21:31:38', '南昌大学前湖校区6栋18室');
INSERT INTO `sys_user` VALUES (38, '金安琪', '18367938811', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'fkhsJzC1gK', 'OWFW5Hjb69', 0, 0, '2016-09-18 01:40:35', '南昌大学前湖校区7栋19室');
INSERT INTO `sys_user` VALUES (39, '顾睿', '19382537069', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'SWKPz7JbXT', 'rOWDguTCc1', 0, 0, '2009-02-18 16:48:16', '南昌大学前湖校区8栋20室');
INSERT INTO `sys_user` VALUES (40, '董云熙', '19678909146', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'BFP4Frszwh', 'EIJWiyeIDW', 0, 0, '2002-02-16 18:41:50', '南昌大学前湖校区1栋1室');
INSERT INTO `sys_user` VALUES (41, '江睿', '19029274749', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '6QPPorOdno', 'Do6jxqStYg', 0, 0, '2001-09-13 08:21:45', '南昌大学前湖校区2栋2室');
INSERT INTO `sys_user` VALUES (42, '严震南', '14588666944', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'As6fajDopJ', 'VY3seixTHs', 0, 0, '2011-08-25 22:02:56', '南昌大学前湖校区3栋3室');
INSERT INTO `sys_user` VALUES (43, '彭杰宏', '16883557028', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'R34ZYbVGZ0', 'yjkC488AHW', 0, 0, '2005-07-16 14:43:31', '南昌大学前湖校区4栋4室');
INSERT INTO `sys_user` VALUES (44, '田璐', '19830483456', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '9o4sLXA8rO', 'wmDWblVQRV', 0, 0, '2017-05-23 21:00:18', '南昌大学前湖校区5栋5室');
INSERT INTO `sys_user` VALUES (45, '邵岚', '16706898751', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'zCOSePa5ZF', 'JWfYmx9oKq', 0, 0, '2021-10-15 15:31:46', '南昌大学前湖校区6栋6室');
INSERT INTO `sys_user` VALUES (46, '丁晓明', '18898589477', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'IUvxqgHxyf', 'HYb8G4dAYv', 0, 0, '2000-11-26 00:26:37', '南昌大学前湖校区7栋7室');
INSERT INTO `sys_user` VALUES (47, '苏璐', '19682844546', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'NysjvBPqYU', 'bXgReYI0KV', 0, 0, '2002-08-26 11:25:56', '南昌大学前湖校区8栋8室');
INSERT INTO `sys_user` VALUES (48, '陈杰宏', '19213198826', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'lSIJCQJpQQ', 'mAxBLtWsDR', 0, 0, '2008-10-25 10:53:08', '南昌大学前湖校区1栋9室');
INSERT INTO `sys_user` VALUES (49, '江杰宏', '17848972002', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '5KuxJBaOc8', '7CPkMn5uLw', 0, 0, '2018-05-27 00:56:19', '南昌大学前湖校区2栋10室');
INSERT INTO `sys_user` VALUES (50, '孔詩涵', '15007659658', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'BfYAojcqmM', 'rurDDfXSE1', 0, 0, '2003-10-26 10:34:18', '南昌大学前湖校区3栋11室');
INSERT INTO `sys_user` VALUES (51, '贺安琪', '17771790008', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'sBPb1wPq1c', '7vMrwZGOsg', 0, 0, '2015-03-07 12:17:03', '南昌大学前湖校区4栋12室');
INSERT INTO `sys_user` VALUES (52, '高杰宏', '16278230591', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'jPyZXLUGh5', 'WgFs1JRH4p', 0, 0, '2012-02-29 18:19:13', '南昌大学前湖校区5栋13室');
INSERT INTO `sys_user` VALUES (53, '邱詩涵', '18898109323', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'ASDCWYT9yV', '0NXRzjGHol', 0, 0, '2013-06-18 04:34:31', '南昌大学前湖校区6栋14室');
INSERT INTO `sys_user` VALUES (54, '蔡安琪', '19450181170', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'sMivOJi4yw', 'FqM4T6P2IT', 0, 0, '2008-07-04 09:00:45', '南昌大学前湖校区7栋15室');
INSERT INTO `sys_user` VALUES (55, '程晓明', '17374111023', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'lVClCN8WsQ', 'sRPUjE5gWg', 0, 0, '2008-09-19 19:26:56', '南昌大学前湖校区8栋16室');
INSERT INTO `sys_user` VALUES (56, '廖致远', '16125937207', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'tCUUPJoVy4', 'tTayrzOD08', 0, 0, '2020-03-22 03:06:26', '南昌大学前湖校区1栋17室');
INSERT INTO `sys_user` VALUES (57, '向睿', '19654261451', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'F038u2FsII', 'A6NrnB33f8', 0, 0, '2025-05-16 08:52:18', '南昌大学前湖校区2栋18室');
INSERT INTO `sys_user` VALUES (58, '邱晓明', '15009504299', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'Q8Zrn3FfnT', 'sar3Toz6WT', 0, 0, '2003-12-17 06:14:26', '南昌大学前湖校区3栋19室');
INSERT INTO `sys_user` VALUES (59, '田秀英', '14513147210', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'h1llcGxOUl', 'zKBSsRzS2H', 0, 0, '2016-04-12 04:53:43', '南昌大学前湖校区4栋20室');
INSERT INTO `sys_user` VALUES (60, '武詩涵', '17543818779', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'jkk5qZFuGu', 'Mu0RGnIylo', 0, 0, '2020-05-20 05:13:40', '南昌大学前湖校区5栋1室');
INSERT INTO `sys_user` VALUES (61, '史岚', '17049030582', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '3jDNTZLPVY', 'l7IcWX6Gsy', 0, 0, '2015-06-07 07:54:48', '南昌大学前湖校区6栋2室');
INSERT INTO `sys_user` VALUES (62, '赵致远', '13843093227', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '3y95nyteuv', 'yoApmaWZvT', 0, 0, '2018-12-04 07:33:51', '南昌大学前湖校区7栋3室');
INSERT INTO `sys_user` VALUES (63, '汪宇宁', '15665739800', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'BwnPyTwRbc', 'm4ZJi5hK4l', 0, 0, '2007-12-19 17:47:02', '南昌大学前湖校区8栋4室');
INSERT INTO `sys_user` VALUES (64, '武致远', '15520660973', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'K5vE5tAWLC', 'i8qKwQpyhT', 0, 0, '2015-03-04 01:30:10', '南昌大学前湖校区1栋5室');
INSERT INTO `sys_user` VALUES (65, '胡璐', '16880156182', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0idqCrSZWc', 'EIG20f8U33', 0, 0, '2011-05-27 22:06:48', '南昌大学前湖校区2栋6室');
INSERT INTO `sys_user` VALUES (66, '吴安琪', '18126984592', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'Vcd4z0MBB2', 'Z4egKNUoOF', 0, 0, '2024-05-28 07:55:08', '南昌大学前湖校区3栋7室');
INSERT INTO `sys_user` VALUES (67, '史安琪', '14342191694', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '20pCIeZBnU', 'wyi4RspcdT', 0, 0, '2000-06-16 15:49:31', '南昌大学前湖校区4栋8室');
INSERT INTO `sys_user` VALUES (68, '尹睿', '17641458790', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'VXr8o3S4PW', 'AxQGROMq8A', 0, 0, '2014-05-18 04:27:36', '南昌大学前湖校区5栋9室');
INSERT INTO `sys_user` VALUES (69, '傅安琪', '13013099881', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'b9WyKFv2GW', 'pcyOFlYMOv', 0, 0, '2022-12-01 15:07:58', '南昌大学前湖校区6栋10室');
INSERT INTO `sys_user` VALUES (70, '邹安琪', '15056282281', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'eb6MG95720', 'Vowar5z3Dg', 0, 0, '2026-03-17 02:57:10', '南昌大学前湖校区7栋11室');
INSERT INTO `sys_user` VALUES (71, '蒋岚', '15675903473', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'IFE8SCvuBW', 'kd01rOAUsT', 0, 0, '2009-07-04 15:00:25', '南昌大学前湖校区8栋12室');
INSERT INTO `sys_user` VALUES (72, '钱岚', '16649729732', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '2RKauhMsAj', '32gpna7umi', 0, 0, '2026-03-20 22:19:31', '南昌大学前湖校区1栋13室');
INSERT INTO `sys_user` VALUES (73, '曾秀英', '17286206069', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '7G0eIogdpo', 'uQvdIJu2aE', 0, 0, '2009-07-06 09:01:26', '南昌大学前湖校区2栋14室');
INSERT INTO `sys_user` VALUES (74, '陈宇宁', '16920686661', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '4S4Zpp7akc', 'UqwtAZezCh', 0, 0, '2010-08-06 16:38:26', '南昌大学前湖校区3栋15室');
INSERT INTO `sys_user` VALUES (75, '郑子异', '18861142882', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '9SY9Tb8cMt', 'UWPsHGeAk8', 0, 0, '2006-04-24 10:23:17', '南昌大学前湖校区4栋16室');
INSERT INTO `sys_user` VALUES (76, '严震南', '16285748695', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'avaLaPTNUw', 'eppmOMznqL', 0, 0, '2025-11-16 18:44:08', '南昌大学前湖校区5栋17室');
INSERT INTO `sys_user` VALUES (77, '谢安琪', '17665601473', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'RV6EfAi4va', 'QbWjKlARcq', 0, 0, '2000-10-26 08:40:53', '南昌大学前湖校区6栋18室');
INSERT INTO `sys_user` VALUES (78, '叶云熙', '19621980293', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'pYFwuFLAt7', '7EF2ByFStB', 0, 0, '2009-12-15 22:00:13', '南昌大学前湖校区7栋19室');
INSERT INTO `sys_user` VALUES (79, '沈安琪', '16962096987', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'FEJ03jvXQ0', 'OTFV2AX4us', 0, 0, '2006-11-09 23:22:57', '南昌大学前湖校区8栋20室');
INSERT INTO `sys_user` VALUES (80, '江宇宁', '15751552063', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'jzxiz2NyHU', 'pfGD22OrPe', 0, 0, '2007-05-29 04:22:24', '南昌大学前湖校区1栋1室');
INSERT INTO `sys_user` VALUES (81, '秦子异', '16619816764', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '3eXfERG23Q', 'eW85MJraww', 0, 0, '2001-07-14 21:33:17', '南昌大学前湖校区2栋2室');
INSERT INTO `sys_user` VALUES (82, '贺宇宁', '13369425252', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'Kpl80NdQDV', 'ecRvNDjMOl', 0, 0, '2013-07-13 05:07:57', '南昌大学前湖校区3栋3室');
INSERT INTO `sys_user` VALUES (83, '熊晓明', '14726373986', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'RYrMkDca9Z', 'TwPyknzJRM', 0, 0, '2004-05-05 08:15:59', '南昌大学前湖校区4栋4室');
INSERT INTO `sys_user` VALUES (84, '蒋岚', '17487957963', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '6foWUTq4tR', 'OjLCpDMty9', 0, 0, '2002-04-22 00:22:03', '南昌大学前湖校区5栋5室');
INSERT INTO `sys_user` VALUES (85, '张睿', '15829789219', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'VjpoOn5W7O', 'kYBcdlGa5k', 0, 0, '2013-04-14 13:04:42', '南昌大学前湖校区6栋6室');
INSERT INTO `sys_user` VALUES (86, '邹杰宏', '16072145548', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'QzDpm3A43f', '996mAjD1RM', 0, 0, '2019-11-18 01:10:04', '南昌大学前湖校区7栋7室');
INSERT INTO `sys_user` VALUES (87, '范晓明', '17173624811', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'HaUSLA5ghw', 'gtcCqkYQ7z', 0, 0, '2016-01-23 00:28:53', '南昌大学前湖校区8栋8室');
INSERT INTO `sys_user` VALUES (88, '雷嘉伦', '19996000462', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'zCVKJ5BYkJ', 'm3rys6UQH1', 0, 0, '2017-07-25 12:09:58', '南昌大学前湖校区1栋9室');
INSERT INTO `sys_user` VALUES (89, '赵震南', '15468322682', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'jUbq2Izqh6', 'rCZ4VgecQH', 0, 0, '2011-11-02 23:14:49', '南昌大学前湖校区2栋10室');
INSERT INTO `sys_user` VALUES (90, '邵致远', '16446899538', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'BKnpb9uEG9', 'QS5cGt2ZaJ', 0, 0, '2004-06-11 02:52:47', '南昌大学前湖校区3栋11室');
INSERT INTO `sys_user` VALUES (91, '侯宇宁', '14297231981', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'Js0wvhIHqw', 'rQhdCrAxcr', 0, 0, '2025-07-13 18:38:55', '南昌大学前湖校区4栋12室');
INSERT INTO `sys_user` VALUES (92, '程子异', '13722801991', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'wjYC3vHk9u', 'U8U63EgyOe', 0, 0, '2005-02-07 06:51:59', '南昌大学前湖校区5栋13室');
INSERT INTO `sys_user` VALUES (93, '侯云熙', '18483735299', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '9QKvRMGPiA', 'oB9FXcFEkM', 0, 0, '2025-10-07 05:54:49', '南昌大学前湖校区6栋14室');
INSERT INTO `sys_user` VALUES (94, '董睿', '13710944761', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'JmoHX7Weym', 'KrnVHAgvT3', 0, 0, '2018-10-30 07:40:46', '南昌大学前湖校区7栋15室');
INSERT INTO `sys_user` VALUES (95, '顾云熙', '14931232399', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'umZ4GjUyqi', 'j5AnlaZinh', 0, 0, '2001-10-28 11:12:37', '南昌大学前湖校区8栋16室');
INSERT INTO `sys_user` VALUES (96, '陈安琪', '15658725841', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'jZu5SlNdHD', 'vMqZOeOVxE', 0, 0, '2015-06-07 18:31:43', '南昌大学前湖校区1栋17室');
INSERT INTO `sys_user` VALUES (97, '蔡子韬', '14125682905', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'NY6uTOJDG2', 'PIZ00Zcx8j', 0, 0, '2005-06-10 13:52:23', '南昌大学前湖校区2栋18室');
INSERT INTO `sys_user` VALUES (98, '彭云熙', '17289331402', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'tGlVRGsBrm', 'ISqxkA5fw5', 0, 0, '2019-04-01 18:22:53', '南昌大学前湖校区3栋19室');
INSERT INTO `sys_user` VALUES (99, '苏嘉伦', '19154706814', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'Nk0as9X4d4', 'ZkGpSpBBhQ', 0, 0, '2017-12-29 06:25:18', '南昌大学前湖校区4栋20室');
INSERT INTO `sys_user` VALUES (100, '姜震南', '15143314208', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'V61qvTdE7D', 'wdDQ2UtEv9', 0, 0, '2024-10-21 16:30:06', '南昌大学前湖校区5栋1室');

-- ----------------------------
-- Triggers structure for table evaluate
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_prevent_unfinished_evaluate`;
delimiter ;;
CREATE TRIGGER `trg_prevent_unfinished_evaluate` BEFORE INSERT ON `evaluate` FOR EACH ROW BEGIN
    DECLARE order_status_check INT;
    SELECT order_status INTO order_status_check FROM orders WHERE order_id = NEW.order_id;
    IF order_status_check IS NULL OR order_status_check <> 3 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '只能对已完成的订单进行评价！';
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table orders
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_order_complete_update_goods`;
delimiter ;;
CREATE TRIGGER `trg_order_complete_update_goods` AFTER UPDATE ON `orders` FOR EACH ROW BEGIN
    IF NEW.order_status = 3 AND OLD.order_status <> 3 THEN
        UPDATE goods SET goods_status = 3 WHERE goods_id = NEW.goods_id;
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table sys_user
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_user_ban_off_goods`;
delimiter ;;
CREATE TRIGGER `trg_user_ban_off_goods` AFTER UPDATE ON `sys_user` FOR EACH ROW BEGIN
    IF NEW.status = 1 AND OLD.status <> 1 THEN
        UPDATE goods SET goods_status = 2 
        WHERE user_id = NEW.user_id AND goods_status IN (0, 1);
    END IF;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
