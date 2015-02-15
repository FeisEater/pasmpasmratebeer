class StyleAsTable < ActiveRecord::Migration
  def change
    create_table :styles do |t|
      t.string :name
      t.text :description
      t.timestamps null: false
    end
    reversible do |dir|
      dir.up do
        Style.create name:"Weizen", description:"Sheizen"
        Style.create name:"Lager", description:"Shlager"
        Style.create name:"Pale Ale", description:"Dat pale shit"
        Style.create name:"IPA", description:"Bunch of letters"
        Style.create name:"Porter", description:"Around the corner (almost rhymes)"
      end
    end
    change_table :beers do |t|
      t.rename :style, :old_style
      t.integer :style_id
    end
    reversible do |dir|
      dir.up do
        Beer.all.each do |beer|
          s = Style.find_by name: beer.old_style
          raise "#{beer.old_style} had no column" if s.nil?
          beer.style_id = s.id
          beer.save
        end
      end
      dir.down do
        Beer.all.each do |beer|
          if beer.style_id
            beer.old_style = beer.style.name
            beer.save
          end
        end
      end
    end
    reversible do |dir|
      dir.up do
        change_table :beers do |t|
          t.remove :old_style
        end
      end
      dir.down do
        change_table :beers do |t|
          t.string :old_style
        end
      end
    end
  end
end
