package com.campus.secondhand.category;

import com.campus.secondhand.common.ApiResponse;
import java.util.List;
import org.springframework.context.annotation.Profile;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Profile("mysql")
public class CategoryController {
    private final CategoryMapper categories;
    public CategoryController(CategoryMapper categories) { this.categories = categories; }

    @GetMapping("/api/categories")
    public ApiResponse<List<CategoryMapper.Category>> list() {
        return ApiResponse.success(categories.findAll());
    }
}
