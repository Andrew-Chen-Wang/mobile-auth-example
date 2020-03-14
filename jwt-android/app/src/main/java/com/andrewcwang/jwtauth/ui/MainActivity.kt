package com.andrewcwang.jwtauth.ui

import android.accounts.Account
import android.accounts.AccountManager
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.andrewcwang.jwtauth.R
import com.andrewcwang.jwtauth.models.body.Login
import com.andrewcwang.jwtauth.models.response.BothTokens
import com.andrewcwang.jwtauth.networking.AuthService
import retrofit2.Response

class MainActivity : AppCompatActivity() {
    private val service = AuthService.create()
    var currentUser: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)  // App Logo or whatever
        val am: AccountManager = AccountManager.get(this)
        Toast.makeText(this@MainActivity, am.accounts.toString(), Toast.LENGTH_SHORT).show()
        if (savedInstanceState == null) {
            supportFragmentManager
                    .beginTransaction()
                    .add(R.id.root_layout, LoginFragment.newInstance(), "login")
                    .commit()
        }
        Log.v("MainActivity", "BEGIN")
    }

    /* This refreshes the access token for use
    * If the refresh token is expired, then use Keychain credentials
    * If that doesn't work, return false for unauthenticated response */
    suspend fun reAuthenticate(account: Account): Boolean {
        val am: AccountManager = AccountManager.get(this)
        val username = account.name
        val password = am.getPassword(account)
        val body = Login(username = username.toString(), password = password.toString())
        val postRequest = service.login(credentials = body)
        Log.v("Request", "request sent")
        if (postRequest.isSuccessful) {
            Log.v("Request", "HOPEFULLY")
            val (access, refresh) = postRequest.body()!!
            am.setAuthToken(account, "access", access)
            am.setAuthToken(account, "refresh", refresh)
            Log.v("Access", access)
            Log.v("Refresh", refresh)
            return true
        } else if (postRequest.code() == 401) {
            Toast.makeText(this@MainActivity, "Invalid username or password.", Toast.LENGTH_LONG).show()
        }
        Log.v("Ok", postRequest.code().toString())
        am.removeAccountExplicitly(account)
        return false
    }
}