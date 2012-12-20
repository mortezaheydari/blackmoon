require 'spec_helper'

describe Account do
  before { @account = Account.new(email: "test@blackmoon.com",
  								 password: "password", password_confirmation:	"password")}

  subject { @account }

  it { should respond_to(:email) }

end
