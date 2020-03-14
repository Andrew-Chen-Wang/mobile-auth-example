package com.andrewcwang.jwtauth.networking

import android.content.Context
import com.andrewcwang.jwtauth.models.body.Login
import com.andrewcwang.jwtauth.models.body.RefreshToken
import com.andrewcwang.jwtauth.models.response.AccessToken
import com.andrewcwang.jwtauth.models.response.BothTokens
import com.andrewcwang.jwtauth.models.response.Ping
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory
import retrofit2.Response
import retrofit2.http.*
import java.io.IOException

interface AuthService {
    // Error handling
    /** A callback which offers granular callbacks for various conditions.  */
    interface MyCallback<T> {
        /** Called for [200, 300) responses.  */
        fun success(response: Response<T>)
        /** Called for 401 responses.  */
        fun unauthenticated(response: Response<*>?)
        /** Called for [400, 500) responses, except 401.  */
        fun clientError(response: Response<*>?)
        /** Called for [500, 600) response.  */
        fun serverError(response: Response<*>?)
        /** Called for network errors while making the call.  */
        fun networkError(e: IOException)
        /** Called for unexpected errors while making the call.  */
        fun unexpectedError(t: Throwable)
    }

    // GET Requests

    @GET("ping/")
    suspend fun ping(
            @Query("id") id : Int
    ) : Response<Ping>

    // POST Requests

    @POST("api/token/access/")
    suspend fun access(
            @Body access: RefreshToken
    ) : Response<AccessToken>

    @POST("api/token/both/")
    suspend fun login(
            @Body credentials: Login
    ) : Response<BothTokens>

    // This is apparently a singleton in Kotlin
    companion object {
        fun create(context: Context): AuthService {
            val baseUrl = "http://192.168.0.8:8000/"

            // Extra Logging - Warning: Will erase your HeaderInterceptor which is NOT good
            val loggingInterceptor = HttpLoggingInterceptor().apply {
                level = HttpLoggingInterceptor.Level.BODY
            }
            val client = OkHttpClient().newBuilder()
                    .addInterceptor(loggingInterceptor)
                    .addInterceptor(HeaderInterceptor())
                    .addInterceptor(TokenInterceptor(context))
                    .build()

            // Create the service
            val retrofit = Retrofit.Builder()
                    .client(client)
                    .addConverterFactory(MoshiConverterFactory.create())
                    .baseUrl(baseUrl)
                    .build()
            return retrofit.create(AuthService::class.java)
        }
    }
}