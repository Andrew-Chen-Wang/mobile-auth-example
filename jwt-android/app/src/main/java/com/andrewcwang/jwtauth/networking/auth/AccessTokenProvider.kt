package com.andrewcwang.jwtauth.networking.auth

/**
 * Provides an access token for request authorization.
 * https://blog.coinbase.com/okhttp-oauth-token-refreshes-b598f55dd3b2
 * I've changed the interface a little bit to suit our header interceptor needs,
 * since I think the article only dealt with access token refresh instead of
 * both access and refresh token which is typically in OAuth2 +/or JWT token auth.
 */
interface AccessTokenProvider {

    /**
     * Returns current access token. In the event that you don't have a token return null.
     * After return null, the authenticator performs refreshToken() by getting
     * a new refresh token and returns the new access token.
     */
    fun token(): String?

    /**
     * Refreshes the token and returns it. This call should be made synchronously.
     * In the event that the token could not be refreshed return null.
     * If that returns null, then call newTokens() which returns new access token.
     */
    fun refreshToken(): String?

    /**
     * Both the access token and refresh token failed. Now, we need to get
     * both the access and refresh token. Return the new access token.
     * If this fails, show the LoginFragment with some kind of message saying
     * password changed or network failed.
     */
    fun newTokens(): String?
}