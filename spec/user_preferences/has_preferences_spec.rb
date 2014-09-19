require 'spec_helper'

describe UserPreferences::HasPreferences do
  let(:user) { User.create }

  it 'should mix in preference methods' do
    expect(user).to respond_to(:saved_preferences)
    expect(user).to respond_to(:preferences)
  end

  describe '#preferences' do
    it 'should return an API instance' do
      expect(user.preferences(:food)).to be_kind_of(UserPreferences::API)
    end
  end

  describe '.with_preference' do
    before(:each) { User.destroy_all }

    it 'only returns users with the matching preference' do
      user_1, user_2 = 2.times.map { User.create }
      user_1.preferences(:food).set(wine: 'white')
      user_2.preferences(:food).set(wine: 'red')
      expect(User.with_preference(:food, :wine, 'white')).to eq([user_1])

      user_2.preferences(:food).set(wine: 'white')
      expect(User.with_preference(:food, :wine, 'white')).to eq([user_1, user_2])
    end

    it 'returns a chainable active record relation' do
      user.preferences(:food).set(wine: 'white')
      expect(User.with_preference(:food, :wine, 'white')).to be_kind_of(ActiveRecord::Relation)
      expect(User.with_preference(:food, :wine, 'white').where('1=1')).to eq([user])
    end

    context 'the desired preference matches the default value' do
      it 'includes users who have not explicitely overriden the preference' do
        user.preferences(:food).set(wine: 'red') # the default value
        user_2 = User.create
        expect(User.with_preference(:food, :wine, 'red')).to eq([user, user_2])
      end
    end
  end
end