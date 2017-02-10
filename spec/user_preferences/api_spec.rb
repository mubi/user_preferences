require 'spec_helper'

describe UserPreferences::API do
  let(:user) { User.create! }
  subject(:api) { UserPreferences::API.new(:food, user.saved_preferences) }

  describe '#all' do
    it 'returns preference state' do
      expect(api.all).to eq({
        vegetarian: false,
        a_la_carte: true,
        courses: 2,
        wine: 'red'
      })
    end
  end

  describe '#get' do
    it 'gets the preference value' do
      expect(api.get(:a_la_carte)).to eq(true)
      expect(api.get(:wine)).to eq('red')
      expect(api.get(:courses)).to eq(2)
    end
  end

  describe '#set' do
    it 'persists the preference values' do
      api.set(wine: 'white')
      api.reload
      expect(api.get(:wine)).to eq('white')
    end

    it 'allows setting of multiple preferences' do
      api.set(wine: 'white', courses: 3)
      api.reload
      expect(api.get(:wine)).to eq('white')
      expect(api.get(:courses)).to eq(3)
    end

    it 'returns true' do
      expect(api.set(wine: 'white')).to eq(true)
    end

    context 'one or more of the preference values were invalid' do
      it 'returns false' do
        expect(api.set(wine: 'sparkling')).to eq(false)
        expect(api.set(wine: 'white', courses: 10)).to eq(false)
      end

      it 'does not persist anything if any of the values were invalid' do
        api.set(wine: 'sparkling', courses: 3)
        api.reload
        expect(api.get(:wine)).to eq('red')
        expect(api.get(:courses)).to eq(2)
      end
    end
  end

  describe '#reload' do
    before(:each) do
      api.set(courses: 1)
      other_thread_api = UserPreferences::API.new('food', User.last.saved_preferences)
      other_thread_api.set(courses: 3)
    end

    it 'reloads the preference state' do
      expect(api.get(:courses)).to eq(1)
      api.reload
      expect(api.get(:courses)).to eq(3)
    end

    it 'returns the preference state' do
      expect(api.reload).to eq({
        vegetarian: false,
        a_la_carte: true,
        courses: 3,
        wine: 'red'
      })
    end
  end
end
