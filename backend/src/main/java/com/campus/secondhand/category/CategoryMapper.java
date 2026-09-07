package com.campus.secondhand.category;

import java.util.List;

public interface CategoryMapper {
    List<Category> findAll();
    record Category(String categoryId, String cateName, String cateDesc) { }
}
