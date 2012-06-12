Factory.define :omniuser do |omniuser|
  omniuser.uid          12234
  omniuser.provider     "facebook"
  omniuser.screen_name  "NickName"
  omniuser.name         "FirstName LastName"
  omniuser.admin        true
  omniuser.member       true
end

Factory.define :movie do |movie|
end

Factory.define :comment do |comment|
  comment.comment     "test comment"
  comment.association :omniuser
  comment.association :movie
end
