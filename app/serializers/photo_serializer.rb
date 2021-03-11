class PhotoSerializer
  include FastJsonapi::ObjectSerializer
  attributes :sol, :status, :img_src, :earth_date, :earthdate_id
end
