require 'spec_helper'

describe Key, type: :model do
  describe 'attributes' do
    it 'defaults to open access_type' do
      md5 = Digest::MD5.hexdigest 'a'
      key = Key.create(value: md5)

      expect(key.value).to eq(md5)
      expect(key.access_type).to eq('open')
    end

    it 'can have admin access_type' do
      md5 = Digest::MD5.hexdigest 'a'
      key = Key.create(value: md5, access_type: 1)

      expect(key.value).to eq(md5)
      expect(key.access_type).to eq('admin')
    end
  end
end
