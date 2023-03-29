require 'spec_helper'

describe UserPreferences::Defaults do
  subject(:defaults) { UserPreferences::Defaults.new(UserPreferences.definitions) }

  describe '.get' do
    it 'returns the default preference state' do
      expect(defaults.get).to eq(
        {
          hobbies: {
            outdoors: true,
            cultural: false
          },
          food: {
            vegetarian: false,
            a_la_carte: true,
            courses: 2,
            wine: 'red'
          },
          notifications: {
            followed_user: true
          }
        }
      )
    end

    context 'a category is supplied' do
      it 'returns the default preference state for the category' do
        expect(defaults.get(:hobbies)).to eq({
          outdoors: true,
          cultural: false
        })
      end
    end
  end
end
