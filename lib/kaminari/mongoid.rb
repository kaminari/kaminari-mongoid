require 'kaminari'
require 'mongoid'
require 'kaminari/models/mongoid_extension'
::Mongoid::Document.send :include, Kaminari::MongoidExtension::Document
