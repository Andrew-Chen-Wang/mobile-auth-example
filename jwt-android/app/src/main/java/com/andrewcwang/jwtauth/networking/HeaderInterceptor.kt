package com.andrewcwang.jwtauth.networking

import android.annotation.SuppressLint
import com.andrewcwang.jwtauth.BuildConfig.DEBUG
import com.andrewcwang.jwtauth.networking.auth.AuthManager
import okhttp3.Interceptor
import okhttp3.Request
import okhttp3.Response
import okhttp3.internal.http2.Http2Reader
import java.io.IOException

internal class HeaderInterceptor(
        private val authManager: AuthManager
) : Interceptor {
    // Remember, both and access use post requests to get tokens
    private val unauthenticatedURLs: List<String> = listOf("both", "access", "register")

    @SuppressLint("DefaultLocale")
    @Throws(IOException::class)
    override fun intercept(chain: Interceptor.Chain): Response {
        val request: Request = chain.request()
        // Because Kotlin's so fun, size means index.max, not len()
        // I didn't bother writing any throw due to the size thing since
        // pathSegments is always at least size 2 with api/ as the first
        // index and a blank being the last.
        val newRequest: Request = if (request.url.pathSegments[request.url.pathSegments.size - 2] in unauthenticatedURLs) {
            request.newBuilder()
                    .addHeader("Content-Type", "application/json")
                    .build()
        } else {
            request.newBuilder()
                    .addHeader("Content-Type", "application/json")
                    .addHeader("Authorization", "Bearer ${authManager.accessToken}")
                    .build()
        }

        return if (DEBUG) {
            val t1 = System.nanoTime()
            Http2Reader.logger.info(java.lang.String.format("Sending request %s on %s%n%s",
                    newRequest.url, chain.connection(), newRequest.headers))
            val response: Response = chain.proceed(newRequest)
            val t2 = System.nanoTime()
            Http2Reader.logger.info(java.lang.String.format("Received response for %s in %.1fms%n%s",
                    response.request.url, (t2 - t1) / 1e6, response.headers))
            response
        } else {
            val response: Response = chain.proceed(newRequest)
            response
        }
    }
}