require 'rails_helper'

module Flickr
  RSpec.describe Info do

    let(:photo_json)    { open(File.join(fixture_path, 'flickr_photo.json')).read }
    let(:photo_info)    { JSON::load(photo_json) }
    let(:flickr_userid) { '130616888@N02' }

    subject(:info) { Info.new flickr_userid, photo_info }

    context "initialize" do
      it "creates an Info object from a hash" do
        expect(Info.new(flickr_userid, photo_json).info).to be_a Hash
      end

      it "creates an Info obect from a json string" do
        expect(Info.new(flickr_userid, photo_json).info).to be_a Hash
      end

      it "creates an Info object with a nil #info" do
        expect(Info.new(flickr_userid).info).to be_nil
      end

      it 'has an info hash' do
        expect(subject.info).to be_a Hash
      end
    end

    context "accessor methods" do
      it "has a photo ID" do
        expect(subject.photo_id).to eq("25425808545")
      end

      it 'has an nsid' do
        expect(subject.nsid).to eq('130616888@N02')
      end
    end

    context "urls" do
      it "creates a photostream URL" do
        # "#{PHOTOS_URL}#{nsid}"
        expect(info.photostream_url).to eq('https://www.flickr.com/photos/130616888@N02')
      end

      it "creates a photopage URL" do
        expect(subject.photopage_url).to eq('https://www.flickr.com/photos/130616888@N02/25425808545')
      end

      it 'creates a tag URL' do
        expect(subject.tag_url("tag value")).to eq('https://www.flickr.com/photos/130616888@N02/tags/tagvalue')
      end
    end
  end
end