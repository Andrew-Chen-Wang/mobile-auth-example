package com.andrewcwang.jwtauth.ui.extensions

import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import com.andrewcwang.jwtauth.R

// NOTE for changing fragments: https://stackoverflow.com/a/55886771
// I've changed this since I only have one frame which is R.id.root_layout

fun AppCompatActivity.addFragment(fragment: Fragment){
    supportFragmentManager.doTransaction { add(R.id.root_layout, fragment) }
}


fun AppCompatActivity.replaceFragment(fragment: Fragment) {
    supportFragmentManager.doTransaction{ replace(R.id.root_layout, fragment) }
}

fun AppCompatActivity.removeFragment(fragment: Fragment) {
    supportFragmentManager.doTransaction{ remove(fragment) }
}