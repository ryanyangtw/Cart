class Allpay
  attr_accessor :merchant_id, :hash_key, :hash_iv
  def initialize merchant_id: ENV['ALLPAY_MERCHANT_ID'], hash_key: ENV['ALLPAY_HASH_KEY'], hash_iv: ENV['AllPAY_HASH_IV']
    @merchant_id = merchant_id
    @hash_key = hash_key
    @hash_iv = hash_iv
  end

  def make_mac params = {}
    # key = params.sort.map{|i| "#{i.first}=#{i.last}"}.join('&')
    # key = "HashKey=#{@hash_key}&#{key}&HashIV=#{@hash_iv}"
    # key = CGI::escape(key)
    # key.downcase!
    # key = Digest::MD5.hexdigest(key)
    # key.upcase!
    raw = params.sort.map!{|ary| "#{ary.first}=#{ary.last}"}.join('&')
    padding = "HashKey=#{@hash_key}&#{raw}&HashIV=#{@hash_iv}"
    url_encoded = CGI.escape(padding).downcase
    Digest::MD5.hexdigest(url_encoded).upcase
    # Hash#sort
    # Array#join
    # CGI#escape
    # Diges::MD5#hexdigest
    # String#downcase
    # String#upcase
  end 


  def check_mac params = {}
    stringified = params.stringify_keys
    check_mac_value = stringified.delete('CheckMacValue')
    make_mac(stringified) == check_mac_value
  end
end