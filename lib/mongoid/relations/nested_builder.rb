# encoding: utf-8
module Mongoid # :nodoc:
  module Relations #:nodoc:

    # This is the superclass for builders that are in charge of handling
    # creation, deletion, and updates of documents through that ever so lovely
    # #accepts_nested_attributes_for.
    class NestedBuilder
      attr_accessor :attributes, :existing, :metadata, :options

      # Determines if destroys are allowed for this document.
      #
      # @example Do we allow a destroy?
      #   builder.allow_destroy?
      #
      # @return [ true, false ] True if the allow destroy option was set.
      #
      # @since 2.0.0.rc.1
      def allow_destroy?
        options[:allow_destroy] || false
      end

      # Returns the reject if option defined with the macro.
      #
      # @example Is there a reject proc?
      #   builder.reject?
      #
      # @param [ Hash ] attrs The attributes to check for rejection.
      #
      # @return [ true, false ] True and call proc if rejectable, false if not.
      #
      # @since 2.0.0.rc.1
      def reject?(attrs)
        criteria = options[:reject_if]
        criteria ? criteria.call(attrs) : false
      end

      # Determines if only updates can occur. Only valid for one-to-one
      # relations.
      #
      # @example Is this update only?
      #   builder.update_only?
      #
      # @return [ true, false ] True if the update_only option was set.
      #
      # @since 2.0.0.rc.1
      def update_only?
        options[:update_only] || false
      end

      # Convert an id to its appropriate type.
      #
      # @todo Durran: Move this into a common reusable place.
      #
      # @example Convert the id.
      #   builder.convert_id("4d371b444835d98b8b000010")
      #
      # @param [ String ] id The id, usually coming from the form.
      #
      # @return [ BSON::ObjectId, String, Object ] The converted id.
      #
      # @since 2.0.0.rc.6
      def convert_id(id)
        return nil unless id
        model = metadata.klass
        model.using_object_ids? ? BSON::ObjectId.cast!(model, id) : id.class.set(id)
      end
    end
  end
end
