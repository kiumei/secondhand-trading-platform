package com.campus.secondhand.user;

/** Public seller profile excludes phone, password and authorization fields. */
public record PublicUserView(String userId, String userName, String avatar, String intro) { }
