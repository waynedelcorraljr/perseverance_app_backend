class EarthdateSerializer
  include FastJsonapi::ObjectSerializer
  attributes :date, :total_photos, :photos
end
