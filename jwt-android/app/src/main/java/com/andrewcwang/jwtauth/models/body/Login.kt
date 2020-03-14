package com.andrewcwang.jwtauth.models.body

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class Login(
        @Json(name = "username") val username: String,
        @Json(name = "password") val password: String
)