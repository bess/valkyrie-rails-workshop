require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe BookChangeSet do
  let(:change_set) { described_class.new(Book.new) }

  it_behaves_like 'a Valkyrie::ChangeSet'
end
