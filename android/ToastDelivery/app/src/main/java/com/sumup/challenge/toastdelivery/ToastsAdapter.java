package com.sumup.challenge.toastdelivery;

import android.content.Context;
import android.content.res.Resources;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.Currency;
import java.util.Locale;

public class ToastsAdapter extends RecyclerView.Adapter<ToastsAdapter.ViewHolder> {

    private final Context mContext;
    private final ToastItem[] mData;

    ToastsAdapter(Context context, ToastItem[] data) {
        mContext = context;
        mData = data;
    }

    @Override
    @NonNull
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.toast_item, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        ToastItem toastItem = mData[position];

        holder.name.setText(toastItem.getName());

        Locale locale = mContext.getResources().getConfiguration().locale;
        String currencySymbol = Currency.getInstance(locale).getSymbol();
        holder.price.setText(String.format("%s%s", currencySymbol, toastItem.getPrice()));

        int imageRes = getDrawableResWithName(mContext, toastItem.getImageName());
        if (imageRes != 0) {
            holder.image.setImageResource(imageRes);
        }
    }

    @Override
    public int getItemCount() {
        return mData.length;
    }


    public static class ViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        TextView name;
        TextView price;
        ImageView image;

        ViewHolder(View itemView) {
            super(itemView);
            name = itemView.findViewById(R.id.tv_toast_name);
            price = itemView.findViewById(R.id.tv_toast_price);
            image = itemView.findViewById(R.id.iv_toast);
        }

        @Override
        public void onClick(View view) {
            // TODO: add item to shopping cart
        }
    }

    private int getDrawableResWithName(Context context, String name) {
        Resources resources = context.getResources();
        return resources.getIdentifier(name, "drawable", context.getPackageName());
    }
}
