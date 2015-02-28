class AddConfirmedToMembership < ActiveRecord::Migration
  def change
    add_column :memberships, :confirmed, :boolean
    Membership.all.each do |m|
      m.confirmed = true
      m.save
    end
  end
end
