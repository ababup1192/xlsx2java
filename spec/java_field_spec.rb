require_relative '../src/java_field'

describe JavaField do
  context IntField do
    it 'returns variable statement' do
      expect(IntField.new('foo').to_s).to eq 'Integer foo;'
    end
  end
end
