module DeletableAttachment
  extend ActiveSupport::Concern

  included do
    attachment_definitions.keys.each do |name|

      attr_accessor :"delete_#{name}"

      before_validation { send(name).clear if send("delete_#{name}") == '1' }

      define_method :"delete_#{name}=" do |value|
        instance_variable_set :"@delete_#{name}", value
        send("#{name}_file_name_will_change!")
      end
    end
  end
end
