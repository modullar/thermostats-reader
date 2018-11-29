class ReadingSerializer < ActiveModel::Serializer

  attributes :battery_charge, :temperature, :humidity, :number

end
