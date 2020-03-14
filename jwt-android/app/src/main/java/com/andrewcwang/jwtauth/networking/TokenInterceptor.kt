package com.andrewcwang.jwtauth.networking

import android.accounts.Account
import android.accounts.AccountManager
import android.annotation.SuppressLint
import android.content.Context
import android.os.Bundle
import com.andrewcwang.jwtauth.models.body.Login
import com.andrewcwang.jwtauth.models.body.RefreshToken
import okhttp3.Interceptor
import okhttp3.Request
import okhttp3.Response
import java.io.IOException

internal class TokenInterceptor(
        private val context: Context
) : Interceptor {
    // Remember, both and access use post requests to get tokens
    private val unauthenticatedURLs: List<String> = listOf("access", "both", "register")

    @SuppressLint("DefaultLocale")
    @Throws(IOException::class)
    override fun intercept(chain: Interceptor.Chain): Response {
        val request: Request = chain.request()
        val am = AccountManager.get(context)
        val newRequest: Request = if (request.url.pathSegments.last() in unauthenticatedURLs || am.accounts.isEmpty()) {
            request.newBuilder()
                    .addHeader("Content-Type", "application/json")
                    .build()
        } else {
            request.newBuilder()
                    .addHeader("Content-Type", "application/json")
                    .addHeader("Authorization", "Bearer " + "")
                    .build()
        }
        val response: Response = chain.proceed(newRequest)
        // We check if we need to get new access, new refresh, or invalid altogether
        if (response.code == 401) {
            val authTypeURL = request.url.encodedPathSegments.last()
            val service = AuthService.create(context)  // singleton
            // If not account, simply return response since we're in LoginFragment
            if (am.accounts.isEmpty()) {
                // No account or...
                // All failed, need to return to LoginFragment
            } else {
                val account = am.accounts[am.accounts.size - 1]
                when (authTypeURL) {
                    unauthenticatedURLs[0] -> {
                        val refresh = am.getAuthToken(
                                account,
                                "refresh",
                                null,
                                false,
                                null,
                                null
                        )
                        suspend { service.access(access = RefreshToken(refresh = refresh.toString())) }
                    }
                    unauthenticatedURLs[1] -> {
                        suspend { service.login(
                                credentials = Login(
                                        username = account.name,
                                        password = am.getPassword(account)))
                        }
                    }
                }
            }
        }
        return response
    }
}