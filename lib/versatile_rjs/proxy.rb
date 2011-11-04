
module VersatileRJS
  class Proxy
    attr_reader :page, :statement, :container
    attr_accessor :index, :container
    private :page, :statement, :container, :index

    def initialize(page, statement)
      @page = page
      @statement = statement
    end

    def call(method, *arguments)
      method = method.to_s.camelcase
      statement =
        if method =~ /(.*)=$/
          "#{self.statement}.#{$1} = #{arguments.first.to_json}"
        else
          "#{self.statement}.#{method}(#{arguments.map(&:to_json).join(', ')})"
        end
      ActiveSupport::JSON::Variable.new statement
    end

    def to_json
      ActiveSupport::JSON::Variable.new(statement)
    end

    alias_method :to_s, :to_json
  end
end

require 'versatile_rjs/proxy/element_proxy'
require 'versatile_rjs/proxy/element_by_id_proxy'
require 'versatile_rjs/proxy/element_set_proxy'
require 'versatile_rjs/proxy/selector_proxy'
require 'versatile_rjs/proxy/framework_dependent'
require 'versatile_rjs/proxy/selectable'
require 'versatile_rjs/proxy/each_proxy'
