package com.sumup.challenge.toastdelivery

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.sumup.challenge.toastdelivery.util.getJsonDataFromAsset

// TODO: create a checkout with shopping cart item
class ShopActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_shop)

        setUpRecyclerView()
    }

    private fun setUpRecyclerView() {
        val recyclerView = findViewById<RecyclerView>(R.id.recycler_view)
        recyclerView.layoutManager = GridLayoutManager(this, 2)
        recyclerView.addItemDecoration(
            SpacesItemDecoration(20)
        )
        recyclerView.adapter = ToastsAdapter(this, getToasts().toTypedArray())
    }

    private fun getToasts(): List<ToastItem> {
        val toastsJson = getJsonDataFromAsset(this, "toasts.json")
        return Gson().fromJson(toastsJson, object : TypeToken<List<ToastItem>>() {}.type)
    }
}
