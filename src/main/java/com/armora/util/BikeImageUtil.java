package com.armora.util;

import com.armora.model.Bike;

import java.util.HashMap;
import java.util.Map;

public class BikeImageUtil {

    private static final String DEFAULT_IMAGE =
            "https://images.unsplash.com/photo-1558981403-c5f9899a28bc?auto=format&fit=crop&w=1200&q=80";

    private static final Map<String, String> IMAGES = new HashMap<>();

    static {
        IMAGES.put("BMW S1000RR",
                "https://images.unsplash.com/photo-1558981403-c5f97dbbe6ad?auto=format&fit=crop&w=1200&q=80");
        IMAGES.put("Ducati Panigale V4",
                "https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?auto=format&fit=crop&w=1200&q=80");
        IMAGES.put("Aprillia RSv4",
                "https://images.unsplash.com/photo-1591637333184-19aa84b3e01f?auto=format&fit=crop&w=1200&q=80");
        IMAGES.put("Kawasaki Ninja ZX10R",
                "https://images.unsplash.com/photo-1614165939020-f71f168bd2fe?auto=format&fit=crop&w=1200&q=80");
        IMAGES.put("Yamaha R1M",
                "https://images.unsplash.com/photo-1547480579-373950f58097?auto=format&fit=crop&w=1200&q=80");
        IMAGES.put("Honda Fireblade 1000RR",
                "https://images.unsplash.com/photo-1599819811279-d5ad9cccf838?auto=format&fit=crop&w=1200&q=80");
    }

    public static String getImageUrl(Bike bike) {
        if (bike == null) {
            return DEFAULT_IMAGE;
        }
        if (bike.getImageUrl() != null && !bike.getImageUrl().isBlank()) {
            return bike.getImageUrl();
        }
        return IMAGES.getOrDefault(bike.getTitle(), DEFAULT_IMAGE);
    }

    public static String formatPricePerHour(java.math.BigDecimal price) {
        if (price == null) {
            return "Rs 0";
        }
        long amount = price.longValue();
        if (amount % 1000 == 0 && amount >= 1000) {
            return "Rs " + (amount / 1000) + "K";
        }
        return "Rs " + amount;
    }
}
