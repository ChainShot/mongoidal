require 'spec_helper'

class PermittableExample
  include Mongoid::Document
  include Mongoidal::Permittable
  include Mongoidal::EnumField

  unpermit enum_field :bin, type: Symbol, values: [:hungry, :bored]

  field :name

  permit!
end

class NestedPermittableExample
  include Mongoid::Document
  include Mongoidal::Permittable

  embedded_in :permittable_example

  permit!
end

describe Mongoidal::Permittable do
  context 'RootDocuments' do
    subject { PermittableExample }
    its(:unpermitted) { should include :bin }
    its(:permitted_fields) { should include :name }
    its(:permitted_fields) { should_not include :id }
  end

  context 'Embedded Documents' do
    subject { NestedPermittableExample }
    its(:permitted_fields) { should include :id }
  end
end