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
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class PingFragment: Fragment() {
    private lateinit var root: View

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        lifecycleScope.launch { ping(1) }
        root = inflater.inflate(R.layout.fragment_ping, container, false)
        return root
    }

    companion object {
        fun newInstance(): PingFragment {
            return PingFragment()
        }
    }

    private suspend fun ping(number: Int) {
        val respondingNum = (activity as MainActivity).ping(number)
        if (respondingNum != 0) {
            val textView = root.findViewById<TextView>(R.id.ping_view)
            textView.text = respondingNum.toString()
            delay(1000)
            ping(number + 1)
        }
    }
}