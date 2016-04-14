require 'kaminari'
require 'mongoid'
require 'kaminari/mongoid/mongoid_extension'
::Mongoid::Document.send :include, Kaminari::Mongoid::MongoidExtension::Document
