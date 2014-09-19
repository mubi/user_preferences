require 'spec_helper'

describe UserPreferences::Preference do

  let(:user) { User.create }
  subject(:preference) { UserPreferences::Preference.new(category: :food, name: :wine, user: user) }

  it 'must have a name' do
    stub_definition
    preference.name = nil
    expect(preference.valid?).to eq(false)
    expect(preference.errors.full_messages).to include("Name can't be blank")
  end

  it 'must have a category' do
    stub_definition
    preference.category = nil
    expect(preference.valid?).to eq(false)
    expect(preference.errors.full_messages).to include("Category can't be blank")
  end

  it 'must have a value' do
    expect(preference.valid?).to eq(false)
    expect(preference.errors.full_messages).to include("Value can't be blank")
  end

  it 'must have a user' do
    preference.user = nil
    expect(preference.valid?).to eq(false)
    expect(preference.errors.full_messages).to include("User can't be blank")
  end

  it 'must have a unique name, scoped within user and category' do
    preference.update_value! 'white'
    second_preference = UserPreferences::Preference.new(category: :food, name: :wine, user: user, value: 1)
    expect(second_preference.valid?).to eq(false)
    expect(second_preference.errors.full_messages).to include('Name has already been taken')
  end

  it 'must have a valid value' do
    expect(preference.valid?).to eq(false)
    expect(preference.errors.full_messages).to include("Value can't be blank")
  end

  describe '#update_value' do
    it 'persists the updated the value' do
      preference.update_value! 'white'
      expect(preference.reload.value).to eq('white')
    end

    context 'the validation fails' do
      it 'raises' do
        expect { preference.update_value! 'sparkling' }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe '#value' do
    it 'casts the persisted value index back to its human readable form' do
      preference.update_value!('red')
      expect(preference.attributes['value']).to eq(0)
      expect(preference.value).to eq('red')
    end
  end

  describe '#definition' do
    it 'returns the preference definition' do
      expect(preference.definition).to be_kind_of(UserPreferences::PreferenceDefinition)
    end
  end

  private

  def stub_definition
    preference.stub(:attributes).and_return({'value' => 1})
    preference.stub(:value).and_return('white')
    preference.stub(:permitted_values).and_return(['white'])
  end
end