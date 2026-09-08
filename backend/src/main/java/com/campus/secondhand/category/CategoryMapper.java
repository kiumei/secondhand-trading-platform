package com.campus.secondhand.category;

import java.util.List;

public interface CategoryMapper {
    List<Category> findAll();

    /** 两级分类：parent_id=0 表示一级分类；数据库 category(cate_id, cate_name, parent_id, sort)。 */
    record Category(String cateId, String cateName, Integer parentId, Integer sort) { }
}
