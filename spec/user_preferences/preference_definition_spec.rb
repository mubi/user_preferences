require 'spec_helper'

describe UserPreferences::PreferenceDefinition do
  subject(:preference) do
    definition = UserPreferences.definitions[:food][:wine]
    UserPreferences::PreferenceDefinition.new(definition, :food, :wine)
  end

  describe '#name' do
    it 'returns the preference name' do
      expect(preference.name).to eq(:wine)
    end
  end

  describe '#category' do
    it 'returns the preference category' do
      expect(preference.category).to eq(:food)
    end
  end

  describe '#permitted_values' do
    it 'returns an array of permitted values' do
      expect(preference.permitted_values).to eq(['red', 'white'])
    end
  end

  describe '#binary?' do
    it 'is false' do
      expect(preference.binary?).to eq(false)
    end
  end

  describe '#default' do
    it 'returns the default preference value' do
      expect(preference.default).to eq('red')
    end
  end

  describe '#lookup' do
    it 'returns the value at the supplied index' do
      expect(preference.lookup(0)).to eq('red')
      expect(preference.lookup(1)).to eq('white')
      expect(preference.lookup(2)).to be_nil
    end
  end

  describe '#to_db' do
    it 'returns the value index for the value' do
      expect(preference.to_db('red')).to eq(0)
      expect(preference.to_db('white')).to eq(1)
    end
  end

  context 'the preference is binary' do
    subject(:preference) do
      definition = UserPreferences.definitions[:food][:vegetarian]
      UserPreferences::PreferenceDefinition.new(definition, :food, :vegetarian)
    end

    describe '#permitted_values' do
      it 'returns an array of booleans' do
        expect(preference.permitted_values).to eq([false, true])
      end
    end

    describe '#binary?' do
      it 'is true' do
        expect(preference.binary?).to eq(true)
      end
    end

    describe '#default' do
      it 'returns the default boolean' do
        expect(preference.default).to eq(false)
      end
    end

    describe '#to_db' do
      it 'casts true/false strings to booleans' do
        expect(preference.to_db('false')).to eq(0)
        expect(preference.to_db('true')).to eq(1)
      end

      it 'casts integers to booleans' do
        expect(preference.to_db(0)).to eq(0)
        expect(preference.to_db(1)).to eq(1)
      end
    end
  end

  context 'non-binary preference acting as binary' do
    subject(:preference) do
      definition = UserPreferences.definitions[:notifications][:followed_user]
      UserPreferences::PreferenceDefinition.new(definition, :notifications, :followed_user)
    end

    describe '#binary?' do
      it 'is false' do
        expect(preference.binary?).to eq(false)
      end
    end

    describe '#default' do
      it 'returns the default preference value' do
        expect(preference.default).to eq(true)
      end
    end

    describe '#to_db' do
      it 'casts the first 2 values to booleans' do
        expect(preference.to_db(0)).to eq(0)
        expect(preference.to_db(1)).to eq(1)
        expect(preference.to_db(2)).to eq(nil)
      end

      it 'casts true/false strings to booleans' do
        expect(preference.to_db('false')).to eq(0)
        expect(preference.to_db('true')).to eq(1)
      end
    end
  end
end
