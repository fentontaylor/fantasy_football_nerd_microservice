module AuthorizationHelper
  def valid_open_key?(key)
    return false if key.nil?

    key_digest = Digest::MD5.hexdigest key
    !Key.find_by(value: key_digest).nil?
  end

  def valid_admin_key?(key)
    return false if key.nil?

    key_digest = Digest::MD5.hexdigest key
    !Key.find_by(value: key_digest, access_type: 'admin').nil?
  end
end
