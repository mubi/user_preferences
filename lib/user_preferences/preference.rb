class UserPreferences::Preference < ActiveRecord::Base
  self.table_name = 'preferences'
  belongs_to :user
  validates_uniqueness_of :name, scope: [:user_id, :category]
  validates_presence_of :user_id, :category, :name
  validates :value, inclusion: { in: ->(p) { p.permitted_values }}

  delegate :binary?, :default, :permitted_values, :lookup, :to_db, to: :definition

  def update_value!(v)
    update_attributes!(value: to_db(v))
  end

  def value
    lookup(attributes['value'])
  end

  def definition
    UserPreferences[category, name]
  end
end