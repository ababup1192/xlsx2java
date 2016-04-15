require_relative '../src/hello'

describe Hello do
  it 'returns hello' do
    expect(Hello.new.message).to eq 'hello'
  end
end
