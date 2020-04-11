package com.andrewcwang.jwtauth.networking.auth

import okhttp3.Authenticator
import okhttp3.Request
import okhttp3.Response
import okhttp3.Route

/**
 * Authenticator that attempts to refresh the client's access token.
 * In the event that a refresh fails and a new token can't be issued an error
 * is delivered to the caller. This authenticator blocks all requests while a token
 * refresh is being performed. In-flight requests that fail with a 401 are
 * automatically retried.
 */
class AccessTokenAuthenticator(
        private val tokenProvider: AccessTokenProvider
) : Authenticator {

    // Only used if we get a status code 401, unauthorized.
    // Could happen if login failed or token expired.
    override fun authenticate(route: Route?, response: Response): Request? {
        // We need to have a token in order to refresh it.
        val token = tokenProvider.token() ?: return null

        synchronized(this) {
            val newToken = tokenProvider.token()

            // Check if the request made was previously made as an authenticated request.
            // Check is for just in case other request just changed the access token
            if (response.request.header("Authorization") == null) {
                // Basically logging in to get new tokens
                val newAccessToken = tokenProvider.newTokens()
                return response.request
                        .newBuilder()
                        .removeHeader("Authorization")
                        .addHeader("Authorization", "Bearer $newAccessToken")
                        .build()
            } else {

                // If the token has changed since the request was made, use the new token.
                if (newToken != token) {
                    return response.request
                            .newBuilder()
                            .removeHeader("Authorization")
                            .addHeader("Authorization", "Bearer $newToken")
                            .build()
                }

                val updatedAccessToken = tokenProvider.refreshToken() ?: return null

                // Retry the request with the new token.
                return response.request
                        .newBuilder()
                        .removeHeader("Authorization")
                        .addHeader("Authorization", "Bearer $updatedAccessToken")
                        .build()
            }
        }
//        return null
    }
}