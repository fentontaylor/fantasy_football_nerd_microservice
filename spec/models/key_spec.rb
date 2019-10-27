require 'spec_helper'

describe Key, type: :model do
  describe 'attributes' do
    it 'defaults to public scope' do
      md5 = Digest::MD5.hexdigest 'a'
      key = Key.create(value: md5)

      expect(key.value).to eq(md5)
      expect(key.access_type).to eq('open')
    end
  end
end
