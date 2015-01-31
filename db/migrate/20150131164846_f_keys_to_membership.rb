class FKeysToMembership < ActiveRecord::Migration
  def change
    add_column :memberships, :member_id, :integer
    add_column :memberships, :beer_club_id, :integer
  end
end
