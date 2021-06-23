package com.sumup.challenge.toastdelivery.checkout;

import android.util.Log;

import org.jetbrains.annotations.NotNull;

import java.math.BigDecimal;

import okhttp3.OkHttpClient;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class SumUpCheckoutService {

    private static final String BASE_URL = "https://api.sumup.com/v0.1/";
    // TODO: provide a merchant code
    private static final String MERCHANT_CODE = "";

    private final CheckoutApi checkoutApi;

    public SumUpCheckoutService(CheckoutApi checkoutApi) {
        this.checkoutApi = checkoutApi;
    }

    // The currency code passed here must match the currency of your account's country
    public void createTransaction(
            String checkoutReference,
            BigDecimal amount,
            String currency,
            ResponseCallback callback) {
        CheckoutRequest checkoutRequest = new CheckoutRequest(checkoutReference, amount, currency, MERCHANT_CODE);
        Call<CheckoutResponse> result = checkoutApi.createCheckout(checkoutRequest);
        result.enqueue(new Callback<CheckoutResponse>() {
            @Override
            public void onResponse(@NotNull Call<CheckoutResponse> call, @NotNull Response<CheckoutResponse> response) {
                if (response.isSuccessful() && response.body() != null) {
                    Log.d("Checkout", "Successfully created checkout");
                    callback.onSuccess(response.body());
                } else {
                    Log.d("Checkout", "Error creating checkout");
                    callback.onError();
                }
            }

            @Override
            public void onFailure(@NotNull Call<CheckoutResponse> call, @NotNull Throwable t) {
                Log.d("Checkout", "Failed to create checkout: " + t.getMessage());
                callback.onError();
            }
        });
    }

    public CheckoutApi getCheckoutApi() {
        HttpLoggingInterceptor loggingInterceptor = new HttpLoggingInterceptor();
        loggingInterceptor.setLevel(HttpLoggingInterceptor.Level.BASIC);

        OkHttpClient okHttpClient = new OkHttpClient().newBuilder()
                .addInterceptor(loggingInterceptor)
                .build();

        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(BASE_URL)
                .client(okHttpClient)
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        return retrofit.create(CheckoutApi.class);
    }

    public interface ResponseCallback {
        void onSuccess(CheckoutResponse response);

        void onError();
    }
}
