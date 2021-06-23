package com.sumup.challenge.toastdelivery.login

import android.util.Log
import com.sumup.challenge.toastdelivery.checkout.CheckoutResponse
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

class LoginController {
    companion object {
        private const val GRANT_TYPE = "client_credentials"

        // TODO: get the client credentials for your app here (we already registered it for you): https://me.sumup.com/developers
        private const val CLIENT_ID = ""
        private const val CLIENT_SECRET = ""
    }

    fun doLogin(callback: LoginCallback) {
        val loginApi = getLoginApi()
        val call = loginApi.getToken(GRANT_TYPE, CLIENT_ID, CLIENT_SECRET)
        call.enqueue(object : Callback<TokenResponse> {
            override fun onResponse(
                call: Call<TokenResponse>,
                response: Response<TokenResponse>
            ) {
                if (response.isSuccessful && response.body() != null) {
                    val accessToken = response.body()?.accessToken
                    Log.d("Login", "accessToken=$accessToken")
                    callback.onSuccess(response.body())
                } else {
                    Log.d("Login", "Token request unsuccessful")
                    callback.onError()
                }
            }

            override fun onFailure(call: Call<TokenResponse>, t: Throwable) {
                Log.d("Login", "Failed to get token")
                callback.onError()
            }

        })
    }

    private fun getLoginApi(): LoginApi {
        val loggingInterceptor = HttpLoggingInterceptor().apply {
            level = HttpLoggingInterceptor.Level.BASIC
        }

        val okHttpClient = OkHttpClient().newBuilder()
            .addInterceptor(loggingInterceptor)
            .build()

        return Retrofit.Builder()
            .addConverterFactory(GsonConverterFactory.create())
            .baseUrl("https://api.sumup.com/")
            .client(okHttpClient)
            .build()
            .create(LoginApi::class.java)
    }

    interface LoginCallback {
        fun onSuccess(response: TokenResponse?)
        fun onError()
    }
}
