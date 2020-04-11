package com.andrewcwang.jwtauth.ui

import android.accounts.Account
import android.accounts.AccountManager
import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.andrewcwang.jwtauth.R
import com.andrewcwang.jwtauth.models.body.Login
import com.andrewcwang.jwtauth.networking.AuthService
import com.andrewcwang.jwtauth.networking.auth.AuthManager
import com.andrewcwang.jwtauth.ui.extensions.addFragment
import com.andrewcwang.jwtauth.ui.extensions.replaceFragment

class MainActivity : AppCompatActivity() {
    private lateinit var service: AuthService
    lateinit var authManager: AuthManager
    var currentUser: Account? = null
    private lateinit var am: AccountManager

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)  // App Logo or whatever
        am = AccountManager.get(this)
        authManager = AuthManager.getInstance(applicationContext)
        service = AuthService.create(authManager)
        if (savedInstanceState == null) {
            addFragment(LoginFragment.newInstance())
        }
    }

    // Network Requests

    /**
     * Authenticates user from LoginFragment
     */
    suspend fun reAuthenticate(account: Account) {
        val username = account.name
        val password = am.getPassword(account)
        val body = Login(username = username.toString(), password = password.toString())
        val postRequest = service.login(credentials = body)
        when {
            postRequest.isSuccessful -> {
                val (access, refresh) = postRequest.body()!!
                currentUser = account
                authManager.currentAccount = account
                authManager.accessToken = access
                authManager.refreshToken = refresh
                replaceFragment(PingFragment.newInstance())
            }
            postRequest.code() == 401 -> {
                Toast.makeText(this@MainActivity, "Invalid username or password.", Toast.LENGTH_LONG).show()
                am.removeAccountExplicitly(account)
            }
            else -> {
                handleRequest(postRequest.code())
            }
        }
    }

    /**
     * Pings the server at the ping endpoint. Returns the ping number.
     */
    suspend fun ping(number: Int): Int {
        val postRequest = service.ping(number)
        return if (postRequest.isSuccessful) {
            val pingNum = postRequest.body()!!
            pingNum.id
        } else {
            handleRequest(postRequest.code())
            0
        }
    }

    // Handle Other Request Codes
    private fun handleRequest(code: Int) {
        when (code) {
            401 -> { // Used outside of the Login fragment
                replaceFragment(LoginFragment.newInstance())
                am.removeAccountExplicitly(currentUser)
                Toast.makeText(this@MainActivity, "Your password may have changed! Re-authenticate to check or change your password.", Toast.LENGTH_LONG).show()
            }
            403 -> {
                Toast.makeText(this@MainActivity, "You do not have permission to view this page.", Toast.LENGTH_SHORT).show()
            }
            in 400..499 -> {
                Toast.makeText(this@MainActivity, "Something wrong happened...", Toast.LENGTH_SHORT).show()
            }
            in 500..599 -> {
                Toast.makeText(this@MainActivity, "Uh oh, there's a server error.", Toast.LENGTH_LONG).show()
            }
        }
    }
}