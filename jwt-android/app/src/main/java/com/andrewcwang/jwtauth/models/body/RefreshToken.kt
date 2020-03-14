package com.andrewcwang.jwtauth.models.body

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class RefreshToken(
        @Json(name = "refresh") val refresh: String
)