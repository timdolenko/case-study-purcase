package com.sumup.challenge.toastdelivery.checkout

import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.Headers
import retrofit2.http.POST

interface CheckoutApi {
    @Headers("Content-Type: application/json")
    @POST("checkouts")
    fun createCheckout(@Body body: CheckoutRequest): Call<CheckoutResponse>
}
