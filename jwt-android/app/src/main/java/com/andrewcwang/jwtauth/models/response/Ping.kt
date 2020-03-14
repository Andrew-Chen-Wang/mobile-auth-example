package com.andrewcwang.jwtauth.models.response

import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class Ping(
        val id: Int
)