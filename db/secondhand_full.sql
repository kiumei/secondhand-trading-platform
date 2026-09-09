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

 Date: 09/09/2026 23:19:32
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
INSERT INTO `evaluate` VALUES (1, '170', 5, '卖家发货很快，【全新卫衣】和图片一模一样，非常满意！', '2026-08-02 23:11:50');
INSERT INTO `evaluate` VALUES (2, '196', 4, '这件【高性价比蓝牙耳机】真的很不错，卖家人很好，性价比高！', '2026-09-14 23:21:50');
INSERT INTO `evaluate` VALUES (3, '130', 2, '【九成新运动鞋】成色很棒，和描述完全一致，交易愉快！', '2026-09-11 23:17:50');
INSERT INTO `evaluate` VALUES (7, '192', 1, '这件【全新保温杯】真的很不错，卖家人很好，性价比高！', '2026-08-04 23:10:50');
INSERT INTO `evaluate` VALUES (8, '178', 4, '【折叠电脑桌】成色很棒，和描述完全一致，交易愉快！', '2026-09-11 23:25:50');
INSERT INTO `evaluate` VALUES (13, '34', 3, '这件【自用iPad保护壳】真的很不错，卖家人很好，性价比高！', '2026-08-20 23:15:50');
INSERT INTO `evaluate` VALUES (16, '17', 3, '卖家发货很快，【自用iPad保护壳】和图片一模一样，非常满意！', '2026-08-02 23:08:50');
INSERT INTO `evaluate` VALUES (17, '27', 2, '收到【九成新羽毛球拍】了，质量很好，用起来很舒服，好评！', '2026-09-16 23:09:50');
INSERT INTO `evaluate` VALUES (24, '1', 2, '【多功能收纳盒】成色很棒，和描述完全一致，交易愉快！', '2026-07-22 23:25:50');
INSERT INTO `evaluate` VALUES (29, '57', 3, '卖家发货很快，【高等数学教材】和图片一模一样，非常满意！', '2026-08-24 23:14:50');
INSERT INTO `evaluate` VALUES (36, '174', 4, '收到【宿舍小台灯】了，质量很好，用起来很舒服，好评！', '2026-09-16 23:25:50');
INSERT INTO `evaluate` VALUES (61, '114', 4, '这件【自用iPad保护壳】真的很不错，卖家人很好，性价比高！', '2026-07-21 23:16:50');
INSERT INTO `evaluate` VALUES (62, '89', 3, '【高性价比蓝牙耳机】成色很棒，和描述完全一致，交易愉快！', '2026-09-15 23:19:50');
INSERT INTO `evaluate` VALUES (63, '97', 1, '收到【自用iPad保护壳】了，质量很好，用起来很舒服，好评！', '2026-08-10 23:22:50');
INSERT INTO `evaluate` VALUES (66, '172', 2, '卖家发货很快，【折叠电脑桌】和图片一模一样，非常满意！', '2026-08-30 23:12:50');
INSERT INTO `evaluate` VALUES (87, '82', 1, '卖家发货很快，【大学英语四级真题】和图片一模一样，非常满意！', '2026-07-30 23:20:50');
INSERT INTO `evaluate` VALUES (103, '95', 3, '【宿舍小台灯】成色很棒，和描述完全一致，交易愉快！', '2026-08-02 23:09:50');
INSERT INTO `evaluate` VALUES (116, '96', 2, '卖家发货很快，【大学英语四级真题】和图片一模一样，非常满意！', '2026-09-15 23:23:50');
INSERT INTO `evaluate` VALUES (125, '183', 4, '卖家发货很快，【折叠电脑桌】和图片一模一样，非常满意！', '2026-07-27 23:12:50');
INSERT INTO `evaluate` VALUES (126, '59', 1, '这件【九成新羽毛球拍】真的很不错，卖家人很好，性价比高！', '2026-09-13 23:22:50');
INSERT INTO `evaluate` VALUES (134, '18', 4, '卖家发货很快，【多功能收纳盒】和图片一模一样，非常满意！', '2026-08-31 23:16:50');
INSERT INTO `evaluate` VALUES (145, '160', 5, '【九成新运动鞋】成色很棒，和描述完全一致，交易愉快！', '2026-09-04 23:07:50');
INSERT INTO `evaluate` VALUES (154, '155', 4, '收到【高等数学教材】了，质量很好，用起来很舒服，好评！', '2026-09-11 23:25:50');
INSERT INTO `evaluate` VALUES (155, '16', 5, '【闲置瑜伽垫】成色很棒，和描述完全一致，交易愉快！', '2026-08-06 23:15:50');
INSERT INTO `evaluate` VALUES (181, '189', 3, '卖家发货很快，【九成新运动鞋】和图片一模一样，非常满意！', '2026-07-17 23:22:50');
INSERT INTO `evaluate` VALUES (197, '48', 2, '卖家发货很快，【全新卫衣】和图片一模一样，非常满意！', '2026-07-25 23:14:50');
INSERT INTO `evaluate` VALUES (200, '13', 4, '收到【宿舍小台灯】了，质量很好，用起来很舒服，好评！', '2026-09-16 23:09:50');

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
) ENGINE = InnoDB AUTO_INCREMENT = 257 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商品收藏表' ROW_FORMAT = Dynamic;

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
INSERT INTO `goods` VALUES (1, 56, 3, '多功能收纳盒', 337.24, 404.69, 3, '多功能收纳盒，桌面杂物一秒归位，材质坚固耐用。', 2, NULL, '2026-07-31 22:57:50', 1);
INSERT INTO `goods` VALUES (2, 80, 2, '自用iPad保护壳', 331.69, 365.84, 3, '自用iPad保护壳，硅胶材质，防摔防刮，几乎全新。', 4, NULL, '2026-09-08 22:57:50', 1);
INSERT INTO `goods` VALUES (3, 73, 6, '九成新运动鞋', 668.23, 997.77, 1, '九成新运动鞋，鞋底磨损极小，透气舒适，尺码标准。', 2, '商品包含违规信息，请修改后再提交。', '2026-07-02 22:57:50', 1);
INSERT INTO `goods` VALUES (4, 90, 1, '高等数学教材', 201.18, 760.13, 3, '高等数学教材，内部有少量笔记，适合期末复习，价格可小刀。', 1, NULL, '2026-08-22 22:57:50', 1);
INSERT INTO `goods` VALUES (5, 84, 2, '高性价比蓝牙耳机', 243.68, 635.29, 2, '高性价比蓝牙耳机，音质清晰，续航持久，无杂音。', 1, NULL, '2026-09-04 22:57:50', 1);
INSERT INTO `goods` VALUES (6, 4, 4, '宿舍小台灯', 511.09, 562.20, 3, '宿舍小台灯，三档调光，USB充电，护眼不频闪。', 1, NULL, '2026-09-08 22:57:50', 1);
INSERT INTO `goods` VALUES (7, 64, 3, '多功能收纳盒', 350.45, 403.05, 1, '多功能收纳盒，桌面杂物一秒归位，材质坚固耐用。', 4, NULL, '2026-07-13 22:57:50', 1);
INSERT INTO `goods` VALUES (8, 69, 6, '全新卫衣', 687.12, 893.26, 2, '全新卫衣，纯棉面料，宽松版型，颜色百搭，未下水。', 2, NULL, '2026-06-30 22:57:50', 1);
INSERT INTO `goods` VALUES (9, 77, 1, '大学英语四级真题', 981.73, 1079.90, 1, '大学英语四级真题，包含近年真题解析，刷题必备，成色很新。', 5, NULL, '2026-08-30 22:57:50', 1);
INSERT INTO `goods` VALUES (10, 51, 4, '宿舍小台灯', 378.22, 453.86, 1, '宿舍小台灯，三档调光，USB充电，护眼不频闪。', 3, NULL, '2026-08-21 22:57:50', 1);
INSERT INTO `goods` VALUES (11, 19, 1, '大学英语四级真题', 990.77, 1288.00, 3, '大学英语四级真题，包含近年真题解析，刷题必备，成色很新。', 4, NULL, '2026-08-02 22:57:50', 1);
INSERT INTO `goods` VALUES (12, 7, 1, '高等数学教材', 335.51, 623.97, 3, '高等数学教材，内部有少量笔记，适合期末复习，价格可小刀。', 3, NULL, '2026-09-09 22:57:50', 1);
INSERT INTO `goods` VALUES (13, 61, 6, '九成新运动鞋', 98.58, 228.64, 3, '九成新运动鞋，鞋底磨损极小，透气舒适，尺码标准。', 4, NULL, '2026-07-21 22:57:50', 1);
INSERT INTO `goods` VALUES (14, 72, 1, '高等数学教材', 673.91, 770.50, 2, '高等数学教材，内部有少量笔记，适合期末复习，价格可小刀。', 5, NULL, '2026-08-27 22:57:50', 1);
INSERT INTO `goods` VALUES (15, 10, 5, '闲置瑜伽垫', 914.86, 1006.35, 3, '闲置瑜伽垫，加厚防滑，回弹力好，适合初学者。', 3, NULL, '2026-09-01 22:57:50', 1);
INSERT INTO `goods` VALUES (16, 29, 2, '自用iPad保护壳', 19.14, 447.80, 3, '自用iPad保护壳，硅胶材质，防摔防刮，几乎全新。', 4, NULL, '2026-08-08 22:57:50', 1);
INSERT INTO `goods` VALUES (17, 41, 3, '多功能收纳盒', 496.58, 645.55, 2, '多功能收纳盒，桌面杂物一秒归位，材质坚固耐用。', 3, NULL, '2026-07-07 22:57:50', 1);
INSERT INTO `goods` VALUES (18, 94, 5, '九成新羽毛球拍', 68.49, 299.76, 3, '九成新羽毛球拍，手感舒适，拍线完好，附赠球拍包。', 4, NULL, '2026-09-03 22:57:50', 1);
INSERT INTO `goods` VALUES (19, 20, 5, '闲置瑜伽垫', 878.74, 1054.49, 1, '闲置瑜伽垫，加厚防滑，回弹力好，适合初学者。', 1, NULL, '2026-09-01 22:57:50', 1);
INSERT INTO `goods` VALUES (20, 60, 3, '全新保温杯', 901.34, 1171.74, 1, '全新保温杯，304不锈钢内胆，保温效果好，未拆封。', 2, NULL, '2026-08-27 22:57:50', 1);
INSERT INTO `goods` VALUES (21, 74, 6, '九成新运动鞋', 708.70, 779.57, 1, '九成新运动鞋，鞋底磨损极小，透气舒适，尺码标准。', 2, NULL, '2026-08-20 22:57:50', 1);
INSERT INTO `goods` VALUES (22, 53, 3, '全新保温杯', 942.02, 1130.42, 1, '全新保温杯，304不锈钢内胆，保温效果好，未拆封。', 2, NULL, '2026-09-08 22:57:50', 1);
INSERT INTO `goods` VALUES (23, 62, 4, '折叠电脑桌', 661.91, 860.48, 1, '折叠电脑桌，床上办公神器，稳固不晃动，收纳方便。', 4, NULL, '2026-07-25 22:57:50', 1);
INSERT INTO `goods` VALUES (24, 90, 5, '九成新羽毛球拍', 824.24, 906.66, 2, '九成新羽毛球拍，手感舒适，拍线完好，附赠球拍包。', 3, NULL, '2026-08-21 22:57:50', 1);
INSERT INTO `goods` VALUES (25, 6, 1, '大学英语四级真题', 774.87, 929.84, 2, '大学英语四级真题，包含近年真题解析，刷题必备，成色很新。', 3, NULL, '2026-07-23 22:57:50', 1);
INSERT INTO `goods` VALUES (26, 1, 3, '全新保温杯', 974.63, 1267.02, 2, '全新保温杯，304不锈钢内胆，保温效果好，未拆封。', 1, NULL, '2026-08-04 22:57:50', 1);
INSERT INTO `goods` VALUES (27, 9, 4, '折叠电脑桌', 987.42, 1086.16, 2, '折叠电脑桌，床上办公神器，稳固不晃动，收纳方便。', 2, NULL, '2026-09-08 22:57:50', 1);
INSERT INTO `goods` VALUES (28, 2, 1, '高等数学教材', 408.53, 844.96, 2, '高等数学教材，内部有少量笔记，适合期末复习，价格可小刀。', 4, NULL, '2026-09-08 22:57:50', 1);
INSERT INTO `goods` VALUES (29, 78, 6, '九成新运动鞋', 800.47, 1040.61, 1, '九成新运动鞋，鞋底磨损极小，透气舒适，尺码标准。', 4, NULL, '2026-08-16 22:57:50', 1);
INSERT INTO `goods` VALUES (30, 80, 3, '全新保温杯', 932.46, 1025.71, 1, '全新保温杯，304不锈钢内胆，保温效果好，未拆封。', 1, NULL, '2026-09-04 22:57:50', 1);
INSERT INTO `goods` VALUES (31, 86, 1, '大学英语四级真题', 148.09, 274.00, 1, '大学英语四级真题，包含近年真题解析，刷题必备，成色很新。', 3, NULL, '2026-09-08 22:57:50', 2);
INSERT INTO `goods` VALUES (32, 70, 4, '宿舍小台灯', 11.20, 821.44, 2, '宿舍小台灯，三档调光，USB充电，护眼不频闪。', 3, NULL, '2026-08-23 22:57:50', 4);
INSERT INTO `goods` VALUES (33, 95, 2, '高性价比蓝牙耳机', 674.69, 742.16, 1, '高性价比蓝牙耳机，音质清晰，续航持久，无杂音。', 2, NULL, '2026-09-08 22:57:50', 3);
INSERT INTO `goods` VALUES (34, 31, 1, '高等数学教材', 128.61, 571.60, 1, '高等数学教材，内部有少量笔记，适合期末复习，价格可小刀。', 4, NULL, '2026-09-08 22:57:50', 2);
INSERT INTO `goods` VALUES (35, 60, 5, '闲置瑜伽垫', 789.41, 1026.23, 1, '闲置瑜伽垫，加厚防滑，回弹力好，适合初学者。', 2, NULL, '2026-08-19 22:57:50', 3);
INSERT INTO `goods` VALUES (36, 47, 3, '全新保温杯', 874.70, 962.17, 2, '全新保温杯，304不锈钢内胆，保温效果好，未拆封。', 4, NULL, '2026-07-09 22:57:50', 1);
INSERT INTO `goods` VALUES (37, 17, 2, '高性价比蓝牙耳机', 715.54, 858.65, 3, '高性价比蓝牙耳机，音质清晰，续航持久，无杂音。', 2, NULL, '2026-07-25 22:57:50', 2);
INSERT INTO `goods` VALUES (38, 86, 2, '自用iPad保护壳', 30.63, 48.91, 3, '自用iPad保护壳，硅胶材质，防摔防刮，几乎全新。', 4, '商品分类选择错误，请重新选择正确的分类。', '2026-09-05 22:57:50', 4);
INSERT INTO `goods` VALUES (39, 91, 2, '高性价比蓝牙耳机', 503.83, 770.32, 3, '高性价比蓝牙耳机，音质清晰，续航持久，无杂音。', 3, NULL, '2026-09-08 22:57:50', 3);
INSERT INTO `goods` VALUES (40, 33, 3, '全新保温杯', 332.58, 417.85, 3, '全新保温杯，304不锈钢内胆，保温效果好，未拆封。', 3, NULL, '2026-09-08 22:57:50', 2);
INSERT INTO `goods` VALUES (41, 79, 5, '闲置瑜伽垫', 175.78, 399.67, 2, '闲置瑜伽垫，加厚防滑，回弹力好，适合初学者。', 1, NULL, '2026-09-07 22:57:50', 3);
INSERT INTO `goods` VALUES (42, 41, 2, '自用iPad保护壳', 444.62, 839.46, 2, '自用iPad保护壳，硅胶材质，防摔防刮，几乎全新。', 5, NULL, '2026-07-03 22:57:50', 0);
INSERT INTO `goods` VALUES (43, 49, 6, '九成新运动鞋', 35.12, 786.93, 2, '九成新运动鞋，鞋底磨损极小，透气舒适，尺码标准。', 5, NULL, '2026-07-30 22:57:50', 3);
INSERT INTO `goods` VALUES (44, 6, 2, '自用iPad保护壳', 372.47, 484.21, 1, '自用iPad保护壳，硅胶材质，防摔防刮，几乎全新。', 2, NULL, '2026-07-17 22:57:50', 1);
INSERT INTO `goods` VALUES (45, 95, 6, '九成新运动鞋', 973.29, 1070.62, 1, '九成新运动鞋，鞋底磨损极小，透气舒适，尺码标准。', 4, NULL, '2026-09-08 22:57:50', 0);
INSERT INTO `goods` VALUES (46, 64, 2, '自用iPad保护壳', 538.05, 645.66, 3, '自用iPad保护壳，硅胶材质，防摔防刮，几乎全新。', 3, NULL, '2026-07-09 22:57:50', 1);
INSERT INTO `goods` VALUES (47, 44, 3, '多功能收纳盒', 226.23, 294.10, 1, '多功能收纳盒，桌面杂物一秒归位，材质坚固耐用。', 1, NULL, '2026-07-06 22:57:50', 3);
INSERT INTO `goods` VALUES (48, 30, 4, '宿舍小台灯', 145.17, 884.22, 2, '宿舍小台灯，三档调光，USB充电，护眼不频闪。', 4, '商品图片不清晰，请重新拍摄实物图后再提交审核。', '2026-07-04 22:57:50', 0);
INSERT INTO `goods` VALUES (49, 86, 4, '折叠电脑桌', 687.23, 993.69, 3, '折叠电脑桌，床上办公神器，稳固不晃动，收纳方便。', 4, NULL, '2026-09-08 22:57:50', 2);
INSERT INTO `goods` VALUES (50, 11, 5, '九成新羽毛球拍', 496.07, 613.29, 2, '九成新羽毛球拍，手感舒适，拍线完好，附赠球拍包。', 1, NULL, '2026-08-24 22:57:50', 4);
INSERT INTO `goods` VALUES (51, 84, 4, '折叠电脑桌', 936.69, 1030.36, 2, '折叠电脑桌，床上办公神器，稳固不晃动，收纳方便。', 2, NULL, '2026-08-21 22:57:50', 3);
INSERT INTO `goods` VALUES (52, 19, 2, '自用iPad保护壳', 445.55, 534.66, 2, '自用iPad保护壳，硅胶材质，防摔防刮，几乎全新。', 1, NULL, '2026-07-17 22:57:50', 1);
INSERT INTO `goods` VALUES (53, 74, 5, '闲置瑜伽垫', 822.44, 1069.17, 1, '闲置瑜伽垫，加厚防滑，回弹力好，适合初学者。', 4, NULL, '2026-08-20 22:57:50', 3);
INSERT INTO `goods` VALUES (54, 58, 3, '全新保温杯', 252.88, 884.42, 3, '全新保温杯，304不锈钢内胆，保温效果好，未拆封。', 2, NULL, '2026-09-08 22:57:50', 0);
INSERT INTO `goods` VALUES (55, 68, 6, '九成新运动鞋', 140.85, 859.74, 1, '九成新运动鞋，鞋底磨损极小，透气舒适，尺码标准。', 2, NULL, '2026-08-23 22:57:50', 2);
INSERT INTO `goods` VALUES (56, 7, 5, '九成新羽毛球拍', 635.95, 826.74, 2, '九成新羽毛球拍，手感舒适，拍线完好，附赠球拍包。', 4, NULL, '2026-09-08 22:57:50', 3);
INSERT INTO `goods` VALUES (57, 19, 1, '大学英语四级真题', 741.09, 999.21, 2, '大学英语四级真题，包含近年真题解析，刷题必备，成色很新。', 2, NULL, '2026-07-11 22:57:50', 3);
INSERT INTO `goods` VALUES (58, 67, 3, '全新保温杯', 981.68, 1178.02, 1, '全新保温杯，304不锈钢内胆，保温效果好，未拆封。', 2, '商品分类选择错误，请重新选择正确的分类。', '2026-08-04 22:57:50', 2);
INSERT INTO `goods` VALUES (59, 7, 2, '高性价比蓝牙耳机', 241.16, 657.19, 2, '高性价比蓝牙耳机，音质清晰，续航持久，无杂音。', 5, NULL, '2026-09-09 22:57:50', 3);
INSERT INTO `goods` VALUES (60, 22, 4, '宿舍小台灯', 744.31, 818.74, 3, '宿舍小台灯，三档调光，USB充电，护眼不频闪。', 3, NULL, '2026-08-04 22:57:50', 1);
INSERT INTO `goods` VALUES (61, 82, 6, '九成新运动鞋', 584.24, 658.50, 2, '九成新运动鞋，鞋底磨损极小，透气舒适，尺码标准。', 3, NULL, '2026-09-08 22:57:50', 1);
INSERT INTO `goods` VALUES (62, 3, 4, '宿舍小台灯', 86.25, 504.06, 2, '宿舍小台灯，三档调光，USB充电，护眼不频闪。', 3, NULL, '2026-09-08 22:57:50', 4);
INSERT INTO `goods` VALUES (63, 35, 1, '大学英语四级真题', 572.20, 629.42, 3, '大学英语四级真题，包含近年真题解析，刷题必备，成色很新。', 4, NULL, '2026-07-27 22:57:50', 3);
INSERT INTO `goods` VALUES (64, 4, 6, '全新卫衣', 893.94, 1072.73, 2, '全新卫衣，纯棉面料，宽松版型，颜色百搭，未下水。', 5, NULL, '2026-09-01 22:57:50', 2);
INSERT INTO `goods` VALUES (65, 45, 5, '闲置瑜伽垫', 823.80, 979.88, 2, '闲置瑜伽垫，加厚防滑，回弹力好，适合初学者。', 2, NULL, '2026-07-14 22:57:50', 1);
INSERT INTO `goods` VALUES (66, 10, 2, '自用iPad保护壳', 290.73, 319.80, 1, '自用iPad保护壳，硅胶材质，防摔防刮，几乎全新。', 4, NULL, '2026-09-08 22:57:50', 1);
INSERT INTO `goods` VALUES (67, 88, 6, '九成新运动鞋', 148.68, 706.20, 2, '九成新运动鞋，鞋底磨损极小，透气舒适，尺码标准。', 5, NULL, '2026-08-09 22:57:50', 1);
INSERT INTO `goods` VALUES (68, 35, 4, '宿舍小台灯', 323.41, 420.43, 2, '宿舍小台灯，三档调光，USB充电，护眼不频闪。', 1, NULL, '2026-07-18 22:57:50', 1);
INSERT INTO `goods` VALUES (69, 89, 2, '高性价比蓝牙耳机', 767.47, 844.22, 3, '高性价比蓝牙耳机，音质清晰，续航持久，无杂音。', 3, NULL, '2026-09-08 22:57:50', 1);
INSERT INTO `goods` VALUES (70, 35, 3, '全新保温杯', 943.00, 1131.60, 1, '全新保温杯，304不锈钢内胆，保温效果好，未拆封。', 2, NULL, '2026-08-02 22:57:50', 1);
INSERT INTO `goods` VALUES (71, 95, 2, '高性价比蓝牙耳机', 510.21, 663.27, 3, '高性价比蓝牙耳机，音质清晰，续航持久，无杂音。', 2, NULL, '2026-09-08 22:57:50', 4);
INSERT INTO `goods` VALUES (72, 54, 4, '宿舍小台灯', 399.38, 462.15, 2, '宿舍小台灯，三档调光，USB充电，护眼不频闪。', 1, NULL, '2026-09-08 22:57:50', 1);
INSERT INTO `goods` VALUES (73, 38, 5, '闲置瑜伽垫', 351.16, 421.39, 3, '闲置瑜伽垫，加厚防滑，回弹力好，适合初学者。', 2, NULL, '2026-07-16 22:57:50', 3);
INSERT INTO `goods` VALUES (74, 100, 1, '高等数学教材', 350.90, 941.49, 3, '高等数学教材，内部有少量笔记，适合期末复习，价格可小刀。', 2, NULL, '2026-08-14 22:57:50', 4);
INSERT INTO `goods` VALUES (75, 76, 6, '九成新运动鞋', 999.33, 1099.26, 2, '九成新运动鞋，鞋底磨损极小，透气舒适，尺码标准。', 4, NULL, '2026-07-12 22:57:50', 3);
INSERT INTO `goods` VALUES (76, 99, 3, '全新保温杯', 244.61, 293.53, 3, '全新保温杯，304不锈钢内胆，保温效果好，未拆封。', 1, NULL, '2026-07-17 22:57:50', 3);
INSERT INTO `goods` VALUES (77, 71, 6, '九成新运动鞋', 808.08, 1050.50, 2, '九成新运动鞋，鞋底磨损极小，透气舒适，尺码标准。', 5, NULL, '2026-08-14 22:57:50', 1);
INSERT INTO `goods` VALUES (78, 53, 6, '全新卫衣', 83.52, 308.00, 3, '全新卫衣，纯棉面料，宽松版型，颜色百搭，未下水。', 3, '商品分类选择错误，请重新选择正确的分类。', '2026-09-08 22:57:50', 0);
INSERT INTO `goods` VALUES (79, 36, 3, '多功能收纳盒', 428.12, 703.19, 2, '多功能收纳盒，桌面杂物一秒归位，材质坚固耐用。', 3, NULL, '2026-08-06 22:57:50', 3);
INSERT INTO `goods` VALUES (80, 99, 2, '自用iPad保护壳', 307.79, 996.46, 2, '自用iPad保护壳，硅胶材质，防摔防刮，几乎全新。', 4, NULL, '2026-08-03 22:57:50', 4);
INSERT INTO `goods` VALUES (81, 38, 4, '折叠电脑桌', 940.58, 1034.64, 2, '折叠电脑桌，床上办公神器，稳固不晃动，收纳方便。', 2, NULL, '2026-07-07 22:57:50', 3);
INSERT INTO `goods` VALUES (82, 64, 1, '高等数学教材', 417.29, 788.10, 2, '高等数学教材，内部有少量笔记，适合期末复习，价格可小刀。', 2, NULL, '2026-07-31 22:57:50', 2);
INSERT INTO `goods` VALUES (83, 90, 2, '高性价比蓝牙耳机', 429.75, 582.88, 2, '高性价比蓝牙耳机，音质清晰，续航持久，无杂音。', 3, NULL, '2026-08-06 22:57:50', 2);
INSERT INTO `goods` VALUES (84, 10, 3, '全新保温杯', 37.26, 613.67, 1, '全新保温杯，304不锈钢内胆，保温效果好，未拆封。', 4, NULL, '2026-09-08 22:57:50', 3);
INSERT INTO `goods` VALUES (85, 40, 3, '多功能收纳盒', 103.27, 123.92, 2, '多功能收纳盒，桌面杂物一秒归位，材质坚固耐用。', 5, NULL, '2026-08-06 22:57:50', 1);
INSERT INTO `goods` VALUES (86, 61, 4, '宿舍小台灯', 371.87, 483.43, 2, '宿舍小台灯，三档调光，USB充电，护眼不频闪。', 2, NULL, '2026-08-15 22:57:50', 3);
INSERT INTO `goods` VALUES (87, 63, 1, '大学英语四级真题', 479.76, 640.72, 2, '大学英语四级真题，包含近年真题解析，刷题必备，成色很新。', 4, NULL, '2026-07-28 22:57:50', 0);
INSERT INTO `goods` VALUES (88, 97, 6, '全新卫衣', 340.95, 781.14, 3, '全新卫衣，纯棉面料，宽松版型，颜色百搭，未下水。', 1, NULL, '2026-09-03 22:57:50', 3);
INSERT INTO `goods` VALUES (89, 1, 3, '多功能收纳盒', 154.49, 294.13, 2, '多功能收纳盒，桌面杂物一秒归位，材质坚固耐用。', 3, NULL, '2026-07-24 22:57:50', 3);
INSERT INTO `goods` VALUES (90, 61, 6, '全新卫衣', 775.22, 852.74, 1, '全新卫衣，纯棉面料，宽松版型，颜色百搭，未下水。', 2, NULL, '2026-07-26 22:57:50', 0);
INSERT INTO `goods` VALUES (91, 55, 4, '折叠电脑桌', 409.00, 574.39, 3, '折叠电脑桌，床上办公神器，稳固不晃动，收纳方便。', 4, NULL, '2026-09-01 22:57:50', 3);
INSERT INTO `goods` VALUES (92, 9, 2, '自用iPad保护壳', 239.73, 981.21, 2, '自用iPad保护壳，硅胶材质，防摔防刮，几乎全新。', 3, NULL, '2026-09-08 22:57:50', 1);
INSERT INTO `goods` VALUES (93, 37, 6, '九成新运动鞋', 201.62, 221.78, 2, '九成新运动鞋，鞋底磨损极小，透气舒适，尺码标准。', 2, NULL, '2026-09-08 22:57:50', 3);
INSERT INTO `goods` VALUES (94, 94, 6, '全新卫衣', 40.10, 248.64, 1, '全新卫衣，纯棉面料，宽松版型，颜色百搭，未下水。', 4, NULL, '2026-09-06 22:57:50', 2);
INSERT INTO `goods` VALUES (95, 75, 2, '高性价比蓝牙耳机', 166.46, 853.96, 1, '高性价比蓝牙耳机，音质清晰，续航持久，无杂音。', 4, NULL, '2026-07-18 22:57:50', 4);
INSERT INTO `goods` VALUES (96, 96, 4, '宿舍小台灯', 579.23, 914.43, 3, '宿舍小台灯，三档调光，USB充电，护眼不频闪。', 2, NULL, '2026-09-09 22:57:50', 0);
INSERT INTO `goods` VALUES (97, 6, 6, '九成新运动鞋', 817.54, 981.05, 2, '九成新运动鞋，鞋底磨损极小，透气舒适，尺码标准。', 4, NULL, '2026-08-04 22:57:50', 1);
INSERT INTO `goods` VALUES (98, 32, 3, '全新保温杯', 91.99, 601.53, 2, '全新保温杯，304不锈钢内胆，保温效果好，未拆封。', 4, '商品分类选择错误，请重新选择正确的分类。', '2026-08-14 22:57:50', 4);
INSERT INTO `goods` VALUES (99, 59, 4, '折叠电脑桌', 53.03, 226.10, 2, '折叠电脑桌，床上办公神器，稳固不晃动，收纳方便。', 4, NULL, '2026-07-25 22:57:50', 0);
INSERT INTO `goods` VALUES (100, 90, 1, '高等数学教材', 466.28, 559.54, 2, '高等数学教材，内部有少量笔记，适合期末复习，价格可小刀。', 1, NULL, '2026-08-27 22:57:50', 2);
INSERT INTO `goods` VALUES (101, 13, 6, '九成新运动鞋', 612.37, 796.08, 3, '九成新运动鞋，鞋底磨损极小，透气舒适，尺码标准。', 3, NULL, '2026-08-21 22:57:50', 4);
INSERT INTO `goods` VALUES (102, 83, 1, '高等数学教材', 518.97, 669.71, 2, '高等数学教材，内部有少量笔记，适合期末复习，价格可小刀。', 3, NULL, '2026-07-14 22:57:50', 3);
INSERT INTO `goods` VALUES (103, 65, 4, '折叠电脑桌', 506.16, 607.39, 1, '折叠电脑桌，床上办公神器，稳固不晃动，收纳方便。', 2, NULL, '2026-09-03 22:57:50', 3);
INSERT INTO `goods` VALUES (104, 62, 1, '高等数学教材', 475.13, 781.43, 2, '高等数学教材，内部有少量笔记，适合期末复习，价格可小刀。', 4, NULL, '2026-07-26 22:57:50', 3);
INSERT INTO `goods` VALUES (105, 12, 4, '折叠电脑桌', 605.49, 890.00, 1, '折叠电脑桌，床上办公神器，稳固不晃动，收纳方便。', 1, NULL, '2026-09-01 22:57:50', 3);
INSERT INTO `goods` VALUES (106, 70, 2, '自用iPad保护壳', 672.66, 717.64, 3, '自用iPad保护壳，硅胶材质，防摔防刮，几乎全新。', 3, NULL, '2026-08-21 22:57:50', 2);
INSERT INTO `goods` VALUES (107, 35, 2, '高性价比蓝牙耳机', 548.70, 653.10, 1, '高性价比蓝牙耳机，音质清晰，续航持久，无杂音。', 3, NULL, '2026-07-19 22:57:50', 3);
INSERT INTO `goods` VALUES (108, 19, 6, '全新卫衣', 911.14, 1002.25, 3, '全新卫衣，纯棉面料，宽松版型，颜色百搭，未下水。', 3, '商品图片不清晰，请重新拍摄实物图后再提交审核。', '2026-07-24 22:57:50', 0);
INSERT INTO `goods` VALUES (109, 52, 4, '折叠电脑桌', 815.67, 823.89, 2, '折叠电脑桌，床上办公神器，稳固不晃动，收纳方便。', 5, NULL, '2026-08-08 22:57:50', 2);
INSERT INTO `goods` VALUES (110, 11, 2, '自用iPad保护壳', 264.31, 801.19, 2, '自用iPad保护壳，硅胶材质，防摔防刮，几乎全新。', 3, NULL, '2026-08-11 22:57:50', 4);
INSERT INTO `goods` VALUES (111, 11, 1, '大学英语四级真题', 520.36, 572.40, 2, '大学英语四级真题，包含近年真题解析，刷题必备，成色很新。', 2, NULL, '2026-08-18 22:57:50', 3);
INSERT INTO `goods` VALUES (112, 81, 1, '高等数学教材', 189.71, 613.56, 2, '高等数学教材，内部有少量笔记，适合期末复习，价格可小刀。', 5, NULL, '2026-07-08 22:57:50', 1);
INSERT INTO `goods` VALUES (113, 42, 1, '大学英语四级真题', 849.17, 1103.92, 2, '大学英语四级真题，包含近年真题解析，刷题必备，成色很新。', 2, NULL, '2026-09-01 22:57:50', 3);
INSERT INTO `goods` VALUES (114, 34, 5, '九成新羽毛球拍', 745.34, 819.87, 2, '九成新羽毛球拍，手感舒适，拍线完好，附赠球拍包。', 3, NULL, '2026-08-11 22:57:50', 1);
INSERT INTO `goods` VALUES (115, 80, 3, '多功能收纳盒', 662.54, 795.05, 1, '多功能收纳盒，桌面杂物一秒归位，材质坚固耐用。', 3, NULL, '2026-09-05 22:57:50', 2);
INSERT INTO `goods` VALUES (116, 52, 1, '高等数学教材', 134.17, 729.67, 2, '高等数学教材，内部有少量笔记，适合期末复习，价格可小刀。', 3, NULL, '2026-08-21 22:57:50', 4);
INSERT INTO `goods` VALUES (117, 79, 4, '折叠电脑桌', 949.67, 1044.64, 3, '折叠电脑桌，床上办公神器，稳固不晃动，收纳方便。', 3, NULL, '2026-09-08 22:57:50', 0);
INSERT INTO `goods` VALUES (118, 46, 6, '全新卫衣', 323.54, 443.45, 3, '全新卫衣，纯棉面料，宽松版型，颜色百搭，未下水。', 5, NULL, '2026-09-08 22:57:50', 3);
INSERT INTO `goods` VALUES (119, 83, 3, '多功能收纳盒', 146.83, 259.33, 2, '多功能收纳盒，桌面杂物一秒归位，材质坚固耐用。', 3, NULL, '2026-07-05 22:57:50', 4);
INSERT INTO `goods` VALUES (120, 45, 5, '九成新羽毛球拍', 54.14, 332.82, 1, '九成新羽毛球拍，手感舒适，拍线完好，附赠球拍包。', 3, NULL, '2026-06-29 22:57:50', 0);
INSERT INTO `goods` VALUES (121, 27, 3, '多功能收纳盒', 48.17, 263.92, 2, '多功能收纳盒，桌面杂物一秒归位，材质坚固耐用。', 3, NULL, '2026-07-08 22:57:50', 3);
INSERT INTO `goods` VALUES (122, 47, 2, '自用iPad保护壳', 150.17, 984.28, 1, '自用iPad保护壳，硅胶材质，防摔防刮，几乎全新。', 4, NULL, '2026-07-27 22:57:50', 3);
INSERT INTO `goods` VALUES (123, 8, 6, '九成新运动鞋', 463.48, 805.56, 2, '九成新运动鞋，鞋底磨损极小，透气舒适，尺码标准。', 3, NULL, '2026-08-08 22:57:50', 3);
INSERT INTO `goods` VALUES (124, 22, 5, '九成新羽毛球拍', 355.71, 575.36, 3, '九成新羽毛球拍，手感舒适，拍线完好，附赠球拍包。', 5, NULL, '2026-08-09 22:57:50', 2);
INSERT INTO `goods` VALUES (125, 56, 4, '折叠电脑桌', 839.74, 1091.66, 2, '折叠电脑桌，床上办公神器，稳固不晃动，收纳方便。', 1, NULL, '2026-07-17 22:57:50', 3);
INSERT INTO `goods` VALUES (126, 7, 4, '宿舍小台灯', 361.58, 539.71, 2, '宿舍小台灯，三档调光，USB充电，护眼不频闪。', 1, NULL, '2026-09-08 22:57:50', 1);
INSERT INTO `goods` VALUES (127, 58, 4, '折叠电脑桌', 382.98, 459.58, 1, '折叠电脑桌，床上办公神器，稳固不晃动，收纳方便。', 2, NULL, '2026-09-08 22:57:50', 2);
INSERT INTO `goods` VALUES (128, 34, 2, '自用iPad保护壳', 385.59, 408.63, 2, '自用iPad保护壳，硅胶材质，防摔防刮，几乎全新。', 3, NULL, '2026-08-06 22:57:50', 1);
INSERT INTO `goods` VALUES (129, 16, 6, '九成新运动鞋', 469.88, 516.87, 2, '九成新运动鞋，鞋底磨损极小，透气舒适，尺码标准。', 2, NULL, '2026-08-23 22:57:50', 0);
INSERT INTO `goods` VALUES (130, 43, 3, '全新保温杯', 402.42, 482.90, 1, '全新保温杯，304不锈钢内胆，保温效果好，未拆封。', 4, NULL, '2026-08-16 22:57:50', 2);
INSERT INTO `goods` VALUES (131, 27, 4, '折叠电脑桌', 822.23, 1068.90, 2, '折叠电脑桌，床上办公神器，稳固不晃动，收纳方便。', 3, NULL, '2026-07-19 22:57:50', 4);
INSERT INTO `goods` VALUES (132, 97, 1, '高等数学教材', 369.71, 406.68, 2, '高等数学教材，内部有少量笔记，适合期末复习，价格可小刀。', 4, NULL, '2026-09-01 22:57:50', 3);
INSERT INTO `goods` VALUES (133, 71, 2, '高性价比蓝牙耳机', 881.66, 1057.99, 1, '高性价比蓝牙耳机，音质清晰，续航持久，无杂音。', 5, NULL, '2026-07-31 22:57:50', 1);
INSERT INTO `goods` VALUES (134, 51, 6, '全新卫衣', 927.81, 1206.15, 3, '全新卫衣，纯棉面料，宽松版型，颜色百搭，未下水。', 2, NULL, '2026-08-12 22:57:50', 4);
INSERT INTO `goods` VALUES (135, 32, 1, '大学英语四级真题', 693.17, 762.49, 2, '大学英语四级真题，包含近年真题解析，刷题必备，成色很新。', 2, NULL, '2026-08-24 22:57:50', 0);
INSERT INTO `goods` VALUES (136, 50, 3, '全新保温杯', 290.35, 586.07, 2, '全新保温杯，304不锈钢内胆，保温效果好，未拆封。', 5, NULL, '2026-06-29 22:57:50', 1);
INSERT INTO `goods` VALUES (137, 41, 5, '闲置瑜伽垫', 985.73, 1281.45, 3, '闲置瑜伽垫，加厚防滑，回弹力好，适合初学者。', 2, NULL, '2026-07-05 22:57:50', 3);
INSERT INTO `goods` VALUES (138, 9, 6, '全新卫衣', 728.16, 770.12, 3, '全新卫衣，纯棉面料，宽松版型，颜色百搭，未下水。', 2, NULL, '2026-09-08 22:57:50', 3);
INSERT INTO `goods` VALUES (139, 9, 4, '折叠电脑桌', 109.57, 985.12, 3, '折叠电脑桌，床上办公神器，稳固不晃动，收纳方便。', 1, NULL, '2026-09-08 22:57:50', 1);
INSERT INTO `goods` VALUES (140, 15, 1, '高等数学教材', 737.47, 958.71, 2, '高等数学教材，内部有少量笔记，适合期末复习，价格可小刀。', 3, NULL, '2026-08-13 22:57:50', 3);
INSERT INTO `goods` VALUES (141, 24, 1, '大学英语四级真题', 393.65, 538.30, 2, '大学英语四级真题，包含近年真题解析，刷题必备，成色很新。', 4, NULL, '2026-08-14 22:57:50', 0);
INSERT INTO `goods` VALUES (142, 14, 4, '宿舍小台灯', 477.99, 573.59, 2, '宿舍小台灯，三档调光，USB充电，护眼不频闪。', 3, NULL, '2026-08-18 22:57:50', 1);
INSERT INTO `goods` VALUES (143, 26, 3, '多功能收纳盒', 863.92, 919.54, 1, '多功能收纳盒，桌面杂物一秒归位，材质坚固耐用。', 1, NULL, '2026-08-14 22:57:50', 3);
INSERT INTO `goods` VALUES (144, 67, 6, '全新卫衣', 872.24, 959.46, 3, '全新卫衣，纯棉面料，宽松版型，颜色百搭，未下水。', 5, NULL, '2026-08-05 22:57:50', 3);
INSERT INTO `goods` VALUES (145, 17, 4, '折叠电脑桌', 658.96, 790.75, 2, '折叠电脑桌，床上办公神器，稳固不晃动，收纳方便。', 5, NULL, '2026-07-27 22:57:50', 3);
INSERT INTO `goods` VALUES (146, 4, 4, '宿舍小台灯', 794.89, 950.34, 2, '宿舍小台灯，三档调光，USB充电，护眼不频闪。', 1, NULL, '2026-09-08 22:57:50', 3);
INSERT INTO `goods` VALUES (147, 20, 4, '折叠电脑桌', 216.33, 302.03, 2, '折叠电脑桌，床上办公神器，稳固不晃动，收纳方便。', 5, NULL, '2026-09-06 22:57:50', 3);
INSERT INTO `goods` VALUES (148, 59, 3, '全新保温杯', 240.43, 336.05, 2, '全新保温杯，304不锈钢内胆，保温效果好，未拆封。', 3, NULL, '2026-07-02 22:57:50', 3);
INSERT INTO `goods` VALUES (149, 40, 6, '九成新运动鞋', 622.13, 808.77, 3, '九成新运动鞋，鞋底磨损极小，透气舒适，尺码标准。', 4, NULL, '2026-08-22 22:57:50', 4);
INSERT INTO `goods` VALUES (150, 10, 3, '全新保温杯', 614.13, 675.54, 2, '全新保温杯，304不锈钢内胆，保温效果好，未拆封。', 3, NULL, '2026-09-08 22:57:50', 1);
INSERT INTO `goods` VALUES (151, 37, 3, '多功能收纳盒', 490.76, 525.52, 1, '多功能收纳盒，桌面杂物一秒归位，材质坚固耐用。', 4, NULL, '2026-08-27 22:57:50', 3);
INSERT INTO `goods` VALUES (152, 4, 3, '全新保温杯', 924.10, 1201.33, 3, '全新保温杯，304不锈钢内胆，保温效果好，未拆封。', 1, NULL, '2026-09-03 22:57:50', 1);
INSERT INTO `goods` VALUES (153, 62, 5, '闲置瑜伽垫', 687.90, 756.69, 2, '闲置瑜伽垫，加厚防滑，回弹力好，适合初学者。', 5, NULL, '2026-07-18 22:57:50', 3);
INSERT INTO `goods` VALUES (154, 64, 5, '九成新羽毛球拍', 871.33, 1045.60, 1, '九成新羽毛球拍，手感舒适，拍线完好，附赠球拍包。', 2, NULL, '2026-08-01 22:57:50', 2);
INSERT INTO `goods` VALUES (155, 24, 5, '闲置瑜伽垫', 423.87, 932.01, 2, '闲置瑜伽垫，加厚防滑，回弹力好，适合初学者。', 5, NULL, '2026-08-21 22:57:50', 3);
INSERT INTO `goods` VALUES (156, 37, 3, '全新保温杯', 427.33, 470.06, 2, '全新保温杯，304不锈钢内胆，保温效果好，未拆封。', 4, NULL, '2026-08-20 22:57:50', 0);
INSERT INTO `goods` VALUES (157, 45, 1, '大学英语四级真题', 735.17, 882.20, 2, '大学英语四级真题，包含近年真题解析，刷题必备，成色很新。', 4, NULL, '2026-06-25 22:57:50', 3);
INSERT INTO `goods` VALUES (158, 63, 1, '高等数学教材', 800.43, 1040.56, 2, '高等数学教材，内部有少量笔记，适合期末复习，价格可小刀。', 3, NULL, '2026-07-31 22:57:50', 3);
INSERT INTO `goods` VALUES (159, 4, 2, '高性价比蓝牙耳机', 990.79, 1089.87, 2, '高性价比蓝牙耳机，音质清晰，续航持久，无杂音。', 3, NULL, '2026-09-08 22:57:50', 0);
INSERT INTO `goods` VALUES (160, 91, 3, '全新保温杯', 689.41, 989.33, 3, '全新保温杯，304不锈钢内胆，保温效果好，未拆封。', 2, NULL, '2026-09-02 22:57:50', 2);
INSERT INTO `goods` VALUES (161, 23, 1, '大学英语四级真题', 448.85, 583.51, 2, '大学英语四级真题，包含近年真题解析，刷题必备，成色很新。', 4, NULL, '2026-09-08 22:57:50', 1);
INSERT INTO `goods` VALUES (162, 61, 5, '九成新羽毛球拍', 385.72, 676.12, 1, '九成新羽毛球拍，手感舒适，拍线完好，附赠球拍包。', 2, NULL, '2026-08-01 22:57:50', 3);
INSERT INTO `goods` VALUES (163, 95, 1, '大学英语四级真题', 170.44, 451.51, 2, '大学英语四级真题，包含近年真题解析，刷题必备，成色很新。', 4, NULL, '2026-09-08 22:57:50', 3);
INSERT INTO `goods` VALUES (164, 53, 2, '自用iPad保护壳', 400.97, 676.18, 3, '自用iPad保护壳，硅胶材质，防摔防刮，几乎全新。', 3, NULL, '2026-09-08 22:57:50', 4);
INSERT INTO `goods` VALUES (165, 36, 2, '高性价比蓝牙耳机', 124.30, 999.35, 3, '高性价比蓝牙耳机，音质清晰，续航持久，无杂音。', 4, NULL, '2026-08-25 22:57:50', 1);
INSERT INTO `goods` VALUES (166, 67, 6, '全新卫衣', 665.52, 913.37, 2, '全新卫衣，纯棉面料，宽松版型，颜色百搭，未下水。', 4, NULL, '2026-08-05 22:57:50', 1);
INSERT INTO `goods` VALUES (167, 73, 6, '九成新运动鞋', 468.34, 608.84, 1, '九成新运动鞋，鞋底磨损极小，透气舒适，尺码标准。', 2, NULL, '2026-07-02 22:57:50', 3);
INSERT INTO `goods` VALUES (168, 47, 2, '自用iPad保护壳', 882.73, 971.00, 1, '自用iPad保护壳，硅胶材质，防摔防刮，几乎全新。', 3, '商品图片不清晰，请重新拍摄实物图后再提交审核。', '2026-07-12 22:57:50', 0);
INSERT INTO `goods` VALUES (169, 28, 1, '大学英语四级真题', 525.29, 630.35, 2, '大学英语四级真题，包含近年真题解析，刷题必备，成色很新。', 3, NULL, '2026-09-08 22:57:50', 2);
INSERT INTO `goods` VALUES (170, 2, 2, '自用iPad保护壳', 848.49, 1103.04, 3, '自用iPad保护壳，硅胶材质，防摔防刮，几乎全新。', 2, NULL, '2026-09-08 22:57:50', 4);
INSERT INTO `goods` VALUES (171, 62, 6, '九成新运动鞋', 471.57, 652.49, 3, '九成新运动鞋，鞋底磨损极小，透气舒适，尺码标准。', 2, NULL, '2026-08-01 22:57:50', 0);
INSERT INTO `goods` VALUES (172, 97, 5, '九成新羽毛球拍', 291.61, 391.75, 2, '九成新羽毛球拍，手感舒适，拍线完好，附赠球拍包。', 4, NULL, '2026-08-31 22:57:50', 2);
INSERT INTO `goods` VALUES (173, 40, 6, '九成新运动鞋', 568.34, 738.84, 1, '九成新运动鞋，鞋底磨损极小，透气舒适，尺码标准。', 3, '商品描述不完整，请补充详细的功能或成色说明。', '2026-08-05 22:57:50', 4);
INSERT INTO `goods` VALUES (174, 1, 1, '高等数学教材', 606.21, 922.17, 2, '高等数学教材，内部有少量笔记，适合期末复习，价格可小刀。', 1, NULL, '2026-08-04 22:57:50', 3);
INSERT INTO `goods` VALUES (175, 15, 4, '折叠电脑桌', 637.65, 686.75, 3, '折叠电脑桌，床上办公神器，稳固不晃动，收纳方便。', 4, NULL, '2026-08-31 22:57:50', 1);
INSERT INTO `goods` VALUES (176, 17, 6, '全新卫衣', 455.73, 520.48, 1, '全新卫衣，纯棉面料，宽松版型，颜色百搭，未下水。', 5, NULL, '2026-07-15 22:57:50', 3);
INSERT INTO `goods` VALUES (177, 40, 6, '九成新运动鞋', 736.60, 810.26, 1, '九成新运动鞋，鞋底磨损极小，透气舒适，尺码标准。', 2, NULL, '2026-08-24 22:57:50', 3);
INSERT INTO `goods` VALUES (178, 76, 1, '高等数学教材', 539.68, 669.34, 2, '高等数学教材，内部有少量笔记，适合期末复习，价格可小刀。', 3, NULL, '2026-07-13 22:57:50', 1);
INSERT INTO `goods` VALUES (179, 77, 4, '折叠电脑桌', 16.35, 89.59, 1, '折叠电脑桌，床上办公神器，稳固不晃动，收纳方便。', 3, NULL, '2026-08-30 22:57:50', 3);
INSERT INTO `goods` VALUES (180, 58, 1, '高等数学教材', 922.73, 1015.00, 2, '高等数学教材，内部有少量笔记，适合期末复习，价格可小刀。', 4, NULL, '2026-09-08 22:57:50', 0);
INSERT INTO `goods` VALUES (181, 8, 4, '折叠电脑桌', 783.02, 939.62, 1, '折叠电脑桌，床上办公神器，稳固不晃动，收纳方便。', 3, NULL, '2026-07-28 22:57:50', 2);
INSERT INTO `goods` VALUES (182, 12, 3, '全新保温杯', 495.72, 644.44, 2, '全新保温杯，304不锈钢内胆，保温效果好，未拆封。', 2, NULL, '2026-08-27 22:57:50', 4);
INSERT INTO `goods` VALUES (183, 35, 2, '高性价比蓝牙耳机', 746.92, 903.60, 1, '高性价比蓝牙耳机，音质清晰，续航持久，无杂音。', 4, '商品包含违规信息，请修改后再提交。', '2026-07-21 22:57:50', 0);
INSERT INTO `goods` VALUES (184, 8, 2, '自用iPad保护壳', 278.23, 551.37, 2, '自用iPad保护壳，硅胶材质，防摔防刮，几乎全新。', 5, NULL, '2026-07-13 22:57:50', 2);
INSERT INTO `goods` VALUES (185, 49, 6, '九成新运动鞋', 930.88, 1210.14, 1, '九成新运动鞋，鞋底磨损极小，透气舒适，尺码标准。', 1, NULL, '2026-08-13 22:57:50', 1);
INSERT INTO `goods` VALUES (186, 69, 5, '九成新羽毛球拍', 163.32, 974.20, 3, '九成新羽毛球拍，手感舒适，拍线完好，附赠球拍包。', 2, NULL, '2026-07-10 22:57:50', 3);
INSERT INTO `goods` VALUES (187, 16, 4, '折叠电脑桌', 499.56, 599.47, 1, '折叠电脑桌，床上办公神器，稳固不晃动，收纳方便。', 2, NULL, '2026-08-13 22:57:50', 3);
INSERT INTO `goods` VALUES (188, 32, 1, '高等数学教材', 887.26, 896.87, 1, '高等数学教材，内部有少量笔记，适合期末复习，价格可小刀。', 2, NULL, '2026-08-14 22:57:50', 1);
INSERT INTO `goods` VALUES (189, 82, 4, '折叠电脑桌', 68.37, 217.70, 2, '折叠电脑桌，床上办公神器，稳固不晃动，收纳方便。', 4, NULL, '2026-09-08 22:57:50', 1);
INSERT INTO `goods` VALUES (190, 95, 4, '宿舍小台灯', 695.15, 935.33, 3, '宿舍小台灯，三档调光，USB充电，护眼不频闪。', 3, NULL, '2026-09-08 22:57:50', 3);
INSERT INTO `goods` VALUES (191, 38, 5, '闲置瑜伽垫', 406.85, 528.91, 2, '闲置瑜伽垫，加厚防滑，回弹力好，适合初学者。', 2, NULL, '2026-07-18 22:57:50', 1);
INSERT INTO `goods` VALUES (192, 49, 1, '高等数学教材', 534.69, 700.80, 2, '高等数学教材，内部有少量笔记，适合期末复习，价格可小刀。', 4, NULL, '2026-07-28 22:57:50', 0);
INSERT INTO `goods` VALUES (193, 51, 4, '折叠电脑桌', 723.48, 737.15, 2, '折叠电脑桌，床上办公神器，稳固不晃动，收纳方便。', 4, '商品描述不完整，请补充详细的功能或成色说明。', '2026-08-23 22:57:50', 2);
INSERT INTO `goods` VALUES (194, 76, 6, '全新卫衣', 489.03, 635.74, 2, '全新卫衣，纯棉面料，宽松版型，颜色百搭，未下水。', 2, NULL, '2026-07-01 22:57:50', 4);
INSERT INTO `goods` VALUES (195, 44, 4, '折叠电脑桌', 883.01, 981.22, 2, '折叠电脑桌，床上办公神器，稳固不晃动，收纳方便。', 4, NULL, '2026-07-10 22:57:50', 3);
INSERT INTO `goods` VALUES (196, 61, 6, '全新卫衣', 381.38, 669.12, 2, '全新卫衣，纯棉面料，宽松版型，颜色百搭，未下水。', 2, NULL, '2026-07-30 22:57:50', 1);
INSERT INTO `goods` VALUES (197, 48, 1, '大学英语四级真题', 104.69, 570.89, 1, '大学英语四级真题，包含近年真题解析，刷题必备，成色很新。', 4, NULL, '2026-07-27 22:57:50', 3);
INSERT INTO `goods` VALUES (198, 79, 5, '九成新羽毛球拍', 245.21, 901.12, 2, '九成新羽毛球拍，手感舒适，拍线完好，附赠球拍包。', 4, NULL, '2026-09-08 22:57:50', 3);
INSERT INTO `goods` VALUES (199, 15, 2, '高性价比蓝牙耳机', 891.30, 1069.56, 2, '高性价比蓝牙耳机，音质清晰，续航持久，无杂音。', 2, NULL, '2026-08-17 22:57:50', 2);
INSERT INTO `goods` VALUES (200, 73, 6, '全新卫衣', 717.80, 795.89, 2, '全新卫衣，纯棉面料，宽松版型，颜色百搭，未下水。', 3, NULL, '2026-07-14 22:57:50', 3);

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
INSERT INTO `goods_image` VALUES (1, 26, 'http://localhost:5173/goods/cup.jpg', 1);
INSERT INTO `goods_image` VALUES (2, 89, 'http://localhost:5173/goods/box.jpg', 1);
INSERT INTO `goods_image` VALUES (3, 174, 'http://localhost:5173/goods/math.jpg', 1);
INSERT INTO `goods_image` VALUES (4, 28, 'http://localhost:5173/goods/math.jpg', 1);
INSERT INTO `goods_image` VALUES (5, 170, 'http://localhost:5173/goods/ipad.jpg', 1);
INSERT INTO `goods_image` VALUES (6, 62, 'http://localhost:5173/goods/lamp.jpg', 1);
INSERT INTO `goods_image` VALUES (7, 6, 'http://localhost:5173/goods/lamp.jpg', 1);
INSERT INTO `goods_image` VALUES (8, 64, 'http://localhost:5173/goods/hoodie.jpg', 1);
INSERT INTO `goods_image` VALUES (9, 146, 'http://localhost:5173/goods/lamp.jpg', 1);
INSERT INTO `goods_image` VALUES (10, 152, 'http://localhost:5173/goods/cup.jpg', 1);
INSERT INTO `goods_image` VALUES (11, 159, 'http://localhost:5173/goods/headset.jpg', 1);
INSERT INTO `goods_image` VALUES (12, 25, 'http://localhost:5173/goods/english.jpg', 1);
INSERT INTO `goods_image` VALUES (13, 44, 'http://localhost:5173/goods/ipad.jpg', 1);
INSERT INTO `goods_image` VALUES (14, 97, 'http://localhost:5173/goods/shoes.jpg', 1);
INSERT INTO `goods_image` VALUES (15, 12, 'http://localhost:5173/goods/math.jpg', 1);
INSERT INTO `goods_image` VALUES (16, 56, 'http://localhost:5173/goods/badminton.jpg', 1);
INSERT INTO `goods_image` VALUES (17, 59, 'http://localhost:5173/goods/headset.jpg', 1);
INSERT INTO `goods_image` VALUES (18, 126, 'http://localhost:5173/goods/lamp.jpg', 1);
INSERT INTO `goods_image` VALUES (19, 123, 'http://localhost:5173/goods/shoes.jpg', 1);
INSERT INTO `goods_image` VALUES (20, 181, 'http://localhost:5173/goods/desk.jpg', 1);
INSERT INTO `goods_image` VALUES (21, 184, 'http://localhost:5173/goods/ipad.jpg', 1);
INSERT INTO `goods_image` VALUES (22, 27, 'http://localhost:5173/goods/desk.jpg', 1);
INSERT INTO `goods_image` VALUES (23, 92, 'http://localhost:5173/goods/ipad.jpg', 1);
INSERT INTO `goods_image` VALUES (24, 138, 'http://localhost:5173/goods/hoodie.jpg', 1);
INSERT INTO `goods_image` VALUES (25, 139, 'http://localhost:5173/goods/desk.jpg', 1);
INSERT INTO `goods_image` VALUES (26, 15, 'http://localhost:5173/goods/yoga.jpg', 1);
INSERT INTO `goods_image` VALUES (27, 66, 'http://localhost:5173/goods/ipad.jpg', 1);
INSERT INTO `goods_image` VALUES (28, 84, 'http://localhost:5173/goods/cup.jpg', 1);
INSERT INTO `goods_image` VALUES (29, 150, 'http://localhost:5173/goods/cup.jpg', 1);
INSERT INTO `goods_image` VALUES (30, 50, 'http://localhost:5173/goods/badminton.jpg', 1);
INSERT INTO `goods_image` VALUES (31, 110, 'http://localhost:5173/goods/ipad.jpg', 1);
INSERT INTO `goods_image` VALUES (32, 111, 'http://localhost:5173/goods/english.jpg', 1);
INSERT INTO `goods_image` VALUES (33, 105, 'http://localhost:5173/goods/desk.jpg', 1);
INSERT INTO `goods_image` VALUES (34, 182, 'http://localhost:5173/goods/cup.jpg', 1);
INSERT INTO `goods_image` VALUES (35, 101, 'http://localhost:5173/goods/shoes.jpg', 1);
INSERT INTO `goods_image` VALUES (36, 142, 'http://localhost:5173/goods/lamp.jpg', 1);
INSERT INTO `goods_image` VALUES (37, 140, 'http://localhost:5173/goods/math.jpg', 1);
INSERT INTO `goods_image` VALUES (38, 175, 'http://localhost:5173/goods/desk.jpg', 1);
INSERT INTO `goods_image` VALUES (39, 199, 'http://localhost:5173/goods/headset.jpg', 1);
INSERT INTO `goods_image` VALUES (40, 129, 'http://localhost:5173/goods/shoes.jpg', 1);
INSERT INTO `goods_image` VALUES (41, 187, 'http://localhost:5173/goods/desk.jpg', 1);
INSERT INTO `goods_image` VALUES (42, 37, 'http://localhost:5173/goods/headset.jpg', 1);
INSERT INTO `goods_image` VALUES (43, 145, 'http://localhost:5173/goods/desk.jpg', 1);
INSERT INTO `goods_image` VALUES (44, 176, 'http://localhost:5173/goods/hoodie.jpg', 1);
INSERT INTO `goods_image` VALUES (45, 11, 'http://localhost:5173/goods/english.jpg', 1);
INSERT INTO `goods_image` VALUES (46, 52, 'http://localhost:5173/goods/ipad.jpg', 1);
INSERT INTO `goods_image` VALUES (47, 57, 'http://localhost:5173/goods/english.jpg', 1);
INSERT INTO `goods_image` VALUES (48, 108, 'http://localhost:5173/goods/hoodie.jpg', 1);
INSERT INTO `goods_image` VALUES (49, 19, 'http://localhost:5173/goods/yoga.jpg', 1);
INSERT INTO `goods_image` VALUES (50, 147, 'http://localhost:5173/goods/desk.jpg', 1);
INSERT INTO `goods_image` VALUES (51, 60, 'http://localhost:5173/goods/lamp.jpg', 1);
INSERT INTO `goods_image` VALUES (52, 124, 'http://localhost:5173/goods/badminton.jpg', 1);
INSERT INTO `goods_image` VALUES (53, 161, 'http://localhost:5173/goods/english.jpg', 1);
INSERT INTO `goods_image` VALUES (54, 141, 'http://localhost:5173/goods/english.jpg', 1);
INSERT INTO `goods_image` VALUES (55, 155, 'http://localhost:5173/goods/yoga.jpg', 1);
INSERT INTO `goods_image` VALUES (56, 143, 'http://localhost:5173/goods/box.jpg', 1);
INSERT INTO `goods_image` VALUES (57, 121, 'http://localhost:5173/goods/box.jpg', 1);
INSERT INTO `goods_image` VALUES (58, 131, 'http://localhost:5173/goods/desk.jpg', 1);
INSERT INTO `goods_image` VALUES (59, 169, 'http://localhost:5173/goods/english.jpg', 1);
INSERT INTO `goods_image` VALUES (60, 16, 'http://localhost:5173/goods/ipad.jpg', 1);
INSERT INTO `goods_image` VALUES (61, 48, 'http://localhost:5173/goods/lamp.jpg', 1);
INSERT INTO `goods_image` VALUES (62, 34, 'http://localhost:5173/goods/math.jpg', 1);
INSERT INTO `goods_image` VALUES (63, 98, 'http://localhost:5173/goods/cup.jpg', 1);
INSERT INTO `goods_image` VALUES (64, 135, 'http://localhost:5173/goods/english.jpg', 1);
INSERT INTO `goods_image` VALUES (65, 188, 'http://localhost:5173/goods/math.jpg', 1);
INSERT INTO `goods_image` VALUES (66, 40, 'http://localhost:5173/goods/cup.jpg', 1);
INSERT INTO `goods_image` VALUES (67, 114, 'http://localhost:5173/goods/badminton.jpg', 1);
INSERT INTO `goods_image` VALUES (68, 128, 'http://localhost:5173/goods/ipad.jpg', 1);
INSERT INTO `goods_image` VALUES (69, 63, 'http://localhost:5173/goods/english.jpg', 1);
INSERT INTO `goods_image` VALUES (70, 68, 'http://localhost:5173/goods/lamp.jpg', 1);
INSERT INTO `goods_image` VALUES (71, 70, 'http://localhost:5173/goods/cup.jpg', 1);
INSERT INTO `goods_image` VALUES (72, 107, 'http://localhost:5173/goods/headset.jpg', 1);
INSERT INTO `goods_image` VALUES (73, 183, 'http://localhost:5173/goods/headset.jpg', 1);
INSERT INTO `goods_image` VALUES (74, 79, 'http://localhost:5173/goods/box.jpg', 1);
INSERT INTO `goods_image` VALUES (75, 165, 'http://localhost:5173/goods/headset.jpg', 1);
INSERT INTO `goods_image` VALUES (76, 93, 'http://localhost:5173/goods/shoes.jpg', 1);
INSERT INTO `goods_image` VALUES (77, 151, 'http://localhost:5173/goods/box.jpg', 1);
INSERT INTO `goods_image` VALUES (78, 156, 'http://localhost:5173/goods/cup.jpg', 1);
INSERT INTO `goods_image` VALUES (79, 73, 'http://localhost:5173/goods/yoga.jpg', 1);
INSERT INTO `goods_image` VALUES (80, 81, 'http://localhost:5173/goods/desk.jpg', 1);
INSERT INTO `goods_image` VALUES (81, 191, 'http://localhost:5173/goods/yoga.jpg', 1);
INSERT INTO `goods_image` VALUES (82, 85, 'http://localhost:5173/goods/box.jpg', 1);
INSERT INTO `goods_image` VALUES (83, 149, 'http://localhost:5173/goods/shoes.jpg', 1);
INSERT INTO `goods_image` VALUES (84, 173, 'http://localhost:5173/goods/shoes.jpg', 1);
INSERT INTO `goods_image` VALUES (85, 177, 'http://localhost:5173/goods/shoes.jpg', 1);
INSERT INTO `goods_image` VALUES (86, 17, 'http://localhost:5173/goods/box.jpg', 1);
INSERT INTO `goods_image` VALUES (87, 42, 'http://localhost:5173/goods/ipad.jpg', 1);
INSERT INTO `goods_image` VALUES (88, 137, 'http://localhost:5173/goods/yoga.jpg', 1);
INSERT INTO `goods_image` VALUES (89, 113, 'http://localhost:5173/goods/english.jpg', 1);
INSERT INTO `goods_image` VALUES (90, 130, 'http://localhost:5173/goods/cup.jpg', 1);
INSERT INTO `goods_image` VALUES (91, 47, 'http://localhost:5173/goods/box.jpg', 1);
INSERT INTO `goods_image` VALUES (92, 195, 'http://localhost:5173/goods/desk.jpg', 1);
INSERT INTO `goods_image` VALUES (93, 65, 'http://localhost:5173/goods/yoga.jpg', 1);
INSERT INTO `goods_image` VALUES (94, 120, 'http://localhost:5173/goods/badminton.jpg', 1);
INSERT INTO `goods_image` VALUES (95, 157, 'http://localhost:5173/goods/english.jpg', 1);
INSERT INTO `goods_image` VALUES (96, 118, 'http://localhost:5173/goods/hoodie.jpg', 1);
INSERT INTO `goods_image` VALUES (97, 36, 'http://localhost:5173/goods/cup.jpg', 1);
INSERT INTO `goods_image` VALUES (98, 122, 'http://localhost:5173/goods/ipad.jpg', 1);
INSERT INTO `goods_image` VALUES (99, 168, 'http://localhost:5173/goods/ipad.jpg', 1);
INSERT INTO `goods_image` VALUES (100, 197, 'http://localhost:5173/goods/english.jpg', 1);
INSERT INTO `goods_image` VALUES (101, 43, 'http://localhost:5173/goods/shoes.jpg', 1);
INSERT INTO `goods_image` VALUES (102, 185, 'http://localhost:5173/goods/shoes.jpg', 1);
INSERT INTO `goods_image` VALUES (103, 192, 'http://localhost:5173/goods/math.jpg', 1);
INSERT INTO `goods_image` VALUES (104, 136, 'http://localhost:5173/goods/cup.jpg', 1);
INSERT INTO `goods_image` VALUES (105, 10, 'http://localhost:5173/goods/lamp.jpg', 1);
INSERT INTO `goods_image` VALUES (106, 134, 'http://localhost:5173/goods/hoodie.jpg', 1);
INSERT INTO `goods_image` VALUES (107, 193, 'http://localhost:5173/goods/desk.jpg', 1);
INSERT INTO `goods_image` VALUES (108, 109, 'http://localhost:5173/goods/desk.jpg', 1);
INSERT INTO `goods_image` VALUES (109, 116, 'http://localhost:5173/goods/math.jpg', 1);
INSERT INTO `goods_image` VALUES (110, 22, 'http://localhost:5173/goods/cup.jpg', 1);
INSERT INTO `goods_image` VALUES (111, 78, 'http://localhost:5173/goods/hoodie.jpg', 1);
INSERT INTO `goods_image` VALUES (112, 164, 'http://localhost:5173/goods/ipad.jpg', 1);
INSERT INTO `goods_image` VALUES (113, 72, 'http://localhost:5173/goods/lamp.jpg', 1);
INSERT INTO `goods_image` VALUES (114, 91, 'http://localhost:5173/goods/desk.jpg', 1);
INSERT INTO `goods_image` VALUES (115, 1, 'http://localhost:5173/goods/box.jpg', 1);
INSERT INTO `goods_image` VALUES (116, 125, 'http://localhost:5173/goods/desk.jpg', 1);
INSERT INTO `goods_image` VALUES (117, 54, 'http://localhost:5173/goods/cup.jpg', 1);
INSERT INTO `goods_image` VALUES (118, 127, 'http://localhost:5173/goods/desk.jpg', 1);
INSERT INTO `goods_image` VALUES (119, 180, 'http://localhost:5173/goods/math.jpg', 1);
INSERT INTO `goods_image` VALUES (120, 99, 'http://localhost:5173/goods/desk.jpg', 1);
INSERT INTO `goods_image` VALUES (121, 148, 'http://localhost:5173/goods/cup.jpg', 1);
INSERT INTO `goods_image` VALUES (122, 20, 'http://localhost:5173/goods/cup.jpg', 1);
INSERT INTO `goods_image` VALUES (123, 35, 'http://localhost:5173/goods/yoga.jpg', 1);
INSERT INTO `goods_image` VALUES (124, 13, 'http://localhost:5173/goods/shoes.jpg', 1);
INSERT INTO `goods_image` VALUES (125, 86, 'http://localhost:5173/goods/lamp.jpg', 1);
INSERT INTO `goods_image` VALUES (126, 90, 'http://localhost:5173/goods/hoodie.jpg', 1);
INSERT INTO `goods_image` VALUES (127, 162, 'http://localhost:5173/goods/badminton.jpg', 1);
INSERT INTO `goods_image` VALUES (128, 196, 'http://localhost:5173/goods/hoodie.jpg', 1);
INSERT INTO `goods_image` VALUES (129, 23, 'http://localhost:5173/goods/desk.jpg', 1);
INSERT INTO `goods_image` VALUES (130, 104, 'http://localhost:5173/goods/math.jpg', 1);
INSERT INTO `goods_image` VALUES (131, 153, 'http://localhost:5173/goods/yoga.jpg', 1);
INSERT INTO `goods_image` VALUES (132, 171, 'http://localhost:5173/goods/shoes.jpg', 1);
INSERT INTO `goods_image` VALUES (133, 87, 'http://localhost:5173/goods/english.jpg', 1);
INSERT INTO `goods_image` VALUES (134, 158, 'http://localhost:5173/goods/math.jpg', 1);
INSERT INTO `goods_image` VALUES (135, 7, 'http://localhost:5173/goods/box.jpg', 1);
INSERT INTO `goods_image` VALUES (136, 46, 'http://localhost:5173/goods/ipad.jpg', 1);
INSERT INTO `goods_image` VALUES (137, 82, 'http://localhost:5173/goods/math.jpg', 1);
INSERT INTO `goods_image` VALUES (138, 154, 'http://localhost:5173/goods/badminton.jpg', 1);
INSERT INTO `goods_image` VALUES (139, 103, 'http://localhost:5173/goods/desk.jpg', 1);
INSERT INTO `goods_image` VALUES (140, 58, 'http://localhost:5173/goods/cup.jpg', 1);
INSERT INTO `goods_image` VALUES (141, 144, 'http://localhost:5173/goods/hoodie.jpg', 1);
INSERT INTO `goods_image` VALUES (142, 166, 'http://localhost:5173/goods/hoodie.jpg', 1);
INSERT INTO `goods_image` VALUES (143, 55, 'http://localhost:5173/goods/shoes.jpg', 1);
INSERT INTO `goods_image` VALUES (144, 8, 'http://localhost:5173/goods/hoodie.jpg', 1);
INSERT INTO `goods_image` VALUES (145, 186, 'http://localhost:5173/goods/badminton.jpg', 1);
INSERT INTO `goods_image` VALUES (146, 32, 'http://localhost:5173/goods/lamp.jpg', 1);
INSERT INTO `goods_image` VALUES (147, 106, 'http://localhost:5173/goods/ipad.jpg', 1);
INSERT INTO `goods_image` VALUES (148, 77, 'http://localhost:5173/goods/shoes.jpg', 1);
INSERT INTO `goods_image` VALUES (149, 133, 'http://localhost:5173/goods/headset.jpg', 1);
INSERT INTO `goods_image` VALUES (150, 14, 'http://localhost:5173/goods/math.jpg', 1);
INSERT INTO `goods_image` VALUES (151, 3, 'http://localhost:5173/goods/shoes.jpg', 1);
INSERT INTO `goods_image` VALUES (152, 167, 'http://localhost:5173/goods/shoes.jpg', 1);
INSERT INTO `goods_image` VALUES (153, 200, 'http://localhost:5173/goods/hoodie.jpg', 1);
INSERT INTO `goods_image` VALUES (154, 21, 'http://localhost:5173/goods/shoes.jpg', 1);
INSERT INTO `goods_image` VALUES (155, 53, 'http://localhost:5173/goods/yoga.jpg', 1);
INSERT INTO `goods_image` VALUES (156, 95, 'http://localhost:5173/goods/headset.jpg', 1);
INSERT INTO `goods_image` VALUES (157, 75, 'http://localhost:5173/goods/shoes.jpg', 1);
INSERT INTO `goods_image` VALUES (158, 178, 'http://localhost:5173/goods/math.jpg', 1);
INSERT INTO `goods_image` VALUES (159, 194, 'http://localhost:5173/goods/hoodie.jpg', 1);
INSERT INTO `goods_image` VALUES (160, 9, 'http://localhost:5173/goods/english.jpg', 1);
INSERT INTO `goods_image` VALUES (161, 179, 'http://localhost:5173/goods/desk.jpg', 1);
INSERT INTO `goods_image` VALUES (162, 29, 'http://localhost:5173/goods/shoes.jpg', 1);
INSERT INTO `goods_image` VALUES (163, 41, 'http://localhost:5173/goods/yoga.jpg', 1);
INSERT INTO `goods_image` VALUES (164, 117, 'http://localhost:5173/goods/desk.jpg', 1);
INSERT INTO `goods_image` VALUES (165, 198, 'http://localhost:5173/goods/badminton.jpg', 1);
INSERT INTO `goods_image` VALUES (166, 2, 'http://localhost:5173/goods/ipad.jpg', 1);
INSERT INTO `goods_image` VALUES (167, 30, 'http://localhost:5173/goods/cup.jpg', 1);
INSERT INTO `goods_image` VALUES (168, 115, 'http://localhost:5173/goods/box.jpg', 1);
INSERT INTO `goods_image` VALUES (169, 112, 'http://localhost:5173/goods/math.jpg', 1);
INSERT INTO `goods_image` VALUES (170, 61, 'http://localhost:5173/goods/shoes.jpg', 1);
INSERT INTO `goods_image` VALUES (171, 189, 'http://localhost:5173/goods/desk.jpg', 1);
INSERT INTO `goods_image` VALUES (172, 102, 'http://localhost:5173/goods/math.jpg', 1);
INSERT INTO `goods_image` VALUES (173, 119, 'http://localhost:5173/goods/box.jpg', 1);
INSERT INTO `goods_image` VALUES (174, 5, 'http://localhost:5173/goods/headset.jpg', 1);
INSERT INTO `goods_image` VALUES (175, 51, 'http://localhost:5173/goods/desk.jpg', 1);
INSERT INTO `goods_image` VALUES (176, 31, 'http://localhost:5173/goods/english.jpg', 1);
INSERT INTO `goods_image` VALUES (177, 38, 'http://localhost:5173/goods/ipad.jpg', 1);
INSERT INTO `goods_image` VALUES (178, 49, 'http://localhost:5173/goods/desk.jpg', 1);
INSERT INTO `goods_image` VALUES (179, 67, 'http://localhost:5173/goods/shoes.jpg', 1);
INSERT INTO `goods_image` VALUES (180, 69, 'http://localhost:5173/goods/headset.jpg', 1);
INSERT INTO `goods_image` VALUES (181, 4, 'http://localhost:5173/goods/math.jpg', 1);
INSERT INTO `goods_image` VALUES (182, 24, 'http://localhost:5173/goods/badminton.jpg', 1);
INSERT INTO `goods_image` VALUES (183, 83, 'http://localhost:5173/goods/headset.jpg', 1);
INSERT INTO `goods_image` VALUES (184, 100, 'http://localhost:5173/goods/math.jpg', 1);
INSERT INTO `goods_image` VALUES (185, 39, 'http://localhost:5173/goods/headset.jpg', 1);
INSERT INTO `goods_image` VALUES (186, 160, 'http://localhost:5173/goods/cup.jpg', 1);
INSERT INTO `goods_image` VALUES (187, 18, 'http://localhost:5173/goods/badminton.jpg', 1);
INSERT INTO `goods_image` VALUES (188, 94, 'http://localhost:5173/goods/hoodie.jpg', 1);
INSERT INTO `goods_image` VALUES (189, 33, 'http://localhost:5173/goods/headset.jpg', 1);
INSERT INTO `goods_image` VALUES (190, 45, 'http://localhost:5173/goods/shoes.jpg', 1);
INSERT INTO `goods_image` VALUES (191, 71, 'http://localhost:5173/goods/headset.jpg', 1);
INSERT INTO `goods_image` VALUES (192, 163, 'http://localhost:5173/goods/english.jpg', 1);
INSERT INTO `goods_image` VALUES (193, 190, 'http://localhost:5173/goods/lamp.jpg', 1);
INSERT INTO `goods_image` VALUES (194, 96, 'http://localhost:5173/goods/lamp.jpg', 1);
INSERT INTO `goods_image` VALUES (195, 88, 'http://localhost:5173/goods/hoodie.jpg', 1);
INSERT INTO `goods_image` VALUES (196, 132, 'http://localhost:5173/goods/math.jpg', 1);
INSERT INTO `goods_image` VALUES (197, 172, 'http://localhost:5173/goods/badminton.jpg', 1);
INSERT INTO `goods_image` VALUES (198, 76, 'http://localhost:5173/goods/cup.jpg', 1);
INSERT INTO `goods_image` VALUES (199, 80, 'http://localhost:5173/goods/ipad.jpg', 1);
INSERT INTO `goods_image` VALUES (200, 74, 'http://localhost:5173/goods/math.jpg', 1);

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
INSERT INTO `message` VALUES (1, 53, 53, '你好，请问这个商品还在吗？', 1, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (2, 3, 3, '你好，请问这个商品还在吗？', 0, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (3, 76, 76, '你好，请问这个商品还在吗？', 1, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (4, 6, 6, '你好，请问这个商品还在吗？', 0, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (5, 28, 28, '可以便宜一点吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (6, 62, 62, '你好，请问这个商品还在吗？', 1, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (7, 61, 61, '你好，请问这个商品还在吗？', 0, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (8, 73, 73, '你好，请问这个商品还在吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (9, 97, 97, '支持自提吗？', 0, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (10, 43, 43, '支持自提吗？', 0, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (11, 1, 1, '支持自提吗？', 1, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (12, 1, 1, '可以便宜一点吗？', 1, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (13, 39, 39, '你好，请问这个商品还在吗？', 0, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (14, 80, 80, '你好，请问这个商品还在吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (15, 40, 40, '你好，请问这个商品还在吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (16, 10, 10, '你好，请问这个商品还在吗？', 0, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (17, 35, 35, '支持自提吗？', 1, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (18, 80, 80, '可以便宜一点吗？', 0, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (19, 40, 40, '支持自提吗？', 0, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (20, 19, 19, '你好，请问这个商品还在吗？', 0, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (21, 75, 75, '你好，请问这个商品还在吗？', 1, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (22, 19, 19, '可以便宜一点吗？', 0, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (23, 41, 41, '可以便宜一点吗？', 1, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (24, 20, 20, '你好，请问这个商品还在吗？', 1, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (25, 9, 9, '你好，请问这个商品还在吗？', 1, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (26, 39, 39, '支持自提吗？', 0, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (27, 72, 72, '你好，请问这个商品还在吗？', 1, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (28, 66, 66, '可以便宜一点吗？', 0, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (29, 90, 90, '你好，请问这个商品还在吗？', 1, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (30, 96, 96, '支持自提吗？', 1, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (31, 71, 71, '支持自提吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (32, 16, 16, '可以便宜一点吗？', 1, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (33, 8, 8, '可以便宜一点吗？', 0, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (34, 67, 67, '你好，请问这个商品还在吗？', 1, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (35, 32, 32, '可以便宜一点吗？', 0, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (36, 38, 38, '支持自提吗？', 1, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (37, 33, 33, '支持自提吗？', 0, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (38, 59, 59, '你好，请问这个商品还在吗？', 1, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (39, 6, 6, '你好，请问这个商品还在吗？', 1, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (40, 74, 74, '你好，请问这个商品还在吗？', 1, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (41, 93, 93, '你好，请问这个商品还在吗？', 0, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (42, 69, 69, '你好，请问这个商品还在吗？', 1, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (43, 21, 21, '你好，请问这个商品还在吗？', 1, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (44, 52, 52, '可以便宜一点吗？', 1, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (45, 65, 65, '你好，请问这个商品还在吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (46, 58, 58, '可以便宜一点吗？', 1, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (47, 31, 31, '支持自提吗？', 1, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (48, 55, 55, '可以便宜一点吗？', 1, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (49, 55, 55, '你好，请问这个商品还在吗？', 0, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (50, 10, 10, '你好，请问这个商品还在吗？', 1, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (51, 95, 95, '支持自提吗？', 0, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (52, 1, 1, '可以便宜一点吗？', 1, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (53, 12, 12, '可以便宜一点吗？', 1, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (54, 32, 32, '支持自提吗？', 0, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (55, 6, 6, '支持自提吗？', 1, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (56, 50, 50, '可以便宜一点吗？', 1, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (57, 42, 42, '支持自提吗？', 1, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (58, 68, 68, '可以便宜一点吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (59, 99, 99, '你好，请问这个商品还在吗？', 1, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (60, 80, 80, '可以便宜一点吗？', 0, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (61, 44, 44, '支持自提吗？', 1, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (62, 72, 72, '你好，请问这个商品还在吗？', 0, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (63, 61, 61, '支持自提吗？', 0, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (64, 14, 14, '支持自提吗？', 1, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (65, 53, 53, '支持自提吗？', 0, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (66, 23, 23, '可以便宜一点吗？', 1, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (67, 63, 63, '支持自提吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (68, 45, 45, '支持自提吗？', 0, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (69, 82, 82, '可以便宜一点吗？', 1, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (70, 56, 56, '你好，请问这个商品还在吗？', 1, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (71, 47, 47, '可以便宜一点吗？', 1, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (72, 25, 25, '你好，请问这个商品还在吗？', 0, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (73, 27, 27, '可以便宜一点吗？', 1, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (74, 69, 69, '支持自提吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (75, 32, 32, '支持自提吗？', 0, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (76, 63, 63, '支持自提吗？', 0, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (77, 83, 83, '你好，请问这个商品还在吗？', 0, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (78, 20, 20, '可以便宜一点吗？', 0, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (79, 69, 69, '支持自提吗？', 0, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (80, 78, 78, '支持自提吗？', 1, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (81, 41, 41, '你好，请问这个商品还在吗？', 0, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (82, 28, 28, '可以便宜一点吗？', 1, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (83, 17, 17, '支持自提吗？', 1, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (84, 99, 99, '可以便宜一点吗？', 1, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (85, 94, 94, '支持自提吗？', 0, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (86, 12, 12, '你好，请问这个商品还在吗？', 1, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (87, 68, 68, '可以便宜一点吗？', 0, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (88, 29, 29, '支持自提吗？', 0, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (89, 21, 21, '支持自提吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (90, 100, 100, '支持自提吗？', 0, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (91, 61, 61, '你好，请问这个商品还在吗？', 1, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (92, 65, 65, '可以便宜一点吗？', 0, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (93, 29, 29, '你好，请问这个商品还在吗？', 1, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (94, 87, 87, '支持自提吗？', 1, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (95, 31, 31, '你好，请问这个商品还在吗？', 0, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (96, 97, 97, '可以便宜一点吗？', 0, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (97, 40, 40, '你好，请问这个商品还在吗？', 1, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (98, 50, 50, '支持自提吗？', 1, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (99, 7, 7, '你好，请问这个商品还在吗？', 0, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (100, 62, 62, '支持自提吗？', 0, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (101, 66, 66, '支持自提吗？', 0, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (102, 51, 51, '支持自提吗？', 1, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (103, 33, 33, '支持自提吗？', 1, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (104, 65, 65, '你好，请问这个商品还在吗？', 0, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (105, 65, 65, '可以便宜一点吗？', 1, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (106, 83, 83, '你好，请问这个商品还在吗？', 0, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (107, 10, 10, '支持自提吗？', 1, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (108, 40, 40, '可以便宜一点吗？', 0, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (109, 36, 36, '可以便宜一点吗？', 0, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (110, 91, 91, '可以便宜一点吗？', 1, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (111, 67, 67, '你好，请问这个商品还在吗？', 1, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (112, 31, 31, '支持自提吗？', 1, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (113, 53, 53, '支持自提吗？', 1, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (114, 89, 89, '可以便宜一点吗？', 1, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (115, 88, 88, '你好，请问这个商品还在吗？', 1, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (116, 36, 36, '你好，请问这个商品还在吗？', 0, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (117, 15, 15, '你好，请问这个商品还在吗？', 0, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (118, 94, 94, '支持自提吗？', 0, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (119, 8, 8, '你好，请问这个商品还在吗？', 1, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (120, 16, 16, '可以便宜一点吗？', 1, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (121, 73, 73, '你好，请问这个商品还在吗？', 1, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (122, 80, 80, '你好，请问这个商品还在吗？', 1, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (123, 57, 57, '你好，请问这个商品还在吗？', 1, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (124, 73, 73, '可以便宜一点吗？', 1, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (125, 5, 5, '支持自提吗？', 1, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (126, 79, 79, '支持自提吗？', 1, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (127, 63, 63, '你好，请问这个商品还在吗？', 0, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (128, 83, 83, '支持自提吗？', 1, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (129, 78, 78, '可以便宜一点吗？', 1, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (130, 40, 40, '可以便宜一点吗？', 1, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (131, 33, 33, '你好，请问这个商品还在吗？', 0, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (132, 91, 91, '你好，请问这个商品还在吗？', 0, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (133, 4, 4, '支持自提吗？', 1, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (134, 68, 68, '可以便宜一点吗？', 1, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (135, 27, 27, '支持自提吗？', 1, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (136, 16, 16, '支持自提吗？', 1, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (137, 13, 13, '支持自提吗？', 1, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (138, 47, 47, '支持自提吗？', 0, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (139, 42, 42, '你好，请问这个商品还在吗？', 1, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (140, 17, 17, '支持自提吗？', 0, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (141, 27, 27, '可以便宜一点吗？', 0, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (142, 46, 46, '你好，请问这个商品还在吗？', 1, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (143, 93, 93, '可以便宜一点吗？', 1, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (144, 100, 100, '可以便宜一点吗？', 1, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (145, 25, 25, '可以便宜一点吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (146, 95, 95, '你好，请问这个商品还在吗？', 0, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (147, 90, 90, '你好，请问这个商品还在吗？', 0, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (148, 7, 7, '可以便宜一点吗？', 1, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (149, 54, 54, '可以便宜一点吗？', 0, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (150, 39, 39, '你好，请问这个商品还在吗？', 0, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (151, 62, 62, '你好，请问这个商品还在吗？', 1, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (152, 69, 69, '支持自提吗？', 1, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (153, 89, 89, '你好，请问这个商品还在吗？', 0, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (154, 19, 19, '可以便宜一点吗？', 1, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (155, 15, 15, '支持自提吗？', 0, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (156, 96, 96, '可以便宜一点吗？', 1, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (157, 62, 62, '可以便宜一点吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (158, 45, 45, '你好，请问这个商品还在吗？', 1, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (159, 44, 44, '你好，请问这个商品还在吗？', 1, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (160, 97, 97, '支持自提吗？', 1, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (161, 20, 20, '可以便宜一点吗？', 0, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (162, 84, 84, '支持自提吗？', 1, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (163, 67, 67, '你好，请问这个商品还在吗？', 0, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (164, 41, 41, '可以便宜一点吗？', 0, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (165, 13, 13, '你好，请问这个商品还在吗？', 0, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (166, 89, 89, '支持自提吗？', 0, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (167, 31, 31, '可以便宜一点吗？', 0, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (168, 39, 39, '可以便宜一点吗？', 1, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (169, 21, 21, '你好，请问这个商品还在吗？', 0, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (170, 74, 74, '支持自提吗？', 0, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (171, 89, 89, '你好，请问这个商品还在吗？', 1, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (172, 84, 84, '可以便宜一点吗？', 1, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (173, 67, 67, '支持自提吗？', 0, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (174, 41, 41, '可以便宜一点吗？', 0, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (175, 25, 25, '支持自提吗？', 1, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (176, 65, 65, '可以便宜一点吗？', 0, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (177, 48, 48, '支持自提吗？', 1, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (178, 78, 78, '支持自提吗？', 0, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (179, 5, 5, '可以便宜一点吗？', 1, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (180, 36, 36, '可以便宜一点吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (181, 60, 60, '可以便宜一点吗？', 0, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (182, 77, 77, '你好，请问这个商品还在吗？', 0, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (183, 92, 92, '可以便宜一点吗？', 0, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (184, 76, 76, '可以便宜一点吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (185, 79, 79, '可以便宜一点吗？', 1, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (186, 53, 53, '支持自提吗？', 1, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (187, 92, 92, '可以便宜一点吗？', 1, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (188, 4, 4, '可以便宜一点吗？', 1, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (189, 71, 71, '支持自提吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (190, 29, 29, '可以便宜一点吗？', 0, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (191, 55, 55, '支持自提吗？', 0, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (192, 70, 70, '可以便宜一点吗？', 0, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (193, 29, 29, '可以便宜一点吗？', 1, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (194, 29, 29, '可以便宜一点吗？', 0, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (195, 71, 71, '可以便宜一点吗？', 1, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (196, 51, 51, '支持自提吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (197, 16, 16, '你好，请问这个商品还在吗？', 1, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (198, 47, 47, '你好，请问这个商品还在吗？', 0, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (199, 51, 51, '可以便宜一点吗？', 1, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (200, 11, 11, '你好，请问这个商品还在吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (201, 95, 95, '你好，请问这个商品还在吗？', 0, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (202, 42, 42, '你好，请问这个商品还在吗？', 1, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (203, 26, 26, '支持自提吗？', 1, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (204, 28, 28, '可以便宜一点吗？', 0, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (205, 84, 84, '你好，请问这个商品还在吗？', 1, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (206, 16, 16, '可以便宜一点吗？', 0, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (207, 34, 34, '可以便宜一点吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (208, 36, 36, '你好，请问这个商品还在吗？', 0, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (209, 68, 68, '你好，请问这个商品还在吗？', 0, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (210, 72, 72, '支持自提吗？', 1, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (211, 96, 96, '可以便宜一点吗？', 1, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (212, 81, 81, '支持自提吗？', 0, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (213, 44, 44, '可以便宜一点吗？', 0, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (214, 86, 86, '支持自提吗？', 1, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (215, 90, 90, '支持自提吗？', 1, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (216, 98, 98, '支持自提吗？', 0, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (217, 84, 84, '支持自提吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (218, 73, 73, '可以便宜一点吗？', 1, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (219, 76, 76, '可以便宜一点吗？', 1, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (220, 87, 87, '可以便宜一点吗？', 1, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (221, 94, 94, '支持自提吗？', 1, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (222, 46, 46, '你好，请问这个商品还在吗？', 0, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (223, 33, 33, '你好，请问这个商品还在吗？', 1, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (224, 33, 33, '可以便宜一点吗？', 0, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (225, 49, 49, '你好，请问这个商品还在吗？', 1, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (226, 5, 5, '你好，请问这个商品还在吗？', 1, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (227, 52, 52, '你好，请问这个商品还在吗？', 1, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (228, 23, 23, '可以便宜一点吗？', 0, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (229, 27, 27, '你好，请问这个商品还在吗？', 1, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (230, 16, 16, '可以便宜一点吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (231, 52, 52, '你好，请问这个商品还在吗？', 1, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (232, 4, 4, '你好，请问这个商品还在吗？', 0, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (233, 91, 91, '可以便宜一点吗？', 0, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (234, 89, 89, '你好，请问这个商品还在吗？', 1, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (235, 75, 75, '支持自提吗？', 0, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (236, 88, 88, '可以便宜一点吗？', 0, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (237, 62, 62, '你好，请问这个商品还在吗？', 1, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (238, 86, 86, '你好，请问这个商品还在吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (239, 1, 1, '支持自提吗？', 1, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (240, 28, 28, '支持自提吗？', 1, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (241, 16, 16, '你好，请问这个商品还在吗？', 1, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (242, 2, 2, '支持自提吗？', 1, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (243, 95, 95, '你好，请问这个商品还在吗？', 0, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (244, 96, 96, '你好，请问这个商品还在吗？', 0, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (245, 68, 68, '支持自提吗？', 1, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (246, 66, 66, '可以便宜一点吗？', 0, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (247, 23, 23, '你好，请问这个商品还在吗？', 1, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (248, 81, 81, '可以便宜一点吗？', 0, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (249, 50, 50, '你好，请问这个商品还在吗？', 0, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (250, 97, 97, '可以便宜一点吗？', 0, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (251, 19, 19, '可以便宜一点吗？', 0, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (252, 3, 3, '你好，请问这个商品还在吗？', 0, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (253, 96, 96, '可以便宜一点吗？', 1, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (254, 31, 31, '支持自提吗？', 0, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (255, 67, 67, '可以便宜一点吗？', 1, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (256, 3, 3, '支持自提吗？', 0, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (257, 96, 96, '可以便宜一点吗？', 1, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (258, 12, 12, '可以便宜一点吗？', 1, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (259, 15, 15, '你好，请问这个商品还在吗？', 0, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (260, 71, 71, '可以便宜一点吗？', 1, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (261, 59, 59, '你好，请问这个商品还在吗？', 1, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (262, 10, 10, '可以便宜一点吗？', 1, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (263, 24, 24, '可以便宜一点吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (264, 82, 82, '你好，请问这个商品还在吗？', 0, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (265, 23, 23, '支持自提吗？', 0, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (266, 84, 84, '支持自提吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (267, 82, 82, '支持自提吗？', 0, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (268, 86, 86, '你好，请问这个商品还在吗？', 0, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (269, 51, 51, '支持自提吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (270, 44, 44, '支持自提吗？', 0, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (271, 56, 56, '支持自提吗？', 0, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (272, 54, 54, '可以便宜一点吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (273, 12, 12, '支持自提吗？', 0, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (274, 26, 26, '支持自提吗？', 0, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (275, 87, 87, '你好，请问这个商品还在吗？', 0, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (276, 97, 97, '你好，请问这个商品还在吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (277, 17, 17, '支持自提吗？', 1, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (278, 44, 44, '可以便宜一点吗？', 0, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (279, 40, 40, '你好，请问这个商品还在吗？', 0, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (280, 75, 75, '你好，请问这个商品还在吗？', 1, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (281, 47, 47, '支持自提吗？', 1, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (282, 67, 67, '你好，请问这个商品还在吗？', 1, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (283, 95, 95, '你好，请问这个商品还在吗？', 0, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (284, 67, 67, '你好，请问这个商品还在吗？', 1, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (285, 29, 29, '支持自提吗？', 0, '2026-09-08 22:57:50');
INSERT INTO `message` VALUES (286, 25, 25, '可以便宜一点吗？', 1, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (287, 15, 15, '你好，请问这个商品还在吗？', 0, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (288, 25, 25, '你好，请问这个商品还在吗？', 0, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (289, 96, 96, '你好，请问这个商品还在吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (290, 45, 45, '可以便宜一点吗？', 0, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (291, 95, 95, '你好，请问这个商品还在吗？', 0, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (292, 76, 76, '你好，请问这个商品还在吗？', 0, '2026-09-09 22:57:50');
INSERT INTO `message` VALUES (293, 97, 97, '支持自提吗？', 0, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (294, 29, 29, '可以便宜一点吗？', 0, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (295, 48, 48, '支持自提吗？', 1, '2026-09-03 22:57:50');
INSERT INTO `message` VALUES (296, 49, 49, '你好，请问这个商品还在吗？', 1, '2026-09-06 22:57:50');
INSERT INTO `message` VALUES (297, 51, 51, '你好，请问这个商品还在吗？', 1, '2026-09-04 22:57:50');
INSERT INTO `message` VALUES (298, 35, 35, '你好，请问这个商品还在吗？', 1, '2026-09-07 22:57:50');
INSERT INTO `message` VALUES (299, 95, 95, '支持自提吗？', 0, '2026-09-05 22:57:50');
INSERT INTO `message` VALUES (300, 18, 18, '你好，请问这个商品还在吗？', 0, '2026-09-03 22:57:50');

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
INSERT INTO `orders` VALUES ('1', 21, '南昌大学前湖校区6栋18室', 17, 21, 641.12, 1, 3, '2026-07-17 23:25:50', '2026-07-18 23:25:50', '2026-07-17 22:57:50');
INSERT INTO `orders` VALUES ('10', 26, '南昌大学前湖校区3栋18室', 97, 26, 815.61, 1, 3, '2026-08-18 23:26:50', '2026-08-20 23:26:50', '2026-08-18 22:57:50');
INSERT INTO `orders` VALUES ('100', 28, '南昌大学前湖校区5栋9室', 68, 28, 378.39, 1, 3, '2026-07-27 23:10:50', '2026-07-30 23:10:50', '2026-07-27 22:57:50');
INSERT INTO `orders` VALUES ('101', 11, '南昌大学前湖校区4栋4室', 83, 11, 798.46, 1, 0, '2026-08-08 23:25:50', NULL, '2026-08-08 22:57:50');
INSERT INTO `orders` VALUES ('102', 75, '南昌大学前湖校区4栋5室', 144, 75, 493.38, 0, 1, NULL, NULL, '2026-08-20 22:57:50');
INSERT INTO `orders` VALUES ('103', 16, '南昌大学前湖校区1栋18室', 197, 16, 187.91, 0, 2, NULL, NULL, '2026-08-02 22:57:50');
INSERT INTO `orders` VALUES ('104', 37, '南昌大学前湖校区6栋14室', 93, 37, 59.39, 0, 1, NULL, NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('105', 54, '南昌大学前湖校区7栋2室', 81, 54, 515.09, 1, 2, '2026-08-01 23:09:50', NULL, '2026-08-01 22:57:50');
INSERT INTO `orders` VALUES ('106', 19, '南昌大学前湖校区4栋15室', 14, 19, 362.52, 1, 2, '2026-09-08 23:21:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('107', 64, '南昌大学前湖校区1栋6室', 165, 64, 278.10, 1, 4, '2026-08-28 23:14:50', NULL, '2026-08-28 22:57:50');
INSERT INTO `orders` VALUES ('108', 10, '南昌大学前湖校区3栋13室', 152, 10, 478.22, 1, 1, '2026-09-08 23:21:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('109', 74, '南昌大学前湖校区3栋10室', 189, 74, 206.04, 1, 4, '2026-09-08 23:16:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('11', 47, '南昌大学前湖校区8栋19室', 18, 47, 965.94, 1, 5, '2026-09-08 23:08:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('110', 5, '南昌大学前湖校区6栋8室', 47, 5, 866.19, 1, 3, '2026-07-22 23:08:50', '2026-07-23 23:08:50', '2026-07-22 22:57:50');
INSERT INTO `orders` VALUES ('111', 79, '南昌大学前湖校区8栋5室', 84, 79, 16.38, 1, 2, '2026-09-08 23:09:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('112', 41, '南昌大学前湖校区2栋16室', 175, 41, 71.53, 0, 4, NULL, NULL, '2026-09-03 22:57:50');
INSERT INTO `orders` VALUES ('113', 21, '南昌大学前湖校区6栋9室', 128, 21, 990.65, 0, 4, NULL, NULL, '2026-08-14 22:57:50');
INSERT INTO `orders` VALUES ('114', 32, '南昌大学前湖校区1栋13室', 52, 32, 254.26, 1, 3, '2026-07-19 23:16:50', '2026-07-20 23:16:50', '2026-07-19 22:57:50');
INSERT INTO `orders` VALUES ('115', 54, '南昌大学前湖校区7栋9室', 88, 54, 700.93, 1, 1, '2026-09-08 23:07:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('116', 38, '南昌大学前湖校区7栋17室', 196, 38, 506.38, 1, 5, '2026-08-29 23:20:50', NULL, '2026-08-29 22:57:50');
INSERT INTO `orders` VALUES ('117', 54, '南昌大学前湖校区7栋18室', 137, 54, 725.27, 0, 1, NULL, NULL, '2026-07-25 22:57:50');
INSERT INTO `orders` VALUES ('118', 18, '南昌大学前湖校区3栋18室', 177, 18, 691.79, 0, 2, NULL, NULL, '2026-09-01 22:57:50');
INSERT INTO `orders` VALUES ('119', 95, '南昌大学前湖校区8栋13室', 72, 95, 64.57, 1, 0, '2026-09-08 23:14:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('12', 53, '南昌大学前湖校区6栋18室', 177, 53, 685.87, 0, 2, NULL, NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('120', 46, '南昌大学前湖校区7栋4室', 83, 46, 308.92, 1, 0, '2026-08-07 23:22:50', NULL, '2026-08-07 22:57:50');
INSERT INTO `orders` VALUES ('121', 31, '南昌大学前湖校区8栋1室', 20, 31, 164.52, 1, 2, '2026-09-08 23:22:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('122', 24, '南昌大学前湖校区1栋3室', 162, 24, 458.76, 0, 1, NULL, NULL, '2026-08-25 22:57:50');
INSERT INTO `orders` VALUES ('123', 6, '南昌大学前湖校区7栋11室', 30, 6, 968.25, 0, 2, NULL, NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('124', 37, '南昌大学前湖校区6栋4室', 103, 37, 823.66, 1, 1, '2026-09-08 23:15:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('125', 40, '南昌大学前湖校区1栋17室', 36, 40, 197.88, 0, 0, NULL, NULL, '2026-07-11 22:57:50');
INSERT INTO `orders` VALUES ('126', 23, '南昌大学前湖校区8栋6室', 185, 23, 10.09, 0, 2, NULL, NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('127', 58, '南昌大学前湖校区3栋6室', 165, 58, 591.90, 1, 4, '2026-08-28 23:25:50', NULL, '2026-08-28 22:57:50');
INSERT INTO `orders` VALUES ('128', 38, '南昌大学前湖校区7栋15室', 14, 38, 824.34, 1, 1, '2026-09-08 23:14:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('129', 97, '南昌大学前湖校区2栋5室', 44, 97, 847.65, 0, 4, NULL, NULL, '2026-07-25 22:57:50');
INSERT INTO `orders` VALUES ('13', 91, '南昌大学前湖校区4栋7室', 146, 91, 159.73, 1, 3, '2026-09-08 23:09:50', '2026-09-11 23:09:50', '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('130', 10, '南昌大学前湖校区3栋14室', 93, 10, 386.25, 1, 3, '2026-09-08 23:17:50', '2026-09-09 23:17:50', '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('131', 22, '南昌大学前湖校区7栋13室', 112, 22, 38.31, 0, 2, NULL, NULL, '2026-07-18 22:57:50');
INSERT INTO `orders` VALUES ('132', 50, '南昌大学前湖校区3栋13室', 112, 50, 409.39, 1, 4, '2026-08-04 23:11:50', NULL, '2026-08-04 22:57:50');
INSERT INTO `orders` VALUES ('133', 53, '南昌大学前湖校区6栋14室', 13, 53, 602.37, 1, 2, '2026-08-04 23:18:50', NULL, '2026-08-04 22:57:50');
INSERT INTO `orders` VALUES ('134', 37, '南昌大学前湖校区6栋12室', 111, 37, 810.03, 1, 2, '2026-09-06 23:10:50', NULL, '2026-09-06 22:57:50');
INSERT INTO `orders` VALUES ('135', 45, '南昌大学前湖校区6栋1室', 20, 45, 915.45, 1, 5, '2026-09-08 23:08:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('136', 15, '南昌大学前湖校区8栋12室', 51, 15, 578.60, 1, 2, '2026-09-08 23:25:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('137', 59, '南昌大学前湖校区4栋18室', 157, 59, 972.29, 0, 5, NULL, NULL, '2026-07-23 22:57:50');
INSERT INTO `orders` VALUES ('138', 10, '南昌大学前湖校区3栋3室', 102, 10, 213.71, 1, 5, '2026-07-18 23:13:50', NULL, '2026-07-18 22:57:50');
INSERT INTO `orders` VALUES ('139', 20, '南昌大学前湖校区5栋1室', 60, 20, 365.51, 1, 4, '2026-08-29 23:24:50', NULL, '2026-08-29 22:57:50');
INSERT INTO `orders` VALUES ('14', 31, '南昌大学前湖校区8栋4室', 43, 31, 259.45, 1, 2, '2026-08-23 23:15:50', NULL, '2026-08-23 22:57:50');
INSERT INTO `orders` VALUES ('140', 100, '南昌大学前湖校区5栋1室', 20, 100, 463.43, 0, 0, NULL, NULL, '2026-09-09 22:57:50');
INSERT INTO `orders` VALUES ('141', 27, '南昌大学前湖校区4栋10室', 189, 27, 950.54, 1, 2, '2026-09-08 23:15:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('142', 48, '南昌大学前湖校区1栋12室', 191, 48, 856.38, 1, 2, '2026-07-26 23:26:50', NULL, '2026-07-26 22:57:50');
INSERT INTO `orders` VALUES ('143', 67, '南昌大学前湖校区4栋6室', 185, 67, 850.93, 0, 5, NULL, NULL, '2026-08-19 22:57:50');
INSERT INTO `orders` VALUES ('144', 80, '南昌大学前湖校区1栋20室', 79, 80, 26.92, 1, 3, '2026-08-10 23:18:50', '2026-08-13 23:18:50', '2026-08-10 22:57:50');
INSERT INTO `orders` VALUES ('145', 84, '南昌大学前湖校区5栋16室', 35, 84, 47.87, 1, 5, '2026-08-22 23:26:50', NULL, '2026-08-22 22:57:50');
INSERT INTO `orders` VALUES ('146', 28, '南昌大学前湖校区5栋13室', 92, 28, 945.58, 1, 4, '2026-09-08 23:11:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('147', 26, '南昌大学前湖校区3栋19室', 178, 26, 173.43, 0, 4, NULL, NULL, '2026-07-19 22:57:50');
INSERT INTO `orders` VALUES ('148', 45, '南昌大学前湖校区6栋19室', 138, 45, 963.11, 1, 3, '2026-09-08 23:08:50', '2026-09-11 23:08:50', '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('149', 39, '南昌大学前湖校区8栋12室', 91, 39, 258.43, 1, 0, '2026-09-08 23:23:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('15', 80, '南昌大学前湖校区1栋20室', 19, 80, 17.02, 0, 1, NULL, NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('150', 32, '南昌大学前湖校区1栋15室', 114, 32, 242.83, 1, 2, '2026-08-27 23:21:50', NULL, '2026-08-27 22:57:50');
INSERT INTO `orders` VALUES ('151', 11, '南昌大学前湖校区4栋20室', 39, 11, 505.55, 1, 5, '2026-09-08 23:12:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('152', 11, '南昌大学前湖校区4栋20室', 139, 11, 160.26, 0, 1, NULL, NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('153', 23, '南昌大学前湖校区8栋7室', 166, 23, 938.39, 0, 2, NULL, NULL, '2026-08-13 22:57:50');
INSERT INTO `orders` VALUES ('154', 87, '南昌大学前湖校区8栋17室', 196, 87, 485.53, 1, 4, '2026-08-27 23:09:50', NULL, '2026-08-27 22:57:50');
INSERT INTO `orders` VALUES ('155', 28, '南昌大学前湖校区5栋13室', 132, 28, 266.25, 1, 3, '2026-09-08 23:25:50', '2026-09-09 23:25:50', '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('156', 52, '南昌大学前湖校区5栋14室', 33, 52, 215.49, 1, 2, '2026-09-08 23:09:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('157', 95, '南昌大学前湖校区8栋14室', 53, 95, 845.81, 0, 0, NULL, NULL, '2026-09-01 22:57:50');
INSERT INTO `orders` VALUES ('158', 63, '南昌大学前湖校区8栋15室', 14, 63, 590.32, 1, 3, '2026-09-01 23:24:50', '2026-09-03 23:24:50', '2026-09-01 22:57:50');
INSERT INTO `orders` VALUES ('159', 88, '南昌大学前湖校区1栋2室', 121, 88, 229.93, 1, 3, '2026-07-26 23:07:50', '2026-07-28 23:07:50', '2026-07-26 22:57:50');
INSERT INTO `orders` VALUES ('16', 22, '南昌大学前湖校区7栋14室', 153, 22, 836.35, 1, 3, '2026-08-01 23:15:50', '2026-08-03 23:15:50', '2026-08-01 22:57:50');
INSERT INTO `orders` VALUES ('160', 81, '南昌大学前湖校区2栋18室', 77, 81, 801.42, 1, 3, '2026-08-29 23:07:50', '2026-09-01 23:07:50', '2026-08-29 22:57:50');
INSERT INTO `orders` VALUES ('161', 7, '南昌大学前湖校区8栋20室', 179, 7, 533.01, 0, 1, NULL, NULL, '2026-08-31 22:57:50');
INSERT INTO `orders` VALUES ('162', 3, '南昌大学前湖校区4栋7室', 86, 3, 141.07, 0, 1, NULL, NULL, '2026-09-04 22:57:50');
INSERT INTO `orders` VALUES ('163', 33, '南昌大学前湖校区2栋13室', 52, 33, 874.63, 0, 2, NULL, NULL, '2026-07-25 22:57:50');
INSERT INTO `orders` VALUES ('164', 23, '南昌大学前湖校区8栋15室', 174, 23, 326.37, 0, 1, NULL, NULL, '2026-08-14 22:57:50');
INSERT INTO `orders` VALUES ('165', 29, '南昌大学前湖校区6栋16室', 155, 29, 50.33, 1, 3, '2026-09-08 23:25:50', '2026-09-11 23:25:50', '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('166', 32, '南昌大学前湖校区1栋6室', 25, 32, 327.56, 1, 3, '2026-07-24 23:17:50', '2026-07-25 23:17:50', '2026-07-24 22:57:50');
INSERT INTO `orders` VALUES ('167', 38, '南昌大学前湖校区7栋6室', 145, 38, 619.94, 0, 2, NULL, NULL, '2026-08-17 22:57:50');
INSERT INTO `orders` VALUES ('168', 10, '南昌大学前湖校区3栋5室', 44, 10, 687.05, 1, 4, '2026-07-28 23:24:50', NULL, '2026-07-28 22:57:50');
INSERT INTO `orders` VALUES ('169', 82, '南昌大学前湖校区3栋6室', 125, 82, 362.60, 1, 2, '2026-08-06 23:21:50', NULL, '2026-08-06 22:57:50');
INSERT INTO `orders` VALUES ('17', 21, '南昌大学前湖校区6栋5室', 44, 21, 290.18, 1, 3, '2026-07-26 23:08:50', '2026-07-28 23:08:50', '2026-07-26 22:57:50');
INSERT INTO `orders` VALUES ('170', 7, '南昌大学前湖校区8栋17室', 176, 7, 958.59, 1, 3, '2026-07-30 23:11:50', '2026-07-31 23:11:50', '2026-07-30 22:57:50');
INSERT INTO `orders` VALUES ('171', 16, '南昌大学前湖校区1栋13室', 152, 16, 491.38, 1, 3, '2026-09-08 23:22:50', '2026-09-09 23:22:50', '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('172', 14, '南昌大学前湖校区7栋4室', 23, 14, 197.72, 1, 3, '2026-08-24 23:12:50', '2026-08-25 23:12:50', '2026-08-24 22:57:50');
INSERT INTO `orders` VALUES ('173', 50, '南昌大学前湖校区3栋2室', 41, 50, 967.26, 1, 3, '2026-09-08 23:25:50', '2026-09-09 23:25:50', '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('174', 16, '南昌大学前湖校区1栋11室', 190, 16, 745.60, 1, 3, '2026-09-08 23:25:50', '2026-09-11 23:25:50', '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('175', 41, '南昌大学前湖校区2栋6室', 85, 41, 340.92, 0, 4, NULL, NULL, '2026-08-20 22:57:50');
INSERT INTO `orders` VALUES ('176', 23, '南昌大学前湖校区8栋6室', 185, 23, 581.08, 1, 4, '2026-08-26 23:25:50', NULL, '2026-08-26 22:57:50');
INSERT INTO `orders` VALUES ('177', 88, '南昌大学前湖校区1栋14室', 53, 88, 468.83, 1, 0, '2026-09-08 23:21:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('178', 29, '南昌大学前湖校区6栋16室', 175, 29, 175.72, 1, 3, '2026-09-08 23:25:50', '2026-09-10 23:25:50', '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('179', 17, '南昌大学前湖校区2栋2室', 81, 17, 633.52, 0, 5, NULL, NULL, '2026-07-18 22:57:50');
INSERT INTO `orders` VALUES ('18', 72, '南昌大学前湖校区1栋4室', 143, 72, 966.31, 1, 3, '2026-08-28 23:16:50', '2026-08-30 23:16:50', '2026-08-28 22:57:50');
INSERT INTO `orders` VALUES ('180', 67, '南昌大学前湖校区4栋5室', 84, 67, 337.33, 1, 5, '2026-09-08 23:19:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('181', 100, '南昌大学前湖校区5栋10室', 69, 100, 420.72, 0, 5, NULL, NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('182', 50, '南昌大学前湖校区3栋5室', 104, 50, 313.48, 1, 1, '2026-08-02 23:19:50', NULL, '2026-08-02 22:57:50');
INSERT INTO `orders` VALUES ('183', 51, '南昌大学前湖校区4栋16室', 195, 51, 744.89, 1, 3, '2026-07-24 23:12:50', '2026-07-25 23:12:50', '2026-07-24 22:57:50');
INSERT INTO `orders` VALUES ('184', 66, '南昌大学前湖校区3栋16室', 35, 66, 359.64, 1, 5, '2026-09-08 23:17:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('185', 71, '南昌大学前湖校区8栋20室', 139, 71, 572.70, 0, 4, NULL, NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('186', 23, '南昌大学前湖校区8栋4室', 143, 23, 73.52, 0, 2, NULL, NULL, '2026-08-21 22:57:50');
INSERT INTO `orders` VALUES ('187', 57, '南昌大学前湖校区2栋10室', 89, 57, 490.33, 1, 0, '2026-08-11 23:22:50', NULL, '2026-08-11 22:57:50');
INSERT INTO `orders` VALUES ('188', 70, '南昌大学前湖校区7栋7室', 6, 70, 961.78, 1, 1, '2026-09-08 23:11:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('189', 49, '南昌大学前湖校区2栋8室', 167, 49, 619.67, 1, 3, '2026-07-14 23:22:50', '2026-07-16 23:22:50', '2026-07-14 22:57:50');
INSERT INTO `orders` VALUES ('19', 68, '南昌大学前湖校区5栋6室', 105, 68, 406.29, 0, 1, NULL, NULL, '2026-09-07 22:57:50');
INSERT INTO `orders` VALUES ('190', 26, '南昌大学前湖校区3栋17室', 56, 26, 402.74, 1, 2, '2026-09-08 23:13:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('191', 91, '南昌大学前湖校区4栋14室', 73, 91, 917.61, 1, 1, '2026-08-10 23:11:50', NULL, '2026-08-10 22:57:50');
INSERT INTO `orders` VALUES ('192', 92, '南昌大学前湖校区5栋17室', 76, 92, 46.76, 1, 3, '2026-07-31 23:10:50', '2026-08-03 23:10:50', '2026-07-31 22:57:50');
INSERT INTO `orders` VALUES ('193', 68, '南昌大学前湖校区5栋2室', 61, 68, 784.43, 1, 4, '2026-09-08 23:08:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('194', 79, '南昌大学前湖校区8栋12室', 111, 79, 259.20, 1, 5, '2026-09-08 23:26:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('195', 81, '南昌大学前湖校区2栋6室', 185, 81, 417.00, 0, 4, NULL, NULL, '2026-08-23 22:57:50');
INSERT INTO `orders` VALUES ('196', 59, '南昌大学前湖校区4栋20室', 59, 59, 97.16, 1, 3, '2026-09-08 23:21:50', '2026-09-10 23:21:50', '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('197', 43, '南昌大学前湖校区4栋9室', 68, 43, 128.55, 0, 1, NULL, NULL, '2026-07-30 22:57:50');
INSERT INTO `orders` VALUES ('198', 34, '南昌大学前湖校区3栋14室', 113, 34, 805.56, 0, 1, NULL, NULL, '2026-09-05 22:57:50');
INSERT INTO `orders` VALUES ('199', 100, '南昌大学前湖校区5栋20室', 79, 100, 69.01, 1, 1, '2026-08-21 23:18:50', NULL, '2026-08-21 22:57:50');
INSERT INTO `orders` VALUES ('2', 58, '南昌大学前湖校区3栋7室', 126, 58, 475.97, 0, 4, NULL, NULL, '2026-09-09 22:57:50');
INSERT INTO `orders` VALUES ('20', 59, '南昌大学前湖校区4栋5室', 84, 59, 701.90, 0, 2, NULL, NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('200', 31, '南昌大学前湖校区8栋1室', 60, 31, 417.76, 1, 1, '2026-08-05 23:19:50', NULL, '2026-08-05 22:57:50');
INSERT INTO `orders` VALUES ('21', 95, '南昌大学前湖校区8栋13室', 92, 95, 916.00, 1, 2, '2026-09-08 23:18:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('22', 33, '南昌大学前湖校区2栋6室', 105, 33, 115.19, 1, 0, '2026-09-03 23:24:50', NULL, '2026-09-03 22:57:50');
INSERT INTO `orders` VALUES ('23', 89, '南昌大学前湖校区2栋7室', 186, 89, 607.33, 1, 2, '2026-07-27 23:20:50', NULL, '2026-07-27 22:57:50');
INSERT INTO `orders` VALUES ('24', 98, '南昌大学前湖校区3栋16室', 155, 98, 883.29, 1, 0, '2026-09-08 23:23:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('25', 62, '南昌大学前湖校区7栋4室', 163, 62, 733.95, 1, 2, '2026-09-08 23:09:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('26', 24, '南昌大学前湖校区1栋13室', 52, 24, 508.15, 0, 4, NULL, NULL, '2026-08-15 22:57:50');
INSERT INTO `orders` VALUES ('27', 21, '南昌大学前湖校区6栋19室', 18, 21, 217.79, 1, 3, '2026-09-08 23:09:50', '2026-09-11 23:09:50', '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('28', 58, '南昌大学前湖校区3栋10室', 189, 58, 158.80, 0, 2, NULL, NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('29', 98, '南昌大学前湖校区3栋4室', 123, 98, 935.63, 0, 0, NULL, NULL, '2026-09-06 22:57:50');
INSERT INTO `orders` VALUES ('3', 28, '南昌大学前湖校区5栋2室', 161, 28, 225.46, 1, 2, '2026-09-08 23:09:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('30', 84, '南昌大学前湖校区5栋3室', 142, 84, 946.31, 1, 4, '2026-08-24 23:14:50', NULL, '2026-08-24 22:57:50');
INSERT INTO `orders` VALUES ('31', 50, '南昌大学前湖校区3栋6室', 65, 50, 768.07, 0, 0, NULL, NULL, '2026-08-05 22:57:50');
INSERT INTO `orders` VALUES ('32', 71, '南昌大学前湖校区8栋5室', 4, 71, 222.46, 0, 4, NULL, NULL, '2026-08-25 22:57:50');
INSERT INTO `orders` VALUES ('33', 60, '南昌大学前湖校区5栋7室', 126, 60, 896.37, 0, 5, NULL, NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('34', 15, '南昌大学前湖校区8栋3室', 122, 15, 828.80, 1, 3, '2026-08-15 23:15:50', '2026-08-16 23:15:50', '2026-08-15 22:57:50');
INSERT INTO `orders` VALUES ('35', 49, '南昌大学前湖校区2栋12室', 151, 49, 275.70, 0, 2, NULL, NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('36', 30, '南昌大学前湖校区7栋16室', 15, 30, 156.98, 1, 4, '2026-09-08 23:09:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('37', 30, '南昌大学前湖校区7栋7室', 166, 30, 75.75, 1, 4, '2026-08-18 23:10:50', NULL, '2026-08-18 22:57:50');
INSERT INTO `orders` VALUES ('38', 9, '南昌大学前湖校区2栋9室', 188, 9, 201.72, 0, 4, NULL, NULL, '2026-09-05 22:57:50');
INSERT INTO `orders` VALUES ('39', 87, '南昌大学前湖校区8栋9室', 148, 87, 190.62, 0, 1, NULL, NULL, '2026-07-14 22:57:50');
INSERT INTO `orders` VALUES ('4', 86, '南昌大学前湖校区7栋2室', 81, 86, 789.97, 0, 1, NULL, NULL, '2026-07-27 22:57:50');
INSERT INTO `orders` VALUES ('40', 33, '南昌大学前湖校区2栋9室', 28, 33, 876.32, 1, 3, '2026-09-08 23:19:50', '2026-09-11 23:19:50', '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('41', 26, '南昌大学前湖校区3栋2室', 161, 26, 616.80, 1, 4, '2026-09-08 23:18:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('42', 1, '南昌大学前湖校区2栋15室', 114, 1, 497.55, 0, 4, NULL, NULL, '2026-08-31 22:57:50');
INSERT INTO `orders` VALUES ('43', 62, '南昌大学前湖校区7栋14室', 133, 62, 972.25, 0, 4, NULL, NULL, '2026-08-02 22:57:50');
INSERT INTO `orders` VALUES ('44', 5, '南昌大学前湖校区6栋1室', 140, 5, 545.47, 0, 1, NULL, NULL, '2026-08-24 22:57:50');
INSERT INTO `orders` VALUES ('45', 65, '南昌大学前湖校区2栋8室', 107, 65, 225.07, 0, 5, NULL, NULL, '2026-08-04 22:57:50');
INSERT INTO `orders` VALUES ('46', 13, '南昌大学前湖校区6栋7室', 26, 13, 610.64, 1, 3, '2026-08-24 23:08:50', '2026-08-27 23:08:50', '2026-08-24 22:57:50');
INSERT INTO `orders` VALUES ('47', 73, '南昌大学前湖校区2栋11室', 30, 73, 528.58, 1, 5, '2026-09-08 23:17:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('48', 24, '南昌大学前湖校区1栋1室', 200, 24, 475.82, 1, 3, '2026-07-21 23:14:50', '2026-07-23 23:14:50', '2026-07-21 22:57:50');
INSERT INTO `orders` VALUES ('49', 88, '南昌大学前湖校区1栋4室', 163, 88, 294.60, 0, 2, NULL, NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('5', 67, '南昌大学前湖校区4栋18室', 77, 67, 183.59, 1, 4, '2026-08-21 23:14:50', NULL, '2026-08-21 22:57:50');
INSERT INTO `orders` VALUES ('50', 18, '南昌大学前湖校区3栋7室', 186, 18, 93.66, 1, 2, '2026-07-26 23:21:50', NULL, '2026-07-26 22:57:50');
INSERT INTO `orders` VALUES ('51', 68, '南昌大学前湖校区5栋4室', 123, 68, 998.81, 1, 3, '2026-08-09 23:17:50', '2026-08-10 23:17:50', '2026-08-09 22:57:50');
INSERT INTO `orders` VALUES ('52', 89, '南昌大学前湖校区2栋14室', 93, 89, 804.54, 0, 2, NULL, NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('53', 92, '南昌大学前湖校区5栋19室', 118, 92, 676.33, 0, 2, NULL, NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('54', 23, '南昌大学前湖校区8栋8室', 187, 23, 314.53, 1, 2, '2026-09-05 23:14:50', NULL, '2026-09-05 22:57:50');
INSERT INTO `orders` VALUES ('55', 84, '南昌大学前湖校区5栋18室', 97, 84, 952.79, 0, 4, NULL, NULL, '2026-08-27 22:57:50');
INSERT INTO `orders` VALUES ('56', 39, '南昌大学前湖校区8栋14室', 53, 39, 852.34, 0, 1, NULL, NULL, '2026-09-04 22:57:50');
INSERT INTO `orders` VALUES ('57', 74, '南昌大学前湖校区3栋9室', 188, 74, 587.61, 1, 3, '2026-08-18 23:14:50', '2026-08-21 23:14:50', '2026-08-18 22:57:50');
INSERT INTO `orders` VALUES ('58', 19, '南昌大学前湖校区4栋9室', 68, 19, 895.41, 0, 4, NULL, NULL, '2026-07-22 22:57:50');
INSERT INTO `orders` VALUES ('59', 74, '南昌大学前湖校区3栋19室', 198, 74, 139.98, 1, 3, '2026-09-08 23:22:50', '2026-09-11 23:22:50', '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('6', 24, '南昌大学前湖校区1栋14室', 53, 24, 17.04, 1, 3, '2026-09-08 23:22:50', '2026-09-10 23:22:50', '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('60', 29, '南昌大学前湖校区6栋10室', 29, 29, 403.24, 0, 0, NULL, NULL, '2026-08-26 22:57:50');
INSERT INTO `orders` VALUES ('61', 13, '南昌大学前湖校区6栋13室', 172, 13, 321.81, 1, 0, '2026-09-05 23:18:50', NULL, '2026-09-05 22:57:50');
INSERT INTO `orders` VALUES ('62', 73, '南昌大学前湖校区2栋13室', 112, 73, 346.50, 0, 1, NULL, NULL, '2026-08-02 22:57:50');
INSERT INTO `orders` VALUES ('63', 76, '南昌大学前湖校区5栋16室', 175, 76, 169.30, 0, 2, NULL, NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('64', 76, '南昌大学前湖校区5栋8室', 67, 76, 867.80, 1, 4, '2026-09-05 23:15:50', NULL, '2026-09-05 22:57:50');
INSERT INTO `orders` VALUES ('65', 24, '南昌大学前湖校区1栋10室', 89, 24, 591.96, 0, 1, NULL, NULL, '2026-08-06 22:57:50');
INSERT INTO `orders` VALUES ('66', 85, '南昌大学前湖校区6栋3室', 162, 85, 630.26, 0, 5, NULL, NULL, '2026-08-15 22:57:50');
INSERT INTO `orders` VALUES ('67', 12, '南昌大学前湖校区5栋19室', 118, 12, 880.93, 1, 0, '2026-09-08 23:15:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('68', 97, '南昌大学前湖校区2栋19室', 178, 97, 151.12, 1, 3, '2026-08-06 23:24:50', '2026-08-08 23:24:50', '2026-08-06 22:57:50');
INSERT INTO `orders` VALUES ('69', 95, '南昌大学前湖校区8栋4室', 163, 95, 964.52, 1, 3, '2026-09-08 23:08:50', '2026-09-11 23:08:50', '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('7', 56, '南昌大学前湖校区1栋4室', 23, 56, 448.67, 1, 0, '2026-08-18 23:21:50', NULL, '2026-08-18 22:57:50');
INSERT INTO `orders` VALUES ('70', 96, '南昌大学前湖校区1栋11室', 70, 96, 878.42, 0, 0, NULL, NULL, '2026-08-16 22:57:50');
INSERT INTO `orders` VALUES ('71', 22, '南昌大学前湖校区7栋7室', 46, 22, 398.02, 1, 4, '2026-08-07 23:14:50', NULL, '2026-08-07 22:57:50');
INSERT INTO `orders` VALUES ('72', 93, '南昌大学前湖校区6栋7室', 166, 93, 472.58, 0, 5, NULL, NULL, '2026-08-16 22:57:50');
INSERT INTO `orders` VALUES ('73', 61, '南昌大学前湖校区6栋13室', 152, 61, 72.87, 0, 4, NULL, NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('74', 43, '南昌大学前湖校区4栋7室', 66, 43, 780.74, 0, 4, NULL, NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('75', 29, '南昌大学前湖校区6栋8室', 167, 29, 722.81, 0, 2, NULL, NULL, '2026-07-04 22:57:50');
INSERT INTO `orders` VALUES ('76', 24, '南昌大学前湖校区1栋12室', 11, 24, 36.61, 1, 1, '2026-08-21 23:20:50', NULL, '2026-08-21 22:57:50');
INSERT INTO `orders` VALUES ('77', 37, '南昌大学前湖校区6栋9室', 8, 37, 58.07, 1, 4, '2026-07-26 23:12:50', NULL, '2026-07-26 22:57:50');
INSERT INTO `orders` VALUES ('78', 65, '南昌大学前湖校区2栋4室', 63, 65, 268.73, 1, 2, '2026-08-09 23:16:50', NULL, '2026-08-09 22:57:50');
INSERT INTO `orders` VALUES ('79', 66, '南昌大学前湖校区3栋4室', 123, 66, 919.82, 1, 3, '2026-08-26 23:14:50', '2026-08-27 23:14:50', '2026-08-26 22:57:50');
INSERT INTO `orders` VALUES ('8', 85, '南昌大学前湖校区6栋1室', 200, 85, 773.90, 1, 1, '2026-08-03 23:18:50', NULL, '2026-08-03 22:57:50');
INSERT INTO `orders` VALUES ('80', 94, '南昌大学前湖校区7栋7室', 166, 94, 625.20, 0, 2, NULL, NULL, '2026-08-21 22:57:50');
INSERT INTO `orders` VALUES ('81', 83, '南昌大学前湖校区4栋11室', 150, 83, 578.81, 0, 0, NULL, NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('82', 61, '南昌大学前湖校区6栋18室', 57, 61, 222.21, 1, 3, '2026-07-23 23:20:50', '2026-07-25 23:20:50', '2026-07-23 22:57:50');
INSERT INTO `orders` VALUES ('83', 43, '南昌大学前湖校区4栋11室', 10, 43, 732.18, 0, 2, NULL, NULL, '2026-08-27 22:57:50');
INSERT INTO `orders` VALUES ('84', 79, '南昌大学前湖校区8栋16室', 75, 79, 560.38, 0, 2, NULL, NULL, '2026-08-06 22:57:50');
INSERT INTO `orders` VALUES ('85', 30, '南昌大学前湖校区7栋10室', 69, 30, 831.88, 0, 4, NULL, NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('86', 30, '南昌大学前湖校区7栋8室', 147, 30, 46.21, 0, 1, NULL, NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('87', 52, '南昌大学前湖校区5栋12室', 191, 52, 429.93, 0, 4, NULL, NULL, '2026-07-22 22:57:50');
INSERT INTO `orders` VALUES ('88', 60, '南昌大学前湖校区5栋12室', 91, 60, 826.94, 0, 1, NULL, NULL, '2026-09-07 22:57:50');
INSERT INTO `orders` VALUES ('89', 85, '南昌大学前湖校区6栋6室', 5, 85, 36.48, 1, 3, '2026-09-08 23:19:50', '2026-09-11 23:19:50', '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('9', 1, '南昌大学前湖校区2栋14室', 13, 1, 130.16, 1, 5, '2026-07-22 23:08:50', NULL, '2026-07-22 22:57:50');
INSERT INTO `orders` VALUES ('90', 69, '南昌大学前湖校区6栋19室', 158, 69, 558.59, 0, 1, NULL, NULL, '2026-08-15 22:57:50');
INSERT INTO `orders` VALUES ('91', 65, '南昌大学前湖校区2栋17室', 136, 65, 307.46, 0, 0, NULL, NULL, '2026-07-14 22:57:50');
INSERT INTO `orders` VALUES ('92', 24, '南昌大学前湖校区1栋18室', 197, 24, 135.52, 1, 5, '2026-08-24 23:17:50', NULL, '2026-08-24 22:57:50');
INSERT INTO `orders` VALUES ('93', 30, '南昌大学前湖校区7栋3室', 102, 30, 220.04, 1, 5, '2026-07-20 23:14:50', NULL, '2026-07-20 22:57:50');
INSERT INTO `orders` VALUES ('94', 44, '南昌大学前湖校区5栋13室', 72, 44, 87.45, 1, 4, '2026-09-08 23:11:50', NULL, '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('95', 10, '南昌大学前湖校区3栋9室', 68, 10, 558.60, 1, 3, '2026-07-25 23:09:50', '2026-07-28 23:09:50', '2026-07-25 22:57:50');
INSERT INTO `orders` VALUES ('96', 80, '南昌大学前湖校区1栋10室', 9, 80, 163.98, 1, 3, '2026-09-08 23:23:50', '2026-09-10 23:23:50', '2026-09-08 22:57:50');
INSERT INTO `orders` VALUES ('97', 6, '南昌大学前湖校区7栋5室', 44, 6, 474.58, 1, 3, '2026-08-05 23:22:50', '2026-08-08 23:22:50', '2026-08-05 22:57:50');
INSERT INTO `orders` VALUES ('98', 66, '南昌大学前湖校区3栋4室', 23, 66, 86.80, 0, 1, NULL, NULL, '2026-07-30 22:57:50');
INSERT INTO `orders` VALUES ('99', 4, '南昌大学前湖校区5栋5室', 24, 4, 912.10, 0, 1, NULL, NULL, '2026-09-08 22:57:50');

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
INSERT INTO `report` VALUES (1, 96, 81, 3, '卖家态度恶劣，请求平台介入。', 'https://picsumKphotos/seed/report_353/300/300', 0, NULL, '2026-07-09 22:57:50');
INSERT INTO `report` VALUES (2, 17, 114, 3, '怀疑商品是盗版或假货，请求下架。', NULL, 1, '经核实为恶意举报，已驳回本次举报。', '2026-08-16 22:57:50');
INSERT INTO `report` VALUES (3, 73, 167, 2, '描述与实物严重不符，请求处理。', NULL, 1, '商品已下架，并已扣除卖家信用分。', '2026-07-19 22:57:50');
INSERT INTO `report` VALUES (4, 36, 66, 4, '商品存在虚假描述，请求管理员核实。', NULL, 0, NULL, '2026-08-24 22:51:15');
INSERT INTO `report` VALUES (5, 14, 191, 2, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-07-21 22:57:50');
INSERT INTO `report` VALUES (6, 33, 193, 5, '怀疑商品是盗版或假货，请求下架。', NULL, 0, NULL, '2026-09-04 22:51:15');
INSERT INTO `report` VALUES (7, 69, 174, 4, '描述与实物严重不符，请求处理。', NULL, 1, '商品已下架，并已扣除卖家信用分。', '2026-08-31 22:57:50');
INSERT INTO `report` VALUES (8, 95, 144, 2, '商品存在虚假描述，请求管理员核实。', NULL, 1, '已联系卖家，要求其立即下架违规商品。', '2026-08-28 22:57:50');
INSERT INTO `report` VALUES (9, 75, 104, 4, '卖家态度恶劣，请求平台介入。', NULL, 0, NULL, '2026-07-30 22:57:50');
INSERT INTO `report` VALUES (10, 9, 54, 2, '怀疑商品是盗版或假货，请求下架。', NULL, 1, '经核实为恶意举报，已驳回本次举报。', '2026-09-02 22:51:15');
INSERT INTO `report` VALUES (11, 51, 144, 2, '描述与实物严重不符，请求处理。', 'https://picsumKphotos/seed/report_9541/300/300', 1, '商品已下架，并已扣除卖家信用分。', '2026-08-07 22:57:50');
INSERT INTO `report` VALUES (12, 97, 158, 3, '商品存在虚假描述，请求管理员核实。', NULL, 1, '已联系卖家，要求其立即下架违规商品。', '2026-08-13 22:57:50');
INSERT INTO `report` VALUES (13, 5, 3, 4, '卖家态度恶劣，请求平台介入。', NULL, 0, NULL, '2026-07-22 22:57:50');
INSERT INTO `report` VALUES (14, 64, 8, 4, '怀疑商品是盗版或假货，请求下架。', NULL, 0, NULL, '2026-07-09 22:57:50');
INSERT INTO `report` VALUES (15, 81, 162, 2, '描述与实物严重不符，请求处理。', NULL, 1, '商品已下架，并已扣除卖家信用分。', '2026-08-21 22:57:50');
INSERT INTO `report` VALUES (16, 44, 102, 4, '商品存在虚假描述，请求管理员核实。', NULL, 0, NULL, '2026-08-03 22:57:50');
INSERT INTO `report` VALUES (17, 93, 159, 1, '卖家态度恶劣，请求平台介入。', 'https://picsum|photos/seed/report_4828/300/300', 0, NULL, '2026-09-02 22:51:15');
INSERT INTO `report` VALUES (18, 93, 120, 3, '怀疑商品是盗版或假货，请求下架。', 'https://picsumxphotos/seed/report_024/300/300', 1, '经核实为恶意举报，已驳回本次举报。', '2026-07-06 22:57:50');
INSERT INTO `report` VALUES (19, 18, 144, 2, '描述与实物严重不符，请求处理。', NULL, 1, '商品已下架，并已扣除卖家信用分。', '2026-08-26 22:57:50');
INSERT INTO `report` VALUES (20, 47, 54, 4, '商品存在虚假描述，请求管理员核实。', 'https://picsumhphotos/seed/report_55/300/300', 0, NULL, '2026-09-05 22:51:15');
INSERT INTO `report` VALUES (21, 90, 54, 3, '卖家态度恶劣，请求平台介入。', NULL, 0, NULL, '2026-09-09 22:51:15');
INSERT INTO `report` VALUES (22, 66, 81, 2, '怀疑商品是盗版或假货，请求下架。', 'https://picsumhphotos/seed/report_716/300/300', 1, '经核实为恶意举报，已驳回本次举报。', '2026-07-20 22:57:50');
INSERT INTO `report` VALUES (23, 98, 154, 2, '描述与实物严重不符，请求处理。', NULL, 1, '商品已下架，并已扣除卖家信用分。', '2026-08-28 22:57:50');
INSERT INTO `report` VALUES (24, 37, 132, 4, '商品存在虚假描述，请求管理员核实。', 'https://picsum6photos/seed/report_57452/300/300', 1, '已联系卖家，要求其立即下架违规商品。', '2026-08-14 22:51:15');
INSERT INTO `report` VALUES (25, 31, 97, 2, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-08-07 22:57:50');
INSERT INTO `report` VALUES (26, 93, 133, 4, '怀疑商品是盗版或假货，请求下架。', 'https://picsum}photos/seed/report_145/300/300', 0, NULL, '2026-08-08 22:57:50');
INSERT INTO `report` VALUES (27, 73, 176, 1, '描述与实物严重不符，请求处理。', NULL, 0, NULL, '2026-08-09 22:57:50');
INSERT INTO `report` VALUES (28, 65, 79, 4, '商品存在虚假描述，请求管理员核实。', NULL, 0, NULL, '2026-08-25 22:57:50');
INSERT INTO `report` VALUES (29, 81, 22, 2, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-09-08 22:51:15');
INSERT INTO `report` VALUES (30, 72, 192, 1, '怀疑商品是盗版或假货，请求下架。', NULL, 1, '经核实为恶意举报，已驳回本次举报。', '2026-08-13 22:57:50');
INSERT INTO `report` VALUES (31, 34, 24, 5, '描述与实物严重不符，请求处理。', 'https://picsum0photos/seed/report_00756/300/300', 0, NULL, '2026-08-16 22:51:15');
INSERT INTO `report` VALUES (32, 42, 87, 3, '商品存在虚假描述，请求管理员核实。', NULL, 1, '已联系卖家，要求其立即下架违规商品。', '2026-08-19 22:57:50');
INSERT INTO `report` VALUES (33, 91, 140, 4, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-08-21 22:57:50');
INSERT INTO `report` VALUES (34, 98, 172, 1, '怀疑商品是盗版或假货，请求下架。', NULL, 0, NULL, '2026-09-09 22:57:50');
INSERT INTO `report` VALUES (35, 39, 111, 2, '描述与实物严重不符，请求处理。', NULL, 0, NULL, '2026-09-06 22:57:50');
INSERT INTO `report` VALUES (36, 69, 149, 2, '商品存在虚假描述，请求管理员核实。', 'https://picsumEphotos/seed/report_834/300/300', 0, NULL, '2026-08-28 22:51:15');
INSERT INTO `report` VALUES (37, 99, 17, 1, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-07-12 22:57:50');
INSERT INTO `report` VALUES (38, 93, 80, 5, '怀疑商品是盗版或假货，请求下架。', NULL, 1, '经核实为恶意举报，已驳回本次举报。', '2026-08-22 22:57:50');
INSERT INTO `report` VALUES (39, 54, 45, 4, '描述与实物严重不符，请求处理。', NULL, 1, '商品已下架，并已扣除卖家信用分。', '2026-09-08 22:51:15');
INSERT INTO `report` VALUES (40, 23, 160, 4, '商品存在虚假描述，请求管理员核实。', NULL, 1, '已联系卖家，要求其立即下架违规商品。', '2026-09-06 22:57:50');
INSERT INTO `report` VALUES (41, 49, 74, 5, '卖家态度恶劣，请求平台介入。', 'https://picsum:photos/seed/report_7/300/300', 1, '已核实相关情况，对卖家进行警告处理。', '2026-08-22 22:57:50');
INSERT INTO `report` VALUES (42, 92, 42, 1, '怀疑商品是盗版或假货，请求下架。', NULL, 1, '经核实为恶意举报，已驳回本次举报。', '2026-07-05 22:57:50');
INSERT INTO `report` VALUES (43, 30, 77, 4, '描述与实物严重不符，请求处理。', 'https://picsumXphotos/seed/report_116/300/300', 1, '商品已下架，并已扣除卖家信用分。', '2026-09-08 22:51:15');
INSERT INTO `report` VALUES (44, 95, 128, 2, '商品存在虚假描述，请求管理员核实。', 'https://picsum!photos/seed/report_180/300/300', 1, '已联系卖家，要求其立即下架违规商品。', '2026-08-30 22:57:50');
INSERT INTO `report` VALUES (45, 29, 178, 5, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-07-25 22:57:50');
INSERT INTO `report` VALUES (46, 78, 79, 4, '怀疑商品是盗版或假货，请求下架。', 'https://picsumMphotos/seed/report_60/300/300', 1, '经核实为恶意举报，已驳回本次举报。', '2026-09-01 22:57:50');
INSERT INTO `report` VALUES (47, 58, 6, 1, '描述与实物严重不符，请求处理。', NULL, 1, '商品已下架，并已扣除卖家信用分。', '2026-08-29 22:51:15');
INSERT INTO `report` VALUES (48, 46, 141, 1, '商品存在虚假描述，请求管理员核实。', 'https://picsum/photos/seed/report_0094/300/300', 0, NULL, '2026-09-09 22:57:50');
INSERT INTO `report` VALUES (49, 17, 133, 3, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-08-09 22:57:50');
INSERT INTO `report` VALUES (50, 1, 30, 2, '怀疑商品是盗版或假货，请求下架。', NULL, 0, NULL, '2026-09-06 22:51:15');
INSERT INTO `report` VALUES (51, 80, 115, 1, '描述与实物严重不符，请求处理。', NULL, 1, '商品已下架，并已扣除卖家信用分。', '2026-09-04 22:51:15');
INSERT INTO `report` VALUES (52, 71, 62, 2, '商品存在虚假描述，请求管理员核实。', NULL, 1, '已联系卖家，要求其立即下架违规商品。', '2026-08-21 22:51:15');
INSERT INTO `report` VALUES (53, 77, 170, 1, '卖家态度恶劣，请求平台介入。', NULL, 0, NULL, '2026-08-21 22:51:15');
INSERT INTO `report` VALUES (54, 80, 55, 4, '怀疑商品是盗版或假货，请求下架。', NULL, 0, NULL, '2026-08-30 22:51:15');
INSERT INTO `report` VALUES (55, 39, 113, 4, '描述与实物严重不符，请求处理。', NULL, 1, '商品已下架，并已扣除卖家信用分。', '2026-08-19 22:51:15');
INSERT INTO `report` VALUES (56, 70, 15, 4, '商品存在虚假描述，请求管理员核实。', NULL, 0, NULL, '2026-08-24 22:51:15');
INSERT INTO `report` VALUES (57, 1, 94, 5, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-08-21 22:51:15');
INSERT INTO `report` VALUES (58, 20, 160, 2, '怀疑商品是盗版或假货，请求下架。', NULL, 0, NULL, '2026-08-24 22:51:15');
INSERT INTO `report` VALUES (59, 86, 155, 1, '描述与实物严重不符，请求处理。', NULL, 1, '商品已下架，并已扣除卖家信用分。', '2026-09-06 22:57:50');
INSERT INTO `report` VALUES (60, 29, 184, 3, '商品存在虚假描述，请求管理员核实。', NULL, 1, '已联系卖家，要求其立即下架违规商品。', '2026-07-24 22:57:50');
INSERT INTO `report` VALUES (61, 36, 191, 3, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-08-13 22:57:50');
INSERT INTO `report` VALUES (62, 73, 52, 5, '怀疑商品是盗版或假货，请求下架。', NULL, 0, NULL, '2026-08-13 22:57:50');
INSERT INTO `report` VALUES (63, 62, 163, 1, '描述与实物严重不符，请求处理。', NULL, 1, '商品已下架，并已扣除卖家信用分。', '2026-08-16 22:51:15');
INSERT INTO `report` VALUES (64, 9, 158, 2, '商品存在虚假描述，请求管理员核实。', 'https://picsumjphotos/seed/report_1581/300/300', 1, '已联系卖家，要求其立即下架违规商品。', '2026-08-27 22:57:50');
INSERT INTO `report` VALUES (65, 38, 69, 2, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-08-11 22:51:15');
INSERT INTO `report` VALUES (66, 94, 168, 4, '怀疑商品是盗版或假货，请求下架。', NULL, 1, '经核实为恶意举报，已驳回本次举报。', '2026-07-26 22:57:50');
INSERT INTO `report` VALUES (67, 13, 167, 2, '描述与实物严重不符，请求处理。', NULL, 1, '商品已下架，并已扣除卖家信用分。', '2026-07-16 22:57:50');
INSERT INTO `report` VALUES (68, 71, 125, 1, '商品存在虚假描述，请求管理员核实。', NULL, 1, '已联系卖家，要求其立即下架违规商品。', '2026-08-01 22:57:50');
INSERT INTO `report` VALUES (69, 68, 188, 3, '卖家态度恶劣，请求平台介入。', 'https://picsumcphotos/seed/report_8/300/300', 1, '已核实相关情况，对卖家进行警告处理。', '2026-08-16 22:57:50');
INSERT INTO `report` VALUES (70, 47, 33, 1, '怀疑商品是盗版或假货，请求下架。', NULL, 1, '经核实为恶意举报，已驳回本次举报。', '2026-08-31 22:51:15');
INSERT INTO `report` VALUES (71, 57, 134, 3, '描述与实物严重不符，请求处理。', 'https://picsumvphotos/seed/report_061/300/300', 0, NULL, '2026-08-26 22:57:50');
INSERT INTO `report` VALUES (72, 65, 94, 2, '商品存在虚假描述，请求管理员核实。', NULL, 0, NULL, '2026-08-15 22:51:15');
INSERT INTO `report` VALUES (73, 6, 180, 3, '卖家态度恶劣，请求平台介入。', NULL, 0, NULL, '2026-08-12 22:51:15');
INSERT INTO `report` VALUES (74, 50, 150, 5, '怀疑商品是盗版或假货，请求下架。', NULL, 1, '经核实为恶意举报，已驳回本次举报。', '2026-09-03 22:51:15');
INSERT INTO `report` VALUES (75, 28, 184, 4, '描述与实物严重不符，请求处理。', NULL, 1, '商品已下架，并已扣除卖家信用分。', '2026-08-09 22:57:50');
INSERT INTO `report` VALUES (76, 49, 45, 2, '商品存在虚假描述，请求管理员核实。', 'https://picsumkphotos/seed/report_3814/300/300', 0, NULL, '2026-08-16 22:51:15');
INSERT INTO `report` VALUES (77, 46, 23, 3, '卖家态度恶劣，请求平台介入。', NULL, 0, NULL, '2026-08-21 22:57:50');
INSERT INTO `report` VALUES (78, 88, 54, 4, '怀疑商品是盗版或假货，请求下架。', 'https://picsumqphotos/seed/report_7/300/300', 0, NULL, '2026-09-02 22:51:15');
INSERT INTO `report` VALUES (79, 31, 146, 3, '描述与实物严重不符，请求处理。', NULL, 1, '商品已下架，并已扣除卖家信用分。', '2026-08-14 22:51:15');
INSERT INTO `report` VALUES (80, 83, 118, 3, '商品存在虚假描述，请求管理员核实。', NULL, 0, NULL, '2026-08-20 22:51:15');
INSERT INTO `report` VALUES (81, 85, 196, 2, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-08-27 22:57:50');
INSERT INTO `report` VALUES (82, 36, 19, 1, '怀疑商品是盗版或假货，请求下架。', NULL, 1, '经核实为恶意举报，已驳回本次举报。', '2026-08-23 22:51:15');
INSERT INTO `report` VALUES (83, 85, 171, 4, '描述与实物严重不符，请求处理。', 'https://picsum0photos/seed/report_07/300/300', 1, '商品已下架，并已扣除卖家信用分。', '2026-08-12 22:57:50');
INSERT INTO `report` VALUES (84, 93, 120, 4, '商品存在虚假描述，请求管理员核实。', NULL, 1, '已联系卖家，要求其立即下架违规商品。', '2026-07-18 22:57:50');
INSERT INTO `report` VALUES (85, 34, 116, 4, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-08-31 22:51:15');
INSERT INTO `report` VALUES (86, 7, 92, 4, '怀疑商品是盗版或假货，请求下架。', NULL, 1, '经核实为恶意举报，已驳回本次举报。', '2026-08-15 22:51:15');
INSERT INTO `report` VALUES (87, 35, 131, 3, '描述与实物严重不符，请求处理。', NULL, 1, '商品已下架，并已扣除卖家信用分。', '2026-07-27 22:57:50');
INSERT INTO `report` VALUES (88, 95, 29, 4, '商品存在虚假描述，请求管理员核实。', NULL, 1, '已联系卖家，要求其立即下架违规商品。', '2026-08-30 22:57:50');
INSERT INTO `report` VALUES (89, 68, 44, 1, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-07-29 22:57:50');
INSERT INTO `report` VALUES (90, 96, 39, 4, '怀疑商品是盗版或假货，请求下架。', NULL, 0, NULL, '2026-08-28 22:51:15');
INSERT INTO `report` VALUES (91, 20, 20, 3, '描述与实物严重不符，请求处理。', NULL, 1, '商品已下架，并已扣除卖家信用分。', '2026-09-06 22:57:50');
INSERT INTO `report` VALUES (92, 79, 26, 4, '商品存在虚假描述，请求管理员核实。', NULL, 1, '已联系卖家，要求其立即下架违规商品。', '2026-08-29 22:57:50');
INSERT INTO `report` VALUES (93, 86, 86, 3, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-08-22 22:57:50');
INSERT INTO `report` VALUES (94, 90, 162, 4, '怀疑商品是盗版或假货，请求下架。', NULL, 1, '经核实为恶意举报，已驳回本次举报。', '2026-08-02 22:57:50');
INSERT INTO `report` VALUES (95, 74, 175, 2, '描述与实物严重不符，请求处理。', 'https://picsumWphotos/seed/report_2/300/300', 1, '商品已下架，并已扣除卖家信用分。', '2026-09-09 22:57:50');
INSERT INTO `report` VALUES (96, 8, 152, 1, '商品存在虚假描述，请求管理员核实。', NULL, 1, '已联系卖家，要求其立即下架违规商品。', '2026-08-18 22:51:15');
INSERT INTO `report` VALUES (97, 67, 59, 3, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-08-31 22:51:15');
INSERT INTO `report` VALUES (98, 16, 40, 1, '怀疑商品是盗版或假货，请求下架。', NULL, 1, '经核实为恶意举报，已驳回本次举报。', '2026-08-30 22:51:15');
INSERT INTO `report` VALUES (99, 63, 160, 2, '描述与实物严重不符，请求处理。', NULL, 0, NULL, '2026-08-18 22:51:15');
INSERT INTO `report` VALUES (100, 29, 38, 5, '商品存在虚假描述，请求管理员核实。', NULL, 0, NULL, '2026-08-18 22:51:15');
INSERT INTO `report` VALUES (101, 21, 167, 2, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-07-11 22:57:50');
INSERT INTO `report` VALUES (102, 78, 62, 4, '怀疑商品是盗版或假货，请求下架。', 'https://picsumBphotos/seed/report_63493/300/300', 0, NULL, '2026-08-26 22:51:15');
INSERT INTO `report` VALUES (103, 16, 109, 5, '描述与实物严重不符，请求处理。', NULL, 1, '商品已下架，并已扣除卖家信用分。', '2026-08-16 22:57:50');
INSERT INTO `report` VALUES (104, 59, 101, 1, '商品存在虚假描述，请求管理员核实。', NULL, 0, NULL, '2026-09-08 22:51:15');
INSERT INTO `report` VALUES (105, 96, 75, 3, '卖家态度恶劣，请求平台介入。', NULL, 0, NULL, '2026-07-26 22:57:50');
INSERT INTO `report` VALUES (106, 99, 181, 3, '怀疑商品是盗版或假货，请求下架。', 'https://picsumqphotos/seed/report_9/300/300', 1, '经核实为恶意举报，已驳回本次举报。', '2026-08-16 22:57:50');
INSERT INTO `report` VALUES (107, 87, 48, 4, '描述与实物严重不符，请求处理。', NULL, 1, '商品已下架，并已扣除卖家信用分。', '2026-07-29 22:57:50');
INSERT INTO `report` VALUES (108, 64, 47, 5, '商品存在虚假描述，请求管理员核实。', NULL, 1, '已联系卖家，要求其立即下架违规商品。', '2026-08-03 22:57:50');
INSERT INTO `report` VALUES (109, 57, 68, 2, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-08-16 22:57:50');
INSERT INTO `report` VALUES (110, 88, 29, 2, '怀疑商品是盗版或假货，请求下架。', 'https://picsumJphotos/seed/report_2287/300/300', 0, NULL, '2026-08-21 22:57:50');
INSERT INTO `report` VALUES (111, 95, 85, 1, '描述与实物严重不符，请求处理。', NULL, 0, NULL, '2026-08-19 22:57:50');
INSERT INTO `report` VALUES (112, 36, 77, 3, '商品存在虚假描述，请求管理员核实。', NULL, 1, '已联系卖家，要求其立即下架违规商品。', '2026-08-22 22:57:50');
INSERT INTO `report` VALUES (113, 50, 117, 2, '卖家态度恶劣，请求平台介入。', NULL, 0, NULL, '2026-09-02 22:51:15');
INSERT INTO `report` VALUES (114, 91, 133, 4, '怀疑商品是盗版或假货，请求下架。', NULL, 0, NULL, '2026-08-12 22:57:50');
INSERT INTO `report` VALUES (115, 8, 77, 3, '描述与实物严重不符，请求处理。', NULL, 0, NULL, '2026-09-02 22:57:50');
INSERT INTO `report` VALUES (116, 99, 125, 4, '商品存在虚假描述，请求管理员核实。', NULL, 0, NULL, '2026-07-23 22:57:50');
INSERT INTO `report` VALUES (117, 24, 182, 3, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-08-11 22:51:15');
INSERT INTO `report` VALUES (118, 63, 1, 4, '怀疑商品是盗版或假货，请求下架。', NULL, 0, NULL, '2026-08-25 22:57:50');
INSERT INTO `report` VALUES (119, 39, 152, 1, '描述与实物严重不符，请求处理。', NULL, 1, '商品已下架，并已扣除卖家信用分。', '2026-08-12 22:51:15');
INSERT INTO `report` VALUES (120, 75, 70, 3, '商品存在虚假描述，请求管理员核实。', 'https://picsumLphotos/seed/report_5099/300/300', 1, '已联系卖家，要求其立即下架违规商品。', '2026-08-07 22:57:50');
INSERT INTO `report` VALUES (121, 7, 195, 4, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-07-27 22:57:50');
INSERT INTO `report` VALUES (122, 16, 63, 5, '怀疑商品是盗版或假货，请求下架。', 'https://picsum;photos/seed/report_92011/300/300', 0, NULL, '2026-07-30 22:57:50');
INSERT INTO `report` VALUES (123, 55, 88, 2, '描述与实物严重不符，请求处理。', NULL, 0, NULL, '2026-08-23 22:51:15');
INSERT INTO `report` VALUES (124, 89, 184, 2, '商品存在虚假描述，请求管理员核实。', NULL, 0, NULL, '2026-07-29 22:57:50');
INSERT INTO `report` VALUES (125, 68, 155, 5, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-08-25 22:51:15');
INSERT INTO `report` VALUES (126, 79, 110, 4, '怀疑商品是盗版或假货，请求下架。', NULL, 1, '经核实为恶意举报，已驳回本次举报。', '2026-08-13 22:57:50');
INSERT INTO `report` VALUES (127, 87, 121, 2, '描述与实物严重不符，请求处理。', NULL, 0, NULL, '2026-07-15 22:57:50');
INSERT INTO `report` VALUES (128, 36, 140, 4, '商品存在虚假描述，请求管理员核实。', NULL, 0, NULL, '2026-09-08 22:57:50');
INSERT INTO `report` VALUES (129, 96, 156, 4, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-08-23 22:57:50');
INSERT INTO `report` VALUES (130, 55, 199, 2, '怀疑商品是盗版或假货，请求下架。', NULL, 0, NULL, '2026-08-28 22:51:15');
INSERT INTO `report` VALUES (131, 72, 70, 3, '描述与实物严重不符，请求处理。', NULL, 0, NULL, '2026-08-24 22:57:50');
INSERT INTO `report` VALUES (132, 8, 167, 3, '商品存在虚假描述，请求管理员核实。', NULL, 0, NULL, '2026-07-23 22:57:50');
INSERT INTO `report` VALUES (133, 28, 178, 3, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-08-07 22:57:50');
INSERT INTO `report` VALUES (134, 37, 100, 5, '怀疑商品是盗版或假货，请求下架。', NULL, 1, '经核实为恶意举报，已驳回本次举报。', '2026-08-19 22:51:15');
INSERT INTO `report` VALUES (135, 19, 74, 4, '描述与实物严重不符，请求处理。', NULL, 1, '商品已下架，并已扣除卖家信用分。', '2026-09-07 22:51:15');
INSERT INTO `report` VALUES (136, 4, 130, 4, '商品存在虚假描述，请求管理员核实。', NULL, 1, '已联系卖家，要求其立即下架违规商品。', '2026-08-17 22:57:50');
INSERT INTO `report` VALUES (137, 34, 132, 5, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-08-12 22:51:15');
INSERT INTO `report` VALUES (138, 56, 58, 2, '怀疑商品是盗版或假货，请求下架。', NULL, 0, NULL, '2026-08-23 22:57:50');
INSERT INTO `report` VALUES (139, 36, 127, 5, '描述与实物严重不符，请求处理。', NULL, 0, NULL, '2026-08-23 22:51:15');
INSERT INTO `report` VALUES (140, 47, 186, 3, '商品存在虚假描述，请求管理员核实。', 'https://picsumJphotos/seed/report_4795/300/300', 1, '已联系卖家，要求其立即下架违规商品。', '2026-07-28 22:57:50');
INSERT INTO `report` VALUES (141, 54, 113, 4, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-09-02 22:51:15');
INSERT INTO `report` VALUES (142, 60, 169, 5, '怀疑商品是盗版或假货，请求下架。', NULL, 0, NULL, '2026-08-27 22:51:15');
INSERT INTO `report` VALUES (143, 58, 97, 4, '描述与实物严重不符，请求处理。', 'https://picsumnphotos/seed/report_4310/300/300', 0, NULL, '2026-08-08 22:57:50');
INSERT INTO `report` VALUES (144, 27, 72, 2, '商品存在虚假描述，请求管理员核实。', NULL, 1, '已联系卖家，要求其立即下架违规商品。', '2026-08-26 22:51:15');
INSERT INTO `report` VALUES (145, 1, 30, 2, '卖家态度恶劣，请求平台介入。', 'https://picsumxphotos/seed/report_225/300/300', 1, '已核实相关情况，对卖家进行警告处理。', '2026-08-19 22:51:15');
INSERT INTO `report` VALUES (146, 24, 77, 3, '怀疑商品是盗版或假货，请求下架。', NULL, 0, NULL, '2026-09-07 22:57:50');
INSERT INTO `report` VALUES (147, 15, 27, 2, '描述与实物严重不符，请求处理。', NULL, 0, NULL, '2026-08-30 22:51:15');
INSERT INTO `report` VALUES (148, 28, 92, 2, '商品存在虚假描述，请求管理员核实。', NULL, 1, '已联系卖家，要求其立即下架违规商品。', '2026-08-29 22:51:15');
INSERT INTO `report` VALUES (149, 21, 115, 5, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-08-11 22:51:15');
INSERT INTO `report` VALUES (150, 50, 86, 2, '怀疑商品是盗版或假货，请求下架。', NULL, 0, NULL, '2026-08-27 22:57:50');
INSERT INTO `report` VALUES (151, 46, 124, 1, '描述与实物严重不符，请求处理。', NULL, 0, NULL, '2026-08-31 22:57:50');
INSERT INTO `report` VALUES (152, 36, 111, 3, '商品存在虚假描述，请求管理员核实。', NULL, 1, '已联系卖家，要求其立即下架违规商品。', '2026-08-22 22:57:50');
INSERT INTO `report` VALUES (153, 1, 10, 4, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-09-05 22:51:15');
INSERT INTO `report` VALUES (154, 21, 91, 5, '怀疑商品是盗版或假货，请求下架。', NULL, 0, NULL, '2026-09-02 22:51:15');
INSERT INTO `report` VALUES (155, 43, 166, 4, '描述与实物严重不符，请求处理。', 'https://picsumDphotos/seed/report_53/300/300', 1, '商品已下架，并已扣除卖家信用分。', '2026-08-24 22:57:50');
INSERT INTO `report` VALUES (156, 33, 126, 2, '商品存在虚假描述，请求管理员核实。', NULL, 1, '已联系卖家，要求其立即下架违规商品。', '2026-08-14 22:51:15');
INSERT INTO `report` VALUES (157, 71, 58, 4, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-08-24 22:57:50');
INSERT INTO `report` VALUES (158, 81, 153, 4, '怀疑商品是盗版或假货，请求下架。', NULL, 0, NULL, '2026-08-09 22:57:50');
INSERT INTO `report` VALUES (159, 24, 92, 4, '描述与实物严重不符，请求处理。', NULL, 1, '商品已下架，并已扣除卖家信用分。', '2026-08-28 22:51:15');
INSERT INTO `report` VALUES (160, 42, 46, 4, '商品存在虚假描述，请求管理员核实。', 'https://picsum+photos/seed/report_8/300/300', 0, NULL, '2026-07-26 22:57:50');
INSERT INTO `report` VALUES (161, 46, 74, 5, '卖家态度恶劣，请求平台介入。', 'https://picsum,photos/seed/report_6800/300/300', 0, NULL, '2026-08-15 22:57:50');
INSERT INTO `report` VALUES (162, 11, 31, 5, '怀疑商品是盗版或假货，请求下架。', NULL, 0, NULL, '2026-08-15 22:51:15');
INSERT INTO `report` VALUES (163, 54, 47, 4, '描述与实物严重不符，请求处理。', NULL, 0, NULL, '2026-07-13 22:57:50');
INSERT INTO `report` VALUES (164, 4, 18, 3, '商品存在虚假描述，请求管理员核实。', NULL, 0, NULL, '2026-09-06 22:57:50');
INSERT INTO `report` VALUES (165, 37, 46, 3, '卖家态度恶劣，请求平台介入。', NULL, 0, NULL, '2026-08-03 22:57:50');
INSERT INTO `report` VALUES (166, 11, 148, 2, '怀疑商品是盗版或假货，请求下架。', NULL, 1, '经核实为恶意举报，已驳回本次举报。', '2026-07-31 22:57:50');
INSERT INTO `report` VALUES (167, 1, 188, 3, '描述与实物严重不符，请求处理。', NULL, 0, NULL, '2026-09-06 22:57:50');
INSERT INTO `report` VALUES (168, 95, 95, 4, '商品存在虚假描述，请求管理员核实。', NULL, 1, '已联系卖家，要求其立即下架违规商品。', '2026-07-25 22:57:50');
INSERT INTO `report` VALUES (169, 2, 67, 4, '卖家态度恶劣，请求平台介入。', NULL, 0, NULL, '2026-09-06 22:57:50');
INSERT INTO `report` VALUES (170, 99, 48, 1, '怀疑商品是盗版或假货，请求下架。', NULL, 0, NULL, '2026-07-06 22:57:50');
INSERT INTO `report` VALUES (171, 20, 159, 2, '描述与实物严重不符，请求处理。', 'https://picsumbphotos/seed/report_37680/300/300', 1, '商品已下架，并已扣除卖家信用分。', '2026-08-26 22:51:15');
INSERT INTO `report` VALUES (172, 69, 126, 2, '商品存在虚假描述，请求管理员核实。', NULL, 1, '已联系卖家，要求其立即下架违规商品。', '2026-08-28 22:51:15');
INSERT INTO `report` VALUES (173, 68, 133, 2, '卖家态度恶劣，请求平台介入。', NULL, 0, NULL, '2026-08-26 22:57:50');
INSERT INTO `report` VALUES (174, 78, 143, 5, '怀疑商品是盗版或假货，请求下架。', NULL, 1, '经核实为恶意举报，已驳回本次举报。', '2026-08-26 22:57:50');
INSERT INTO `report` VALUES (175, 25, 82, 3, '描述与实物严重不符，请求处理。', NULL, 0, NULL, '2026-08-13 22:57:50');
INSERT INTO `report` VALUES (176, 68, 181, 1, '商品存在虚假描述，请求管理员核实。', 'https://picsumQphotos/seed/report_502/300/300', 0, NULL, '2026-08-12 22:57:50');
INSERT INTO `report` VALUES (177, 35, 6, 3, '卖家态度恶劣，请求平台介入。', NULL, 0, NULL, '2026-08-23 22:51:15');
INSERT INTO `report` VALUES (178, 39, 194, 2, '怀疑商品是盗版或假货，请求下架。', NULL, 0, NULL, '2026-07-12 22:57:50');
INSERT INTO `report` VALUES (179, 7, 122, 5, '描述与实物严重不符，请求处理。', NULL, 0, NULL, '2026-08-20 22:57:50');
INSERT INTO `report` VALUES (180, 63, 67, 2, '商品存在虚假描述，请求管理员核实。', NULL, 0, NULL, '2026-09-05 22:57:50');
INSERT INTO `report` VALUES (181, 3, 109, 2, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-09-01 22:57:50');
INSERT INTO `report` VALUES (182, 13, 143, 1, '怀疑商品是盗版或假货，请求下架。', NULL, 1, '经核实为恶意举报，已驳回本次举报。', '2026-08-18 22:57:50');
INSERT INTO `report` VALUES (183, 9, 5, 4, '描述与实物严重不符，请求处理。', 'https://picsumJphotos/seed/report_00/300/300', 0, NULL, '2026-09-06 22:57:50');
INSERT INTO `report` VALUES (184, 98, 156, 1, '商品存在虚假描述，请求管理员核实。', NULL, 1, '已联系卖家，要求其立即下架违规商品。', '2026-08-11 22:51:15');
INSERT INTO `report` VALUES (185, 41, 119, 3, '卖家态度恶劣，请求平台介入。', NULL, 0, NULL, '2026-07-14 22:57:50');
INSERT INTO `report` VALUES (186, 63, 55, 2, '怀疑商品是盗版或假货，请求下架。', NULL, 0, NULL, '2026-09-08 22:57:50');
INSERT INTO `report` VALUES (187, 44, 65, 4, '描述与实物严重不符，请求处理。', NULL, 0, NULL, '2026-07-24 22:57:50');
INSERT INTO `report` VALUES (188, 98, 16, 2, '商品存在虚假描述，请求管理员核实。', NULL, 1, '已联系卖家，要求其立即下架违规商品。', '2026-08-17 22:57:50');
INSERT INTO `report` VALUES (189, 94, 161, 1, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-09-06 22:51:15');
INSERT INTO `report` VALUES (190, 29, 196, 1, '怀疑商品是盗版或假货，请求下架。', 'https://picsumTphotos/seed/report_4/300/300', 1, '经核实为恶意举报，已驳回本次举报。', '2026-08-26 22:57:50');
INSERT INTO `report` VALUES (191, 21, 199, 4, '描述与实物严重不符，请求处理。', 'https://picsum0photos/seed/report_86/300/300', 0, NULL, '2026-08-31 22:51:15');
INSERT INTO `report` VALUES (192, 87, 71, 2, '商品存在虚假描述，请求管理员核实。', 'https://picsumaphotos/seed/report_1218/300/300', 0, NULL, '2026-08-13 22:51:15');
INSERT INTO `report` VALUES (193, 76, 174, 3, '卖家态度恶劣，请求平台介入。', NULL, 1, '已核实相关情况，对卖家进行警告处理。', '2026-08-22 22:57:50');
INSERT INTO `report` VALUES (194, 60, 146, 4, '怀疑商品是盗版或假货，请求下架。', NULL, 1, '经核实为恶意举报，已驳回本次举报。', '2026-08-26 22:51:15');
INSERT INTO `report` VALUES (195, 59, 192, 4, '描述与实物严重不符，请求处理。', NULL, 1, '商品已下架，并已扣除卖家信用分。', '2026-08-18 22:57:50');
INSERT INTO `report` VALUES (196, 46, 175, 5, '商品存在虚假描述，请求管理员核实。', 'https://picsum4photos/seed/report_97941/300/300', 0, NULL, '2026-09-07 22:51:15');
INSERT INTO `report` VALUES (197, 72, 129, 2, '卖家态度恶劣，请求平台介入。', NULL, 0, NULL, '2026-08-14 22:51:15');
INSERT INTO `report` VALUES (198, 11, 34, 4, '怀疑商品是盗版或假货，请求下架。', 'https://picsum0photos/seed/report_7/300/300', 0, NULL, '2026-09-03 22:51:15');
INSERT INTO `report` VALUES (199, 65, 119, 5, '描述与实物严重不符，请求处理。', NULL, 0, NULL, '2026-07-12 22:57:50');
INSERT INTO `report` VALUES (200, 72, 85, 1, '商品存在虚假描述，请求管理员核实。', NULL, 1, '已联系卖家，要求其立即下架违规商品。', '2026-08-31 22:57:50');

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
INSERT INTO `sys_user` VALUES (1, '郝睿', '19028135411', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=1', '诚信交易，拒绝套路，欢迎随时来聊~', 1, 0, '2026-07-06 22:57:50', '南昌大学前湖校区2栋2室');
INSERT INTO `sys_user` VALUES (2, '向致远', '14572081876', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=2', '大四老学长/学姐，毕业出闲置，价格绝对实惠！', 1, 0, '2026-09-05 22:57:50', '南昌大学前湖校区3栋3室');
INSERT INTO `sys_user` VALUES (3, '武子韬', '15861176797', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=3', '校内的朋友多关照，好物一起分享～', 0, 0, '2026-09-05 22:57:50', '南昌大学前湖校区4栋4室');
INSERT INTO `sys_user` VALUES (4, '宋岚', '14103924816', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=4', '爱生活，爱分享，闲置好物都在这里！', 0, 0, '2026-08-31 22:57:50', '南昌大学前湖校区5栋5室');
INSERT INTO `sys_user` VALUES (5, '廖詩涵', '16924344849', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=5', '诚信交易，拒绝套路，欢迎随时来聊~', 0, 0, '2026-08-05 22:57:50', '南昌大学前湖校区6栋6室');
INSERT INTO `sys_user` VALUES (6, '余安琪', '14330596984', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=6', '大四老学长/学姐，毕业出闲置，价格绝对实惠！', 0, 0, '2026-07-11 22:57:50', '南昌大学前湖校区7栋7室');
INSERT INTO `sys_user` VALUES (7, '戴云熙', '19256343272', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=7', '校内的朋友多关照，好物一起分享～', 0, 0, '2026-08-28 22:57:50', '南昌大学前湖校区8栋8室');
INSERT INTO `sys_user` VALUES (8, '石云熙', '18137578405', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=8', '爱生活，爱分享，闲置好物都在这里！', 0, 0, '2026-07-09 22:57:50', '南昌大学前湖校区1栋9室');
INSERT INTO `sys_user` VALUES (9, '崔云熙', '18955248839', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=9', '诚信交易，拒绝套路，欢迎随时来聊~', 0, 0, '2026-09-06 22:57:50', '南昌大学前湖校区2栋10室');
INSERT INTO `sys_user` VALUES (10, '龚子异', '16919068636', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=10', '大四老学长/学姐，毕业出闲置，价格绝对实惠！', 0, 0, '2026-08-29 22:57:50', '南昌大学前湖校区3栋11室');
INSERT INTO `sys_user` VALUES (11, '张子异', '13410657358', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=11', '校内的朋友多关照，好物一起分享～', 0, 0, '2026-07-25 22:57:50', '南昌大学前湖校区4栋12室');
INSERT INTO `sys_user` VALUES (12, '陆云熙', '13116906669', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=12', '爱生活，爱分享，闲置好物都在这里！', 0, 0, '2026-08-23 22:57:50', '南昌大学前湖校区5栋13室');
INSERT INTO `sys_user` VALUES (13, '侯秀英', '16895763309', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=13', '诚信交易，拒绝套路，欢迎随时来聊~', 0, 0, '2026-08-02 22:57:50', '南昌大学前湖校区6栋14室');
INSERT INTO `sys_user` VALUES (14, '彭岚', '17623988031', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=14', '大四老学长/学姐，毕业出闲置，价格绝对实惠！', 0, 0, '2026-07-24 22:57:50', '南昌大学前湖校区7栋15室');
INSERT INTO `sys_user` VALUES (15, '邓致远', '18364022995', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=15', '校内的朋友多关照，好物一起分享～', 0, 0, '2026-08-05 22:57:50', '南昌大学前湖校区8栋16室');
INSERT INTO `sys_user` VALUES (16, '苏宇宁', '19419828272', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=16', '爱生活，爱分享，闲置好物都在这里！', 0, 0, '2026-08-08 22:57:50', '南昌大学前湖校区1栋17室');
INSERT INTO `sys_user` VALUES (17, '汪云熙', '17940699052', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=17', '诚信交易，拒绝套路，欢迎随时来聊~', 0, 0, '2026-07-13 22:57:50', '南昌大学前湖校区2栋18室');
INSERT INTO `sys_user` VALUES (18, '钱宇宁', '17978205337', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=18', '大四老学长/学姐，毕业出闲置，价格绝对实惠！', 0, 0, '2026-08-28 22:57:50', '南昌大学前湖校区3栋19室');
INSERT INTO `sys_user` VALUES (19, '秦杰宏', '14071283361', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=19', '校内的朋友多关照，好物一起分享～', 0, 0, '2026-07-06 22:57:50', '南昌大学前湖校区4栋20室');
INSERT INTO `sys_user` VALUES (20, '许杰宏', '14857388565', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=20', '爱生活，爱分享，闲置好物都在这里！', 0, 0, '2026-08-17 22:57:50', '南昌大学前湖校区5栋1室');
INSERT INTO `sys_user` VALUES (21, '莫子韬', '16684392867', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=21', '诚信交易，拒绝套路，欢迎随时来聊~', 0, 0, '2026-09-02 22:57:50', '南昌大学前湖校区6栋2室');
INSERT INTO `sys_user` VALUES (22, '孔岚', '19581107903', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=22', '大四老学长/学姐，毕业出闲置，价格绝对实惠！', 0, 0, '2026-07-11 22:57:50', '南昌大学前湖校区7栋3室');
INSERT INTO `sys_user` VALUES (23, '谢璐', '16920040895', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=23', '校内的朋友多关照，好物一起分享～', 0, 0, '2026-09-01 22:57:50', '南昌大学前湖校区8栋4室');
INSERT INTO `sys_user` VALUES (24, '钟震南', '14472691284', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=24', '爱生活，爱分享，闲置好物都在这里！', 0, 0, '2026-08-01 22:57:50', '南昌大学前湖校区1栋5室');
INSERT INTO `sys_user` VALUES (25, '邵秀英', '15628893378', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=25', '诚信交易，拒绝套路，欢迎随时来聊~', 0, 0, '2026-06-18 22:57:50', '南昌大学前湖校区2栋6室');
INSERT INTO `sys_user` VALUES (26, '顾安琪', '17600117678', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=26', '大四老学长/学姐，毕业出闲置，价格绝对实惠！', 0, 0, '2026-08-11 22:57:50', '南昌大学前湖校区3栋7室');
INSERT INTO `sys_user` VALUES (27, '苏璐', '15259350289', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=27', '校内的朋友多关照，好物一起分享～', 0, 0, '2026-06-26 22:57:50', '南昌大学前湖校区4栋8室');
INSERT INTO `sys_user` VALUES (28, '钟晓明', '16243631724', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=28', '爱生活，爱分享，闲置好物都在这里！', 0, 0, '2026-08-22 22:57:50', '南昌大学前湖校区5栋9室');
INSERT INTO `sys_user` VALUES (29, '马詩涵', '16754469727', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=29', '诚信交易，拒绝套路，欢迎随时来聊~', 0, 0, '2026-07-25 22:57:50', '南昌大学前湖校区6栋10室');
INSERT INTO `sys_user` VALUES (30, '刘震南', '18490237100', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=30', '大四老学长/学姐，毕业出闲置，价格绝对实惠！', 0, 0, '2026-06-15 22:57:50', '南昌大学前湖校区7栋11室');
INSERT INTO `sys_user` VALUES (31, '陶睿', '18823985756', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=31', '校内的朋友多关照，好物一起分享～', 0, 0, '2026-08-18 22:57:50', '南昌大学前湖校区8栋12室');
INSERT INTO `sys_user` VALUES (32, '董云熙', '13894278475', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=32', '爱生活，爱分享，闲置好物都在这里！', 0, 0, '2026-08-07 22:57:50', '南昌大学前湖校区1栋13室');
INSERT INTO `sys_user` VALUES (33, '赵岚', '18913744650', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=33', '诚信交易，拒绝套路，欢迎随时来聊~', 0, 0, '2026-08-31 22:57:50', '南昌大学前湖校区2栋14室');
INSERT INTO `sys_user` VALUES (34, '薛致远', '16648826621', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=34', '大四老学长/学姐，毕业出闲置，价格绝对实惠！', 0, 0, '2026-08-03 22:57:50', '南昌大学前湖校区3栋15室');
INSERT INTO `sys_user` VALUES (35, '邱致远', '14670549845', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=35', '校内的朋友多关照，好物一起分享～', 0, 0, '2026-07-04 22:57:50', '南昌大学前湖校区4栋16室');
INSERT INTO `sys_user` VALUES (36, '常璐', '19213131977', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=36', '爱生活，爱分享，闲置好物都在这里！', 0, 0, '2026-07-27 22:57:50', '南昌大学前湖校区5栋17室');
INSERT INTO `sys_user` VALUES (37, '阎致远', '18343472150', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=37', '诚信交易，拒绝套路，欢迎随时来聊~', 0, 0, '2026-08-17 22:57:50', '南昌大学前湖校区6栋18室');
INSERT INTO `sys_user` VALUES (38, '金安琪', '18367938811', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=38', '大四老学长/学姐，毕业出闲置，价格绝对实惠！', 0, 0, '2026-06-30 22:57:50', '南昌大学前湖校区7栋19室');
INSERT INTO `sys_user` VALUES (39, '顾睿', '19382537069', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=39', '校内的朋友多关照，好物一起分享～', 0, 0, '2026-08-25 22:57:50', '南昌大学前湖校区8栋20室');
INSERT INTO `sys_user` VALUES (40, '董云熙', '19678909146', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=40', '爱生活，爱分享，闲置好物都在这里！', 0, 0, '2026-07-27 22:57:50', '南昌大学前湖校区1栋1室');
INSERT INTO `sys_user` VALUES (41, '江睿', '19029274749', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=41', '诚信交易，拒绝套路，欢迎随时来聊~', 0, 0, '2026-06-17 22:57:50', '南昌大学前湖校区2栋2室');
INSERT INTO `sys_user` VALUES (42, '严震南', '14588666944', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=42', '大四老学长/学姐，毕业出闲置，价格绝对实惠！', 0, 0, '2026-08-21 22:57:50', '南昌大学前湖校区3栋3室');
INSERT INTO `sys_user` VALUES (43, '彭杰宏', '16883557028', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=43', '校内的朋友多关照，好物一起分享～', 0, 0, '2026-08-15 22:57:50', '南昌大学前湖校区4栋4室');
INSERT INTO `sys_user` VALUES (44, '田璐', '19830483456', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=44', '爱生活，爱分享，闲置好物都在这里！', 0, 0, '2026-07-04 22:57:50', '南昌大学前湖校区5栋5室');
INSERT INTO `sys_user` VALUES (45, '邵岚', '16706898751', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=45', '诚信交易，拒绝套路，欢迎随时来聊~', 0, 0, '2026-06-20 22:57:50', '南昌大学前湖校区6栋6室');
INSERT INTO `sys_user` VALUES (46, '丁晓明', '18898589477', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=46', '大四老学长/学姐，毕业出闲置，价格绝对实惠！', 0, 0, '2026-08-14 22:57:50', '南昌大学前湖校区7栋7室');
INSERT INTO `sys_user` VALUES (47, '苏璐', '19682844546', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=47', '校内的朋友多关照，好物一起分享～', 0, 0, '2026-07-06 22:57:50', '南昌大学前湖校区8栋8室');
INSERT INTO `sys_user` VALUES (48, '陈杰宏', '19213198826', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=48', '爱生活，爱分享，闲置好物都在这里！', 0, 0, '2026-07-03 22:57:50', '南昌大学前湖校区1栋9室');
INSERT INTO `sys_user` VALUES (49, '江杰宏', '17848972002', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=49', '诚信交易，拒绝套路，欢迎随时来聊~', 0, 0, '2026-07-15 22:57:50', '南昌大学前湖校区2栋10室');
INSERT INTO `sys_user` VALUES (50, '孔詩涵', '15007659658', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=50', '大四老学长/学姐，毕业出闲置，价格绝对实惠！', 0, 0, '2026-06-24 22:57:50', '南昌大学前湖校区3栋11室');
INSERT INTO `sys_user` VALUES (51, '贺安琪', '17771790008', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=51', '校内的朋友多关照，好物一起分享～', 0, 0, '2026-08-04 22:57:50', '南昌大学前湖校区4栋12室');
INSERT INTO `sys_user` VALUES (52, '高杰宏', '16278230591', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=52', '爱生活，爱分享，闲置好物都在这里！', 0, 0, '2026-07-29 22:57:50', '南昌大学前湖校区5栋13室');
INSERT INTO `sys_user` VALUES (53, '邱詩涵', '18898109323', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=53', '诚信交易，拒绝套路，欢迎随时来聊~', 0, 0, '2026-08-31 22:57:50', '南昌大学前湖校区6栋14室');
INSERT INTO `sys_user` VALUES (54, '蔡安琪', '19450181170', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=54', '大四老学长/学姐，毕业出闲置，价格绝对实惠！', 0, 0, '2026-08-27 22:57:50', '南昌大学前湖校区7栋15室');
INSERT INTO `sys_user` VALUES (55, '程晓明', '17374111023', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=55', '校内的朋友多关照，好物一起分享～', 0, 0, '2026-08-02 22:57:50', '南昌大学前湖校区8栋16室');
INSERT INTO `sys_user` VALUES (56, '廖致远', '16125937207', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=56', '爱生活，爱分享，闲置好物都在这里！', 0, 0, '2026-07-12 22:57:50', '南昌大学前湖校区1栋17室');
INSERT INTO `sys_user` VALUES (57, '向睿', '19654261451', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=57', '诚信交易，拒绝套路，欢迎随时来聊~', 0, 0, '2026-09-07 22:57:50', '南昌大学前湖校区2栋18室');
INSERT INTO `sys_user` VALUES (58, '邱晓明', '15009504299', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=58', '大四老学长/学姐，毕业出闲置，价格绝对实惠！', 0, 0, '2026-08-25 22:57:50', '南昌大学前湖校区3栋19室');
INSERT INTO `sys_user` VALUES (59, '田秀英', '14513147210', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=59', '校内的朋友多关照，好物一起分享～', 0, 0, '2026-07-01 22:57:50', '南昌大学前湖校区4栋20室');
INSERT INTO `sys_user` VALUES (60, '武詩涵', '17543818779', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=60', '爱生活，爱分享，闲置好物都在这里！', 0, 0, '2026-08-06 22:57:50', '南昌大学前湖校区5栋1室');
INSERT INTO `sys_user` VALUES (61, '史岚', '17049030582', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=61', '诚信交易，拒绝套路，欢迎随时来聊~', 0, 0, '2026-07-20 22:57:50', '南昌大学前湖校区6栋2室');
INSERT INTO `sys_user` VALUES (62, '赵致远', '13843093227', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=62', '大四老学长/学姐，毕业出闲置，价格绝对实惠！', 0, 0, '2026-07-09 22:57:50', '南昌大学前湖校区7栋3室');
INSERT INTO `sys_user` VALUES (63, '汪宇宁', '15665739800', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=63', '校内的朋友多关照，好物一起分享～', 0, 0, '2026-07-03 22:57:50', '南昌大学前湖校区8栋4室');
INSERT INTO `sys_user` VALUES (64, '武致远', '15520660973', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=64', '爱生活，爱分享，闲置好物都在这里！', 0, 0, '2026-07-07 22:57:50', '南昌大学前湖校区1栋5室');
INSERT INTO `sys_user` VALUES (65, '胡璐', '16880156182', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=65', '诚信交易，拒绝套路，欢迎随时来聊~', 0, 0, '2026-08-15 22:57:50', '南昌大学前湖校区2栋6室');
INSERT INTO `sys_user` VALUES (66, '吴安琪', '18126984592', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=66', '大四老学长/学姐，毕业出闲置，价格绝对实惠！', 0, 0, '2026-08-13 22:57:50', '南昌大学前湖校区3栋7室');
INSERT INTO `sys_user` VALUES (67, '史安琪', '14342191694', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=67', '校内的朋友多关照，好物一起分享～', 0, 0, '2026-07-12 22:57:50', '南昌大学前湖校区4栋8室');
INSERT INTO `sys_user` VALUES (68, '尹睿', '17641458790', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=68', '爱生活，爱分享，闲置好物都在这里！', 0, 0, '2026-08-07 22:57:50', '南昌大学前湖校区5栋9室');
INSERT INTO `sys_user` VALUES (69, '傅安琪', '13013099881', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=69', '诚信交易，拒绝套路，欢迎随时来聊~', 0, 0, '2026-06-23 22:57:50', '南昌大学前湖校区6栋10室');
INSERT INTO `sys_user` VALUES (70, '邹安琪', '15056282281', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=70', '大四老学长/学姐，毕业出闲置，价格绝对实惠！', 0, 0, '2026-08-18 22:57:50', '南昌大学前湖校区7栋11室');
INSERT INTO `sys_user` VALUES (71, '蒋岚', '15675903473', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=71', '校内的朋友多关照，好物一起分享～', 0, 0, '2026-07-16 22:57:50', '南昌大学前湖校区8栋12室');
INSERT INTO `sys_user` VALUES (72, '钱岚', '16649729732', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=72', '爱生活，爱分享，闲置好物都在这里！', 0, 0, '2026-08-09 22:57:50', '南昌大学前湖校区1栋13室');
INSERT INTO `sys_user` VALUES (73, '曾秀英', '17286206069', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=73', '诚信交易，拒绝套路，欢迎随时来聊~', 0, 0, '2026-06-19 22:57:50', '南昌大学前湖校区2栋14室');
INSERT INTO `sys_user` VALUES (74, '陈宇宁', '16920686661', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=74', '大四老学长/学姐，毕业出闲置，价格绝对实惠！', 0, 0, '2026-07-24 22:57:50', '南昌大学前湖校区3栋15室');
INSERT INTO `sys_user` VALUES (75, '郑子异', '18861142882', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=75', '校内的朋友多关照，好物一起分享～', 0, 0, '2026-06-23 22:57:50', '南昌大学前湖校区4栋16室');
INSERT INTO `sys_user` VALUES (76, '严震南', '16285748695', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=76', '爱生活，爱分享，闲置好物都在这里！', 0, 0, '2026-06-30 22:57:50', '南昌大学前湖校区5栋17室');
INSERT INTO `sys_user` VALUES (77, '谢安琪', '17665601473', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=77', '诚信交易，拒绝套路，欢迎随时来聊~', 0, 0, '2026-08-07 22:57:50', '南昌大学前湖校区6栋18室');
INSERT INTO `sys_user` VALUES (78, '叶云熙', '19621980293', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=78', '大四老学长/学姐，毕业出闲置，价格绝对实惠！', 0, 0, '2026-08-01 22:57:50', '南昌大学前湖校区7栋19室');
INSERT INTO `sys_user` VALUES (79, '沈安琪', '16962096987', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=79', '校内的朋友多关照，好物一起分享～', 0, 0, '2026-08-31 22:57:50', '南昌大学前湖校区8栋20室');
INSERT INTO `sys_user` VALUES (80, '江宇宁', '15751552063', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=80', '爱生活，爱分享，闲置好物都在这里！', 0, 0, '2026-08-22 22:57:50', '南昌大学前湖校区1栋1室');
INSERT INTO `sys_user` VALUES (81, '秦子异', '16619816764', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=81', '诚信交易，拒绝套路，欢迎随时来聊~', 0, 0, '2026-07-06 22:57:50', '南昌大学前湖校区2栋2室');
INSERT INTO `sys_user` VALUES (82, '贺宇宁', '13369425252', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=82', '大四老学长/学姐，毕业出闲置，价格绝对实惠！', 0, 0, '2026-09-08 22:57:50', '南昌大学前湖校区3栋3室');
INSERT INTO `sys_user` VALUES (83, '熊晓明', '14726373986', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=83', '校内的朋友多关照，好物一起分享～', 0, 0, '2026-06-22 22:57:50', '南昌大学前湖校区4栋4室');
INSERT INTO `sys_user` VALUES (84, '蒋岚', '17487957963', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=84', '爱生活，爱分享，闲置好物都在这里！', 0, 0, '2026-08-06 22:57:50', '南昌大学前湖校区5栋5室');
INSERT INTO `sys_user` VALUES (85, '张睿', '15829789219', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=85', '诚信交易，拒绝套路，欢迎随时来聊~', 0, 0, '2026-08-17 22:57:50', '南昌大学前湖校区6栋6室');
INSERT INTO `sys_user` VALUES (86, '邹杰宏', '16072145548', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=86', '大四老学长/学姐，毕业出闲置，价格绝对实惠！', 0, 0, '2026-08-26 22:57:50', '南昌大学前湖校区7栋7室');
INSERT INTO `sys_user` VALUES (87, '范晓明', '17173624811', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=87', '校内的朋友多关照，好物一起分享～', 0, 0, '2026-09-06 22:57:50', '南昌大学前湖校区8栋8室');
INSERT INTO `sys_user` VALUES (88, '雷嘉伦', '19996000462', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=88', '爱生活，爱分享，闲置好物都在这里！', 0, 0, '2026-07-10 22:57:50', '南昌大学前湖校区1栋9室');
INSERT INTO `sys_user` VALUES (89, '赵震南', '15468322682', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=89', '诚信交易，拒绝套路，欢迎随时来聊~', 0, 0, '2026-08-14 22:57:50', '南昌大学前湖校区2栋10室');
INSERT INTO `sys_user` VALUES (90, '邵致远', '16446899538', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=90', '大四老学长/学姐，毕业出闲置，价格绝对实惠！', 0, 0, '2026-08-01 22:57:50', '南昌大学前湖校区3栋11室');
INSERT INTO `sys_user` VALUES (91, '侯宇宁', '14297231981', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=91', '校内的朋友多关照，好物一起分享～', 0, 0, '2026-08-13 22:57:50', '南昌大学前湖校区4栋12室');
INSERT INTO `sys_user` VALUES (92, '程子异', '13722801991', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=92', '爱生活，爱分享，闲置好物都在这里！', 0, 0, '2026-08-20 22:57:50', '南昌大学前湖校区5栋13室');
INSERT INTO `sys_user` VALUES (93, '侯云熙', '18483735299', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=93', '诚信交易，拒绝套路，欢迎随时来聊~', 0, 0, '2026-08-22 22:57:50', '南昌大学前湖校区6栋14室');
INSERT INTO `sys_user` VALUES (94, '董睿', '13710944761', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=94', '大四老学长/学姐，毕业出闲置，价格绝对实惠！', 0, 0, '2026-08-11 22:57:50', '南昌大学前湖校区7栋15室');
INSERT INTO `sys_user` VALUES (95, '顾云熙', '14931232399', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=95', '校内的朋友多关照，好物一起分享～', 0, 0, '2026-09-05 22:57:50', '南昌大学前湖校区8栋16室');
INSERT INTO `sys_user` VALUES (96, '陈安琪', '15658725841', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=96', '爱生活，爱分享，闲置好物都在这里！', 0, 0, '2026-08-17 22:57:50', '南昌大学前湖校区1栋17室');
INSERT INTO `sys_user` VALUES (97, '蔡子韬', '14125682905', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=97', '诚信交易，拒绝套路，欢迎随时来聊~', 0, 0, '2026-08-25 22:57:50', '南昌大学前湖校区2栋18室');
INSERT INTO `sys_user` VALUES (98, '彭云熙', '17289331402', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=98', '大四老学长/学姐，毕业出闲置，价格绝对实惠！', 0, 0, '2026-09-06 22:57:50', '南昌大学前湖校区3栋19室');
INSERT INTO `sys_user` VALUES (99, '苏嘉伦', '19154706814', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=99', '校内的朋友多关照，好物一起分享～', 0, 0, '2026-07-08 22:57:50', '南昌大学前湖校区4栋20室');
INSERT INTO `sys_user` VALUES (100, '姜震南', '15143314208', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'https://api.dicebear.com/7.x/avataaars/svg?seed=100', '爱生活，爱分享，闲置好物都在这里！', 0, 0, '2026-08-03 22:57:50', '南昌大学前湖校区5栋1室');

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
