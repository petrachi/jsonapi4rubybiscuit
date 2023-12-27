module Rectify
  class Form
    class << self
      attr_accessor :attributes_to_serialize, :relationships_to_serialize
      alias original_attribute attribute
    end

    def self.inherited(subclass)
      super

      subclass.attributes_to_serialize = attributes_to_serialize.deep_dup
      subclass.relationships_to_serialize = relationships_to_serialize.deep_dup
    end

    # This methods add `belongs_to` keyword to easily define a relationship in forms
    def self.belongs_to(association_name, optional: false)
      self.relationships_to_serialize ||= {}
      self.relationships_to_serialize[association_name] = nil

      original_attribute :"#{association_name}_id", Integer
      define_method association_name do
        model_name.name.constantize
          .new("#{association_name}_id" => send("#{association_name}_id"))
          .send(association_name)
      end

      unless optional
        validate do
          errors.add(association_name, :required) if send(association_name).blank?
        end
      end
    end

    # This methods add `has_many` keyword to easily define a relationship in forms
    def self.has_many(association_name)
      self.relationships_to_serialize ||= {}
      self.relationships_to_serialize[association_name] = nil

      original_attribute :"#{association_name.to_s.singularize}_ids", Array[Integer]
      define_method association_name do
        model_name.name.constantize
          .reflect_on_all_associations
          .find { |association| association.name.to_s == association_name.to_s }
          .klass
          .where(id: send("#{association_name.to_s.singularize}_ids"))
      end
    end

    # This methods add `has_one` keyword to easily define a relationship in forms
    def self.has_one(association_name) # rubocop:disable Naming/PredicateName
      self.relationships_to_serialize ||= {}
      self.relationships_to_serialize[association_name] = nil

      original_attribute :"#{association_name.to_s.singularize}_id", Array[Integer]
      define_method association_name do
        model_name.name.constantize
          .reflect_on_all_associations
          .find { |association| association.name.to_s == association_name.to_s }
          .klass
          .where(id: send("#{association_name.to_s.singularize}_id"))
      end
    end

    # We override the `attribute` method to add the attribute in the `attributes_to_serialize`
    # This allows for the jsonapi_errors renderer to correctly process the `source` of the error
    def self.attribute(attribute_name, *args, &block)
      self.attributes_to_serialize ||= {}
      self.attributes_to_serialize[attribute_name] = nil

      original_attribute(attribute_name, *args, &block)
    end
  end
end
