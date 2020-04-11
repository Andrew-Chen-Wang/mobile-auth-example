package com.andrewcwang.jwtauth.ui

import android.accounts.Account
import android.accounts.AccountAuthenticatorResponse
import android.accounts.AccountManager
import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import com.andrewcwang.jwtauth.R
import kotlinx.coroutines.launch

class LoginFragment: Fragment() {
    private lateinit var root: View

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        root = inflater.inflate(R.layout.fragment_login, container, false)
        val loginButton = root.findViewById<Button>(R.id.login_button)
        loginButton.setOnClickListener {
            lifecycleScope.launch { login() }  // https://stackoverflow.com/a/57174689
        }
        return root
    }

    companion object {
        fun newInstance(): LoginFragment {
            return LoginFragment()
        }
    }

    private suspend fun login() {
        val username = root.findViewById<EditText>(R.id.login_username)
        val password = root.findViewById<EditText>(R.id.login_password)
        val am: AccountManager = AccountManager.get(view?.context)
        val account = Account(username.text.toString(), "com.andrewcwang.jwtauth")
        am.addAccountExplicitly(account, password.text.toString(), Bundle())
        // Store the keys from authentication authentication
        (activity as MainActivity).reAuthenticate(account)
    }
}