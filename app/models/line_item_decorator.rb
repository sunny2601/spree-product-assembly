LineItem.class_eval do
  def validate
    unless quantity && quantity >= 0
      errors.add(:quantity, I18n.t("validation.must_be_non_negative"))
    end
    # avoid reload of order.inventory_units by using direct lookup
    unless !Spree::Config[:track_inventory_levels]                        ||
           Spree::Config[:allow_backorders]                               ||
           order   && InventoryUnit.order_id_equals(order).first.present? ||
           variant && quantity <= variant.on_hand
      errors.add(:quantity, I18n.t("validation.is_too_large") + " (#{self.variant.name})")
    end

    return unless variant
    
=begin # Commented out until Order#shipped_units not restored in the Core
    if variant.product.assembly?
      variant.product.parts.each do |part|
        if shipped_count = order.shipped_units.nil? ? nil : order.shipped_units[part]
          errors.add(:quantity, I18n.t("validation.cannot_be_less_than_shipped_units") ) if quantity < shipped_count
        end
      end
    else
      if shipped_count = order.shipped_units.nil? ? nil : order.shipped_units[variant]
        errors.add(:quantity, I18n.t("validation.cannot_be_less_than_shipped_units") ) if quantity < shipped_count
      end
    end
=end
    
  end

end
