require 'rails_helper'

# This spec tests the spe

shared_examples_for "spreadsheet_extractor" do
  let(:model) {  described_class }
  let(:new_oject) { build model.to_s.underscore.to_sym }
  let(:created_object) { create model.to_s.underscore.to_sym }

  it 'opens a spreadsheet for an unsaved object' do
    expect(new_oject.open_spreadsheet).to respond_to :read
  end

  it 'opens a spreadsheet for a saved object' do
    expect(created_object.open_spreadsheet).to respond_to :read
  end

  it 'reads a spreadsheet for an unsaved object' do
    expect(new_oject.read_spreadsheet).to be_a String
  end

  it 'reads a spreadsheet for an saved object' do
    expect(created_object.read_spreadsheet).to be_a String
  end
end
