package com.andrewcwang.jwtauth.ui

import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import com.andrewcwang.jwtauth.R
import kotlinx.coroutines.launch

class PingFragment: Fragment() {
    private lateinit var root: View

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        lifecycleScope.launch { ping() }
        return inflater.inflate(R.layout.fragment_login, container, false)
    }

    companion object {
        fun newInstance(): PingFragment {
            return PingFragment()
        }
    }

    private suspend fun ping() {
        val textView = root.findViewById<TextView>(R.id.ping_view)
        ping()
    }
}