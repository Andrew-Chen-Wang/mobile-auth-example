package com.andrewcwang.jwtauth.networking.auth

import okhttp3.*

/**
 * Authenticator that attempts to refresh the client's access token.
 * In the event that a refresh fails and a new token can't be issued an error
 * is delivered to the caller. This authenticator blocks all requests while a token
 * refresh is being performed. In-flight requests that fail with a 401 are
 * automatically retried.
 */
var grabbedNewTokens = false
lateinit var lastURL: HttpUrl

class AccessTokenAuthenticator(
        private val tokenProvider: AccessTokenProvider
) : Authenticator {
    // Only used if we get a status code 401, unauthorized.
    // Could happen if login failed or token expired.
    override fun authenticate(route: Route?, response: Response): Request? {
        synchronized(this) {
            // Check if the request made was previously made as an authenticated request.
            // The check is for just in case other request just changed the access token
            if (response.request.header("Authorization") == null) {
                // Basically logging in to get new tokens
                grabbedNewTokens = true
                return response.request
                        .newBuilder()
                        .addHeader("Authorization", "Bearer ${tokenProvider.newTokens()}")
                        .build()
            } else {
                // Uses new URL to build request
                if (grabbedNewTokens) {
                    grabbedNewTokens = false
                    return response.request
                            .newBuilder()
                            .url(lastURL)
                            .removeHeader("Authorization")
                            .addHeader("Authorization", "Bearer ${tokenProvider.token()}")
                            .build()
                }

                // Refresh the Access token.
                // Retry the request with the new token.
                lastURL = response.request.url
                return response.request
                        .newBuilder()
                        .removeHeader("Authorization")
                        .addHeader("Authorization", "Bearer ${tokenProvider.refreshToken()}")
                        .build()
            }
        }
    }
}