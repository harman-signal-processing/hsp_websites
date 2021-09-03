if Rails.env.development?
  Marginalia::Comment.components = [:line]
end
