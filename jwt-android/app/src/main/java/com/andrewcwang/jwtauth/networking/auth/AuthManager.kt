package com.andrewcwang.jwtauth.networking.auth

import android.accounts.Account
import android.accounts.AccountManager
import android.content.Context
import com.andrewcwang.jwtauth.models.body.Login
import com.andrewcwang.jwtauth.models.body.RefreshToken
import com.andrewcwang.jwtauth.networking.AuthService
import kotlinx.coroutines.async
import kotlinx.coroutines.runBlocking

class AuthManager private constructor(context: Context): AccessTokenProvider {
    private var service = AuthService.create(this)

    companion object : SingletonHolder<AuthManager, Context>(::AuthManager)

    var accessToken: String? = null
    var refreshToken: String? = null
    private var accountManager = AccountManager.get(context)
    var currentAccount: Account? = null

    // TODO Use AccountManagerCallback instead? https://developer.android.com/training/id-auth/authenticate
    override fun token(): String? {
        return accessToken
    }

    override fun refreshToken(): String? {
        var newToken: String? = null
        runBlocking {
            val body = RefreshToken(refresh = refreshToken!!)
            val postRequest = async { service.access(access = body) }
            val req = postRequest.await()
            if (req.isSuccessful) {
                accessToken = req.body()!!.access
                newToken = accessToken
            }
        }
        return newToken
    }

    override fun newTokens(): String? {
        var newToken: String? = null
        runBlocking {
            val body = Login(
                    username = currentAccount?.name!!,
                    password = accountManager.getPassword(currentAccount!!)
            )
            val postRequest = async { service.login(credentials = body) }
            val req = postRequest.await()
            if (req.isSuccessful) {
                val (access, refresh) = req.body()!!
                accessToken = access
                refreshToken = refresh
                newToken = access
            } else if (req.code() == 401) {
                accessToken = null
                refreshToken = null
                currentAccount = null
                accountManager.removeAccountExplicitly(currentAccount)
            }
        }
        return newToken
    }
}