require 'codependent/container'
require 'codependent/injectable'
require 'codependent/injectable_builder'
require 'codependent/default_resolver'
require 'codependent/helper'

module Codependent
  def self.reset
    @scopes = {
      global: Container.new
    }
  end

  def self.scope?(scope_id)
    reset unless scopes

    scopes.key?(scope_id)
  end

  def self.scope(scope_id, &config_block)
    reset unless scopes

    return self[scope_id] if scope?(scope_id)

    scopes[scope_id] = Codependent::Container.new(&config_block)
  end

  def self.[](scope_id)
    reset unless scopes

    scopes.fetch(scope_id, nil)
  end

  def self.global
    scopes[:global]
  end

  def self.scopes
    @scopes
  end
end
