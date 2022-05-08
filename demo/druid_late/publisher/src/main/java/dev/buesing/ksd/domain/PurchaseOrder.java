package dev.buesing.ksd.domain;

import com.fasterxml.jackson.annotation.JsonTypeInfo;
import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

@JsonTypeInfo(use = JsonTypeInfo.Id.CLASS, property = "$type")
public class PurchaseOrder {

    public static class LineItem {
        private String sku;
        private int quantity;
        private BigDecimal price;

        public String getSku() {
            return sku;
        }

        public void setSku(String sku) {
            this.sku = sku;
        }

        public int getQuantity() {
            return quantity;
        }

        public void setQuantity(int quantity) {
            this.quantity = quantity;
        }

        public BigDecimal getPrice() {
            return price;
        }

        public void setPrice(BigDecimal price) {
            this.price = price;
        }

        @Override
        public String toString() {
            return "{sku='" + sku + '\'' + ", quantity=" + quantity + ", price=" + price + '}';
        }
    }

    private Instant timestamp;
    private String orderId;
    private String userId;
    private String storeId;
    private List<LineItem> items;


    public Instant getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Instant timestamp) {
        this.timestamp = timestamp;
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getStoreId() {
        return storeId;
    }

    public void setStoreId(String storeId) {
        this.storeId = storeId;
    }

    public List<LineItem> getItems() {
        return items;
    }

    public void setItems(List<LineItem> items) {
        this.items = items;
    }

    @Override
    public String toString() {
        return "PurchaseOrder{" +
                "timestamp=" + timestamp +
                ", orderId='" + orderId + '\'' +
                ", userId='" + userId + '\'' +
                ", storeId='" + storeId + '\'' +
                ", items=" + items +
                '}';
    }
}
