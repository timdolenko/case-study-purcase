package com.sumup.challenge.toastdelivery.checkout

import com.google.gson.annotations.SerializedName
import java.math.BigDecimal

data class CheckoutRequest(
    @SerializedName("checkout_reference") val reference: String,
    @SerializedName("amount") val amount: BigDecimal,
    @SerializedName("currency") val currencyCode: String,
    @SerializedName("merchant_code") val merchantCode: String,
)
