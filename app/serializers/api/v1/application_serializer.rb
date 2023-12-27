module API
  module V1
    class ApplicationSerializer
      include JSONAPI::Serializer

      # This method overrides the default jsonapi.rb method
      # It allows us to add defaut options for serializer relationships
      def self.create_relationship(base_key, relationship_type, options, block)
        add_default_relationships_options!(base_key, relationship_type, options)
        super(base_key, relationship_type, options, block)
      end

      # This method defines the default options for serializer relationships
      # It avoid loading the relationship if it is not already included & cached in the object to serialize
      def self.add_default_relationships_options!(relationship_name, _relationship_type, options)
        options.reverse_merge!(
          lazy_load_data: ->(record, _serialization_params) {
            !record.association_cached?(relationship_name)
          },
          meta: ->(record, _serialization_params) {
            if !record.association_cached?(relationship_name)
              {
                info: "relationship `#{relationship_name}` is lazy_loaded," \
                  " use the `include` param to see relationship's datas",
              }
            else
              {}
            end
          }
        )
      end

      # This methods allows us to keep track of the sparse fields
      # See `sparse_attribute' for more information
      def self.sparse_attributes_to_serialize
        @sparse_attributes_to_serialize ||= []
      end

      # This method injects all attributes and all associations from a model into the serializer
      def self.trusted_serializer(model:, include_all_attributes:, include_all_associations:)
        attributes(*(model.column_names - %w[id])) if include_all_attributes

        if include_all_associations
          model.reflect_on_all_associations(:has_many).each do |association|
            has_many(association.name) do |object|
              associated = object.send(association.name)
              associated
            end
          end

          model.reflect_on_all_associations(:belongs_to).each do |association|
            belongs_to(association.name) do |object|
              object.send(:association_instance_set, association.name, nil)
              association.klass.unscoped { object.send(association.name) }
            end
          end

          model.reflect_on_all_associations(:has_one).each do |association|
            belongs_to(association.name) do |object|
              object.send(:association_instance_set, association.name, nil)
              association.klass.unscoped { object.send(association.name) }
            end
          end
        end
      end
    end
  end
end
