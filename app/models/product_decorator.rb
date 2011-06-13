Product.class_eval do
    
    def has_property?( name )
        properties.any? { |p| p.name == name }
    end

    def is_donation?
        has_property?( 'is_donation' ) 
    end
    
end
