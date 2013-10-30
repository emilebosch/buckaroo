require './test/support/test_helper.rb'

describe "Buckaroo::WebCallback" do

  it "should properly validate a web callback" do
    p = {"BRQ_AMOUNT"=>"100.00", "BRQ_CURRENCY"=>"EUR", "BRQ_CUSTOMER_NAME"=>"J. de Tèster", "BRQ_INVOICENUMBER"=>"sasad", "BRQ_PAYMENT"=>"B13DF6097C4945A39CB2BA118A437B42", "BRQ_PAYMENT_METHOD"=>"ideal", "BRQ_SERVICE_IDEAL_CONSUMERBIC"=>"RABONL2U", "BRQ_SERVICE_IDEAL_CONSUMERIBAN"=>"NL44RABO0123456789", "BRQ_SERVICE_IDEAL_CONSUMERISSUER"=>"ABNAMRO Bank ", "BRQ_SERVICE_IDEAL_CONSUMERNAME"=>"J. de Tèster", "BRQ_STATUSCODE"=>"190", "BRQ_STATUSCODE_DETAIL"=>"S001", "BRQ_STATUSMESSAGE"=>"Payment successfully processed", "BRQ_TEST"=>"true", "BRQ_TIMESTAMP"=>"2013-10-28 11:31:01", "BRQ_TRANSACTIONS"=>"A4EDB605DC594F2D9CFBDBABABFC9FE4", "BRQ_WEBSITEKEY"=>"2EwHAHd454", "BRQ_SIGNATURE"=>"aa1860a3cdadad2b3abf9514aa47fdc28395d95b"}
    callback = Buckaroo::WebCallback.new(p)
    assert callback.valid?, "should be valid"
  end

end

describe "Buckaroo::Hasher" do

  it "should validate a valid hash" do
    p = {"BRQ_AMOUNT"=>"100.00", "BRQ_CURRENCY"=>"EUR", "BRQ_CUSTOMER_NAME"=>"J. de Tèster", "BRQ_INVOICENUMBER"=>"sasad", "BRQ_PAYMENT"=>"B13DF6097C4945A39CB2BA118A437B42", "BRQ_PAYMENT_METHOD"=>"ideal", "BRQ_SERVICE_IDEAL_CONSUMERBIC"=>"RABONL2U", "BRQ_SERVICE_IDEAL_CONSUMERIBAN"=>"NL44RABO0123456789", "BRQ_SERVICE_IDEAL_CONSUMERISSUER"=>"ABNAMRO Bank ", "BRQ_SERVICE_IDEAL_CONSUMERNAME"=>"J. de Tèster", "BRQ_STATUSCODE"=>"190", "BRQ_STATUSCODE_DETAIL"=>"S001", "BRQ_STATUSMESSAGE"=>"Payment successfully processed", "BRQ_TEST"=>"true", "BRQ_TIMESTAMP"=>"2013-10-28 11:31:01", "BRQ_TRANSACTIONS"=>"A4EDB605DC594F2D9CFBDBABABFC9FE4", "BRQ_WEBSITEKEY"=>"2EwHAHd454", "BRQ_SIGNATURE"=>"aa1860a3cdadad2b3abf9514aa47fdc28395d95b"}
    assert Buckaroo::Hasher.valid?(p, Buckaroo.secret), "Should be valid"
  end

  it "should not validate an invalid hash" do
    p = {"BRQ_AMOUNT"=>"100.10", "BRQ_CURRENCY"=>"EUR", "BRQ_CUSTOMER_NAME"=>"J. de Tèster", "BRQ_INVOICENUMBER"=>"sasad", "BRQ_PAYMENT"=>"B13DF6097C4945A39CB2BA118A437B42", "BRQ_PAYMENT_METHOD"=>"ideal", "BRQ_SERVICE_IDEAL_CONSUMERBIC"=>"RABONL2U", "BRQ_SERVICE_IDEAL_CONSUMERIBAN"=>"NL44RABO0123456789", "BRQ_SERVICE_IDEAL_CONSUMERISSUER"=>"ABNAMRO Bank ", "BRQ_SERVICE_IDEAL_CONSUMERNAME"=>"J. de Tèster", "BRQ_STATUSCODE"=>"190", "BRQ_STATUSCODE_DETAIL"=>"S001", "BRQ_STATUSMESSAGE"=>"Payment successfully processed", "BRQ_TEST"=>"true", "BRQ_TIMESTAMP"=>"2013-10-28 11:31:01", "BRQ_TRANSACTIONS"=>"A4EDB605DC594F2D9CFBDBABABFC9FE4", "BRQ_WEBSITEKEY"=>"2EwHAHd454", "BRQ_SIGNATURE"=>"aa1860a3cdadad2b3abf9514aa47fdc28395d95b"}
    assert !Buckaroo::Hasher.valid?(p, Buckaroo.secret), "Should not be valid"
  end

  it "should raise on invalid parameters" do
    assert_raises(ArgumentError) do
      Buckaroo::Hasher.calculate(nil, 'secret')
    end

    assert_raises(ArgumentError) do
      Buckaroo::Hasher.calculate({hash: 'hello'} ,nil)
    end
  end

  it "should properly sort the hash before signing" do
    a = Buckaroo::Hasher.calculate({a:'HELLO',  b:'ok',     c:'ok'},'secret')
    b = Buckaroo::Hasher.calculate({b:'ok',     a:'HELLO' , c:'ok'},'secret')
    assert a == b, "Should sign properly"
  end

  it "should hash a request" do
    hash = {name:'hello'}
    signature = Buckaroo::Hasher.calculate(hash, 'im a secret')
    assert 'a8058903eea2b869ecae917442e7e9a99694421b' ==  signature, "Should sign properly"
  end

end