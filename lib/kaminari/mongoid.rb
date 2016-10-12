# frozen_string_literal: true
require 'kaminari/core'
require 'mongoid'
require 'kaminari/mongoid/mongoid_extension'
::Mongoid::Document.send :include, Kaminari::Mongoid::MongoidExtension::Document
